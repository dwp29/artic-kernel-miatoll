<!-- SPDX-License-Identifier: CC-BY-4.0 -->
# Building Artic

## Variants

| Variant | Target | Fragment |
|---|---|---|
| `artic` | AOSP-based ROMs, first target Lunaris 3.13 / Android 16 | `config/artic.fragment` |
| `artic-xp` | Port ROM builds (MIUI/HyperOS/Xiaomi.EU family) | `config/artic-xp.fragment` |

Both variants currently build the same pinned RedCherry source. The split
exists so ROM-specific config, init and AnyKernel values can be added one
at a time without cross-contaminating the AOSP target. `artic-xp` is not a
claim of compatibility with any specific port build until that build is
flashed and tested.

## CI build

GitHub Actions runs `build-artic-variants` on changes to scripts, config,
`versions.lock` or the workflow, and can be started manually from the
Actions tab. Two jobs run in parallel, one per variant.

Artifacts per job: `Image.gz`, `dtbo.img`, `cust-atoll-ab.dtb`, `compile.h`,
`log.txt` and an AnyKernel3 zip named `artic-<variant>-<timestamp>.zip`.

## Local build

```bash
bash scripts/fetch-sources.sh
bash scripts/verify-source.sh
VARIANT=artic bash scripts/build-variant.sh
VARIANT=artic-xp bash scripts/build-variant.sh
```

The script downloads AOSP Clang r530567 and GCC 4.9 prebuilts into
`src/clang`, `src/gcc` and `src/gcc32`. Those directories are ignored by git.

## What is not in these builds

- KernelSU Next driver.
- SUSFS patches.
- Artic init tweaks.
- Custom manager signature.

Those are added only after a baseline variant boots on its target ROM.
