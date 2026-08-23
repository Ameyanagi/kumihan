"""Small deterministic SFNT/TTC builders for parser and shaping tests."""

from std.collections import List


def _write_u16(mut data: List[UInt8], offset: Int, value: Int):
    data[offset] = UInt8((value >> 8) & 0xFF)
    data[offset + 1] = UInt8(value & 0xFF)


def _write_i16(mut data: List[UInt8], offset: Int, value: Int):
    _write_u16(data, offset, value & 0xFFFF)


def _write_u32(mut data: List[UInt8], offset: Int, value: Int):
    data[offset] = UInt8((value >> 24) & 0xFF)
    data[offset + 1] = UInt8((value >> 16) & 0xFF)
    data[offset + 2] = UInt8((value >> 8) & 0xFF)
    data[offset + 3] = UInt8(value & 0xFF)


def _write_u24(mut data: List[UInt8], offset: Int, value: Int):
    data[offset] = UInt8((value >> 16) & 0xFF)
    data[offset + 1] = UInt8((value >> 8) & 0xFF)
    data[offset + 2] = UInt8(value & 0xFF)


def _read_u16(data: List[UInt8], offset: Int) -> Int:
    return (Int(data[offset]) << 8) | Int(data[offset + 1])


def _read_u32(data: List[UInt8], offset: Int) -> Int:
    return (
        (Int(data[offset]) << 24)
        | (Int(data[offset + 1]) << 16)
        | (Int(data[offset + 2]) << 8)
        | Int(data[offset + 3])
    )


def _align4(value: Int) -> Int:
    return (value + 3) & ~3


def _make_cmap12() -> List[UInt8]:
    comptime group_count = 5
    comptime subtable_length = 16 + 12 * group_count
    var data = List[UInt8](length=12 + subtable_length, fill=UInt8(0))
    _write_u16(data, 0, 0)
    _write_u16(data, 2, 1)
    _write_u16(data, 4, 3)
    _write_u16(data, 6, 10)
    _write_u32(data, 8, 12)
    _write_u16(data, 12, 12)
    _write_u16(data, 14, 0)
    _write_u32(data, 16, subtable_length)
    _write_u32(data, 20, 0)
    _write_u32(data, 24, group_count)
    var codepoints: List[Int] = [0x41, 0x65E5, 0x672C, 0x8A9E, 0x20000]
    for index in range(group_count):
        var record = 28 + 12 * index
        _write_u32(data, record, codepoints[index])
        _write_u32(data, record + 4, codepoints[index])
        _write_u32(data, record + 8, index + 1)
    return data^


def _make_cmap12_auto_cjk() -> List[UInt8]:
    """Map one representative scalar per automatic script to glyph one."""
    comptime group_count = 6
    comptime subtable_length = 16 + 12 * group_count
    var data = List[UInt8](length=12 + subtable_length, fill=UInt8(0))
    _write_u16(data, 0, 0)
    _write_u16(data, 2, 1)
    _write_u16(data, 4, 3)
    _write_u16(data, 6, 10)
    _write_u32(data, 8, 12)
    _write_u16(data, 12, 12)
    _write_u16(data, 14, 0)
    _write_u32(data, 16, subtable_length)
    _write_u32(data, 20, 0)
    _write_u32(data, 24, group_count)
    var codepoints: List[Int] = [
        0x41,  # Latin: DFLT
        0x3042,  # Hiragana: kana
        0x30A2,  # Katakana: kana
        0x3105,  # Bopomofo: bopo
        0x65E5,  # Han: hani
        0xD55C,  # Hangul: hang
    ]
    for index in range(group_count):
        var record = 28 + 12 * index
        _write_u32(data, record, codepoints[index])
        _write_u32(data, record + 4, codepoints[index])
        _write_u32(data, record + 8, 1)
    return data^


def _make_cmap4() -> List[UInt8]:
    comptime segment_count = 5
    # One extra glyph word exercises the idRangeOffset lookup path; the other
    # segments use direct deltas.
    comptime subtable_length = 16 + 8 * segment_count + 2
    var data = List[UInt8](length=12 + subtable_length, fill=UInt8(0))
    _write_u16(data, 0, 0)
    _write_u16(data, 2, 1)
    _write_u16(data, 4, 3)
    _write_u16(data, 6, 1)
    _write_u32(data, 8, 12)
    _write_u16(data, 12, 4)
    _write_u16(data, 14, subtable_length)
    _write_u16(data, 16, 0)
    _write_u16(data, 18, 2 * segment_count)
    _write_u16(data, 20, 8)
    _write_u16(data, 22, 2)
    _write_u16(data, 24, 2)

    var codepoints: List[Int] = [0x41, 0x65E5, 0x672C, 0x8A9E, 0xFFFF]
    var end_codes = 26
    var start_codes = end_codes + 2 * segment_count + 2
    var deltas = start_codes + 2 * segment_count
    var range_offsets = deltas + 2 * segment_count
    for index in range(segment_count):
        _write_u16(data, end_codes + 2 * index, codepoints[index])
        _write_u16(data, start_codes + 2 * index, codepoints[index])
        var glyph = 0 if index == segment_count - 1 else index + 1
        _write_u16(data, deltas + 2 * index, glyph - codepoints[index])
        _write_u16(data, range_offsets + 2 * index, 0)
    # Map 日 through glyphIdArray instead of the direct-delta path.
    _write_u16(data, deltas + 2, 0)
    _write_u16(data, range_offsets + 2, 2 * (segment_count - 1))
    _write_u16(data, range_offsets + 2 * segment_count, 2)
    return data^


