# Kumihan

Validated OpenType font data and renderer-neutral text shaping foundations for
Mojo.

> **Experimental pre-1.0 API.** Source compatibility may change before 1.0.

Kumihan is the font and shaping layer for the Mojo graphics ecosystem. It is
designed for complete CJK typography without making a plotting or rendering
library own a second font stack. Kumihan validates SFNT and TrueType Collection
structure, maps Unicode through `cmap` formats 4, 12, and 14, and produces
renderer-neutral horizontal glyph runs. Its first OpenType shaping slice adds
validated GSUB layout selection and CJK-localized SingleSubst forms. GSUB 1.1
FeatureVariations are bounded safely but use the default Feature tables.

## Install

Kumihan v0.1.0 is published as a GitHub source release, but not yet to the
hosted Mojo channel. Work from the tagged source with [Pixi](https://pixi.sh/):

```sh
git clone --branch v0.1.0 --depth 1 https://github.com/Ameyanagi/kumihan.git
cd kumihan
pixi install --locked
pixi run check
```

The Mojo import remains `kumihan`; the distribution name is `mojo-kumihan`.
Kumihan targets exactly stable Mojo 1.0.0 on macOS ARM64, Linux x86-64, and
Linux ARM64. Run a local program against the source package with:

```sh
pixi run mojo run -I src your_program.mojo
```

`pixi run --locked package` builds and tests a local `mojo-kumihan` Conda
artifact under `output/<platform>/`. A hosted install command will be added
only after the release artifacts are mapped into the public channel.

## Chained text styles

Style modifiers return an updated value, so configuration reads from left to
right and does not require a mutable option object:

```mojo
from kumihan import Language, Script, TextStyle


def main() raises:
    var style = (
        TextStyle()
        .with_size(16.0)
        .with_language(Language.JA)
    )
```

`TextStyle()` automatically itemizes mixed Han, Hiragana/Katakana, Hangul,
Bopomofo, and other text. Append `.with_script(Script.HAN)` to force one
OpenType script or `.with_script(Script.DEFAULT)` to force `DFLT` across the
entire input; `.with_script(Script.AUTO)` restores inference in a chain.

`TextStyle`, `Language`, `Script`, `Direction`, `FontCollection`, `FontFace`,
`GlyphRun`, `ShapeBuffer`, `shape`, `shape_into`, `shape_nominal`, and
`shape_nominal_into` form the intended small root surface. Font parsing,
validated style modifiers, and shaping are fallible; default construction and
policy inspection through `tag()` is an ordinary value operation. Resolving an
actual OpenType tag through `open_type_tag()` is fallible because automatic
itemization has no single tag.

Use `shape` for normal horizontal text. It applies required features and
language-selected `locl` SingleSubst lookups automatically. Use
`shape_nominal` when an exact cmap-plus-hmtx result is required as a reference
or inspection oracle. Automatic itemization uses pinned Unicode 17 Script,
Script_Extensions, General_Category, and paired-bracket data. Language remains
explicit because a Han code point cannot determine Japanese, Korean, Simplified
Chinese, or Traditional Chinese glyph preference.

## Current foundation

- Validate bounded SFNT and TTC table directories before exposing a face.
- Share one reference-counted backing allocation across faces from a TTC/OTC.
- Read the metrics needed for nominal horizontal placement.
- Select and query Unicode `cmap` format 4 and 12 subtables.
- Validate `cmap` format 14 and resolve default or explicit variation glyphs
  with `FontFace.variation_glyph_id(base, selector)`.
- Map Unicode scalars to nominal glyph IDs and horizontal advances.
- Consume a supported or unsupported base-plus-variation-selector pair as one
  UTF-8 source cluster during nominal shaping.
- Validate GSUB 1.0 plus the default-feature path of GSUB 1.1: ScriptList,
  LangSys, FeatureList, LookupList, Coverage formats 1/2, SingleSubst formats
  1/2, and ExtensionSubst type 7 to type 1.
- Apply required and `locl` lookups in LookupList order with exact CJK script
  and language-system selection, stable clusters, and final-glyph metrics.
- Itemize mixed CJK text automatically without copying glyph subranges;
  explicit `Script` values remain whole-input overrides.
- Retain explicit direction, language, style, cluster, and glyph-run contracts
  that later shaping can extend without changing renderer APIs.
- Parse a font face once and reuse sorted-table lookup state across text runs.

This is not yet a complete CJK text engine. Kumihan does **not** yet implement
GPOS or GSUB beyond required/`locl` SingleSubst, a bundled registry of
sanctioned Unicode variation sequences, full emoji/extended-grapheme
itemization, glyph outlines, system-font discovery or locale-aware fallback,
bidirectional layout, CJK line breaking, vertical layout, or rasterization.
These are roadmap work, not hidden best-effort behavior. See
[scope and roadmap](docs/scope.md).

## Ecosystem boundary

Kumihan owns font parsing, character-to-glyph mapping, shaping, fallback
contracts, text metrics, positioned glyph runs, and renderer-neutral outlines.
As those APIs land, [Kagerou](https://github.com/Ameyanagi/kagerou) will consume
Kumihan outlines and runs for raster rendering, while
[Sen](https://github.com/Ameyanagi/sen) will use Kumihan for text layout and
Kagerou for rendering. Terminal width remains in
[Moji](https://github.com/Ameyanagi/moji).

The implementation avoids a mandatory C, C++, Rust, Python, FreeType, or
HarfBuzz runtime. That makes font processing a reusable Mojo ecosystem layer,
while leaving room for optional adapters after the native contracts are
stable.

## Performance contract

Correct parsing of untrusted bytes is the first invariant. Within that bound,
Kumihan parses directory metadata once, performs bounded reads, binary-searches
sorted tables, reuses buffers, and avoids hidden copies. SIMD or parallel work
will be added only to profiled fixed-width or batched kernels while scalar
oracles remain in the test suite. See the [benchmark protocol](benchmarks/README.md).

## Prior art and clean-room development

The Mojo ecosystem already contains useful partial font work:
[canvas_mojo](https://github.com/randyzwitch/canvas_mojo) (MIT) includes a
native TTF parser, outlines, fontconfig-based discovery, and raster drawing;
[mojo-fonttools](https://github.com/lee101/mojo-fonttools) (MIT) implements a
Python-facing TrueType toolkit with Mojo compute kernels. Neither is presented
as the complete, stable-Mojo shaping and fallback layer needed here.

Kumihan uses specifications as the implementation authority and modern Rust
and Go libraries only as behavioral references. The complete reference list,
license record, exact-revision ledger, and clean-room rules are in
[docs/references.md](docs/references.md).

## License

Kumihan is dual-licensed under [MIT](LICENSE-MIT) or
[Apache-2.0](LICENSE-APACHE), at your option. Checked-in tables derived from
Unicode data are distributed under the
[Unicode License v3](LICENSES/Unicode-3.0.txt); see
[data provenance](docs/data-provenance.md).
