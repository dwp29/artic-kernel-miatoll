# Artic Kernel

Artic is a non-GKI Linux 4.14 kernel project for Xiaomi's miatoll family.
It is built around the vendor kernel line so that camera, DSP, audio, modem,
and fingerprint stay compatible with the stock vendor partition. The project
keeps one source of patches and produces one kernel variant per ROM build.

## Devices

| Codename | Model |
|---|---|
| `joyeuse` | Redmi Note 9 Pro (Global) — current test device |
| `curtana` | Redmi Note 9S |
| `excalibur` | Redmi Note 9 Pro Max |
| `gram` | Poco M2 Pro |

All four share the SM7125 / Snapdragon 720G platform and the `sm6250`
kernel tree. They are not automatically interchangeable: DTB, panel, NFC,
camera module and region-specific firmware still have to be matched.

## Current target

The first supported variant is **Lunaris 3.13, Android 16 (AOSP-based)** on
`joyeuse`. Other variants are planned as separate build profiles:

```
variants/lunaris-3.13-a16/     Android 16, current target
variants/los22.2-a15/          Android 15
variants/crdroid12-a16/        Android 16
variants/miui14-stock/         MIUI 14 firmware baseline
variants/xiaomieu-hyperos/     community HyperOS port, best effort
```

A single AnyKernel3 zip is not expected to boot every ROM. The boot image,
ramdisk, DTB/DTBO, fstab, AVB layout, vendor modules and firmware differ
between ROM builds. Each variant records the exact build it was tested against.

## What this repository contains

This is a patch-based project. The full kernel source tree is fetched by the
build scripts and is not stored here. The repository holds:

- `versions.lock` — pinned upstream source revisions and toolchain identity.
- `patches/` — kernel patches in application order.
- `config/` — per-variant config fragments, one change per fragment.
- `scripts/` — source fetch, patch application and build entry points.
- `docs/` — platform notes, toolchain notes and root-stack notes.

## Feature set

Included by design:

- KernelSU Next `legacy` branch with manual/syscall-table hooks, or BakaSU.
- SUSFS in-tree patch for the 4.14 line; its `SPOOF_CMDLINE_OR_BOOTCONFIG`
  option is the primary cmdline spoof mechanism.
- Qualcomm `schedtune` (`/dev/stune/*`) for foreground and top-app boost.
- zram with LZ4 and writeback, conservative lmkd watermarks, TCP BBR.
- Optional userspace audio stack (ViPER4Android, AML, JamesDSP) delivered
  as a root module rather than as a kernel codec patch.

Excluded on purpose:

- Clang LTO/CFI: vendor modules are not built with matching CFI metadata.
- PREEMPT_RT: Qualcomm 4.14 drivers assume non-RT locking semantics.
- UKSM: aggressive page merging conflicts with zram and lmkd.
- uclamp by default: backport conflicts with the QCOM HMP scheduler.

## Partition layout

The device is A-only with a separate `recovery` partition. There are no
`boot_a`/`boot_b` or `init_boot` slots. AnyKernel3 installers must target
`/dev/block/bootdevice/by-name/boot` with slot handling disabled. See
`docs/PLATFORM.md`.

## Toolchain

The compiler is pinned after the first validated build. Clang 11.0.1 with
GCC 4.9 is the reference toolchain; Neutron Clang builds exist in the
community but must be verified against this exact source tree. See
`docs/TOOLCHAIN.md`.

## License

Kernel-side code is GPL-2.0-only. Scripts and config fragments are MIT when
originally written here. Documentation is CC-BY-4.0. See `LICENSE-NOTICE.md`.
Do not commit signing keys, built images, kernel modules, or proprietary
vendor blobs to this repository.

## Contributing

Work on `dev/<topic>` branches and open a pull request. Claims about a
successful boot must include command output (`uname -r`, ROM fingerprint),
not an assumption. See `CONTRIBUTING.md`.
