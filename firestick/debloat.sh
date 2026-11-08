#!/usr/bin/env bash
# Disable Amazon bloat/ad packages on a Fire TV Stick over ADB.
# Usage: ./debloat.sh <FIRESTICK_IP>
set -euo pipefail
IP="${1:?Usage: $0 <firestick-ip>   (Settings > My Fire TV > About > Network)}"
DIR="$(cd "$(dirname "$0")" && pwd)"
command -v adb >/dev/null || { echo "adb not found. Install Android platform-tools first."; exit 1; }

echo "Connecting to $IP... accept the 'Allow USB debugging' prompt on the TV."
adb connect "$IP:5555"
adb -s "$IP:5555" wait-for-device
S=(adb -s "$IP:5555" shell)

read -rp "Disable the packages in packages.txt? [y/N] " ok
[[ "$ok" =~ ^[Yy]$ ]] || exit 0

installed="$("${S[@]}" pm list packages | sed 's/^package://' | tr -d '\r')"
grep -v '^\s*#' "$DIR/packages.txt" | awk '{print $1}' | grep -v '^$' | while read -r p; do
  if grep -qx "$p" <<<"$installed"; then
    if "${S[@]}" pm disable-user --user 0 "$p" </dev/null | grep -q 'disabled'; then
      echo "  disabled  $p"
    else
      echo "  FAILED    $p (Fire OS blocks disabling this one)"
    fi
  else
    echo "  skipped   $p (not installed)"
  fi
done

echo
echo "Done. Rebooting the Firestick..."
"${S[@]}" reboot || true
echo "If anything misbehaves, run: ./restore.sh $IP"
