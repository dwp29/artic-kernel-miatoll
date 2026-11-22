<!-- SPDX-License-Identifier: CC-BY-4.0 -->
# KernelSU manager notes

## Manager is not the root

Artic carries the root driver inside the kernel. The manager APK is only the
control panel and the `ksud` userspace helper. Flashing an AnyKernel3 zip
does not require a patched boot image, and installing the manager alone does
not create root if the kernel was built without `CONFIG_KSU=y`.

## Match the manager to the kernel

| Root in kernel | Manager to install | Source |
|---|---|---|
| KernelSU Next `legacy` | KernelSU Next manager, same release line as the kernel UAPI | KernelSU-Next releases on GitHub |
| BakaSU | BakaSU / compatible KernelSU Next manager | BakaSU project releases |
| SukiSU Nova | SukiSU Nova manager | SukiSU-Nova releases |
| APatch | APatch manager | bmax121/APatch releases |
| Magisk fallback | Magisk stable manager | topjohnwu/Magisk releases |

The manager must be at least as new as the kernel UAPI. A manager older than
the driver reports **Not installed**. A manager from a different fork is not
a safe substitute even if the icon looks the same.

Download manager APKs from project releases. Do not take a random APK from
a Telegram mirror. Record the download source and checksum.

## First boot checklist

1. Boot the kernel and confirm the driver is loaded.
2. Install the matching manager APK.
3. Open the manager; it should show the kernel version and **Working**.
4. Run `su -c id` from `adb shell`. If root is denied, grant root to
   `com.android.shell` in the Superuser list.
5. Install only the modules that are actually needed.

## Profiles and modules

Per-app profiles control root grant, UID/GID, capabilities, SELinux context,
mount namespace and whether modules are unmounted for that app. Use them
instead of granting global root to everything.

KernelSU modules use the metamodule/overlay model. A Magisk module may need
adaptation before it works. Do not install two root implementations at once.
ZygiskNext is the companion module needed by Zygisk-based modules such as
PlayIntegrityFork when running KernelSU or APatch.

## Safe mode and recovery

The manager has a safe-mode switch that disables modules and root
temporarily. The volume-key listener on non-GKI kernels has to be wired up
in the kernel source; do not assume it works just because it works on GKI.

Manual recovery path:

- `ksud module disable <id>` when the manager still opens.
- Rename `/data/adb/modules` to `/data/adb/modules.off` from recovery.
- Flash the backed-up stock `boot` image if the kernel itself is at fault.

## APatch-specific note

APatch uses a SuperKey. Save it before rebooting: it cannot be recovered
without reflashing from scratch.

## OTA and ROM changes

A full ROM update replaces the boot image and removes the built-in root.
Reflash the matching Artic variant after the ROM update. Verify root,
camera, fingerprint and audio again before installing modules.

## Common failures

| Symptom | Likely cause |
|---|---|
| Manager says Not installed | Driver missing, or manager older than kernel UAPI |
| `su` not found in shell | `com.android.shell` not granted root |
| Module inactive | Wrong module format, metamodule missing, or module disabled |
| Bootloop after module install | Module incompatible; use safe mode |
| Root lost after OTA | Boot image replaced; reflash Artic |
