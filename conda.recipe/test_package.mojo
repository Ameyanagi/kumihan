from std.collections import List
from std.testing import assert_equal, assert_true

from kumihan import (
    Direction,
    FontCollection,
    FontFace,
    GlyphRun,
    Language,
    Script,
    ShapeBuffer,
    TextStyle,
    shape,
    shape_into,
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


def _write_u24(mut data: List[UInt8], offset: Int, value: Int):
    data[offset] = UInt8((value >> 16) & 0xFF)
    data[offset + 1] = UInt8((value >> 8) & 0xFF)
    data[offset + 2] = UInt8(value & 0xFF)


def _make_cmap12() -> List[UInt8]:
    comptime group_count = 2
    comptime subtable_length = 16 + 12 * group_count
    comptime cmap_header_length = 20
    comptime format14_length = 30
    var data = List[UInt8](
        length=cmap_header_length + subtable_length + format14_length,
        fill=UInt8(0),
    )
    _write_u16(data, 0, 0)
    _write_u16(data, 2, 2)
    _write_u16(data, 4, 0)
    _write_u16(data, 6, 5)
    _write_u32(data, 8, cmap_header_length + subtable_length)
    _write_u16(data, 12, 3)
    _write_u16(data, 14, 10)
    _write_u32(data, 16, cmap_header_length)

    var format12 = cmap_header_length
    _write_u16(data, format12, 12)
    _write_u16(data, format12 + 2, 0)
    _write_u32(data, format12 + 4, subtable_length)
    _write_u32(data, format12 + 8, 0)
    _write_u32(data, format12 + 12, group_count)

    _write_u32(data, format12 + 16, 0x41)
    _write_u32(data, format12 + 20, 0x41)
    _write_u32(data, format12 + 24, 1)
    _write_u32(data, format12 + 28, 0x65E5)
    _write_u32(data, format12 + 32, 0x65E5)
    _write_u32(data, format12 + 36, 2)

    var format14 = cmap_header_length + subtable_length
    _write_u16(data, format14, 14)
    _write_u32(data, format14 + 2, format14_length)
    _write_u32(data, format14 + 6, 1)
    _write_u24(data, format14 + 10, 0xE0100)
    _write_u32(data, format14 + 13, 0)
    _write_u32(data, format14 + 17, 21)
    _write_u32(data, format14 + 21, 1)
    _write_u24(data, format14 + 25, 0x65E5)
    _write_u16(data, format14 + 28, 1)
    return data^


def _make_gsub() -> List[UInt8]:
    """Build DFLT/locl SingleSubst mappings 1->2 and 2->1."""
    var data = List[UInt8](length=74, fill=UInt8(0))
    _write_u16(data, 0, 1)
    _write_u16(data, 2, 0)
    _write_u16(data, 4, 10)
    _write_u16(data, 6, 30)
    _write_u16(data, 8, 44)

    # ScriptList: DFLT with one DefaultLangSys selecting feature zero.
    _write_u16(data, 10, 1)
    _write_u32(data, 12, 0x44464C54)
    _write_u16(data, 16, 8)
    _write_u16(data, 18, 4)
    _write_u16(data, 20, 0)
    _write_u16(data, 22, 0)
    _write_u16(data, 24, 0xFFFF)
    _write_u16(data, 26, 1)
    _write_u16(data, 28, 0)

    # FeatureList: locl -> lookup zero.
    _write_u16(data, 30, 1)
    _write_u32(data, 32, 0x6C6F636C)
    _write_u16(data, 36, 8)
    _write_u16(data, 38, 0)
    _write_u16(data, 40, 1)
    _write_u16(data, 42, 0)

    # LookupList: SingleSubst format 2 with Coverage format 1.
    _write_u16(data, 44, 1)
    _write_u16(data, 46, 4)
    _write_u16(data, 48, 1)
    _write_u16(data, 50, 0)
    _write_u16(data, 52, 1)
    _write_u16(data, 54, 8)
    _write_u16(data, 56, 2)
    _write_u16(data, 58, 10)
    _write_u16(data, 60, 2)
    _write_u16(data, 62, 2)
    _write_u16(data, 64, 1)
    _write_u16(data, 66, 1)
    _write_u16(data, 68, 2)
    _write_u16(data, 70, 1)
    _write_u16(data, 72, 2)
    return data^


def _make_test_font() -> List[UInt8]:
    var cmap = _make_cmap12()
    var gsub = _make_gsub()
    comptime table_count = 6
    comptime head_offset = 108
    comptime maxp_offset = 164
    comptime hhea_offset = 172
    comptime hmtx_offset = 208
    comptime cmap_offset = 220
    comptime gsub_offset = 312
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
    var lengths: List[Int] = [12, len(cmap), 6, 54, 36, len(gsub)]
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
    for index in range(len(gsub)):
        data[gsub_offset + index] = gsub[index]
    return data^


def main() raises:
    var bytes = _make_test_font()
    var collection = FontCollection.from_bytes(bytes^)
    assert_equal(collection.face_count(), 1)
    var face: FontFace = collection.face()
    assert_equal(face.glyph_id(ord("A")), 1)
    assert_equal(face.glyph_id(ord("日")), 2)
    var variation = face.variation_glyph_id(ord("日"), 0xE0100)
    assert_true(variation)
    assert_equal(variation.value(), 1)

    var style = (
        TextStyle()
        .with_size(20.0)
        .with_language(Language.JA)
        .with_script(Script.HAN)
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

    var localized: GlyphRun = shape(face, "A日", style)
    assert_equal(localized.glyph_ids()[0], 2)
    assert_equal(localized.glyph_ids()[1], 1)
    assert_true(localized.x_advances()[0] == 20.0)
    assert_true(localized.x_advances()[1] == 12.0)
    assert_true(localized.script() == Script.HAN)
    localized.validate_against_source("A日")

    var automatic_style = (
        TextStyle()
        .with_size(20.0)
        .with_language(Language.JA)
        .with_direction(Direction.LEFT_TO_RIGHT)
    )
    var automatic: GlyphRun = shape(face, "A日", automatic_style)
    assert_equal(automatic.glyph_ids()[0], 2)
    assert_equal(automatic.glyph_ids()[1], 1)
    assert_true(automatic.script() == Script.AUTO)
    automatic.validate_against_source("A日")

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

    var ivs = String("日")
    ivs += chr(0xE0100)
    shape_nominal_into(face, ivs, style, output)
    assert_equal(len(output), 1)
    assert_equal(output.glyph_ids()[0], 1)
    assert_equal(output.cluster_starts()[0], 0)
    assert_equal(output.cluster_ends()[0], ivs.byte_length())
    assert_true(output.total_x_advance() == 12.0)
    output.validate_against_source(ivs)

    shape_into(face, ivs, style, output)
    assert_equal(output.glyph_ids()[0], 2)
    assert_equal(output.cluster_ends()[0], ivs.byte_length())
    assert_true(output.total_x_advance() == 20.0)
    output.validate_against_source(ivs)
