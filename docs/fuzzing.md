# Bounded font parser mutation campaigns

`pixi run --locked fuzz-smoke` compiles one AOT worker and tests 256 deterministic
inputs on Linux. Required pull-request CI runs this task; the weekly and manual
Extended parser fuzzing workflow runs `pixi run --locked fuzz-long` (12,000
inputs). The default seed is `0x4B554D49` and is printed with the result. A run
succeeds only after all requested inputs and checked-in regressions complete.

The worker exports nine minimal synthetic fixtures from the existing licensed
builders: SFNT/cmap 4, SFNT/cmap 12, TTC, cmap 14, and five GSUB variants covering
SingleSubst, CJK selection, coverage format 2, FeatureVariations, and lookup
ordering. Every original fixture must yield a valid run. Mutations cycle each
fixture and family, changing 16/32-bit fields to boundary lengths/counts/offsets,
swapping adjacent 16-bit values (including coverage ordering), flipping bits,
deleting ranges, and truncating tables. This is deterministic mutation testing;
it does not claim coverage-guided fuzzing or exhaustive parser safety.

Each input is at most 16 KiB and runs in a fresh process with Linux kernel
limits of **4 GiB virtual address space**, **1 CPU second**, **64 KiB per output
file**, and no core dumps. A parent watchdog kills the process group after
**2 wall-clock seconds**. The virtual ceiling accommodates Mojo 1.0 TCMalloc,
which reserves 1 GiB arenas even for small inputs; this is an address-space
budget, not a claim that each input needs that much resident memory. The whole campaign has a separate deadline (300 seconds
for smoke, 900 seconds for the extended run), and generates mutations lazily.
`fuzz-test`, included in `check`, tests reproducibility and retention everywhere,
and tests actual mmap rejection, CPU termination, and timeout termination on
Linux. These hard address-space guarantees rely on Linux `RLIMIT_AS`; the
campaign deliberately fails with an explanation on macOS, where that limit
is not reliably enforced. The normal Mojo tests and worker compilation remain
portable across all three supported platforms.

A controlled collection/face parse error or unsupported shaping error is an
expected outcome. Successful glyph runs must pass both invariant and source
validation, and all glyph IDs must fit the face. Invariant failures are outside
the parse-error handlers and fail the campaign. A signal, abnormal exit,
unexpected output, or timeout retains the exact bytes and JSON reproduction
metadata before failing. GitHub Actions preserves that directory as a failure
artifact; review potential security findings privately under `SECURITY.md`.

To replay a retained input on Linux:

```sh
pixi run --locked fuzz-build
pixi run --locked python3 scripts/fuzz-parser.py --replay .pixi/fuzz-failures/HASH.bin
```

To explore a separately recorded seed:

```sh
pixi run --locked python3 scripts/fuzz-parser.py --cases 12000 --seed 0x20260905 --campaign-seconds 900
```

Add disclosed crash/hang bytes and seed metadata to
[`tests/fuzz/regressions`](../tests/fuzz/regressions) and a focused Mojo test
before a fix. This corpus is replayed before every subsequent campaign.