def _make_cmap12_with_uvs() -> List[UInt8]:
    """Build nominal mappings plus shared, unaligned, reverse-ordered UVS data."""
    var nominal_table = _make_cmap12()
    # Strip the one-record cmap header, retaining only its format 12 subtable.
    comptime nominal_length = 76
    comptime format14_length = 83
    comptime header_length = 20
    var data = List[UInt8](
        length=header_length + nominal_length + format14_length, fill=UInt8(0)
    )
    _write_u16(data, 0, 0)
    _write_u16(data, 2, 2)
    # Encoding records are sorted by platform ID, then encoding ID.
    _write_u16(data, 4, 0)
    _write_u16(data, 6, 5)
    _write_u32(data, 8, header_length + nominal_length)
    _write_u16(data, 12, 3)
    _write_u16(data, 14, 10)
    _write_u32(data, 16, header_length)
    for index in range(nominal_length):
        data[header_length + index] = nominal_table[12 + index]

    var format14 = header_length + nominal_length
    _write_u16(data, format14, 14)
    _write_u32(data, format14 + 2, format14_length)
    _write_u32(data, format14 + 6, 3)

    # Children start at deliberately unaligned offsets. The first record's
    # non-default table precedes its default table, and the third selector
    # shares the first selector's exact default-table offset.
    comptime shared_non_default = 43
    comptime shared_default = 62
    comptime second_non_default = 74
    _write_u24(data, format14 + 10, 0xE0100)
    _write_u32(data, format14 + 13, shared_default)
    _write_u32(data, format14 + 17, shared_non_default)
    _write_u24(data, format14 + 21, 0xE0101)
    _write_u32(data, format14 + 24, 0)
    _write_u32(data, format14 + 28, second_non_default)
    _write_u24(data, format14 + 32, 0xE0102)
    _write_u32(data, format14 + 35, shared_default)
    _write_u32(data, format14 + 39, 0)

    _write_u32(data, format14 + shared_non_default, 3)
    _write_u24(data, format14 + shared_non_default + 4, 0x4E8C)
    _write_u16(data, format14 + shared_non_default + 7, 1)
    _write_u24(data, format14 + shared_non_default + 9, 0x672C)
    _write_u16(data, format14 + shared_non_default + 12, 5)
    _write_u24(data, format14 + shared_non_default + 14, 0x9AA8)
    _write_u16(data, format14 + shared_non_default + 17, 4)

    _write_u32(data, format14 + shared_default, 2)
    _write_u24(data, format14 + shared_default + 4, 0x4E00)
    data[format14 + shared_default + 7] = UInt8(0)
    _write_u24(data, format14 + shared_default + 8, 0x65E5)
    data[format14 + shared_default + 11] = UInt8(0)

    _write_u32(data, format14 + second_non_default, 1)
    _write_u24(data, format14 + second_non_default + 4, 0x65E5)
    _write_u16(data, format14 + second_non_default + 7, 4)
    return data^


def _make_cmap12_with_mac_language_records() -> List[UInt8]:
    """Build two classic Mac records followed by one supported Unicode cmap."""
    var nominal_table = _make_cmap12()
    comptime nominal_length = 76
    comptime header_length = 28
    comptime format6_length = 10
    var data = List[UInt8](
        length=header_length + 2 * format6_length + nominal_length, fill=UInt8(0)
    )
    _write_u16(data, 0, 0)
    _write_u16(data, 2, 3)
    _write_u16(data, 4, 1)
    _write_u16(data, 6, 0)
    _write_u32(data, 8, header_length)
    _write_u16(data, 12, 1)
    _write_u16(data, 14, 0)
    _write_u32(data, 16, header_length + format6_length)
    _write_u16(data, 20, 3)
    _write_u16(data, 22, 10)
    _write_u32(data, 24, header_length + 2 * format6_length)

    # Format 6 language fields distinguish otherwise equal encoding records.
    _write_u16(data, header_length, 6)
    _write_u16(data, header_length + 2, format6_length)
    _write_u16(data, header_length + 4, 0)
    _write_u16(data, header_length + format6_length, 6)
    _write_u16(data, header_length + format6_length + 2, format6_length)
    _write_u16(data, header_length + format6_length + 4, 3)
    for index in range(nominal_length):
        data[header_length + 2 * format6_length + index] = nominal_table[12 + index]
    return data^


def _make_shared_cmap12() -> List[UInt8]:
    """Build Unicode and Windows records sharing one exact format 12 offset."""
    var nominal_table = _make_cmap12()
    comptime nominal_length = 76
    comptime header_length = 20
    var data = List[UInt8](length=header_length + nominal_length, fill=UInt8(0))
    _write_u16(data, 0, 0)
    _write_u16(data, 2, 2)
    _write_u16(data, 4, 0)
    _write_u16(data, 6, 4)
    _write_u32(data, 8, header_length)
    _write_u16(data, 12, 3)
    _write_u16(data, 14, 10)
    _write_u32(data, 16, header_length)
    for index in range(nominal_length):
        data[header_length + index] = nominal_table[12 + index]
    return data^


def _make_test_font_from_cmap(var cmap: List[UInt8]) -> List[UInt8]:
    comptime table_count = 5
    var directory_length = 12 + 16 * table_count
    var head_offset = _align4(directory_length)
    var maxp_offset = _align4(head_offset + 54)
    var hhea_offset = _align4(maxp_offset + 6)
    var hmtx_offset = _align4(hhea_offset + 36)
    var cmap_offset = _align4(hmtx_offset + 18)
    var total = cmap_offset + len(cmap)
    var data = List[UInt8](length=total, fill=UInt8(0))

    _write_u32(data, 0, 0x00010000)
    _write_u16(data, 4, table_count)

    # Deliberately non-tag-sorted so the parser proves it caches a sorted
    # directory rather than assuming producer order.
    var tags: List[Int] = [
        0x686D7478,  # hmtx
        0x636D6170,  # cmap
        0x6D617870,  # maxp
        0x68656164,  # head
        0x68686561,  # hhea
    ]
    var offsets: List[Int] = [
        hmtx_offset,
        cmap_offset,
        maxp_offset,
        head_offset,
        hhea_offset,
    ]
    var lengths: List[Int] = [18, len(cmap), 6, 54, 36]
    for index in range(table_count):
        var record = 12 + 16 * index
        _write_u32(data, record, tags[index])
        _write_u32(data, record + 4, 0)
        _write_u32(data, record + 8, offsets[index])
        _write_u32(data, record + 12, lengths[index])

    _write_u32(data, head_offset, 0x00010000)
    _write_u32(data, head_offset + 12, 0x5F0F3CF5)
    _write_u16(data, head_offset + 18, 1000)

    _write_u32(data, maxp_offset, 0x00010000)
    _write_u16(data, maxp_offset + 4, 6)

    _write_u32(data, hhea_offset, 0x00010000)
    _write_i16(data, hhea_offset + 4, 800)
    _write_i16(data, hhea_offset + 6, -200)
    _write_i16(data, hhea_offset + 8, 100)
    _write_u16(data, hhea_offset + 34, 3)

    _write_u16(data, hmtx_offset, 500)
    _write_i16(data, hmtx_offset + 2, 0)
    _write_u16(data, hmtx_offset + 4, 600)
    _write_i16(data, hmtx_offset + 6, 10)
    _write_u16(data, hmtx_offset + 8, 1000)
    _write_i16(data, hmtx_offset + 10, 20)
    _write_i16(data, hmtx_offset + 12, 30)
    _write_i16(data, hmtx_offset + 14, 40)
    _write_i16(data, hmtx_offset + 16, 50)

    for index in range(len(cmap)):
        data[cmap_offset + index] = cmap[index]
    return data^


