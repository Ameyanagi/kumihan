# Scope and roadmap

Kumihan is a renderer-neutral font and shaping library. The package boundary is
chosen so one parsed font, fallback decision, and shaped glyph run can serve
SVG, raster, PDF, plotting, and UI consumers.

## Version 0.1.0

The first release is a narrow, testable foundation:

- validated SFNT and TTC face/table directories;
- global and nominal horizontal metrics;
- Unicode `cmap` formats 4 and 12;
- nominal scalar-to-glyph mapping; and
- horizontal positioned runs without OpenType substitutions or positioning.

Nominal shaping means one Unicode scalar is mapped independently through the
selected `cmap`. A missing mapping uses the font's missing-glyph convention.
Horizontal advances come from the font's horizontal metrics. No language,
script, neighboring glyph, or variation selector changes the selected glyph in
this release.

## Full-CJK roadmap

The following stages are ordered to preserve a small API and avoid coupling
parsing to any one renderer.

1. Add `cmap` format 14 and Unicode variation-sequence selection, including
   ideographic variation sequences.
2. Parse the OpenType Layout common structures once, then implement GSUB and
   GPOS lookup execution with script, language, feature, and lookup flags.
3. Add CJK-relevant features and tests: `locl`, `ccmp`, `liga`, `kern`, `vert`,
   `vrt2`, ruby-facing metrics, half/proportional widths, and vertical origins.
4. Add renderer-neutral TrueType `glyf` and CFF/CFF2 outlines, including
   variable-font coordinates.
5. Add a platform-neutral font database and deterministic family/style
   matching. Platform discovery belongs in optional adapters.
6. Add locale- and script-aware fallback across a run. Fallback must retain
   source clusters and avoid splitting sequences that require one font.
7. Add Unicode bidirectional resolution and Unicode line breaking, then layer
   explicit Japanese, Simplified/Traditional Chinese, and Korean typography
   policies over the standards rather than hard-coding one CJK behavior.
8. Let Kagerou cache, hint, and rasterize the resulting outlines and positioned
   runs. Rasterization remains outside Kumihan.

Every stage requires conformance fixtures, malformed-font limits, and a stable
scalar oracle before optimization. A feature is not exported from the root
package until its failure behavior, ownership, and performance contract are
documented.
