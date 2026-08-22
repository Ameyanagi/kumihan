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

## Unreleased variation-sequence foundation

The current unreleased slice adds validated `cmap` format 14 parsing and
font-declared Unicode variation-sequence lookup.
`FontFace.variation_glyph_id(base, selector)` returns an optional resolved
glyph: a default UVS uses the primary format 4/12 mapping, an explicit UVS uses
its format 14 glyph ID, and an unsupported pair remains distinguishable as
`None`.

Nominal shaping consumes a base plus one recognized variation selector as one
UTF-8 source cluster. A supported pair emits the resolved glyph; an unsupported
pair retains the base glyph; a leading or stacked selector is default
ignorable. This is structural, font-declared selection. Kumihan does not yet
bundle the Unicode standardized-variation or Ideographic Variation Database
registries, and format 14 alone does not provide contextual OpenType shaping.

## Full-CJK roadmap

The following stages are ordered to preserve a small API and avoid coupling
parsing to any one renderer.

1. Parse the OpenType Layout common structures once, then implement GSUB and
   GPOS lookup execution with script, language, feature, and lookup flags.
2. Add CJK-relevant features and tests: `locl`, `ccmp`, `liga`, `kern`, `vert`,
   `vrt2`, ruby-facing metrics, half/proportional widths, and vertical origins.
3. Add renderer-neutral TrueType `glyf` and CFF/CFF2 outlines, including
   variable-font coordinates.
4. Add a platform-neutral font database and deterministic family/style
   matching. Platform discovery belongs in optional adapters.
5. Add locale- and script-aware fallback across a run. Fallback must retain
   source clusters and avoid splitting sequences that require one font.
6. Add Unicode bidirectional resolution and Unicode line breaking, then layer
   explicit Japanese, Simplified/Traditional Chinese, and Korean typography
   policies over the standards rather than hard-coding one CJK behavior.
7. Let Kagerou cache, hint, and rasterize the resulting outlines and positioned
   runs. Rasterization remains outside Kumihan.

The planned fallback surface remains small and chainable: construct it from a
primary face, append explicit fallback faces with `with_fallback(...)`, then
call `shape(...)` or `shape_into(...)`. Fallback will select whole source
clusters, including an IVS, rather than resolving isolated code points. That API
will not be exported until face ownership and glyph-to-font provenance are
implemented and tested.

Every stage requires conformance fixtures, malformed-font limits, and a stable
scalar oracle before optimization. A feature is not exported from the root
package until its failure behavior, ownership, and performance contract are
documented.
