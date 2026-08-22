# Changelog

This project follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and uses semantic versioning for public releases.

## [Unreleased]

### Added

- Add validated OpenType `cmap` format 14 parsing and allocation-free,
  binary-searched Unicode variation-sequence lookup.
- Add `FontFace.variation_glyph_id(base, selector)`, preserving unsupported
  pairs as `None` and valid glyph-zero mappings as `Some(0)`.
- Make nominal shaping consume font-declared default and explicit IVSes as one
  UTF-8 cluster while retaining the base glyph for unsupported pairs.

### Fixed

- Enforce specification-compatible Unicode cmap platform/encoding pairs and
  zero language fields without rejecting valid repeated Macintosh encodings
  that point to different language subtables.

## [0.1.0] - 2026-08-22

### Added

- Initial experimental repository scaffold for stable Mojo 1.0.0.
- Add validated SFNT and TrueType Collection directory parsing with bounded
  reads and explicit malformed-input errors.
- Add global and nominal horizontal font metrics.
- Add Unicode-to-glyph mapping for `cmap` formats 4 and 12.
- Add nominal horizontal glyph-run construction with explicit direction,
  language, cluster, and chainable text-style values.
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

[Unreleased]: https://github.com/Ameyanagi/kumihan/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/Ameyanagi/kumihan/releases/tag/v0.1.0
