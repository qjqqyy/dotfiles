#!/usr/bin/env python3
"""AdGuard Home DNS rewrite companion server.

Listens on 10.255.255.1:3001, exposes a single endpoint:
    PUT /set-dns/<domain>/<ip>

Talks to AdGuard Home on localhost:3000.
Set ADGUARD_USER and ADGUARD_PASS env vars for auth.
"""

import base64
import http.server
import json
import os
import re
import sys
import urllib.error
import urllib.parse
import urllib.request

ADGUARD = os.environ.get("ADGUARD_URL", "http://10.255.255.1:3000")

user = os.environ.get("ADGUARD_USER", "")
passwd = os.environ.get("ADGUARD_PASS", "")
if user or passwd:
    cred = base64.b64encode(f"{user}:{passwd}".encode()).decode()
    AUTH = f"Basic {cred}"
else:
    AUTH = None


def adguard(method, path, body=None):
    """Make a request to the AdGuard Home API."""
    url = f"{ADGUARD}{path}"
    data = json.dumps(body).encode() if body else None
    req = urllib.request.Request(url, data=data, method=method)
    req.add_header("Content-Type", "application/json")
    if AUTH:
        req.add_header("Authorization", AUTH)
    try:
        with urllib.request.urlopen(req) as resp:
            return resp.read().decode()
    except urllib.error.HTTPError as e:
        return None


def find_rewrites(domain):
    """Return list of rewrite entries matching domain."""
    raw = adguard("GET", "/control/rewrite/list")
    if raw is None:
        return None
    entries = json.loads(raw)
    return [e for e in entries if e.get("domain") == domain]


def delete_rewrite(entry):
    """Delete a single rewrite entry."""
    return adguard("POST", "/control/rewrite/delete", entry) is not None


def add_rewrite(domain, ip):
    """Add a DNS rewrite. Returns True on success."""
    raw = adguard("POST", "/control/rewrite/add", {"domain": domain, "answer": ip})
    return raw is not None


class Handler(http.server.BaseHTTPRequestHandler):

    def log_message(self, fmt, *args):
        # Log to stderr with timestamp
        print(f"{self.log_date_time_string()} {fmt % args}", file=sys.stderr, flush=True)

    def _respond(self, code, obj):
        body = json.dumps(obj).encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def _handle_set_dns(self):
        # Extract domain and ip from path: /set-dns/<domain>/<ip>
        parts = self.path.rstrip("/").split("/")
        # Expect: ['', 'set-dns', 'domain', 'ip']
        if len(parts) != 4:
            self._respond(400, {"ok": False, "error": "usage: /set-dns/<domain>/<ip>"})
            return

        domain = urllib.parse.unquote(parts[2])
        ip = urllib.parse.unquote(parts[3])

        if not domain or not ip:
            self._respond(400, {"ok": False, "error": "domain and ip must not be empty"})
            return

        # Find existing rewrites for this domain
        existing = find_rewrites(domain)
        if existing is None:
            self._respond(502, {"ok": False, "error": "cannot reach AdGuard Home"})
            return

        # Delete existing entries if any
        for entry in existing:
            if not delete_rewrite(entry):
                self._respond(502, {"ok": False, "error": f"failed to delete stale rewrite {entry.get('domain', '?')}"})
                return

        # Add the new rewrite
        if not add_rewrite(domain, ip):
            self._respond(502, {"ok": False, "error": "failed to add rewrite"})
            return

        self._respond(200, {"ok": True, "domain": domain, "ip": ip})

    def do_PUT(self):
        self._route()

    def do_POST(self):
        self._route()

    def _route(self):
        if self.path.startswith("/set-dns/"):
            self._handle_set_dns()
        else:
            self._respond(404, {"ok": False, "error": "not found, use /set-dns/<domain>/<ip>"})


def main():
    host = os.environ.get("LISTEN_HOST", "10.255.255.1")
    port = int(os.environ.get("LISTEN_PORT", "3001"))
    server = http.server.HTTPServer((host, port), Handler)
    print(f"listening on {host}:{port}", flush=True)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nshutting down", flush=True)
        server.shutdown()


if __name__ == "__main__":
    main()