def _make_test_font_from_cmap_and_gsub(
    var cmap: List[UInt8], var gsub: List[UInt8]
) -> List[UInt8]:
    """Build the standard test face with one optional GSUB table appended.

    The original five records retain their order and field positions, so the
    older malformed-font fixtures can continue mutating exact offsets.
    """
    comptime table_count = 6
    var directory_length = 12 + 16 * table_count
    var head_offset = _align4(directory_length)
    var maxp_offset = _align4(head_offset + 54)
    var hhea_offset = _align4(maxp_offset + 6)
    var hmtx_offset = _align4(hhea_offset + 36)
    var cmap_offset = _align4(hmtx_offset + 18)
    var gsub_offset = _align4(cmap_offset + len(cmap))
    var data = List[UInt8](length=gsub_offset + len(gsub), fill=UInt8(0))

    _write_u32(data, 0, 0x00010000)
    _write_u16(data, 4, table_count)
    var tags: List[Int] = [
        0x686D7478,  # hmtx
        0x636D6170,  # cmap
        0x6D617870,  # maxp
        0x68656164,  # head
        0x68686561,  # hhea
        0x47535542,  # GSUB
    ]
    var offsets: List[Int] = [
        hmtx_offset,
        cmap_offset,
        maxp_offset,
        head_offset,
        hhea_offset,
        gsub_offset,
    ]
    var lengths: List[Int] = [18, len(cmap), 6, 54, 36, len(gsub)]
    for index in range(table_count):
        var record = 12 + 16 * index
        _write_u32(data, record, tags[index])
        _write_u32(data, record + 4, 0)
        _write_u32(data, record + 8, offsets[index])
        _write_u32(data, record + 12, lengths[index])

    _write_u32(data, head_offset, 0x00010000)
    _write_u32(data, head_offset + 12, 0x5F0F3CF5)
    _write_u16(data, head_offset + 18, 1000)
    _write_u32(data, maxp_offset, 0x00010000)
    _write_u16(data, maxp_offset + 4, 6)
    _write_u32(data, hhea_offset, 0x00010000)
    _write_i16(data, hhea_offset + 4, 800)
    _write_i16(data, hhea_offset + 6, -200)
    _write_i16(data, hhea_offset + 8, 100)
    _write_u16(data, hhea_offset + 34, 3)
    _write_u16(data, hmtx_offset, 500)
    _write_i16(data, hmtx_offset + 2, 0)
    _write_u16(data, hmtx_offset + 4, 600)
    _write_i16(data, hmtx_offset + 6, 10)
    _write_u16(data, hmtx_offset + 8, 1000)
    _write_i16(data, hmtx_offset + 10, 20)
    _write_i16(data, hmtx_offset + 12, 30)
    _write_i16(data, hmtx_offset + 14, 40)
    _write_i16(data, hmtx_offset + 16, 50)
    for index in range(len(cmap)):
        data[cmap_offset + index] = cmap[index]
    for index in range(len(gsub)):
        data[gsub_offset + index] = gsub[index]
    return data^


def _write_default_locl_scaffold(
    mut data: List[UInt8], header_length: Int, lookup_type: Int
) -> Int:
    """Write DFLT/default/locl lists and return the Lookup table offset."""
    var script_list = header_length
    var feature_list = script_list + 20
    var lookup_list = feature_list + 14
    _write_u16(data, 4, script_list)
    _write_u16(data, 6, feature_list)
    _write_u16(data, 8, lookup_list)

    _write_u16(data, script_list, 1)
    _write_u32(data, script_list + 2, 0x44464C54)  # DFLT
    _write_u16(data, script_list + 6, 8)
    var script = script_list + 8
    _write_u16(data, script, 4)
    _write_u16(data, script + 2, 0)
    var langsys = script + 4
    _write_u16(data, langsys, 0)
    _write_u16(data, langsys + 2, 0xFFFF)
    _write_u16(data, langsys + 4, 1)
    _write_u16(data, langsys + 6, 0)

    _write_u16(data, feature_list, 1)
    _write_u32(data, feature_list + 2, 0x6C6F636C)  # locl
    _write_u16(data, feature_list + 6, 8)
    var feature = feature_list + 8
    _write_u16(data, feature, 0)
    _write_u16(data, feature + 2, 1)
    _write_u16(data, feature + 4, 0)

    _write_u16(data, lookup_list, 1)
    _write_u16(data, lookup_list + 2, 4)
    var lookup = lookup_list + 4
    _write_u16(data, lookup, lookup_type)
    _write_u16(data, lookup + 2, 0)
    _write_u16(data, lookup + 4, 1)
    _write_u16(data, lookup + 6, 8)
    return lookup


def make_gsub_single_format1(
    input_glyph: Int = 1,
    delta: Int = 1,
    coverage_format: Int = 1,
    version_1_1: Bool = False,
) -> List[UInt8]:
    """Build DFLT/default locl with one direct SingleSubst format 1."""
    var header_length = 14 if version_1_1 else 10
    var coverage_length = 6 if coverage_format == 1 else 10
    var data = List[UInt8](
        length=header_length + 20 + 14 + 18 + coverage_length, fill=UInt8(0)
    )
    _write_u16(data, 0, 1)
    _write_u16(data, 2, 1 if version_1_1 else 0)
    if version_1_1:
        _write_u32(data, 10, 0)
    var lookup = _write_default_locl_scaffold(data, header_length, 1)
    var single = lookup + 8
    _write_u16(data, single, 1)
    _write_u16(data, single + 2, 6)
    _write_i16(data, single + 4, delta)
    var coverage = single + 6
    _write_u16(data, coverage, coverage_format)
    _write_u16(data, coverage + 2, 1)
    if coverage_format == 1:
        _write_u16(data, coverage + 4, input_glyph)
    else:
        _write_u16(data, coverage + 4, input_glyph)
        _write_u16(data, coverage + 6, input_glyph)
        _write_u16(data, coverage + 8, 0)
    return data^


