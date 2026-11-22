#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
set -euo pipefail

cd "$(dirname "$0")/../src"

# The upstream build.py ends with input(); remove it for unattended CI.
sed -e '/Press Enter to exit/d' -e '/^[[:space:]]*input()[[:space:]]*$/d' build.py > build-ci.py
chmod +x build-ci.py
python3 build-ci.py

IMAGE=out/arch/arm64/boot/Image.gz
DTBO=out/arch/arm64/boot/dtbo.img
DTB=out/arch/arm64/boot/dts/qcom/cust-atoll-ab.dtb

for f in "$IMAGE" "$DTBO" "$DTB"; do
  [ -s "$f" ] || { echo "Missing artifact: $f" >&2; exit 1; }
done

ZIP=$(find AnyKernel3 -maxdepth 1 -name 'RedCherry-kernel*.zip' -print | head -n 1)
[ -n "$ZIP" ] || { echo "AnyKernel3 zip not found" >&2; exit 1; }

echo "--- compile.h ---"
grep -E 'LINUX_COMPILER|UTS_RELEASE' out/include/generated/compile.h || true
echo "--- checksums ---"
sha256sum "$IMAGE" "$DTBO" "$DTB" "$ZIP"
echo "BUILD_OK"
