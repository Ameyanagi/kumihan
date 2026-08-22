from std.collections import List
from std.testing import assert_equal, assert_true

from kumihan import (
    Direction,
    FontCollection,
    FontFace,
    GlyphRun,
    Language,
    ShapeBuffer,
    TextStyle,
    shape_nominal,
    shape_nominal_into,
)


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


def _make_cmap12() -> List[UInt8]:
    comptime group_count = 2
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

    _write_u32(data, 28, 0x41)
    _write_u32(data, 32, 0x41)
    _write_u32(data, 36, 1)
    _write_u32(data, 40, 0x65E5)
    _write_u32(data, 44, 0x65E5)
    _write_u32(data, 48, 2)
    return data^


def _make_test_font() -> List[UInt8]:
    var cmap = _make_cmap12()
    comptime table_count = 5
    comptime head_offset = 92
    comptime maxp_offset = 148
    comptime hhea_offset = 156
    comptime hmtx_offset = 192
    comptime cmap_offset = 204
    var data = List[UInt8](length=cmap_offset + len(cmap), fill=UInt8(0))

    _write_u32(data, 0, 0x00010000)
    _write_u16(data, 4, table_count)

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
    var lengths: List[Int] = [12, len(cmap), 6, 54, 36]
    for index in range(table_count):
        var record = 12 + 16 * index
        _write_u32(data, record, tags[index])
        _write_u32(data, record + 8, offsets[index])
        _write_u32(data, record + 12, lengths[index])

    _write_u32(data, head_offset, 0x00010000)
    _write_u32(data, head_offset + 12, 0x5F0F3CF5)
    _write_u16(data, head_offset + 18, 1000)

    _write_u32(data, maxp_offset, 0x00010000)
    _write_u16(data, maxp_offset + 4, 3)

    _write_u32(data, hhea_offset, 0x00010000)
    _write_i16(data, hhea_offset + 4, 800)
    _write_i16(data, hhea_offset + 6, -200)
    _write_i16(data, hhea_offset + 8, 100)
    _write_u16(data, hhea_offset + 34, 3)

    _write_u16(data, hmtx_offset, 500)
    _write_i16(data, hmtx_offset + 2, 0)
    _write_u16(data, hmtx_offset + 4, 600)
    _write_i16(data, hmtx_offset + 6, 0)
    _write_u16(data, hmtx_offset + 8, 1000)
    _write_i16(data, hmtx_offset + 10, 0)

    for index in range(len(cmap)):
        data[cmap_offset + index] = cmap[index]
    return data^


def main() raises:
    var bytes = _make_test_font()
    var collection = FontCollection.from_bytes(bytes^)
    assert_equal(collection.face_count(), 1)
    var face: FontFace = collection.face()
    assert_equal(face.glyph_id(ord("A")), 1)
    assert_equal(face.glyph_id(ord("日")), 2)

    var style = (
        TextStyle()
        .with_size(20.0)
        .with_language(Language.JA)
        .with_direction(Direction.LEFT_TO_RIGHT)
    )

    var run: GlyphRun = shape_nominal(face, "A日", style)
    assert_equal(len(run), 2)
    assert_equal(run.glyph_ids()[0], 1)
    assert_equal(run.glyph_ids()[1], 2)
    assert_equal(run.cluster_starts()[0], 0)
    assert_equal(run.cluster_ends()[1], 4)
    assert_true(run.x_advances()[0] == 12.0)
    assert_true(run.x_advances()[1] == 20.0)
    assert_true(run.total_x_advance() == 32.0)
    assert_equal(run.missing_glyph_count(), 0)
    run.validate_against_source("A日")

    var output = ShapeBuffer(capacity=2)
    shape_nominal_into(face, "日A", style, output)
    assert_equal(len(output), 2)
    assert_true(output.capacity() >= 2)
    assert_equal(output.glyph_ids()[0], 2)
    assert_equal(output.glyph_ids()[1], 1)
    assert_equal(output.cluster_starts()[0], 0)
    assert_equal(output.cluster_ends()[1], 4)
    assert_true(output.total_x_advance() == 32.0)
    output.validate_against_source("日A")
