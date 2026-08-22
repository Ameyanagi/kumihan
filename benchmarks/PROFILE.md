# Core profiling baseline

Recorded 2026-08-22 on an Apple M4 running macOS 26.5.1 (25F80), Mojo
1.0.0 (`ed45d567`), and xctrace 26.0 (17C52). These findings cover only the
small deterministic synthetic font and nominal shaping implemented by v0.1;
they are not a proxy for full OpenType shaping or real CJK font parsing.

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
