<!-- SPDX-License-Identifier: CC-BY-4.0 -->
# License notice

| Path | License | Reason |
|---|---|---|
| Root `LICENSE` | GPL-2.0-only | Matches the upstream kernel `COPYING`. |
| `patches/` and kernel-side source | GPL-2.0-only | Kernel patches are derivative works of GPL-2.0 source. |
| `scripts/`, `config/`, `versions.lock` | MIT | Original build tooling and data files. |
| `docs/`, `README.md` | CC-BY-4.0 | Documentation. |

Some root projects contain GPLv3 components. KernelSU permits its `kernel/`
directory under GPL-2.0-only, while other parts are GPLv3. SUSFS is hosted
on GitLab under a GPLv3 license file. Before importing a patch, check the
license header of that specific file and do not place GPLv3-only code in a
GPL-2.0-only kernel tree without resolving the conflict.

Keep the original `Signed-off-by` and `Change-Id` lines when carrying a
patch. Those are authorship and DCO records, not replaceable labels.