def make_gsub_single_format2_coverage2() -> List[UInt8]:
    """Map coverage range glyphs 1..3 to 4, 5, and glyph zero."""
    comptime header_length = 10
    comptime output_count = 3
    comptime single_length = 6 + 2 * output_count + 10
    var data = List[UInt8](
        length=header_length + 20 + 14 + 12 + single_length, fill=UInt8(0)
    )
    _write_u16(data, 0, 1)
    _write_u16(data, 2, 0)
    var lookup = _write_default_locl_scaffold(data, header_length, 1)
    var single = lookup + 8
    _write_u16(data, single, 2)
    _write_u16(data, single + 2, 6 + 2 * output_count)
    _write_u16(data, single + 4, output_count)
    _write_u16(data, single + 6, 4)
    _write_u16(data, single + 8, 5)
    _write_u16(data, single + 10, 0)
    var coverage = single + 12
    _write_u16(data, coverage, 2)
    _write_u16(data, coverage + 2, 1)
    _write_u16(data, coverage + 4, 1)
    _write_u16(data, coverage + 6, 3)
    _write_u16(data, coverage + 8, 0)
    return data^


def make_gsub_coverage2_two_ranges() -> List[UInt8]:
    """Map glyphs 1 and 3 through two coverage ranges, leaving a gap."""
    comptime header_length = 10
    comptime output_count = 2
    comptime single_length = 6 + 2 * output_count + 16
    var data = List[UInt8](
        length=header_length + 20 + 14 + 12 + single_length, fill=UInt8(0)
    )
    _write_u16(data, 0, 1)
    _write_u16(data, 2, 0)
    var lookup = _write_default_locl_scaffold(data, header_length, 1)
    var single = lookup + 8
    _write_u16(data, single, 2)
    _write_u16(data, single + 2, 6 + 2 * output_count)
    _write_u16(data, single + 4, output_count)
    _write_u16(data, single + 6, 4)
    _write_u16(data, single + 8, 5)
    var coverage = single + 10
    _write_u16(data, coverage, 2)
    _write_u16(data, coverage + 2, 2)
    _write_u16(data, coverage + 4, 1)
    _write_u16(data, coverage + 6, 1)
    _write_u16(data, coverage + 8, 0)
    _write_u16(data, coverage + 10, 3)
    _write_u16(data, coverage + 12, 3)
    _write_u16(data, coverage + 14, 1)
    return data^


def make_gsub_first_subtable_wins() -> List[UInt8]:
    """Build one lookup whose two subtables both match glyph 1."""
    comptime header_length = 10
    comptime single_length = 14
    var data = List[UInt8](
        length=header_length + 20 + 14 + 14 + 2 * single_length,
        fill=UInt8(0),
    )
    _write_u16(data, 0, 1)
    _write_u16(data, 2, 0)
    var lookup = _write_default_locl_scaffold(data, header_length, 1)
    _write_u16(data, lookup + 4, 2)
    _write_u16(data, lookup + 6, 10)
    _write_u16(data, lookup + 8, 10 + single_length)
    for index in range(2):
        var single = lookup + 10 + single_length * index
        _write_u16(data, single, 2)
        _write_u16(data, single + 2, 8)
        _write_u16(data, single + 4, 1)
        _write_u16(data, single + 6, 2 if index == 0 else 5)
        _write_u16(data, single + 8, 1)
        _write_u16(data, single + 10, 1)
        _write_u16(data, single + 12, 1)
    return data^


def make_gsub_extension_shared_reverse() -> List[UInt8]:
    """Build reverse-ordered wrappers sharing one unaligned SingleSubst."""
    comptime header_length = 10
    comptime lookup_payload_length = 42
    var data = List[UInt8](
        length=header_length + 20 + 14 + 4 + lookup_payload_length,
        fill=UInt8(0),
    )
    _write_u16(data, 0, 1)
    _write_u16(data, 2, 0)
    var lookup = _write_default_locl_scaffold(data, header_length, 7)
    _write_u16(data, lookup + 4, 2)
    # Stored order runs from the later wrapper to the earlier wrapper.
    _write_u16(data, lookup + 6, 19)
    _write_u16(data, lookup + 8, 10)
    var early_wrapper = lookup + 10
    var late_wrapper = lookup + 19
    var single = lookup + 28
    for wrapper in [early_wrapper, late_wrapper]:
        _write_u16(data, wrapper, 1)
        _write_u16(data, wrapper + 2, 1)
        _write_u32(data, wrapper + 4, single - wrapper)
    _write_u16(data, single, 2)
    _write_u16(data, single + 2, 8)
    _write_u16(data, single + 4, 1)
    _write_u16(data, single + 6, 5)
    _write_u16(data, single + 8, 1)
    _write_u16(data, single + 10, 1)
    _write_u16(data, single + 12, 1)
    return data^


def _write_langsys(
    mut data: List[UInt8], offset: Int, required_feature: Int, feature: Int
):
    _write_u16(data, offset, 0)
    _write_u16(data, offset + 2, required_feature)
    if feature < 0:
        _write_u16(data, offset + 4, 0)
    else:
        _write_u16(data, offset + 4, 1)
        _write_u16(data, offset + 6, feature)


def _write_single2_coverage1(
    mut data: List[UInt8], single: Int, input_glyph: Int, output_glyph: Int
):
    _write_u16(data, single, 2)
    _write_u16(data, single + 2, 8)
    _write_u16(data, single + 4, 1)
    _write_u16(data, single + 6, output_glyph)
    _write_u16(data, single + 8, 1)
    _write_u16(data, single + 10, 1)
    _write_u16(data, single + 12, input_glyph)


