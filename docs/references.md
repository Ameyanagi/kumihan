# References and clean-room policy

Kumihan is an original Mojo implementation. OpenType and Unicode specifications
are the normative sources. Other projects are used to compare observable
behavior, understand decomposition boundaries, and design independent tests.

## Normative specifications

- [OpenType 1.9.1 `cmap`](https://learn.microsoft.com/en-us/typography/opentype/spec/cmap)
  defines the format 4, 12, and 14 structures and variation-sequence lookup
  semantics.
- [Unicode 17.0, chapter 23](https://www.unicode.org/versions/Unicode17.0.0/core-spec/chapter-23/)
  and the [Unicode 17.0 `Variation_Selector` property](https://www.unicode.org/Public/17.0.0/ucd/PropList.txt)
  define the recognized selector code points.
- [UTS #37](https://www.unicode.org/reports/tr37/) defines the Ideographic
  Variation Database model. Kumihan does not yet bundle its registry data.
- [UAX #29](https://www.unicode.org/reports/tr29/) defines the grapheme-cluster
  behavior used to preserve source coverage around default-ignorable variation
  selectors.

## Existing Mojo work

- [canvas_mojo](https://github.com/randyzwitch/canvas_mojo) — MIT. A Mojo
  raster/vector drawing engine with native TTF parsing, glyph outlines,
  fontconfig-based discovery, and path rasterization. It demonstrates useful
  downstream integration, but does not claim the complete shaping and fallback
  contract targeted by Kumihan.
- [mojo-fonttools](https://github.com/lee101/mojo-fonttools) — MIT. A
  Python-facing TrueType toolkit with Mojo kernels, including SFNT tables,
  `cmap` formats 4/12, `glyf`, subsetting, and batched geometry. Its public
  boundary and runtime model differ from a native stable-Mojo shaping package.

These projects are compatibility context, not source donors. Reuse requires a
separate design review and compliance with their licenses; 0.1.0 contains no
copied implementation from either project.

## Rust behavioral references

- [Fontations and Skrifa](https://github.com/googlefonts/fontations) — MIT OR
  Apache-2.0. Reference for robust font parsing, metadata, variation-aware
  metrics, Unicode mapping, and renderer-neutral outlines.
- [HarfRust](https://github.com/harfbuzz/harfrust) — MIT. Reference for
  OpenType shaping behavior and conformance boundaries.
- [Fontique and Parley](https://github.com/linebender/parley) — Apache-2.0 OR
  MIT. References for font enumeration/fallback and rich-text layout contracts.
- [Swash](https://github.com/dfrg/swash) — Apache-2.0 OR MIT. Reference for font
  introspection, complex shaping, outline scaling, hinting, and glyph images.
- [Cosmic Text](https://github.com/pop-os/cosmic-text) — MIT OR Apache-2.0.
  Reference for composing discovery, fallback, shaping, bidi, multiline
  layout, and optional rasterization into a practical text system.

## Go behavioral references

- [go-text/typesetting](https://github.com/go-text/typesetting) — Unlicense OR
  BSD-3-Clause. An independent parser, HarfBuzz-style shaper, segmenter, bidi,
  wrapping, and font-scanning implementation. It is a useful differential
  reference, while its script/coverage-oriented fallback must not define
  Kumihan's locale-sensitive Han behavior.
- [Gio text](https://github.com/gioui/gio/tree/main/text) — Unlicense OR MIT.
  Reference for composing font discovery, shaping, layout, stable glyph IDs,
  and bounded path/bitmap caches into a production UI pipeline.
- [Ebitengine `text/v2`](https://github.com/hajimehoshi/ebiten/tree/main/text/v2)
  — Apache-2.0. Reference for explicit fallback chains, shared glyph-image
  caches, precaching, append-to-caller storage, and renderer-side batching.
- [Go `x/image/font/sfnt`](https://github.com/golang/image/tree/master/font/sfnt)
  — BSD-3-Clause. A deliberately small parser reference with collection
  support, bounded `ReaderAt` access, and reusable caller scratch storage. It
  is not a shaping or CJK fallback implementation.

## Reviewed revision ledger

This ledger pins the exact source revisions reviewed for the 0.1 architecture.
They are reading and behavior references, not vendored dependencies or proof
that Kumihan matches their complete feature sets.

| Reference | Exact reviewed commit |
|---|---|
| canvas_mojo | [`d9420d424069f7f8602c7e56fc8843427f4d89d7`](https://github.com/randyzwitch/canvas_mojo/commit/d9420d424069f7f8602c7e56fc8843427f4d89d7) |
| mojo-fonttools | [`cc46dace919903d6c04ae4f4527abb8ce593a9ca`](https://github.com/lee101/mojo-fonttools/commit/cc46dace919903d6c04ae4f4527abb8ce593a9ca) |
| Fontations/Skrifa | [`f886c9069b08eaddcb1caced3a44b0d8291a159a`](https://github.com/googlefonts/fontations/commit/f886c9069b08eaddcb1caced3a44b0d8291a159a) |
| HarfRust | [`d15769bb5f6831daa81cceec15ee311f7fbcc29f`](https://github.com/harfbuzz/harfrust/commit/d15769bb5f6831daa81cceec15ee311f7fbcc29f) |
| Fontique/Parley | [`1aba7cacb2030dea204efa87ba55317c0a59964a`](https://github.com/linebender/parley/commit/1aba7cacb2030dea204efa87ba55317c0a59964a) |
| Swash | [`7773843df0d63cd468db61a29c152b5e7a99d4ab`](https://github.com/dfrg/swash/commit/7773843df0d63cd468db61a29c152b5e7a99d4ab) |
| Cosmic Text | [`daae9c75d52322f8fb3af6168d76561540914e1f`](https://github.com/pop-os/cosmic-text/commit/daae9c75d52322f8fb3af6168d76561540914e1f) |
| go-text/typesetting | [`ddb7ff96ad4d2dc730cbcae9dd5140023f319c3e`](https://github.com/go-text/typesetting/commit/ddb7ff96ad4d2dc730cbcae9dd5140023f319c3e) |
| Gio | [`c035a6190b0bcb4c8f90e5830d7410307f7c58e8`](https://github.com/gioui/gio/commit/c035a6190b0bcb4c8f90e5830d7410307f7c58e8) |
| Ebitengine | [`f31ade888bc12a12f3a043eb40484c482deb0551`](https://github.com/hajimehoshi/ebiten/commit/f31ade888bc12a12f3a043eb40484c482deb0551) |
| Go x/image | [`09b0b4f7d91066e434edc5239b0d2268560dc80d`](https://github.com/golang/image/commit/09b0b4f7d91066e434edc5239b0d2268560dc80d) |

License labels describe these exact upstream revisions. Verify them again
before importing any redistributable code or data.

## Exact oracle pinning policy

The current 0.1 tests use independently constructed synthetic fonts and do not
contain expected output generated by an external oracle. Before adding the
first differential fixture, add a checked-in machine-readable manifest beside
it and require all of the following:

1. Pin source tools such as HarfBuzz, HarfRust, Fontations, fontTools, or
   go-text by full commit SHA. A branch name, moving tag, or unqualified package
   version is not an acceptable pin.
2. Record the built executable or package SHA-256, compiler/toolchain version,
   dependency lockfile, and exact build and invocation commands.
3. Pin Unicode inputs by release number and SHA-256 for every conformance or
   generated data file. Record the precise OpenType specification revision and
   section used to resolve behavior.
4. Record each font's source URL, face index, SHA-256, license, and
   redistribution status. Never substitute a system font in CI.
5. Serialize every shaping input: source bytes, direction, script, normalized
   language, features, variation coordinates, cluster policy, scale, and
   expected glyph IDs, clusters, advances, offsets, and flags.
6. Generate fixtures offline and commit normalized deterministic output. CI
   must not contact the network or silently regenerate expected results.
7. Upgrade an oracle only in a focused change that updates the manifest,
   regenerates affected fixtures, and reviews the semantic diff against the
   normative specification.

## Clean-room rules

1. Implement from the current OpenType, Unicode, and language-layout
   specifications. Link the exact section in the design or pull request.
2. Do not copy, transliterate, mechanically convert, or prompt-convert source
   code from a reference project.
3. Derive fixtures independently from small fonts with verified redistribution
   terms, purpose-built synthetic tables, or published conformance data.
4. A reference implementation may produce expected output for differential
   testing only under the exact oracle pinning policy above.
5. Review surprising differences against the specification. Matching one
   implementation is not sufficient evidence when implementations disagree.
6. Keep third-party source and generated data outside the release unless the
   repository includes its license, provenance, checksum, generator command,
   and update procedure.
7. Preserve scalar correctness oracles when adding SIMD, parallel, cached, or
   otherwise specialized paths.
