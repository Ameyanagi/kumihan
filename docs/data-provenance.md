# Unicode data provenance

Kumihan's automatic script itemizer uses generated lookup code derived from
the Unicode Character Database **17.0.0**. The source files were retrieved on
2026-08-23 from Unicode's canonical versioned URLs:

| File | SHA-256 |
| --- | --- |
| `Scripts.txt` | `9f5e50d3abaee7d6ce09480f325c706f485ae3240912527e651954d2d6b035bf` |
| `ScriptExtensions.txt` | `ec2107e58825a1586acee8e0911ce18260394ac8b87e535ca325f1ccbeb06bc6` |
| `PropertyValueAliases.txt` | `64e9a5f76f7a1e8b5a47d6a1f9a26522a251208f5276bdfa1559dac7cf2e827a` |
| `extracted/DerivedGeneralCategory.txt` | `d62e5bab70ca74f099343f71224fa051cb1fdd61a1ab45c0488c44cfc0b6102e` |
| `BidiBrackets.txt` | `dadbaf38a0d0246e5b805bf8725cb81b7c621f93d030595635f5ba2c2f179428` |

The generated artifact preserves all 176 Unicode 17 Script identities and
every exact Script_Extensions set while mapping only final resolved runs to
Kumihan's `DFLT`, `hani`, `kana`, `hang`, or `bopo` OpenType tags. Generator
validation locks the primary Script coverage used by those public outputs:

- Han: 25 ranges and 103,351 scalars;
- Hiragana: 7 ranges and 381 scalars;
- Katakana: 15 ranges and 321 scalars;
- Hangul: 14 ranges and 11,739 scalars;
- Bopomofo: 3 ranges and 77 scalars.

The five unmodified source files are vendored in
[`tests/data/unicode/17.0.0`](../tests/data/unicode/17.0.0) under the retained
Unicode License v3. Their digests are checked before every generation. Routine
validation and regeneration are offline; neither operation downloads data:

```sh
pixi run unicode-check
pixi run unicode-generate
pixi run unicode-test
```

`pixi run check` includes both the byte-for-byte generation check and a negative
regression that deliberately changes a generated constant, verifies rejection,
and verifies that regeneration restores the exact original output. The test
also rejects a tampered input and forbids generator network calls.

Only the separate maintainer command `pixi run unicode-download` fetches the
canonical sources. It verifies the complete input set before replacing files.
A Unicode version update must change the version and hashes in the generator,
review the licensed inputs and provenance, explicitly download them, regenerate,
and commit that change separately from routine CI. `--source-dir /path/to/data`
can select another already downloaded copy; checksum validation still applies.
Package builds and consumers use the checked-in Mojo table without Python.

Unicode Script properties do not prescribe one unique run-resolution
algorithm. The behavior in `src/kumihan/itemize.mojo` is Kumihan's documented
policy: maximize exact candidate-set intersections; keep marks with an
existing base; resolve leading marks and leading pure-Inherited format scalars
to `DFLT`; use surrounding context for implicit Common/Inherited values; and
give matched canonical BidiBrackets one enclosing script when their candidate
sets permit it. Quotes remain ordinary neutrals. This scalar itemizer does not
claim extended-grapheme-cluster or emoji-sequence segmentation.

The derived tables and source data are used under the Unicode License v3,
retained in [`LICENSES/Unicode-3.0.txt`](../LICENSES/Unicode-3.0.txt).