def make_gsub_cjk_selection() -> List[UInt8]:
    """Build exact CJK Script/LangSys locl selection with seven outcomes."""
    comptime header_length = 10
    comptime script_list_length = 174
    comptime feature_list_length = 86
    comptime lookup_count = 7
    comptime lookup_length = 22
    comptime total_length = (
        header_length
        + script_list_length
        + feature_list_length
        + 2
        + 2 * lookup_count
        + lookup_count * lookup_length
    )
    var data = List[UInt8](length=total_length, fill=UInt8(0))
    _write_u16(data, 0, 1)
    _write_u16(data, 2, 0)
    var script_list = header_length
    var feature_list = script_list + script_list_length
    var lookup_list = feature_list + feature_list_length
    _write_u16(data, 4, script_list)
    _write_u16(data, 6, feature_list)
    _write_u16(data, 8, lookup_list)

    var script_tags: List[Int] = [
        0x44464C54,  # DFLT
        0x626F706F,  # bopo
        0x68616E67,  # hang
        0x68616E69,  # hani
        0x6B616E61,  # kana
    ]
    var script_offsets: List[Int] = [32, 42, 54, 80, 148]
    _write_u16(data, script_list, len(script_tags))
    for index in range(len(script_tags)):
        var record = script_list + 2 + 6 * index
        _write_u32(data, record, script_tags[index])
        _write_u16(data, record + 4, script_offsets[index])

    var dflt = script_list + script_offsets[0]
    _write_u16(data, dflt, 4)
    _write_u16(data, dflt + 2, 0)
    _write_langsys(data, dflt + 4, 0, -1)  # required locl feature

    var bopo = script_list + script_offsets[1]
    _write_u16(data, bopo, 4)
    _write_u16(data, bopo + 2, 0)
    _write_langsys(data, bopo + 4, 0xFFFF, 6)

    var hang = script_list + script_offsets[2]
    _write_u16(data, hang, 10)
    _write_u16(data, hang + 2, 1)
    _write_u32(data, hang + 4, 0x4B4F5220)  # KOR
    _write_u16(data, hang + 8, 18)
    _write_langsys(data, hang + 10, 0xFFFF, 0)
    _write_langsys(data, hang + 18, 0xFFFF, 5)

    var hani = script_list + script_offsets[3]
    _write_u16(data, hani, 28)
    _write_u16(data, hani + 2, 4)
    var language_tags: List[Int] = [
        0x4A414E20,  # JAN
        0x5A484820,  # ZHH
        0x5A485320,  # ZHS
        0x5A485420,  # ZHT
    ]
    # Physical LangSys children are in a different order from their tags.
    var language_offsets: List[Int] = [52, 60, 44, 36]
    for index in range(len(language_tags)):
        var record = hani + 4 + 6 * index
        _write_u32(data, record, language_tags[index])
        _write_u16(data, record + 4, language_offsets[index])
    _write_langsys(data, hani + 28, 0xFFFF, 0)
    _write_langsys(data, hani + 36, 0xFFFF, 4)
    _write_langsys(data, hani + 44, 0xFFFF, 2)
    _write_langsys(data, hani + 52, 0xFFFF, 1)
    _write_langsys(data, hani + 60, 0xFFFF, 3)

    var kana = script_list + script_offsets[4]
    _write_u16(data, kana, 10)
    _write_u16(data, kana + 2, 1)
    _write_u32(data, kana + 4, 0x4A414E20)  # JAN
    _write_u16(data, kana + 8, 18)
    _write_langsys(data, kana + 10, 0xFFFF, 0)
    _write_langsys(data, kana + 18, 0xFFFF, 1)

    _write_u16(data, feature_list, lookup_count)
    var feature_child = feature_list + 2 + 6 * lookup_count
    for index in range(lookup_count):
        var record = feature_list + 2 + 6 * index
        _write_u32(data, record, 0x6C6F636C)  # repeated locl is valid
        _write_u16(data, record + 4, feature_child + 6 * index - feature_list)
        _write_u16(data, feature_child + 6 * index, 0)
        _write_u16(data, feature_child + 6 * index + 2, 1)
        _write_u16(data, feature_child + 6 * index + 4, index)

    _write_u16(data, lookup_list, lookup_count)
    var lookup_children = lookup_list + 2 + 2 * lookup_count
    for index in range(lookup_count):
        var lookup = lookup_children + lookup_length * index
        _write_u16(data, lookup_list + 2 + 2 * index, lookup - lookup_list)
        _write_u16(data, lookup, 1)
        _write_u16(data, lookup + 2, 0)
        _write_u16(data, lookup + 4, 1)
        _write_u16(data, lookup + 6, 8)
        _write_single2_coverage1(data, lookup + 8, 1, index + 2)
    return data^


def make_gsub_no_specific_default() -> List[UInt8]:
    """Keep hani/JAN but remove its default LangSys for no-fallback tests."""
    var data = make_gsub_cjk_selection()
    comptime hani = 10 + 80
    _write_u16(data, hani, 0)
    return data^


