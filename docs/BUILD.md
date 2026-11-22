<!-- SPDX-License-Identifier: CC-BY-4.0 -->
# Building Artic

## Baseline build

The baseline build is the unmodified RedCherry source at the commit pinned
in `versions.lock`. It contains no root integration yet. Its purpose is to
prove that the pinned source, compiler and AnyKernel3 layout produce a
bootable package for the target ROM.

GitHub Actions runs `build-artic-baseline` automatically when the build
scripts or `versions.lock` change. It can also be started manually from the
Actions tab with `workflow_dispatch`.

Artifacts: `Image.gz`, `dtbo.img`, `cust-atoll-ab.dtb`, `compile.h`,
`log.txt` and the RedCherry AnyKernel3 zip.

## Local build

```bash
bash scripts/fetch-sources.sh
bash scripts/verify-source.sh
bash scripts/build-baseline.sh
```

The scripts expect to be run from the repository root. The upstream
`build.py` downloads AOSP Clang r530567 and the GCC 4.9 prebuilts into
`src/clang`, `src/gcc` and `src/gcc32`. Those directories are ignored by git.

## What is not in the baseline

- KernelSU Next driver.
- SUSFS patches.
- Artic config fragment and init tweaks.
- Custom manager signature.

Those are added only after the baseline boots on the target ROM.
