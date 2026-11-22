<!-- SPDX-License-Identifier: CC-BY-4.0 -->
# Root stack notes

## Root implementation

The practical path for a 4.14 non-GKI kernel is a built-in root driver.
Boot-image LKM patching is a GKI workflow and is not available here.

- **KernelSU Next `legacy`** with `CONFIG_KSU=y`, `CONFIG_KSU_MANUAL_HOOK=y`
  and `CONFIG_KSU_SYSCALL_TABLE_HOOK=y` is the primary candidate. The branch
  was still active in November 2026 and explicitly supports older kernels.
- **BakaSU** is the alternative used by non-GKI build pipelines.
- **SukiSU Nova** supports 4.14, but some integrity modules report only
  partial compatibility because of its script execution limit.
- **APatch** works through KernelPatch and requires `CONFIG_KALLSYMS`.
- **Magisk** patches the ramdisk and is a fallback, not the kernel solution.

Do not install more than one root implementation at the same time.

## SUSFS

The SUSFS LKM builds target GKI/DDK kernels. For 4.14 the in-tree patch from
the `kernel-4.14` branch is the usable form. That branch is older than the
GKI line and lacks newer features such as SUS_MAP, so each option must be
tested after porting.

`SPOOF_CMDLINE_OR_BOOTCONFIG` is the relevant option for bootloader-state
spoofing: it rewrites `/proc/cmdline` and `/proc/bootconfig` system-wide.
This changes what userspace sees; it does not change the bootloader, TEE,
StrongBox or the hardware warranty bit.

## Integrity modules

Root hiding comes first, then props, then key attestation:

1. Kernel-level hiding from SUSFS or the root manager mount namespace.
2. `PlayIntegrityFork` for `Build.*` and DroidGuard-visible properties.
3. `TEESimulator`, `TrickyStore` or `OhMyKeymint` only when key attestation
   is required. Keybox files from public sources are usually revoked.

SUSFS and Shamiko should not be combined; the SUSFS tree removed Shamiko
support in 2025.

## Recovery and safe mode

OrangeFox is the maintained custom recovery for miatoll. Use the R12.0
FBEv2 build only with AOSP-based Android 13-16 ROMs. MIUI and HyperOS ports
need a recovery variant that matches their encryption type.

For KernelSU safe mode, use the manager setting or rename
`/data/adb/modules` from recovery. The volume-key listener must be wired
up manually on non-GKI kernels; do not assume it exists.