def make_gsub_order_dedup_chain() -> List[UInt8]:
    """Build required/ordinary features whose lookup references need sorting."""
    comptime header_length = 10
    comptime script_list_length = 20
    comptime feature_list_length = 30
    comptime lookup_count = 3
    comptime lookup_list_header = 2 + 2 * lookup_count
    comptime lookup0_length = 28
    comptime other_lookup_length = 22
    var data = List[UInt8](
        length=(
            header_length
            + script_list_length
            + feature_list_length
            + lookup_list_header
            + lookup0_length
            + 2 * other_lookup_length
        ),
        fill=UInt8(0),
    )
    _write_u16(data, 0, 1)
    _write_u16(data, 2, 0)
    var script_list = header_length
    var feature_list = script_list + script_list_length
    var lookup_list = feature_list + feature_list_length
    _write_u16(data, 4, script_list)
    _write_u16(data, 6, feature_list)
    _write_u16(data, 8, lookup_list)

    _write_u16(data, script_list, 1)
    _write_u32(data, script_list + 2, 0x44464C54)
    _write_u16(data, script_list + 6, 8)
    var script = script_list + 8
    _write_u16(data, script, 4)
    _write_u16(data, script + 2, 0)
    # Feature 0 is required; feature 1 lists lookup indices out of order and
    # repeats lookup zero. Execution must be unique LookupList order 0,1,2.
    _write_langsys(data, script + 4, 0, 1)

    _write_u16(data, feature_list, 2)
    _write_u32(data, feature_list + 2, 0x6C6F636C)
    _write_u16(data, feature_list + 6, 14)
    _write_u32(data, feature_list + 8, 0x6C6F636C)
    _write_u16(data, feature_list + 12, 20)
    var required_feature = feature_list + 14
    _write_u16(data, required_feature, 0)
    _write_u16(data, required_feature + 2, 1)
    _write_u16(data, required_feature + 4, 2)
    var ordinary_feature = feature_list + 20
    _write_u16(data, ordinary_feature, 0)
    _write_u16(data, ordinary_feature + 2, 3)
    _write_u16(data, ordinary_feature + 4, 1)
    _write_u16(data, ordinary_feature + 6, 0)
    _write_u16(data, ordinary_feature + 8, 0)

    _write_u16(data, lookup_list, lookup_count)
    var lookup0 = lookup_list + lookup_list_header
    var lookup1 = lookup0 + lookup0_length
    var lookup2 = lookup1 + other_lookup_length
    _write_u16(data, lookup_list + 2, lookup0 - lookup_list)
    _write_u16(data, lookup_list + 4, lookup1 - lookup_list)
    _write_u16(data, lookup_list + 6, lookup2 - lookup_list)

    # One format-2 subtable maps 1->2 and 2->5. A duplicate execution of this
    # lookup would therefore expose failed lookup-index deduplication.
    _write_u16(data, lookup0, 1)
    _write_u16(data, lookup0 + 2, 0)
    _write_u16(data, lookup0 + 4, 1)
    _write_u16(data, lookup0 + 6, 8)
    var single0 = lookup0 + 8
    _write_u16(data, single0, 2)
    _write_u16(data, single0 + 2, 10)
    _write_u16(data, single0 + 4, 2)
    _write_u16(data, single0 + 6, 2)
    _write_u16(data, single0 + 8, 5)
    _write_u16(data, single0 + 10, 1)
    _write_u16(data, single0 + 12, 2)
    _write_u16(data, single0 + 14, 1)
    _write_u16(data, single0 + 16, 2)

    for lookup, input_glyph, output_glyph in [
        (lookup1, 2, 3),
        (lookup2, 3, 4),
    ]:
        _write_u16(data, lookup, 1)
        _write_u16(data, lookup + 2, 0)
        _write_u16(data, lookup + 4, 1)
        _write_u16(data, lookup + 6, 8)
        _write_single2_coverage1(data, lookup + 8, input_glyph, output_glyph)
    return data^


def make_gsub_feature_variations() -> List[UInt8]:
    """Build GSUB 1.1 with an empty FeatureVariations 1.0 table."""
    var data = make_gsub_single_format1(version_1_1=True)
    var feature_variations = len(data)
    for _ in range(8):
        data.append(UInt8(0))
    _write_u32(data, 10, feature_variations)
    _write_u16(data, feature_variations, 1)
    _write_u16(data, feature_variations + 2, 0)
    _write_u32(data, feature_variations + 4, 0)
    return data^


def make_gsub_feature_variation_record() -> List[UInt8]:
    """Build one contained FeatureVariation record with a format-1 condition."""
    var data = make_gsub_single_format1(version_1_1=True)
    var feature_variations = len(data)
    comptime variations_length = 36
    for _ in range(variations_length):
        data.append(UInt8(0))
    _write_u32(data, 10, feature_variations)
    _write_u16(data, feature_variations, 1)
    _write_u16(data, feature_variations + 2, 0)
    _write_u32(data, feature_variations + 4, 1)
    # Offsets in a FeatureVariationRecord are relative to FeatureVariations.
    _write_u32(data, feature_variations + 8, 16)
    _write_u32(data, feature_variations + 12, 22)
    var condition_set = feature_variations + 16
    _write_u16(data, condition_set, 1)
    _write_u32(data, condition_set + 2, 12)
    var substitutions = feature_variations + 22
    _write_u16(data, substitutions, 1)
    _write_u16(data, substitutions + 2, 0)
    _write_u16(data, substitutions + 4, 0)
    var condition = feature_variations + 28
    _write_u16(data, condition, 1)
    _write_u16(data, condition + 2, 0)
    _write_u16(data, condition + 4, 0xC000)  # -1.0 in F2DOT14
    _write_u16(data, condition + 6, 0x4000)  # +1.0 in F2DOT14
    return data^


def make_gsub_selected_unsupported() -> List[UInt8]:
    """Build a selected locl lookup whose valid type is not implemented."""
    var data = make_gsub_single_format1()
    comptime lookup = 48
    _write_u16(data, lookup, 2)
    return data^


def make_gsub_mark_filtering_lookup() -> List[UInt8]:
    """Build a structurally complete GDEF-dependent mark-filtered lookup."""
    var original = make_gsub_single_format1()
    comptime lookup = 48
    comptime old_subtable = lookup + 8
    var data = List[UInt8](length=len(original) + 2, fill=UInt8(0))
    for index in range(old_subtable):
        data[index] = original[index]
    for index in range(old_subtable, len(original)):
        data[index + 2] = original[index]
    _write_u16(data, lookup + 2, 0x0010)
    _write_u16(data, lookup + 6, 10)
    _write_u16(data, lookup + 8, 0)  # markFilteringSet
    return data^


def make_gsub_shape_cjk_selection() -> List[UInt8]:
    """Constrain the full CJK selector's outputs to the six-glyph test face."""
    var data = make_gsub_cjk_selection()
    comptime lookup_children = 286
    comptime lookup_length = 22
    # Keep every language result distinct from DFLT where the six-glyph face
    # permits it, so a broken tag lookup cannot silently pass via fallback.
    var outputs: List[Int] = [2, 3, 4, 5, 1, 4, 5]
    for index in range(len(outputs)):
        _write_u16(
            data,
            lookup_children + lookup_length * index + 14,
            outputs[index],
        )
    return data^


def make_test_font_with_gsub(
    var gsub: List[UInt8], with_uvs: Bool = False
) -> List[UInt8]:
    """Embed caller-provided GSUB bytes in the deterministic six-glyph face."""
    var cmap = _make_cmap12_with_uvs() if with_uvs else _make_cmap12()
    return _make_test_font_from_cmap_and_gsub(cmap^, gsub^)


def make_test_gsub_font() -> List[UInt8]:
    """Build a face whose default locl maps cmap glyph 1 to glyph 2."""
    var gsub = make_gsub_single_format1()
    return make_test_font_with_gsub(gsub^)


def make_test_cjk_gsub_font() -> List[UInt8]:
    """Build a six-glyph face with distinct default/JAN/ZHS/ZHH locl forms."""
    var gsub = make_gsub_shape_cjk_selection()
    return make_test_font_with_gsub(gsub^)


