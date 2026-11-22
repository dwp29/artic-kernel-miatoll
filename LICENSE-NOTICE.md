<!-- SPDX-License-Identifier: GPL-2.0-only -->
# LICENSE-NOTICE.md

| Path | License | Catatan |
|---|---|---|
| `LICENSE` (root) | GPL-2.0-only | Default untuk seluruh repo, sesuai `COPYING` kernel upstream. |
| `patches/`, `kernel-side code/` | GPL-2.0-only | Patch adalah karya turunan dari source kernel GPL-2.0. |
| `scripts/`, `config/` | MIT (bila dibuat original) | Tambahkan SPDX di tiap file. Belum ada file aktif. |
| `docs/`, `README.md` | CC-BY-4.0 / lihat header | Dokumentasi. |
| `versions.lock` | MIT | Data lock, bukan karya turunan kernel. |

Perhatian: sebagian proyek root (KernelSU) dan SUSFS memiliki bagian GPLv3.
Jangan memindahkan kode GPLv3 ke tree kernel GPL-2.0 tanpa audit per-file.
Simpan `Signed-off-by` dan `Change-Id` original saat mengambil patch.
