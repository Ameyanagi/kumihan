# Core profiling baseline

Recorded 2026-08-22 on an Apple M4 running macOS 26.5.1 (25F80), Mojo
1.0.0 (`ed45d567`), and xctrace 26.0 (17C52). These findings cover only the
small deterministic synthetic fonts, nominal shaping, and the current
SingleSubst `locl` slice; they are not a proxy for full OpenType shaping or
real CJK font parsing.

## Reproduce

Build once, then keep trace bundles outside the repository:

```sh
pixi run mojo build -O3 -I src -I tests \
  benchmarks/bench_core.mojo -o .pixi/bench-core

kumihan_profile_dir="$(mktemp -d /tmp/kumihan-profile.XXXXXX)"
for mode in allocating reuse; do
  xcrun xctrace record \
    --template 'Time Profiler' \
    --output "$kumihan_profile_dir/time-$mode.trace" \
    --no-prompt \
    --launch -- "$PWD/.pixi/bench-core" "--profile-$mode"
  xcrun xctrace record \
    --template 'Allocations' \
    --output "$kumihan_profile_dir/alloc-$mode.trace" \
    --no-prompt \
    --launch -- "$PWD/.pixi/bench-core" "--profile-$mode"
done
```

Each profiling mode shapes the same 4,096-scalar mixed CJK/ASCII string 8,192
times: 33,554,432 scalar operations. Both modes must print checksum
`522842188`; the reusable mode must also retain capacity `4096`.

Export raw Time Profiler samples and the Allocations summary as XML when a
machine-readable comparison is needed:

```sh
xcrun xctrace export \
  --input "$kumihan_profile_dir/time-allocating.trace" \
  --xpath '/trace-toc/run[@number="1"]/data/table[@schema="time-profile"]'
xcrun xctrace export \
  --input "$kumihan_profile_dir/alloc-allocating.trace" \
  --xpath '/trace-toc/run[@number="1"]/tracks/track[@name="Allocations"]/details/detail[@name="Statistics"]'
```

Delete the temporary directory after extracting the evidence needed for a
report. Do not commit `.trace` bundles or exported raw XML.

## Evidence

The allocating recording contained 1,024 Time Profiler samples. The reusable
recording contained 1,162. Top-of-stack aggregation placed 984/1,024 (96.1%)
and 1,146/1,162 (98.6%), respectively, in `shape_nominal_into`, format-12 cmap
lookup, or their bounded 16/32-bit reads. The allocating samples also contained
`List::_realloc`, `_alloc_bytes`, and tcmalloc frames. None of those allocator
symbols appeared in the reusable sampled stacks.

The Allocations instrument reported almost identical Apple malloc-zone totals:
1,429 events and 920,096 bytes for allocating versus 1,428 events and 920,032
bytes for reuse. This is not a valid count of Mojo list-buffer allocations:
the Time Profiler proves those go through the Mojo runtime's tcmalloc path,
which this Allocations summary does not attribute. Treat the trace as evidence
of allocator-path presence/absence, not as an allocation-count oracle.

The distribution benchmark is the latency authority. On this run, retained
buffers reduced p50 elapsed time by about 4–5% at 256, 4,096, and 65,536
scalars while producing byte-cluster, glyph, and advance checksums identical
to the allocating API. The profile does not justify SIMD in nominal shaping:
the work is dominated by scalar UTF-8 traversal, branch-heavy cmap lookup, and
seven parallel appends. Retained storage is the appropriate optimization at
this stage.

## Ideographic variation sequences

The format 14 extension adds a third profiling mode:

```sh
xcrun xctrace record \
  --template 'Time Profiler' \
  --output "$kumihan_profile_dir/time-ivs-reuse.trace" \
  --no-prompt \
  --launch -- "$PWD/.pixi/bench-core" --profile-ivs-reuse
```

It shapes 2,048 two-scalar IVSes 8,192 times, or 33,554,432 input scalar
operations, into one retained `ShapeBuffer`. The expected output is capacity
`2048` and checksum `356637355`.

The 2026-08-22 Apple M4 recording contained 1,601 Time Profiler samples.
Top-of-stack aggregation placed 1,589/1,601 samples (99.3%) in
`shape_nominal_into`, `variation_glyph_id`, format-12 lookup, or their bounded
16/24/32-bit reads. Only 29 samples (1.8%) landed directly in
`variation_glyph_id` and 38 (2.4%) in its 24-bit reads; the enclosing scalar
decode, cluster update, and seven parallel appends remained the dominant
combined frame.

No production optimization was applied from this profile. Selector lookup and
default/explicit dispatch are serialized, branch-heavy binary searches over
variable-sized font records; they are not a safe SIMD target. A special cache
for one repeated selector would add state and can regress mixed-selector text,
while the profile attributes too little exclusive time to justify it. Revisit
only with real CJK fonts containing larger format 14 tables and a matching
correctness oracle.

