# Benchmarks

Run the reproducible core benchmark from the repository root:

```sh
pixi run bench-core
```

The Pixi task first compiles `bench_core.mojo` with `mojo build -O3`, then runs
that AOT executable. Compiler startup is never part of a measurement.

## Core protocol

The benchmark uses the small deterministic builders in
`tests/support/font_fixture.mojo`. Its results characterize Kumihan's current
foundational algorithms; they are not representative of real Noto or Source
Han font sizes and must be labelled **synthetic** when quoted. Timed regions
measure:

- validated construction of one face from pre-copied synthetic SFNT bytes;
- alternating construction of both faces from one already-created
  `FontCollection`, proving that the TTC backing allocation remains shared;
- cached `cmap` format 12 lookups over deterministic ASCII and CJK hits and
  misses, including a supplementary-plane character;
- cached `cmap` format 14 lookup distributions for supported default,
  supported explicit, and unsupported variation sequences;
- both allocating `shape_nominal` and retained-capacity `shape_nominal_into`
  over identical deterministic mixed ASCII, Japanese, Han, Hangul, and
  supplementary-plane text, plus retained-capacity shaping of mixed supported
  default, supported explicit, and unsupported ideographic variation sequences;
- the nominal oracle, allocating `shape`, and retained-capacity `shape_into`
  over all-hit synthetic SingleSubst format 1/Coverage format 1 and SingleSubst
  format 2/Coverage format 2 tables, at short and long run lengths;
- explicit CJK IVS resolution followed by `locl`, again comparing nominal,
  allocating, and retained-buffer paths; and
- an end-to-end selector scaling probe comparing one DFLT lookup with the
  seven-lookup `hani`/`JAN` fixture through the public `shape_into` API.

The construction cases perform 4,096 single-face constructions or 4,096 TTC
face pairs per sample. Input fixture generation and SFNT byte copying are
outside the single-face timer. TTC collection construction is outside the
shared-face timer. Lookup cases contain 1,024, 65,536, and 1,048,576 scalars,
normalized to 1,048,576 lookup operations per sample. Shaping cases contain
256, 4,096, and 65,536 scalars, normalized to 65,536 scalar operations per
sample. Each format 14 category performs 1,048,576 variation lookups per
sample. IVS shaping contains 128, 2,048, and 32,768 two-scalar sequences,
normalized to 65,536 input scalar operations per sample. Each case performs
three warmup rounds and then records 31 independent elapsed-time samples with
`perf_counter_ns`. Reported p50 and p95 values use nearest rank (sorted indices
15 and 29). The GSUB short and long runs contain 16 and 4,096 input scalars and
are normalized to 32,768 input scalar operations per sample. The IVS-to-`locl`
cases contain 8 and 2,048 two-scalar sequences. These fixtures deliberately
exercise only the supported `locl` SingleSubst slice; they do not model full
OpenType shaping or real CJK font-table distributions.

Every sample is checked against a deterministic semantic checksum. Lookup
checksums consume positions and glyph IDs. Shaping checksums consume glyph IDs,
UTF-8 cluster starts and ends, advances, missing-glyph count, and source byte
length. The allocating and reusable cases must produce the same checksum.
Checksum validation is outside each shaping timed region, and measurement
order alternates or rotates per sample to reduce order bias. The output also
records UTF-8/input sizes, operation counts, nanoseconds per scalar, and
throughput. Each construction boundary is separately labelled so parsing,
fixture preparation, and cached hot paths are not conflated.

Kumihan does not currently expose a public shape-plan object or separate plan
selection/execution calls. The benchmark therefore does not import private
GSUB internals or claim to isolate planning. The one-versus-seven-lookup probe
measures selector scaling indirectly through the supported public workflow.

Results are distribution measurements, not universal performance claims. When
publishing numbers, record the CPU, OS, machine load, `mojo --version`, commit,
and full command beside the raw output. Use an OS profiler and peak-memory tool
on the compiled `.pixi/bench-core` executable when investigating a regression;
those platform-specific measurements do not contaminate the portable timing
protocol.

Profile before proposing SIMD or parallelism. Table validation and binary
search are branch-heavy and may remain scalar. Regular batched outline
transforms, glyph image preparation, and downstream compositing are stronger
SIMD candidates once those features exist. Report negative results when
launch, gather, allocation, or cache overhead outweighs the kernel improvement.

The checked profiling commands, machine context, and current evidence are in
[the core profiling baseline](PROFILE.md).
