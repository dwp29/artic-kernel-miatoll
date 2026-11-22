#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
set -euo pipefail

VARIANT=${VARIANT:-artic}
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FRAGMENT="$ROOT/config/${VARIANT}.fragment"

[ -f "$FRAGMENT" ] || { echo "Missing fragment: $FRAGMENT" >&2; exit 1; }
[ -d "$ROOT/src/.git" ] || { echo "Run scripts/fetch-sources.sh first" >&2; exit 1; }

cd "$ROOT/src"

if [ ! -x clang/bin/clang ]; then
  mkdir -p clang
  (
    cd clang
    wget -q https://github.com/userariii/AOSP-clang/releases/download/clang-r530567/clang-r530567.tar.gz
    tar -xf clang-r530567.tar.gz
  )
fi

[ -d gcc ] || git clone --depth=1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9.git gcc
[ -d gcc32 ] || git clone --depth=1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_arm_arm-linux-androideabi-4.9.git gcc32

export ARCH=arm64 SUBARCH=arm64
export KBUILD_BUILD_HOST=Linux
export KBUILD_BUILD_USER=ARTIC
export KBUILD_COMPILER_STRING="$("$PWD/clang/bin/clang" --version | head -n 1)"
export PATH="$PWD/clang/bin:$PWD/gcc/bin:$PWD/gcc32/bin:$PATH"

echo "Building variant: $VARIANT"
echo "Compiler: $KBUILD_COMPILER_STRING"

make O=out ARCH=arm64 vendor/xiaomi/miatoll_defconfig
scripts/kconfig/merge_config.sh -m out/.config "$FRAGMENT"
make O=out ARCH=arm64 olddefconfig

make -j"$(nproc)" O=out ARCH=arm64 \
  CC=clang CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
  HOSTCC=clang HOSTCXX=clang++ HOSTCFLAGS="-fuse-ld=lld -Wno-unused-command-line-argument" \
  LD=ld.lld LLVM=1 LLVM_IAS=1 AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy \
  OBJDUMP=llvm-objdump STRIP=llvm-strip READELF=llvm-readelf OBJSIZE=llvm-size

IMAGE=out/arch/arm64/boot/Image.gz
DTBO=out/arch/arm64/boot/dtbo.img
DTB=out/arch/arm64/boot/dts/qcom/cust-atoll-ab.dtb
for f in "$IMAGE" "$DTBO" "$DTB"; do
  [ -s "$f" ] || { echo "Missing artifact: $f" >&2; exit 1; }
done

rm -f AnyKernel3/Image.gz AnyKernel3/dtbo.img AnyKernel3/artic-*.zip
rm -rf AnyKernel3/dtb
mkdir -p AnyKernel3/dtb
cp "$IMAGE" AnyKernel3/
cp "$DTBO" AnyKernel3/
cp "$DTB" AnyKernel3/dtb/
sed -i "s/^kernel.string=.*/kernel.string=Artic-${VARIANT}/" AnyKernel3/anykernel.sh

cd AnyKernel3
ZIP="artic-${VARIANT}-$(date +%Y%m%d-%H%M).zip"
zip -r9 "$ZIP" . >/dev/null
echo "--- checksums ---"
sha256sum "$ZIP" ../"$IMAGE" ../"$DTBO" ../"$DTB"
echo "BUILD_OK $VARIANT $ZIP"