## GSUB/`locl` pre-selection-mask baseline

Provenance: this baseline was recorded from an uncommitted intermediate GSUB
working tree derived from commit `be09c36a31a5bc6c612df999d7f79bbdf735dcd3`.
It is a before-change measurement, not the output of a standalone commit.

The v5 O3 protocol adds public-workflow comparisons for SingleSubst format 1
with Coverage format 1, SingleSubst format 2 with Coverage format 2, and an
explicit IVS followed by `locl`. “Short” is 16 input scalars and “long” is
4,096; every row below represents 32,768 input scalar operations per sample.
These are exact p50/p95 results from the same Apple M4 host before the planned
lookup-selection-mask change:

| Fixture and public path | Run | p50 ns/scalar | p95 ns/scalar | Checksum |
| --- | ---: | ---: | ---: | ---: |
| format1/Coverage1 `shape_nominal` | short | 52.612 | 56.641 | 1,076,528 |
| format1/Coverage1 `shape` | short | 90.668 | 96.466 | 1,793,464 |
| format1/Coverage1 `shape_into` | short | 65.887 | 70.343 | 1,793,464 |
| format1/Coverage1 `shape_nominal` | long | 29.083 | 29.297 | 359,149,568 |
| format1/Coverage1 `shape` | long | 57.495 | 58.228 | 551,041,024 |
| format1/Coverage1 `shape_into` | long | 57.281 | 57.617 | 551,041,024 |
| format2/Coverage2 `shape_nominal` | short | 51.880 | 52.338 | 1,525,978 |
| format2/Coverage2 `shape` | short | 92.987 | 93.506 | 1,515,001 |
| format2/Coverage2 `shape_into` | short | 68.024 | 68.481 | 1,515,001 |
| format2/Coverage2 `shape_nominal` | long | 27.985 | 28.839 | 579,310,418 |
| format2/Coverage2 `shape` | long | 60.547 | 61.432 | 572,481,081 |
| format2/Coverage2 `shape_into` | long | 59.601 | 59.845 | 572,481,081 |
| IVS-to-format1/Coverage1 `shape_nominal` | short | 57.861 | 58.105 | 898,120 |
| IVS-to-format1/Coverage1 `shape` | short | 79.620 | 80.353 | 539,576 |
| IVS-to-format1/Coverage1 `shape_into` | short | 54.871 | 55.115 | 539,576 |
| IVS-to-format1/Coverage1 `shape_nominal` | long | 32.898 | 33.051 | 359,434,240 |
| IVS-to-format1/Coverage1 `shape` | long | 46.814 | 47.394 | 259,291,136 |
| IVS-to-format1/Coverage1 `shape_into` | long | 46.051 | 46.143 | 259,291,136 |

The public selector probe holds the glyph workload constant and changes the
synthetic table from one DFLT lookup to seven lookup/feature records selected
through `hani`/`JAN`. At 16 scalars, `shape_into` rose from p50/p95
66.315/66.498 to 83.649/83.862 ns/scalar: about 277 ns extra per call. At 4,096
scalars the corresponding results were 55.939/56.122 and 55.878/56.030
ns/scalar, indistinguishable at this resolution. This is evidence of fixed
per-call selection cost that matters for short labels, while glyph execution
dominates long runs. It does not isolate plan selection because no public
shape-plan or selection/execution boundary exists.

The dominant reusable format2/Coverage2 long case is reproducible with:

```sh
xcrun xctrace record \
  --template 'Time Profiler' \
  --output "$kumihan_profile_dir/time-gsub-format2-long.trace" \
  --no-prompt \
  --launch -- "$PWD/.pixi/bench-core" --profile-gsub-format2-long
```

The mode performs 8,192 retained-buffer calls, or 33,554,432 input scalar
operations, and must report capacity `4096` and checksum `572481081`. A direct
run took 1.75 s user time with 12,599,296-byte maximum RSS. The xctrace run
recorded 2,167 rows, of which 1,635 had no unwindable top stack. Of the 519
resolved application hot-path top stacks, 284 were in `shape_nominal_into`,
150 in the enclosing `shape_into`, 71 in 16-bit table reads, 10 in format-12
cmap lookup, and 4 in 32-bit table reads. O3 inlining prevents reliable
exclusive attribution of coverage selection versus substitution inside
`shape_into`, so the latency distributions remain the authority.

This profile does not justify SIMD. UTF-8/cmap traversal, ordered lookup
application, variable-size coverage binary search, and bounded font-table reads
are branch-heavy and do not expose a regular vectorizable kernel. The short-run
selector result does justify removing repeated selection membership work with
a retained scalar lookup mask if adversarial table complexity is also bounded;
the identical long-run probe shows why broad glyph-path caching or SIMD would
be premature.

