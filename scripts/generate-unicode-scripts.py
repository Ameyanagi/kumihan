#!/usr/bin/env python3
"""Generate exact Unicode 17 script and paired-bracket lookup code."""

from __future__ import annotations

import argparse
import hashlib
import re
import subprocess
import sys
import tempfile
import urllib.request
from collections.abc import Iterable
from pathlib import Path


UNICODE_VERSION = "17.0.0"
SOURCES = {
    "Scripts.txt": (
        f"https://www.unicode.org/Public/{UNICODE_VERSION}/ucd/Scripts.txt",
        "9f5e50d3abaee7d6ce09480f325c706f485ae3240912527e651954d2d6b035bf",
    ),
    "ScriptExtensions.txt": (
        f"https://www.unicode.org/Public/{UNICODE_VERSION}/ucd/ScriptExtensions.txt",
        "ec2107e58825a1586acee8e0911ce18260394ac8b87e535ca325f1ccbeb06bc6",
    ),
    "PropertyValueAliases.txt": (
        f"https://www.unicode.org/Public/{UNICODE_VERSION}/ucd/PropertyValueAliases.txt",
        "64e9a5f76f7a1e8b5a47d6a1f9a26522a251208f5276bdfa1559dac7cf2e827a",
    ),
    "DerivedGeneralCategory.txt": (
        "https://www.unicode.org/Public/"
        f"{UNICODE_VERSION}/ucd/extracted/DerivedGeneralCategory.txt",
        "d62e5bab70ca74f099343f71224fa051cb1fdd61a1ab45c0488c44cfc0b6102e",
    ),
    "BidiBrackets.txt": (
        f"https://www.unicode.org/Public/{UNICODE_VERSION}/ucd/BidiBrackets.txt",
        "dadbaf38a0d0246e5b805bf8725cb81b7c621f93d030595635f5ba2c2f179428",
    ),
}
OUTPUT = Path(__file__).resolve().parent.parent / "src/kumihan/_unicode_script_data.mojo"

PROPERTY_RE = re.compile(
    r"^([0-9A-F]+)(?:\.\.([0-9A-F]+))?\s*;\s*([A-Za-z_]+)"
)
SCRIPT_EXTENSIONS_RE = re.compile(
    r"^([0-9A-F]+)(?:\.\.([0-9A-F]+))?\s*;\s*([A-Za-z0-9_ ]+)"
)
BRACKET_RE = re.compile(r"^([0-9A-F]+)\s*;\s*([0-9A-F]+)\s*;\s*([oc])")

Interval = tuple[int, int]
ValueInterval = tuple[int, int, int]
PropertyInterval = tuple[int, int, int, int]

FLAG_COMMON = 1
FLAG_INHERITED = 2
FLAG_MARK = 4
MAX_SCALAR = 0x10FFFF
SCRIPT_COUNT = 176

EXPECTED_CJK_COUNTS = {
    "Hani": (25, 103_351),
    "Hira": (7, 381),
    "Kana": (15, 321),
    "Hang": (14, 11_739),
    "Bopo": (3, 77),
}


def read_source(name: str, source_dir: Path | None) -> str:
    url, expected_digest = SOURCES[name]
    if source_dir is None:
        with urllib.request.urlopen(url, timeout=30) as response:
            payload = response.read()
    else:
        path = source_dir / name
        try:
            payload = path.read_bytes()
        except FileNotFoundError as error:
            raise RuntimeError(f"missing pinned Unicode source: {path}") from error
    actual_digest = hashlib.sha256(payload).hexdigest()
    if actual_digest != expected_digest:
        raise RuntimeError(
            f"checksum mismatch for {name}: expected {expected_digest}, "
            f"received {actual_digest}"
        )
    return payload.decode("utf-8")


