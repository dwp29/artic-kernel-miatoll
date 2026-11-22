<!-- SPDX-License-Identifier: CC-BY-4.0 -->
# Ringkasan riset Artic

- Device: joyeuse / miatoll, SM7125, kernel 4.14 non-GKI.
- Target ROM saat ini: Lunaris 3.13 Android 16 (AOSP).
- Base kandidat: 4.14.357-openela (SHA di `versions.lock`).
- SUSFS di 4.14 memungkinkan via backport; bukti: NonGKI_Kernel_Build_2nd.
- KSU versi terverifikasi: official v3.3.1, Next v3.4.2, APatch 11282.
- Uclamp/cgroup v2: backport ada tapi eksperimental di 4.14.
- Bootloader spoof hanya mengubah `/proc/cmdline`/`ro.boot.*`, bukan TEE/StrongBox.
- LTO/CFI, PREEMPT_RT, UKSM: risiko runtime device, bukan sekadar build env.

Detail lengkap ada di dokumen riset lokal author; akan dipindahkan bertahap ke `docs/`.
