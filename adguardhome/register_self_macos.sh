#!/usr/bin/env bash

# Wait until VPN network connectivity is fully available
until ping -c 1 -W 2 10.255.255.1 >/dev/null 2>&1; do
  sleep 2
done

set -euo pipefail

HOSTNAME="$(hostname -s)"
LAN_IP=$(ifconfig -X en inet 2>/dev/null | awk '/inet /{print $2}' | head -1)
WG_IP=$(ifconfig -X tun inet 2>/dev/null | awk '/inet 10\.255\.255\./{print $2}' | head -1)

[[ -n "$LAN_IP" ]] && curl -sf -X PUT "http://10.255.255.1:3001/set-dns/${HOSTNAME}.lan.internal/$LAN_IP"
[[ -n "$WG_IP"  ]] && curl -sf -X PUT "http://10.255.255.1:3001/set-dns/${HOSTNAME}.wg.internal/$WG_IP"