def script_aliases(text: str) -> tuple[list[str], dict[str, str]]:
    short_names: list[str] = []
    aliases: dict[str, str] = {}
    for line in text.splitlines():
        fields = [field.strip() for field in line.split("#", 1)[0].split(";")]
        if len(fields) < 3 or fields[0] != "sc":
            continue
        short_name = fields[1]
        if short_name in aliases:
            raise RuntimeError(f"duplicate Script alias: {short_name}")
        short_names.append(short_name)
        for alias in fields[1:]:
            if alias:
                aliases[alias] = short_name
    if len(short_names) != SCRIPT_COUNT:
        raise RuntimeError(
            f"expected {SCRIPT_COUNT} Unicode scripts, received {len(short_names)}"
        )
    return short_names, aliases


def value_intervals(text: str, aliases: dict[str, str]) -> list[tuple[int, int, str]]:
    result: list[tuple[int, int, str]] = []
    for line in text.splitlines():
        match = PROPERTY_RE.match(line)
        if match is None:
            continue
        start = int(match.group(1), 16)
        end = int(match.group(2) or match.group(1), 16)
        value = match.group(3)
        try:
            short_name = aliases[value]
        except KeyError as error:
            raise RuntimeError(f"unknown Script property value: {value}") from error
        result.append((start, end, short_name))
    return result


def extension_intervals(
    text: str, aliases: dict[str, str]
) -> list[tuple[int, int, tuple[str, ...]]]:
    result: list[tuple[int, int, tuple[str, ...]]] = []
    for line in text.splitlines():
        match = SCRIPT_EXTENSIONS_RE.match(line)
        if match is None:
            continue
        start = int(match.group(1), 16)
        end = int(match.group(2) or match.group(1), 16)
        values: list[str] = []
        for value in match.group(3).split():
            try:
                values.append(aliases[value])
            except KeyError as error:
                raise RuntimeError(f"unknown Script_Extensions value: {value}") from error
        result.append((start, end, tuple(sorted(set(values)))))
    return result


def category_intervals(text: str, selected: set[str]) -> list[Interval]:
    result: list[Interval] = []
    for line in text.splitlines():
        match = PROPERTY_RE.match(line)
        if match is None or match.group(3) not in selected:
            continue
        result.append(
            (
                int(match.group(1), 16),
                int(match.group(2) or match.group(1), 16),
            )
        )
    return result


def validate_cjk_counts(intervals: list[tuple[int, int, str]]) -> None:
    for script, (expected_ranges, expected_scalars) in EXPECTED_CJK_COUNTS.items():
        selected = [(start, end) for start, end, value in intervals if value == script]
        scalar_count = sum(end - start + 1 for start, end in selected)
        if (len(selected), scalar_count) != (expected_ranges, expected_scalars):
            raise RuntimeError(
                f"unexpected {script} coverage: {len(selected)} ranges and "
                f"{scalar_count} scalars"
            )


def compress_properties(
    candidate_ids: list[int], flags: bytearray, default_candidate: int
) -> list[PropertyInterval]:
    result: list[PropertyInterval] = []
    run_start = 0
    run_candidate = candidate_ids[0]
    run_flags = flags[0]
    for value in range(1, MAX_SCALAR + 1):
        candidate = candidate_ids[value]
        value_flags = flags[value]
        if candidate == run_candidate and value_flags == run_flags:
            continue
        if run_candidate != default_candidate or run_flags != 0:
            result.append((run_start, value - 1, run_candidate, run_flags))
        run_start = value
        run_candidate = candidate
        run_flags = value_flags
    if run_candidate != default_candidate or run_flags != 0:
        result.append((run_start, MAX_SCALAR, run_candidate, run_flags))
    return result


