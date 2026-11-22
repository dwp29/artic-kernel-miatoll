<!-- SPDX-License-Identifier: CC-BY-4.0 -->
# Toolchain policy

## Does the compiler change the result?

Yes. The compiler decides the machine code that is actually flashed.
It affects image size, register allocation, inlining, and sometimes boot
behaviour. For a vendor 4.14 tree the practical effects are usually:

- **Build success or failure.** This tree was built with Clang 11.0.1 and
  GCC 4.9 prebuilts. A system Clang 18 build fails on `register 'sp'`,
  unsuitable for global register variables` and out-of-range immediate
  constraints. Community builds with Neutron Clang 18 exist, but they use
  a patched tree and their own flags.
- **Module compatibility.** Compiler changes do not by themselves change
  KMI on a non-GKI device, but they can change exported symbol CRC and
  `vermagic` if config or source differs. Verify modules after each build.
- **Performance and battery.** Within a valid toolchain family, config and
  scheduler tuning matter far more than compiler version. Benchmark the
  same source with both toolchains before claiming a difference.

## Field evidence

A Synthetica kernel built with Neutron Clang has been used on the same
device family (`joyeuse`, Lunaris 3.13 / Android 16) and reported stable in
daily use. That makes Neutron Clang the first toolchain to try for Artic.
It is still evidence from one source revision: record the exact compiler
build and the resulting `LINUX_COMPILER` string before treating it as a pin.

Clang 11.0.1 with GCC 4.9 remains the fallback when a build is not
reproducible with Neutron Clang.

## Rules for this project

1. Pin the exact compiler build. Record it in `versions.lock`.
2. Record `LINUX_COMPILER` from `out/include/generated/compile.h`.
3. Keep `LLVM=1`, `CLANG_TRIPLE`, `CROSS_COMPILE` and `CROSS_COMPILE_ARM32`
   consistent between the baseline build and every variant.
4. Change one variable at a time. A toolchain change is a separate build
   from a config change.
5. Do not enable LTO or CFI on this tree. Vendor modules are not built with
   matching CFI metadata, and the link step needs more memory than a
   typical 8 GiB build host provides.

## Reference combinations

| Toolchain | Status |
|---|---|
| Neutron Clang 18 | Field-tested on Synthetica/joyeuse; first candidate for Artic. |
| Clang 11.0.1 r6443078 + GCC 4.9 | Reference combination; fallback. |
| System Clang 18 | Known to fail on this source line. |

The first validated Artic build decides the pinned value. Until then
`versions.lock` keeps the intended combinations and leaves the actual
compiler string unrecorded.
