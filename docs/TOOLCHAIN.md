<!-- SPDX-License-Identifier: CC-BY-4.0 -->
# Toolchain policy

## Selected base

Artic is based on the RedCherry `17` source tree, pinned in `versions.lock`.
That tree builds with AOSP Clang **r530567** and full LLVM. The compiler
choice follows the base until a measured reason to change it exists.

## Does the compiler change the result?

Yes. It changes the machine code that is actually flashed: image size,
register allocation, inlining and sometimes boot behaviour. On this kernel
line the practical effects are:

- **Build success or failure.** Older inline assembly and global register
  constraints can fail on a newer compiler. A system Clang 18 build of the
  crDroid-era tree is known to fail on `register 'sp' unsuitable` and
  out-of-range immediate constraints.
- **Module compatibility.** This is non-GKI, so there is no KMI. CRC and
  `vermagic` still have to be checked after every config or source change.
- **Performance and battery.** Inside a valid toolchain family, config and
  scheduler tuning matter more than compiler version. Compare the same
  source before claiming a gain.

## Toolchain order

| Order | Toolchain | Reason |
|---|---|---|
| 1 | AOSP Clang r530567 | Pinned by the RedCherry `17` base. |
| 2 | Neutron Clang | Stable on Synthetica/joyeuse in daily use; A/B test after the baseline boots. |
| 3 | Clang 11.0.1 + GCC 4.9 | Use only with the crDroid 16.0 fallback base. |
| Never | System Clang 18 on the old tree | Known failure, not a valid pin. |

Neutron builds from LLVM snapshots; stability is not guaranteed by the
project. Pin the exact snapshot and never use a moving `latest` tag.

## Rules

1. Pin the compiler build in `versions.lock`.
2. Record `LINUX_COMPILER` from `out/include/generated/compile.h`.
3. Keep `LLVM=1`, `CLANG_TRIPLE`, `CROSS_COMPILE` and `CROSS_COMPILE_ARM32`
   consistent between the baseline build and every variant.
4. Change one variable at a time.
5. Do not enable LTO or CFI. Vendor modules are not built with matching
   CFI metadata, and linking needs more memory than a typical 8 GiB host.

