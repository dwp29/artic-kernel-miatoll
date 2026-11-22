<!-- SPDX-License-Identifier: CC-BY-4.0 -->
# Source selection

## Chosen base

`swiitchOFF-miatoll/kernel_xiaomi_sm6250`, branch `17`, commit
`606346b0b53bd04582a20c7cd946e3c075245719` (committer date 15 Nov 2026).
This is the RedCherry source line. It is Linux 4.14.357-openela and uses
`vendor/xiaomi/miatoll_defconfig`. Its `build.py` produces `Image.gz`,
`cust-atoll-ab.dtb` and `dtbo.img` as a RedCherry AnyKernel3 zip.

Reasons:

- Newest active source found for the miatoll family.
- Android 17 branch with EROFS and inline crypto present.
- AnyKernel3 script targets `boot` with `is_slot_device=0` and lists exactly
  `miatoll`, `curtana`, `excalibur`, `gram`, `joyeuse`. There is no lancelot.
- Clean enough to add our own KSU/SUSFS stack without first removing a
  third-party root integration.

## Fallback

`crdroidandroid/android_kernel_xiaomi_sm6250`, branch `16.0`, commit
`8b4afb3dd59ea7f94bef73d61bc23a2b713b1df7` (28 Apr 2026). Same kernel
sublevel, Clang 11 + GCC 4.9, useful as a stability comparison.

## Rejected or limited

| Source | Reason |
|---|---|
| LineageOS kernel `lineage-22.2` | 4.14.336, last commit 30 Jun 2025. No kernel `lineage-23.2` branch exists; the device tree branch with that name has the same SHA as 22.2. |
| crDroid kernel `17.0` | Contains prebuilt `Image`, `dtb/` and `dtbo.img`, not source. It points to the RedCherry release. |
| Saamitk `a` | 4.14.357 but carries a custom root integration; useful as reference, not as a neutral base. |
| Xiaomi-SD720G-Devices, PixelExperience, PixelOS-old, ProjectVelvet, CAF mirror, Klozz | Archived or years old. Reference only. |
| sm7125-mainline | Active, but camera, charging and voice audio need out-of-tree patches; fingerprint is unverified. Research track, not daily driver. |

## Scope limits

No source proves one binary boots every Android 12-17 ROM. Module CRC and
signature, FCM config, EROFS, inline crypto, fstab, vendor, ramdisk and
DTB/DTBO all differ per build. Support stays per-ROM and per-tested build.

