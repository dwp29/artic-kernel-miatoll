<!-- SPDX-License-Identifier: CC-BY-4.0 -->
# Artic Manager UI concept — Arctic Aurora

This document describes the manager application that will pair with the
Artic kernel. The manager is a separate project from the kernel repository;
this file only records the design contract.

## Theme

**Arctic Aurora** is the default theme. It is a cold, technical dark theme
with aurora accents rather than a generic root-manager look.

| Token | Value | Use |
|---|---|---|
| `surface_base` | `#0B1220` | App background |
| `surface_card` | `#121E33` | Cards and sheets |
| `surface_glass` | `#1A2A45` at 70% | Frosted panels |
| `aurora_cyan` | `#4DD0E1` | Primary accent, active state |
| `aurora_teal` | `#26A69A` | Success, root active |
| `aurora_violet` | `#7E57C2` | Warning, advanced tools |
| `text_primary` | `#E6F1FF` | Main text |
| `text_secondary` | `#9FB3C8` | Supporting text |

Typography: system sans with a monospace family for kernel strings,
`uname -r`, hashes and version codes. Shape scale: 12dp cards, 16dp sheets,
fully rounded chips. Motion: 180-250 ms, `FastOutSlowIn`, reduced-motion
override in settings.

## Navigation

Bottom navigation, five destinations:

1. **Status** — root, kernel and hiding state.
2. **Profiles** — per-app root rules.
3. **Modules** — install, enable, WebUI.
4. **Tuning** — performance and memory presets.
5. **Vault** — backups, signatures, safety tools.

## Status screen

```
+------------------------------------+
| snowflake  ARTIC        shield ok |
+------------------------------------+
| ROOT  active     KSU  v3.4.2      |
| 4.14.357-artic-aurora             |
+------------------------------------+
| BATTERY  OK   THERMAL  38C        |
| ZRAM  lz4   SUSFS  active         |
+------------------------------------+
| [ Battery ] [ Social ] [ Balance ] |
| [ Performance ]                   |
+------------------------------------+
NaN
NaN
+------------------------------------+
NaN

The status card is the identity check. It shows the exact kernel version
string and the build tag, so a stale or wrong kernel is obvious.

## New features

- **Signature badge**: shows whether the running manager matches the kernel
  expected signature hash. This is the exclusivity indicator.
- **Kernel identity**: displays `uname -r`, compiler string, source commit
  and defconfig recorded in `versions.lock`.
- **SUSFS panel**: hiding state, cmdline spoof state, and the option to
  disable hiding for a selected app.
- **Tuning presets**: Battery / Social / Balance / Performance, each mapping
  to a documented set of `schedtune`, zram, lmkd and TCP values. No preset
  changes LTO, CFI, PREEMPT_RT or UKSM.
- **Safety checklist**: before flashing, confirm firmware, recovery variant,
  boot backup and ROM build fingerprint.
- **Boot log viewer**: reads `dmesg`, `last_kmsg` and root manager logs with
  filtering for `artic`, `ksu`, `susfs` and `module`.
- **OTA guardian**: detects ROM update and reminds the user to reflash the
  matching Artic variant before installing modules.
- **Module WebUI**: host module configuration screens inside the manager.
- **Vault**: stores the manager keystore path, signature hash, boot backup
  hash and a rollback checklist. Private keys are never stored in the app.

## Exclusive signature flow

1. Generate a dedicated release keystore for the Artic manager and keep it
   offline. Do not commit it.
2. Build the forked manager from the same release line as the kernel UAPI.
3. Run `ksud debug get-sign <apk>` and record signature size and hash.
4. Rebuild the kernel with the matching `KSU_NEXT_MANAGER_SIZE` and
   `KSU_NEXT_MANAGER_HASH`, or apply the pair with
   `ksud debug set-manager <apk>`.
5. Flash the kernel, install the manager, verify the shield badge and
   `su -c id`.
6. Keep the old manager APK and stock boot backup for rollback.

Changing the application id may also require changing the package name
expected by the root implementation. Verify that constant in the exact
fork before changing it; the signature gate alone is not the whole story.

## UX rules

- Dark theme by default; dynamic color is opt-in so the aurora identity stays.
- Touch targets at least 48dp; content descriptions on every icon.
- Destructive actions require a confirmation sheet naming the consequence.
- Safe mode is reachable from the status screen without opening settings.
- Every toggle shows its current kernel value and the last applied time.
- Respect reduced motion and system font scale.

## Artifact

Mockups: `docs/artic-aurora-mockup.svg` (v1) and `docs/artic-aurora-mockup-v2.svg`
(refined typography, consistent strokes, aurora nav and rounded status pills).
