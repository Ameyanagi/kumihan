# Architecture

Kumihan separates untrusted binary parsing from semantic text values and from
rendering:

```text
font bytes
  -> bounded SFNT/TTC directory
  -> validated FontFace table views
  -> cmap + global/horizontal metrics
  -> shape_nominal(text, face, style)
  -> renderer-neutral GlyphRun
  -> downstream SVG, raster, PDF, plot, or UI renderer
```

## Parsing invariants

- A table view is created only after its offset and length fit inside the
  selected font face and backing byte storage.
- Arithmetic that originates in a font field is checked before use.
- A table decoder receives a previously validated offset/length range into the
  shared backing bytes; it never receives an unchecked font-derived offset.
- Directory metadata and selected subtables are retained on the parsed face so
  shaping does not rescan the font.
- Sorted records use binary search. Repeated glyph metrics use the OpenType
  trailing-advance rule without materializing an expanded metrics array.
- Public parsing and shaping operations report invalid input through `raises`;
  malformed bytes do not create partially valid public values.

## Public values

`Language`, `Direction`, and `TextStyle` describe shaping inputs. Style
modifiers return updated values and can be chained. `FontCollection` owns the
shared bytes needed by its validated `FontFace` values. Face metric accessors,
`GlyphRun`, and reusable `ShapeBuffer` expose semantic values rather than raw
table offsets.

The root package remains deliberately small. Raw endian readers, directory
records, and table-specific formats are implementation details. Future
GSUB/GPOS and outline support extend the middle of the pipeline; they do not
require renderer-specific fields in `GlyphRun`.

## Performance model

The primary units of reuse are a `FontCollection`, parsed `FontFace`, and
caller-owned `ShapeBuffer`, not a file path or one transient output allocation
per run. Applications should load a collection once, retain its faces, then
shape many runs into reusable storage. The initial implementation favors compact
validated table descriptors and binary search over eagerly expanding entire
maps. Later caches must be explicit, bounded, keyed by font identity and
variation coordinates, and safe to share without hidden copies.

SIMD is appropriate only after profiling exposes regular batched work, such as
outline transforms or raster preparation. Variable-length table decoding,
branch-heavy GSUB/GPOS lookup dispatch, and fallback decisions stay scalar
unless measured evidence demonstrates a worthwhile vector strategy.