## GSUB/`locl` initial post-selection-mask result

After `ShapeBuffer` gained a retained UInt8 lookup mask, feature edges are
resolved once and preflight/execution traverse the mask linearly. The exact
same v5 binary protocol was rebuilt with O3 and repeated before the subsequent
feature-offset scratch/dedup correction. The clean selector run was:

| Public `shape_into` selector probe | Run | p50 ns/scalar | p95 ns/scalar | Checksum |
| --- | ---: | ---: | ---: | ---: |
| DFLT, one lookup | short | 64.331 | 64.606 | 1,793,464 |
| `hani`/`JAN`, seven lookups | short | 66.284 | 66.681 | 1,793,600 |
| DFLT, one lookup | long | 56.213 | 56.396 | 551,041,024 |
| `hani`/`JAN`, seven lookups | long | 56.763 | 56.946 | 559,431,680 |

The incremental short-run breadth cost fell from about 277 ns/call before the
mask to about 31 ns/call after it, an 88.7% reduction. The seven/one p50 ratio
fell from 1.261 to 1.030. Long rows remain within 1% because per-glyph coverage,
substitution, and advance recomputation dominate. Independent repeat runs put
the post-mask short seven/one ratio between 1.008 and 1.067; the exact clean
run above is retained rather than averaging benchmark distributions.

The dominant format2/Coverage2 long `shape_into` row changed from p50/p95
59.601/59.845 to 60.272/60.577 ns/scalar, a 1.1–1.2% difference on this host.
The fixed 33,554,432-scalar profile mode changed from 1.75 to 1.80 s user time,
6,625,645,454 to 6,661,897,558 cycles, and 35,983,328,559 to 36,181,452,086
retired instructions. The approximately 0.55% cycle/instruction change is the
expected small cost of preparing a one-entry mask and is below the variance of
the elapsed distribution; maximum RSS fell from 12,599,296 to 12,566,528 bytes.

The post-mask xctrace export contained 1,835 rows, with 1,542 lacking an
unwindable top stack. Its 285 resolved application hot-path top stacks were 234
in `shape_nominal_into`, 40 in 16-bit table reads, 8 in 32-bit table reads, and
3 in format-12 cmap lookup. O3 inlined the GSUB body and did not expose a new
named mask or vector kernel. Different unwind rates make sample-count deltas
between the two traces non-comparable, but both support the distribution result:
long input remains dominated by nominal mapping and scalar table traversal.

The mask is justified both by the measured short-run improvement and by the
algorithmic change from repeated O(lookup-count × selected-edge-count)
membership scans to O(selected-edge-count + lookup-count). No second cache or
public plan API is warranted by these synthetic results. SIMD remains
unjustified; the changed work is a small, branch-dependent graph-to-byte-mask
resolution followed by ordered scalar table execution.

## Final feature-offset scratch rerun

Provenance: the recorded source became feature commit
`021f304d33a3dc0d53da097089551f4255f083c8`, derived from
`be09c36a31a5bc6c612df999d7f79bbdf735dcd3`. The only later change was this
provenance note.

The unchanged v5 harness was rebuilt with stable Mojo 1.0.0 and O3. A clean
repeat produced:

| Public `shape_into` case | Run | p50 ns/scalar | p95 ns/scalar | Checksum |
| --- | ---: | ---: | ---: | ---: |
| DFLT, one-lookup selector probe | short | 73.090 | 73.181 | 1,793,464 |
| `hani`/`JAN`, seven-lookup selector probe | short | 69.855 | 75.470 | 1,793,600 |
| DFLT, one-lookup selector probe | long | 59.631 | 59.937 | 551,041,024 |
| `hani`/`JAN`, seven-lookup selector probe | long | 59.235 | 64.026 | 559,431,680 |
| format2/Coverage2 | long | 67.932 | 68.085 | 572,481,081 |

The exact-script `hani` path and DFLT fallback are not identical selector
workloads, so a slightly lower seven-lookup p50 is not a negative lookup cost.
It means the retained scratch has reduced lookup breadth below other fixed
script-selection differences in this synthetic public-workflow probe. The
earlier 1.261 seven/one short-run ratio remains eliminated; this repeat's ratio
is 0.956 at p50 and 1.031 at p95.

The wall-time distribution was recorded at a slower host-frequency/load point
than the initial post-mask table. The fixed 33,554,432-scalar profile mode is a
better regression check: its first clean run reported 1.77 s user time,
6,547,311,134 cycles, 36,181,655,437 retired instructions, and 12,632,064-byte
maximum RSS. Relative to the initial post-mask profile, instructions changed
by only +0.0006% and cycles improved by about 1.7%. The feature-offset scratch
therefore does not materially change the dominant long-run work. No additional
xctrace recording or SIMD change is justified by this rerun.
