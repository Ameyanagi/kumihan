# Scope and roadmap

Kumihan is a renderer-neutral font and shaping library. The package boundary is
chosen so one parsed font, fallback decision, and shaped glyph run can serve
SVG, raster, PDF, plotting, and UI consumers.

## Unreleased 0.2 script itemization

The default `TextStyle()` policy is `Script.AUTO`. During `shape(...)` and
`shape_into(...)`, Kumihan classifies the emitted glyph clusters from pinned
Unicode 17 Script, Script_Extensions, General_Category, and BidiBrackets data,
then applies required and `locl` GSUB separately to each half-open glyph range.
The source remains one UTF-8 input and is decoded once; glyph ranges are never
sliced or copied.

Kumihan preserves all Unicode Script identities while resolving candidates,
then maps finalized Han, Hiragana/Katakana, Hangul, and Bopomofo ranges to
`hani`, `kana`, `hang`, and `bopo`; every other result maps to `DFLT`. Combining
marks stay with their base sequence, variation selectors remain in the base
cluster, and canonical bracket pairs follow their enclosing script. Pure
Common/Inherited text resolves deterministically to `DFLT`. UAX #24 defines the
properties and guidance but not one normative run algorithm, so neighbor and
bracket resolution are documented Kumihan policy.

`TextStyle.with_script(...)` remains a whole-input override. `Script.DEFAULT`
forces `DFLT`, a CJK value forces its corresponding OpenType tag, and
`Script.AUTO` restores inference. Language is never inferred: callers still
select Japanese, Korean, Simplified Chinese, Traditional Chinese, or Hong Kong
forms with `with_language(...)`.

This slice covers UAX #24 combining sequences, not complete UAX #29 extended
grapheme segmentation. It does not claim atomic itemization for every emoji
ZWJ, regional-indicator, modifier, tag, or Indic-conjunct sequence.

## Version 0.1.0

The first release is a narrow, testable foundation:

- validated SFNT and TTC face/table directories;
- global and nominal horizontal metrics;
- Unicode `cmap` formats 4, 12, and 14;
- nominal scalar and font-declared variation-sequence mapping;
- horizontal positioned runs; and
- required and `locl` GSUB SingleSubst shaping for explicit CJK script runs.

Nominal shaping remains the exact cmap-plus-horizontal-metrics reference path.
The higher-level `shape` APIs additionally apply the supported required and
localized-form substitutions described below. GPOS and contextual shaping are
not part of this release.

## Variation-sequence foundation

Version 0.1.0 includes validated `cmap` format 14 parsing and font-declared
Unicode variation-sequence lookup.
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

## Localized-form shaping

Version 0.1.0 validates the OpenType Layout common structures in GSUB 1.0 and
the default-feature path of GSUB 1.1. FeatureVariations records are bounded,
but conditional alternate Feature tables are not evaluated.
Horizontal required features plus `locl` execute when they use SingleSubst
format 1 or 2. Coverage formats 1 and 2 and ExtensionSubst type 7 wrapping
SingleSubst are supported. Lookup indices are deduplicated and applied in
LookupList order; subtables retain first-match semantics. Substitution keeps
source clusters unchanged and horizontal metrics come from the final glyph.

`shape(...)` and `shape_into(...)` provide this behavior. `shape_nominal(...)`
and `shape_nominal_into(...)` remain exact cmap-plus-hmtx reference paths.
By default, the automatic policy above selects `DFLT`, `hani`, `kana`, `hang`,
or `bopo` ranges. `TextStyle.with_script(...)` can instead force one of those
scripts across the whole call, and `with_language(...)` selects the
corresponding default or CJK OpenType language system.

This slice is deliberately horizontal. It does not expose vertical-only GSUB
features such as `vert`, `vrt2`, `vrtr`, or `vkna`: correct vertical output also
needs vertical metrics and origins, UAX #50 orientation, renderer-visible
rotation metadata, and a defined feature policy. A required vertical feature is
rejected before mutation. Selected lookup flags that depend on GDEF likewise
fail transactionally; silently ignoring their filtering semantics would be
incorrect.

## Full-CJK roadmap

The following stages are ordered to preserve a small API and avoid coupling
parsing to any one renderer.

1. Extend the validated Layout foundation beyond required/`locl` SingleSubst
   with GDEF-aware filtering, contextual GSUB, GPOS, and reusable compiled
   feature plans.
2. Add remaining CJK-relevant features and tests: `ccmp`, `liga`, `kern`,
   `vert`, `vrt2`, ruby-facing metrics, half/proportional widths, and vertical
   origins.
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