def make_test_auto_cjk_gsub_font() -> List[UInt8]:
    """Build a face exposing distinct ``locl`` results for every auto tag."""
    var cmap = _make_cmap12_auto_cjk()
    var gsub = make_gsub_shape_cjk_selection()
    return _make_test_font_from_cmap_and_gsub(cmap^, gsub^)


def make_test_auto_cjk_unsupported_hani_font() -> List[UInt8]:
    """Build AUTO DFLT success followed by an unsupported ``hani`` plan."""
    var cmap = _make_cmap12_auto_cjk()
    var gsub = make_gsub_shape_cjk_selection()
    comptime lookup_children = 286
    comptime lookup_length = 22
    _write_u16(gsub, lookup_children + lookup_length, 2)
    return _make_test_font_from_cmap_and_gsub(cmap^, gsub^)


def make_test_font(format12: Bool = True) -> List[UInt8]:
    """Build a six-glyph font mapping ASCII and three CJK characters."""
    var cmap = _make_cmap12() if format12 else _make_cmap4()
    return _make_test_font_from_cmap(cmap^)


def make_test_uvs_font() -> List[UInt8]:
    """Build a format 12 face with default and non-default CJK UVSes."""
    var cmap = _make_cmap12_with_uvs()
    return _make_test_font_from_cmap(cmap^)


def make_test_mac_language_cmap_font() -> List[UInt8]:
    """Build a Unicode face retaining valid repeated Macintosh encodings."""
    var cmap = _make_cmap12_with_mac_language_records()
    return _make_test_font_from_cmap(cmap^)


def make_test_shared_cmap_subtable_font() -> List[UInt8]:
    """Build two supported encoding records sharing the same valid subtable."""
    var cmap = _make_shared_cmap12()
    return _make_test_font_from_cmap(cmap^)


def make_test_collection() -> List[UInt8]:
    """Build a two-face TTC: format 4 first and format 12 second."""
    var first = make_test_font(False)
    var second = make_test_font(True)
    comptime header_length = 20
    var first_offset = _align4(header_length)
    var second_offset = _align4(first_offset + len(first))
    var data = List[UInt8](length=second_offset + len(second), fill=UInt8(0))
    _write_u32(data, 0, 0x74746366)
    _write_u32(data, 4, 0x00010000)
    _write_u32(data, 8, 2)
    _write_u32(data, 12, first_offset)
    _write_u32(data, 16, second_offset)
    for index in range(len(first)):
        data[first_offset + index] = first[index]
    for index in range(len(second)):
        data[second_offset + index] = second[index]

    for face_offset in [first_offset, second_offset]:
        var table_count = _read_u16(data, face_offset + 4)
        for index in range(table_count):
            var field = face_offset + 12 + 16 * index + 8
            _write_u32(data, field, _read_u32(data, field) + face_offset)
    return data^


def make_duplicate_table_font() -> List[UInt8]:
    var data = make_test_font()
    _write_u32(data, 12 + 16, _read_u32(data, 12))
    return data^


def make_out_of_bounds_table_font() -> List[UInt8]:
    var data = make_test_font()
    _write_u32(data, 12 + 8, 0x7FFFFFF0)
    return data^


def make_truncated_cmap_font() -> List[UInt8]:
    var data = make_test_font()
    # cmap is the second record in the synthetic directory.
    var record = 12 + 16
    var cmap_offset = _read_u32(data, record + 8)
    _write_u32(data, cmap_offset + 16, 0x7FFFFFFF)
    return data^


def make_bad_metrics_font() -> List[UInt8]:
    var data = make_test_font()
    # hhea is the fifth record.
    var hhea_offset = _read_u32(data, 12 + 16 * 4 + 8)
    _write_u16(data, hhea_offset + 34, 7)
    return data^


def make_glyph_advance_overflow_font() -> List[UInt8]:
    """Build a valid face whose second mapped advance can overflow."""
    var data = make_test_font()
    # head, hhea, and hmtx are records four, five, and one respectively.
    var head_offset = _read_u32(data, 12 + 16 * 3 + 8)
    var hhea_offset = _read_u32(data, 12 + 16 * 4 + 8)
    var hmtx_offset = _read_u32(data, 12 + 8)
    _write_u16(data, head_offset + 18, 16)
    _write_i16(data, hhea_offset + 4, 0)
    _write_i16(data, hhea_offset + 6, 0)
    _write_i16(data, hhea_offset + 8, 0)
    _write_u16(data, hmtx_offset + 8, 0xFFFF)
    return data^


def _format4_layout(data: List[UInt8]) -> Tuple[Int, Int, Int, Int]:
    var cmap_offset = _read_u32(data, 12 + 16 + 8)
    var subtable = cmap_offset + _read_u32(data, cmap_offset + 8)
    var count = _read_u16(data, subtable + 6) // 2
    var end_codes = subtable + 14
    var start_codes = end_codes + 2 * count + 2
    var range_offsets = start_codes + 4 * count
    return (subtable, count, start_codes, range_offsets)


def make_bad_format4_reserved_pad_font() -> List[UInt8]:
    var data = make_test_font(False)
    var subtable, count, _, _ = _format4_layout(data)
    _write_u16(data, subtable + 14 + 2 * count, 1)
    return data^


def make_bad_format4_sentinel_font() -> List[UInt8]:
    var data = make_test_font(False)
    var _, count, start_codes, _ = _format4_layout(data)
    _write_u16(data, start_codes + 2 * (count - 1), 0xFFFE)
    return data^


def make_bad_format4_search_fields_font() -> List[UInt8]:
    var data = make_test_font(False)
    var subtable, _, _, _ = _format4_layout(data)
    _write_u16(data, subtable + 8, 4)
    return data^


def make_bad_format4_range_lower_bound_font() -> List[UInt8]:
    var data = make_test_font(False)
    var _, _, _, range_offsets = _format4_layout(data)
    _write_u16(data, range_offsets, 2)
    return data^


def make_incompatible_format4_encoding_font() -> List[UInt8]:
    var data = make_test_font(False)
    var cmap_offset = _read_u32(data, 12 + 16 + 8)
    # Windows full-repertoire encoding 10 requires format 12, not format 4.
    _write_u16(data, cmap_offset + 6, 10)
    return data^


