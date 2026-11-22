<!-- SPDX-License-Identifier: GPL-2.0-only -->
# Artic Kernel — miatoll / joyeuse

Kernel Android non-GKI 4.14 untuk keluarga Xiaomi miatoll
(joyeuse / curtana / excalibur / gram), dengan fokus stabilitas, baterai,
dan root KernelSU + SUSFS.

## Status

**RESEARCH / SCAFFOLD — BELUM ADA BUILD YANG TERVERIFIKASI.**

- Target device saat ini: **Redmi Note 9 Pro (joyeuse)**.
- ROM yang dipakai: **Lunaris 3.13, Android 16 (AOSP-based)** → varian pertama.
- Arsitektur: satu source bersama + **varian kernel per ROM/build**.
- Fitur inti: KernelSU Next / BakaSU, SUSFS via backport, schedtune native,
  zram LZ4 + writeback, TCP BBR, audio boost userspace (ViPER/AML).
- Tidak masuk v1: LTO/CFI, PREEMPT_RT, UKSM, uclamp aktif default.

## Model varian

```
common/                  # source + patch + tuning (satu commit)
variants/
  lunaris-3.13-a16/      # prioritas pertama
  los22.2-a15/
  crdroid12-a16/
  miui14-stock/
  xiaomieu-hyperos/
```

zip AnyKernel3 tidak otomatis lintas-ROM: boot image, ramdisk, DTB/DTBO,
fstab, vendor module, firmware, dan AVB berbeda per build.

## Lisensi

| Path | Lisensi |
|---|---|
| root / patch kernel | GPL-2.0-only |
| scripts / config | MIT bila original |
| docs | CC-BY-4.0 |
| versions.lock | MIT |

Lihat `LICENSE-NOTICE.md`. Jangan memasukkan kode GPLv3 ke tree GPL-2.0
tanpa audit per-file. Jangan simpan private key, `.ko`, `.img`, atau
blob vendor proprietary di repo ini.

## Verifikasi

Lihat `versions.lock`. Sebelum build, jalankan pengecekan SHA dan SUBLEVEL.
Commit dengan klaim “boot sukses” wajib menyertakan output `uname -r`
dan ROM build fingerprint yang diuji.
