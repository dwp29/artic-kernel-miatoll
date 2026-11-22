<!-- SPDX-License-Identifier: CC-BY-4.0 -->
# Platform notes

## Boot layout

The miatoll device tree sets:

- `AB_OTA_UPDATER := false` — A-only, no `boot_a`/`boot_b`, no `init_boot`.
- `BOARD_BOOT_HEADER_VERSION := 2`.
- `BOARD_KERNEL_PAGESIZE := 4096`.
- `BOARD_KERNEL_IMAGE_NAME := Image` with `BOARD_INCLUDE_DTB_IN_BOOTIMG := true`.
- `BOARD_KERNEL_SEPARATED_DTBO := true`.
- `BOARD_RAMDISK_USE_LZ4 := true`.
- `BOARD_RECOVERYIMAGE_PARTITION_SIZE` is set separately — `recovery` is its own partition.

An AnyKernel3 installer therefore writes the kernel image to
`/dev/block/bootdevice/by-name/boot`, with slot selection disabled. Writing
to `boot_a`, `init_boot`, or a guessed block path will fail or damage the
device.

## Dynamic partitions

`system`, `system_ext`, `vendor` and `product` are logical partitions inside
`super`. The kernel package must not repack `super` or rewrite `fstab`.
AVB is enabled for `system`, `system_ext` and `product`; vbmeta handling
follows the ROM installation instructions rather than a generic command.

## Firmware baseline

The Global joyeuse firmware referenced by LineageOS is MIUI 14
`V14.0.3.0.SJZMIXM` (Android 12). The EEA build is `V14.0.5.0.SJZEUXM`.
There is no official HyperOS release for this device; HyperOS builds are
ports from other devices and may require a different recovery variant.

## Recovery

OrangeFox has an official miatoll device entry. Its R12.0 FBEv2 build is for
AOSP-based Android 13-16 ROMs and explicitly must not be used with MIUI or
HyperOS ports. FBEv1 ROMs need the older FBEv1 recovery line. Confirm
`ro.crypto.type` and the fstab encryption flags before choosing a recovery.

## Flashing order

1. Back up the original `boot` partition and the current recovery.
2. Confirm the active firmware and the ROM's required recovery variant.
3. Install or update the ROM first.
4. Flash the matching Artic AnyKernel3 zip.
5. Install the root manager and modules after the kernel boots.
6. Do not relock the bootloader while running a custom ROM or kernel.
