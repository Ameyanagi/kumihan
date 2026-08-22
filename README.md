# Kumihan

Validated OpenType font data and renderer-neutral text shaping foundations for
Mojo.

> **Experimental v0.1 API.** Source compatibility may change before 1.0.

Kumihan is the font and shaping layer for the Mojo graphics ecosystem. It is
designed for complete CJK typography without making a plotting or rendering
library own a second font stack. The first release deliberately starts below
complex shaping: it validates SFNT and TrueType Collection structure, reads
global and horizontal metrics, maps Unicode scalars through `cmap` formats 4
and 12, and produces nominal horizontal glyph runs.

## Install

Kumihan has not yet been published to the hosted Mojo channel. Work from a
source checkout with [Pixi](https://pixi.sh/):

```sh
git clone https://github.com/Ameyanagi/kumihan.git
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
from kumihan import Language, TextStyle


def main() raises:
    var style = TextStyle().with_size(16.0).with_language(Language.JA)
```

`TextStyle`, `Language`, `Direction`, `FontCollection`, `FontFace`, `GlyphRun`,
`ShapeBuffer`, `shape_nominal`, and `shape_nominal_into` form the intended small
root surface. Font parsing, validated style modifiers, and nominal shaping are
fallible; default construction and inspection are ordinary value operations.

## What 0.1.0 does

- Validate bounded SFNT and TTC table directories before exposing a face.
- Share one reference-counted backing allocation across faces from a TTC/OTC.
- Read the metrics needed for nominal horizontal placement.
- Select and query Unicode `cmap` format 4 and 12 subtables.
- Map Unicode scalars to nominal glyph IDs and horizontal advances.
- Retain explicit direction, language, style, cluster, and glyph-run contracts
  that later shaping can extend without changing renderer APIs.
- Parse a font face once and reuse sorted-table lookup state across text runs.

This is not yet a complete CJK text engine. Version 0.1.0 does **not** implement
GSUB/GPOS shaping, Unicode variation sequences (`cmap` format 14), glyph
outlines, system-font discovery or locale-aware fallback, bidirectional layout,
CJK line breaking, vertical layout, or rasterization. These are roadmap work,
not hidden best-effort behavior. See [scope and roadmap](docs/scope.md).

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
[Apache-2.0](LICENSE-APACHE), at your option.
