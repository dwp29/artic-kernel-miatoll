<!-- SPDX-License-Identifier: CC-BY-4.0 -->
# Project notes

Artic targets the miatoll kernel line because replacing the vendor kernel
with a mainline 6.x tree would break the proprietary camera, DSP, audio and
charging stack. Keeping 4.14 preserves those features and keeps the project
focused on the parts that matter for daily use.

The current device is `joyeuse` running Lunaris 3.13 (Android 16). This ROM
is AOSP-based, so the same 4.14 kernel line can be used. Support is recorded
per ROM build rather than per Android version string: a zip validated on
Lunaris 3.13 is not silently advertised for another ROM.

Key decisions already made:

- Source base: 4.14.357-openela tree pinned in `versions.lock`.
- Root: KernelSU Next legacy or BakaSU, built into the kernel.
- Hiding: in-tree SUSFS patch, not the GKI-only LKM.
- Scheduling: Qualcomm `schedtune`; no uclamp by default.
- Memory: zram LZ4 with writeback and conservative lmkd watermarks.
- Audio: userspace modules, not a codec driver rewrite.
- Excluded: LTO, CFI, PREEMPT_RT, UKSM.

See `docs/PLATFORM.md`, `docs/TOOLCHAIN.md` and `docs/ROOT-STACK.md` for the
technical background behind those choices.