def emit_property_branch(
    intervals: list[PropertyInterval], indent: str, default_candidate: int
) -> list[str]:
    if not intervals:
        return [
            indent
            + f"return _UnicodeScriptProperty({default_candidate}, UInt8(0))"
        ]
    middle = len(intervals) // 2
    start, end, candidate, flags = intervals[middle]
    lines = [indent + f"if value < 0x{start:X}:"]
    lines.extend(
        emit_property_branch(intervals[:middle], indent + "    ", default_candidate)
    )
    lines.append(indent + f"if value > 0x{end:X}:")
    lines.extend(
        emit_property_branch(
            intervals[middle + 1 :], indent + "    ", default_candidate
        )
    )
    lines.append(
        indent + f"return _UnicodeScriptProperty({candidate}, UInt8({flags}))"
    )
    return lines


def candidate_words(script_ids: Iterable[int]) -> tuple[int, int, int]:
    words = [0, 0, 0]
    for script_id in script_ids:
        words[script_id // 64] |= 1 << (script_id % 64)
    return words[0], words[1], words[2]


def emit_candidate_branch(
    sets: list[tuple[int, tuple[int, ...]]], indent: str
) -> list[str]:
    if not sets:
        return [indent + "return _ScriptCandidateSet()"]
    middle = len(sets) // 2
    candidate_id, scripts = sets[middle]
    word0, word1, word2 = candidate_words(scripts)
    lines = [indent + f"if candidate_id < {candidate_id}:"]
    lines.extend(emit_candidate_branch(sets[:middle], indent + "    "))
    lines.append(indent + f"if candidate_id > {candidate_id}:")
    lines.extend(emit_candidate_branch(sets[middle + 1 :], indent + "    "))
    lines.append(
        indent
        + "return _ScriptCandidateSet("
        + f"UInt64(0x{word0:X}), UInt64(0x{word1:X}), UInt64(0x{word2:X})"
        + ")"
    )
    return lines


def canonical_bracket(value: int) -> int:
    # UAX #9 treats these canonical-equivalent angle brackets identically.
    if value == 0x2329:
        return 0x3008
    if value == 0x232A:
        return 0x3009
    return value


def brackets(text: str) -> list[tuple[int, int]]:
    result: list[tuple[int, int]] = []
    for line in text.splitlines():
        match = BRACKET_RE.match(line)
        if match is None:
            continue
        value = int(match.group(1), 16)
        partner = canonical_bracket(int(match.group(2), 16))
        own_canonical = canonical_bracket(value)
        kind = 1 if match.group(3) == "o" else 2
        packed = kind | (partner << 2) | (own_canonical << 23)
        result.append((value, packed))
    return result


def emit_bracket_branch(entries: list[tuple[int, int]], indent: str) -> list[str]:
    if not entries:
        return [indent + "return _UnicodeBracketProperty(0)"]
    middle = len(entries) // 2
    value, packed = entries[middle]
    lines = [indent + f"if value < 0x{value:X}:"]
    lines.extend(emit_bracket_branch(entries[:middle], indent + "    "))
    lines.append(indent + f"if value > 0x{value:X}:")
    lines.extend(emit_bracket_branch(entries[middle + 1 :], indent + "    "))
    lines.append(indent + f"return _UnicodeBracketProperty(0x{packed:X})")
    return lines


def generate(source_dir: Path | None) -> str:
    source_text = {
        name: read_source(name, source_dir)
        for name in SOURCES
    }
    short_names, aliases = script_aliases(source_text["PropertyValueAliases.txt"])
    script_ids = {name: index for index, name in enumerate(short_names)}
    scripts = value_intervals(source_text["Scripts.txt"], aliases)
    validate_cjk_counts(scripts)
    extensions = extension_intervals(source_text["ScriptExtensions.txt"], aliases)
    marks = category_intervals(
        source_text["DerivedGeneralCategory.txt"], {"Mc", "Me", "Mn"}
    )

    default_candidate = script_ids["Zzzz"]
    candidate_ids = [default_candidate] * (MAX_SCALAR + 1)
    flags = bytearray(MAX_SCALAR + 1)
    for start, end, script in scripts:
        candidate = script_ids[script]
        value_flags = 0
        if script == "Zyyy":
            value_flags |= FLAG_COMMON
        elif script == "Zinh":
            value_flags |= FLAG_INHERITED
        for value in range(start, end + 1):
            candidate_ids[value] = candidate
            flags[value] |= value_flags

    extension_sets = sorted(
        {
            tuple(sorted(script_ids[script] for script in values))
            for _, _, values in extensions
        }
    )
    extension_id = {
        scripts_in_set: SCRIPT_COUNT + index
        for index, scripts_in_set in enumerate(extension_sets)
    }
    for start, end, scripts_in_set in extensions:
        candidate = extension_id[
            tuple(sorted(script_ids[script] for script in scripts_in_set))
        ]
        for value in range(start, end + 1):
            candidate_ids[value] = candidate
    for start, end in marks:
        for value in range(start, end + 1):
            flags[value] |= FLAG_MARK

    properties = compress_properties(candidate_ids, flags, default_candidate)
    candidate_entries = [
        (SCRIPT_COUNT + index, scripts_in_set)
        for index, scripts_in_set in enumerate(extension_sets)
    ]
    bracket_entries = brackets(source_text["BidiBrackets.txt"])
    cjk_word0, cjk_word1, cjk_word2 = candidate_words(
        (
            script_ids["Hani"],
            script_ids["Hira"],
            script_ids["Kana"],
            script_ids["Hang"],
            script_ids["Bopo"],
        )
    )

    lines = [
        '"""Generated exact Unicode script lookup data. Do not edit."""',
        "",
        f"# Unicode version: {UNICODE_VERSION}",
        "# Sources and SHA-256 digests:",
    ]
    for name, (url, digest) in SOURCES.items():
        lines.append(f"# - {url}")
        lines.append(f"#   {digest}  {name}")
    lines.extend(
        [
            "",
            f"comptime _UNICODE_SCRIPT_COUNT = {SCRIPT_COUNT}",
            f"comptime _SCRIPT_HAN = {script_ids['Hani']}",
            f"comptime _SCRIPT_HIRAGANA = {script_ids['Hira']}",
            f"comptime _SCRIPT_KATAKANA = {script_ids['Kana']}",
            f"comptime _SCRIPT_HANGUL = {script_ids['Hang']}",
            f"comptime _SCRIPT_BOPOMOFO = {script_ids['Bopo']}",
            f"comptime _SCRIPT_COMMON = {script_ids['Zyyy']}",
            f"comptime _SCRIPT_INHERITED = {script_ids['Zinh']}",
            f"comptime _SCRIPT_UNKNOWN = {script_ids['Zzzz']}",
            f"comptime _CJK_SCRIPT_WORD0 = 0x{cjk_word0:X}",
            f"comptime _CJK_SCRIPT_WORD1 = 0x{cjk_word1:X}",
            f"comptime _CJK_SCRIPT_WORD2 = 0x{cjk_word2:X}",
            f"comptime _SCRIPT_FLAG_COMMON = {FLAG_COMMON}",
            f"comptime _SCRIPT_FLAG_INHERITED = {FLAG_INHERITED}",
            f"comptime _SCRIPT_FLAG_MARK = {FLAG_MARK}",
            "comptime _BRACKET_OPEN = 1",
            "comptime _BRACKET_CLOSE = 2",
            "",
            "",
            "struct _UnicodeScriptProperty(Copyable, ImplicitlyCopyable):",
            "    var _candidate_id: Int",
            "    var _flags: UInt8",
            "",
            "    def __init__(out self, candidate_id: Int, flags: UInt8):",
            "        self._candidate_id = candidate_id",
            "        self._flags = flags",
            "",
            "    def candidate_id(self) -> Int:",
            "        return self._candidate_id",
            "",
            "    def is_common_or_inherited(self) -> Bool:",
            "        return (self._flags & UInt8(3)) != UInt8(0)",
            "",
            "    def is_mark(self) -> Bool:",
            "        return (self._flags & UInt8(4)) != UInt8(0)",
            "",
            "",
            "struct _ScriptCandidateSet(Copyable, ImplicitlyCopyable):",
            "    var word0: UInt64",
            "    var word1: UInt64",
            "    var word2: UInt64",
            "",
            "    def __init__(out self):",
            "        self.word0 = UInt64(0)",
            "        self.word1 = UInt64(0)",
            "        self.word2 = UInt64(0)",
            "",
            "    def __init__(",
            "        out self, word0: UInt64, word1: UInt64, word2: UInt64",
            "    ):",
            "        self.word0 = word0",
            "        self.word1 = word1",
            "        self.word2 = word2",
            "",
            "",
            "struct _UnicodeBracketProperty(Copyable, ImplicitlyCopyable):",
            "    var _packed: Int",
            "",
            "    def __init__(out self, packed: Int):",
            "        self._packed = packed",
            "",
            "    def packed(self) -> Int:",
            "        return self._packed",
            "",
            "",
            "def _unicode_script_data_version() -> String:",
            f'    return "{UNICODE_VERSION}"',
            "",
            "",
            "def _unicode_script_candidates(candidate_id: Int) -> _ScriptCandidateSet:",
            f"    if candidate_id >= 0 and candidate_id < {SCRIPT_COUNT}:",
            "        var bit = UInt64(1) << UInt64(candidate_id % 64)",
            "        if candidate_id < 64:",
            "            return _ScriptCandidateSet(bit, UInt64(0), UInt64(0))",
            "        if candidate_id < 128:",
            "            return _ScriptCandidateSet(UInt64(0), bit, UInt64(0))",
            "        return _ScriptCandidateSet(UInt64(0), UInt64(0), bit)",
        ]
    )
    lines.extend(emit_candidate_branch(candidate_entries, "    "))
    lines.extend(
        [
            "",
            "",
            "def _unicode_script_property(value: Int) -> _UnicodeScriptProperty:",
            "    if value < 0 or value > 0x10FFFF:",
            f"        return _UnicodeScriptProperty({default_candidate}, UInt8(0))",
        ]
    )
    lines.extend(emit_property_branch(properties, "    ", default_candidate))
    lines.extend(
        [
            "",
            "",
            "def _unicode_bracket_property(value: Int) -> _UnicodeBracketProperty:",
            "    if value < 0 or value > 0x10FFFF:",
            "        return _UnicodeBracketProperty(0)",
        ]
    )
    lines.extend(emit_bracket_branch(bracket_entries, "    "))
    lines.append("")
    return format_mojo("\n".join(lines))


def format_mojo(source: str) -> str:
    """Apply the repository's pinned Mojo 1.0 formatter deterministically."""
    temporary_path: Path | None = None
    try:
        with tempfile.NamedTemporaryFile(
            mode="w", suffix=".mojo", encoding="utf-8", delete=False
        ) as temporary:
            temporary.write(source)
            temporary_path = Path(temporary.name)
        subprocess.run(
            ["mojo", "format", "-l", "88", str(temporary_path)],
            check=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.PIPE,
            text=True,
        )
        return temporary_path.read_text()
    except FileNotFoundError as error:
        raise RuntimeError(
            "Mojo 1.0 formatter not found; run the generator through Pixi"
        ) from error
    finally:
        if temporary_path is not None:
            temporary_path.unlink(missing_ok=True)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--source-dir",
        type=Path,
        help="read pinned files from this directory instead of downloading them",
    )
    parser.add_argument(
        "--check", action="store_true", help="fail if the generated file is stale"
    )
    args = parser.parse_args()

    generated = generate(args.source_dir)
    if args.check:
        if not OUTPUT.exists() or OUTPUT.read_text() != generated:
            print(f"generated Unicode data is stale: {OUTPUT}", file=sys.stderr)
            return 1
        return 0

    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_text(generated)
    print(f"generated {OUTPUT}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