def _format14_layout(data: List[UInt8]) -> Tuple[Int, Int]:
    var cmap_offset = _read_u32(data, 12 + 16 + 8)
    # The sorted Unicode variation encoding record is the first cmap record.
    var format14 = cmap_offset + _read_u32(data, cmap_offset + 8)
    return (cmap_offset, format14)


def make_bad_format14_platform_font() -> List[UInt8]:
    var data = make_test_uvs_font()
    var cmap_offset, _ = _format14_layout(data)
    _write_u16(data, cmap_offset + 4, 2)
    return data^


def make_bad_format14_encoding_font() -> List[UInt8]:
    var data = make_test_uvs_font()
    var cmap_offset, _ = _format14_layout(data)
    _write_u16(data, cmap_offset + 6, 4)
    return data^


def make_bad_format14_length_font() -> List[UInt8]:
    var data = make_test_uvs_font()
    var _, format14 = _format14_layout(data)
    _write_u32(data, format14 + 2, 0x7FFFFFFF)
    return data^


def make_bad_format14_selector_order_font() -> List[UInt8]:
    var data = make_test_uvs_font()
    var _, format14 = _format14_layout(data)
    _write_u24(data, format14 + 21, 0xE0100)
    return data^


def make_bad_format14_selector_font() -> List[UInt8]:
    var data = make_test_uvs_font()
    var _, format14 = _format14_layout(data)
    _write_u24(data, format14 + 10, 0x41)
    return data^


def make_bad_format14_child_offset_font() -> List[UInt8]:
    var data = make_test_uvs_font()
    var _, format14 = _format14_layout(data)
    _write_u32(data, format14 + 13, 82)
    return data^


def make_bad_format14_default_scalar_font() -> List[UInt8]:
    var data = make_test_uvs_font()
    var _, format14 = _format14_layout(data)
    var default_table = format14 + _read_u32(data, format14 + 13)
    _write_u24(data, default_table + 4, 0xD800)
    return data^


def make_bad_format14_non_default_glyph_font() -> List[UInt8]:
    var data = make_test_uvs_font()
    var _, format14 = _format14_layout(data)
    var non_default_table = format14 + _read_u32(data, format14 + 17)
    _write_u16(data, non_default_table + 7, 6)
    return data^


def make_bad_format14_partition_font() -> List[UInt8]:
    var data = make_test_uvs_font()
    var _, format14 = _format14_layout(data)
    var non_default_table = format14 + _read_u32(data, format14 + 17)
    _write_u24(data, non_default_table + 4, 0x65E5)
    return data^


def make_format14_only_font() -> List[UInt8]:
    var data = make_test_uvs_font()
    var cmap_offset, _ = _format14_layout(data)
    # Make the primary format 12 record a non-Unicode Macintosh mapping.
    _write_u16(data, cmap_offset + 12, 4)
    _write_u16(data, cmap_offset + 14, 0)
    return data^


def make_incompatible_format12_encoding6_font() -> List[UInt8]:
    var data = make_test_font(True)
    var cmap_offset = _read_u32(data, 12 + 16 + 8)
    _write_u16(data, cmap_offset + 4, 0)
    _write_u16(data, cmap_offset + 6, 6)
    return data^


def make_bad_cmap_encoding_order_font() -> List[UInt8]:
    var data = make_test_uvs_font()
    var cmap_offset, _ = _format14_layout(data)
    # Place 0/4 after 0/5; records sort first by platform, then encoding.
    _write_u16(data, cmap_offset + 12, 0)
    _write_u16(data, cmap_offset + 14, 4)
    return data^


def make_bad_format4_language_font() -> List[UInt8]:
    var data = make_test_font(False)
    var subtable, _, _, _ = _format4_layout(data)
    _write_u16(data, subtable + 4, 1)
    return data^


def make_bad_format12_language_font() -> List[UInt8]:
    var data = make_test_font(True)
    var cmap_offset = _read_u32(data, 12 + 16 + 8)
    var subtable = cmap_offset + _read_u32(data, cmap_offset + 8)
    _write_u32(data, subtable + 8, 1)
    return data^


def make_test_uvs_explicit_glyph_zero_font() -> List[UInt8]:
    var data = make_test_uvs_font()
    var _, format14 = _format14_layout(data)
    var non_default_table = format14 + _read_u32(data, format14 + 17)
    _write_u16(data, non_default_table + 12, 0)
    return data^


def make_test_uvs_empty_selector_font() -> List[UInt8]:
    var data = make_test_uvs_font()
    var _, format14 = _format14_layout(data)
    # OpenType permits both offsets to be zero; it is simply non-matching.
    _write_u32(data, format14 + 35, 0)
    return data^


def make_test_empty_format14_font() -> List[UInt8]:
    var data = make_test_uvs_font()
    var _, format14 = _format14_layout(data)
    _write_u32(data, format14 + 6, 0)
    return data^


def make_bad_cmap_subtable_before_records_font() -> List[UInt8]:
    var data = make_test_font(True)
    var cmap_offset = _read_u32(data, 12 + 16 + 8)
    _write_u32(data, cmap_offset + 8, 4)
    return data^


def make_bad_format14_default_count_font() -> List[UInt8]:
    var data = make_test_uvs_font()
    var _, format14 = _format14_layout(data)
    var default_table = format14 + _read_u32(data, format14 + 13)
    _write_u32(data, default_table, 0x10000)
    return data^


def make_bad_format14_non_default_count_font() -> List[UInt8]:
    var data = make_test_uvs_font()
    var _, format14 = _format14_layout(data)
    var non_default_table = format14 + _read_u32(data, format14 + 17)
    _write_u32(data, non_default_table, 0x10000)
    return data^


def make_test_uvs_max_default_range_font() -> List[UInt8]:
    var data = make_test_uvs_font()
    var _, format14 = _format14_layout(data)
    var default_table = format14 + _read_u32(data, format14 + 13)
    _write_u24(data, default_table + 4, 0x3400)
    data[default_table + 7] = UInt8(255)
    return data^


def make_bad_format14_selector_180e_font() -> List[UInt8]:
    var data = make_test_uvs_font()
    var _, format14 = _format14_layout(data)
    _write_u24(data, format14 + 10, 0x180E)
    return data^


def make_test_uvs_selector_180f_font() -> List[UInt8]:
    var data = make_test_uvs_font()
    var _, format14 = _format14_layout(data)
    _write_u24(data, format14 + 10, 0x180F)
    return data^
