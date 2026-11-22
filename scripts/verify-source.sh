#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
set -euo pipefail

cd "$(dirname "$0")/.."

get_lock() {
  awk -F" = " -v section="[$1]" -v key="$2" '
    $0 == section { inside=1; next }
    /^\[/ { inside=0 }
    inside && $1 == key { print $2; exit }
  ' versions.lock
}

COMMIT=$(get_lock upstream commit)
SUBLEVEL=$(get_lock tree sublevel)
EXTRAVERSION=$(get_lock tree extraversion)

[ "$(git -C src rev-parse HEAD)" = "$COMMIT" ] || { echo "HEAD mismatch" >&2; exit 1; }

MAKE_SUBLEVEL=$(awk '/^SUBLEVEL/ {print $3}' src/Makefile)
MAKE_EXTRA=$(awk '/^EXTRAVERSION/ {print $3}' src/Makefile)
[ "$MAKE_SUBLEVEL" = "$SUBLEVEL" ] || { echo "SUBLEVEL mismatch: $MAKE_SUBLEVEL" >&2; exit 1; }
[ "$MAKE_EXTRA" = "$EXTRAVERSION" ] || { echo "EXTRAVERSION mismatch: $MAKE_EXTRA" >&2; exit 1; }

for f in Makefile build.py AnyKernel3 arch/arm64/configs/vendor/xiaomi/miatoll_defconfig; do
  [ -e "src/$f" ] || { echo "Missing: $f" >&2; exit 1; }
done

grep -q '^is_slot_device=0' src/AnyKernel3/anykernel.sh || { echo "AnyKernel3 is not A-only" >&2; exit 1; }
grep -q '^device.name5=joyeuse' src/AnyKernel3/anykernel.sh || { echo "joyeuse not in device check" >&2; exit 1; }
if grep -q lancelot src/AnyKernel3/anykernel.sh; then echo "lancelot must not be claimed" >&2; exit 1; fi

echo "Source verified: $COMMIT / 4.14.$SUBLEVEL$EXTRAVERSION"
