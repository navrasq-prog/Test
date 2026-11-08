#!/usr/bin/env bash
# Re-enable everything debloat.sh disabled.
set -euo pipefail
IP="${1:?Usage: $0 <firestick-ip>}"
DIR="$(cd "$(dirname "$0")" && pwd)"
adb connect "$IP:5555"
adb -s "$IP:5555" wait-for-device
grep -v '^\s*#' "$DIR/packages.txt" | awk '{print $1}' | grep -v '^$' | while read -r p; do
  adb -s "$IP:5555" shell pm enable "$p" </dev/null >/dev/null 2>&1 && echo "  enabled $p" || true
done
adb -s "$IP:5555" shell reboot || true
