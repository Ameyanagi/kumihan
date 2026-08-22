# Changelog

This project follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and uses semantic versioning for public releases.

## [Unreleased]

## [0.1.0] - 2026-08-23

### Added

- Initial experimental repository scaffold for stable Mojo 1.0.0.
- Add validated SFNT and TrueType Collection directory parsing with bounded
  reads and explicit malformed-input errors.
- Add global and nominal horizontal font metrics.
- Add Unicode-to-glyph mapping for `cmap` formats 4 and 12.
- Add nominal horizontal glyph-run construction with explicit direction,
  language, cluster, and chainable text-style values.
- Add validated OpenType `cmap` format 14 parsing and allocation-free,
  binary-searched Unicode variation-sequence lookup.
- Add `FontFace.variation_glyph_id(base, selector)`, preserving unsupported
  pairs as `None` and valid glyph-zero mappings as `Some(0)`.
- Make nominal shaping consume font-declared default and explicit IVSes as one
  UTF-8 cluster while retaining the base glyph for unsupported pairs.
- Add validated GSUB 1.0 and GSUB 1.1 default-feature layout parsing for CJK
  script and language-system selection, Coverage formats 1/2, SingleSubst
  formats 1/2, and type 7-to-1 ExtensionSubst. Conditional FeatureVariations
  alternates remain intentionally unapplied.
- Add `Script`, `TextStyle.with_script(...)`, `shape(...)`, and
  `shape_into(...)`; horizontal shaping applies required and `locl` lookups
  automatically while the nominal APIs remain exact cmap-plus-metrics oracles.
- Add cross-platform checks and Conda packaging for `mojo-kumihan` on macOS
  ARM64, Linux x86-64, and Linux ARM64.
- Verify the installed `.mojoc` root API by parsing a synthetic format-12 font
  and exercising both allocating and reusable-buffer nominal shaping.
- Add an annotated-tag-gated workflow that validates all three platforms and
  publishes a source archive without claiming or mutating hosted-channel state.
- Document the full-CJK shaping, fallback, line-layout, outline, and rendering
  roadmap without claiming those features in 0.1.0.
- Record exact reviewed Mojo, Rust, and Go reference revisions plus the
  clean-room and reproducible oracle-pinning policy.

### Fixed

- Enforce specification-compatible Unicode cmap platform/encoding pairs and
  zero language fields without rejecting valid repeated Macintosh encodings
  that point to different language subtables.

[Unreleased]: https://github.com/Ameyanagi/kumihan/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/Ameyanagi/kumihan/releases/tag/v0.1.0
