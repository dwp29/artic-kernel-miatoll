<!-- SPDX-License-Identifier: CC-BY-4.0 -->
# CONTRIBUTING

- `UNVERIFIED` = ada dugaan/hasil riset, belum diuji.
- `UNKNOWN` = belum ada data sama sekali.
- Satu perubahan = satu commit + satu build + satu verifikasi.
- Commit message memakai prefix: `[build]`, `[flash]`, `[cfg]`, `[docs]`, `[fix]`.
- Klaim boot sukses wajib menyertakan output perintah, bukan perkiraan.
- Jangan force-push ke `main`; gunakan branch `dev/<topik>` + PR.
- Jangan commit `out/`, `*.img`, `*.ko`, kunci signing, atau blob vendor.
