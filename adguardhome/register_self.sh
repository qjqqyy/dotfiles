#!/usr/bin/env bash

# meant to be sourced, not executed directly
# requires: curl, jq
# expects ADGUARD to be set by the caller before sourcing

command -v curl >/dev/null 2>&1 || { echo "curl not found, aborting" >&2; return 1; }
command -v jq   >/dev/null 2>&1 || { echo "jq not found, aborting" >&2; return 1; }

: "${ADGUARD:?ADGUARD not set (expected http://user:pass@10.255.255.1:3000)}"

if ! curl -s -o /dev/null -w '%{http_code}' "$ADGUARD/control/status" | grep -q '^200$'; then
  echo "cannot reach/auth to AdGuard at $ADGUARD, bailing" >&2
  return 1
fi

find_rewrite() {
  local domain="$1"
  curl -s "$ADGUARD/control/rewrite/list" \
    | jq -c --arg d "$domain" '[.[] | select(.domain == $d)]'
}

delete_rewrite() {
  local entry="$1"
  curl -s -X POST "$ADGUARD/control/rewrite/delete" \
    -H 'Content-Type: application/json' \
    -d "$entry" >/dev/null
  echo "removed stale $(echo "$entry" | jq -r '"\(.domain) -> \(.answer)"')"
}

add_rewrite() {
  local domain="$1" ip="$2"

  local existing count
  existing=$(find_rewrite "$domain")
  count=$(echo "$existing" | jq 'length')

  if [ "$count" -gt 1 ]; then
    echo "multiple existing rewrites for $domain, refusing to guess, fix manually" >&2
    return 1
  elif [ "$count" -eq 1 ]; then
    delete_rewrite "$(echo "$existing" | jq -c '.[0]')"
  fi

  local code
  code=$(curl -s -o /dev/null -w '%{http_code}' -X POST "$ADGUARD/control/rewrite/add" \
    -H 'Content-Type: application/json' \
    -d "{\"domain\":\"$domain\",\"answer\":\"$ip\"}")

  if [ "$code" -eq "200" ]; then
    echo "registered $domain -> $ip"
  else
    echo "failed to register $domain -> $ip (HTTP $code)" >&2
    return 1
  fi
}
