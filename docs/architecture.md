# Architecture

Kumihan separates untrusted binary parsing from semantic text values and from
rendering:

```text
font bytes
  -> bounded SFNT/TTC directory
  -> validated FontFace table views
  -> cmap 4/12 + optional cmap 14 + global/horizontal metrics
  -> shape_nominal(text, face, style)             [reference path]
  -> optional GSUB Script/LangSys/Feature/Lookup [shape path]
  -> required + locl SingleSubst
  -> renderer-neutral GlyphRun
  -> downstream SVG, raster, PDF, plot, or UI renderer
```

## Parsing invariants

- A table view is created only after its offset and length fit inside the
  selected font face and backing byte storage.
- Arithmetic that originates in a font field is checked before use.
- A table decoder receives a previously validated offset/length range into the
  shared backing bytes; it never receives an unchecked font-derived offset.
- Directory metadata and validated table descriptors are retained on the parsed
  face. Shaping never revalidates SFNT or GSUB structures; it traverses the
  already validated bytes through those descriptors.
- Sorted records use binary search. Repeated glyph metrics use the OpenType
  trailing-advance rule without materializing an expanded metrics array.
- Public parsing and shaping operations report invalid input through `raises`;
  malformed bytes do not create partially valid public values.

## Public values

`Language`, `Script`, `Direction`, and `TextStyle` describe shaping inputs.
Style modifiers return updated values and can be chained. `FontCollection`
owns the shared bytes needed by its validated `FontFace` values. Face metric
accessors, `GlyphRun`, and reusable `ShapeBuffer` expose semantic values rather
than raw table offsets.

The root package remains deliberately small. Raw endian readers, directory
records, and table-specific formats are implementation details. The first GSUB
slice keeps Layout descriptors internal and applies only required and `locl`
SingleSubst lookups. Future contextual GSUB, GPOS, and outline support extend
the middle of the pipeline; they do not require renderer-specific fields in
`GlyphRun`.

Format 14 is retained as a supplement to the selected primary Unicode cmap,
never as its replacement. Its public lookup returns `Optional[Int]`, keeping an
unsupported pair distinct from a supported mapping to glyph zero. Nominal
shaping uses that distinction to retain the base glyph for unsupported pairs
while preserving one source cluster across the base and selector.

GSUB is parsed and validated once with the face. Selection resolves one
caller-provided script and language system, gathers its required Feature and
`locl` Feature offsets, sorts and deduplicates physical aliases, then walks the
LookupList in numeric order. Reusable shaping retains both feature-offset and
lookup-mask scratch rather than allocating them for every run.
Unsupported selected lookups, required vertical-only features, and
GDEF-dependent filtering fail in a preflight pass before glyph IDs are mutated.
A SingleSubst changes neither glyph count nor cluster ranges; advances and
missing-glyph state are recomputed from final glyph IDs. GSUB 1.1
FeatureVariations alternates are not evaluated; the default Feature tables are
used as permitted for clients without variation-feature support.

## Performance model

The primary units of reuse are a `FontCollection`, parsed `FontFace`, and
caller-owned `ShapeBuffer`, not a file path or one transient output allocation
per run. Applications should load a collection once, retain its faces, then
shape many runs into reusable storage. The initial implementation favors compact
validated table descriptors, a bounded reusable lookup mask, and binary search
over eagerly expanding entire maps. Physical Feature offsets use a second
reusable scratch list so aliases are sorted and traversed once. Later caches
must be explicit, bounded,
keyed by font identity and variation coordinates, and safe to share without
hidden copies.

SIMD is appropriate only after profiling exposes regular batched work, such as
outline transforms or raster preparation. Variable-length table decoding,
branch-heavy GSUB/GPOS lookup dispatch, and fallback decisions stay scalar
unless measured evidence demonstrates a worthwhile vector strategy.
