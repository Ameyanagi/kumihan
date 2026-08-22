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


def make_test_font(format12: Bool = True) -> List[UInt8]:
    """Build a six-glyph font mapping ASCII and three CJK characters."""
    var cmap = _make_cmap12() if format12 else _make_cmap4()
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
