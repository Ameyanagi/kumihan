from std.collections import List
from std.testing import TestSuite, assert_equal, assert_raises

from kumihan.sfnt import FontCollection, FontFace, _parse_directory
from support.font_fixture import (
    make_bad_format4_range_lower_bound_font,
    make_bad_format4_reserved_pad_font,
    make_bad_format4_search_fields_font,
    make_bad_format4_sentinel_font,
    make_bad_metrics_font,
    make_duplicate_table_font,
    make_incompatible_format4_encoding_font,
    make_out_of_bounds_table_font,
    make_test_collection,
    make_test_font,
    make_truncated_cmap_font,
)


def _face_after_collection_scope() raises -> FontFace:
    var bytes = make_test_collection()
    var collection = FontCollection.from_bytes(bytes^)
    return collection.face(1)


def test_format12_cjk_lookup_and_metrics() raises:
    var bytes = make_test_font()
    var face = FontFace.from_bytes(bytes^)
    assert_equal(face.units_per_em(), 1000)
    assert_equal(face.ascender(), 800)
    assert_equal(face.descender(), -200)
    assert_equal(face.line_gap(), 100)
    assert_equal(face.glyph_count(), 6)
    assert_equal(face.glyph_id(ord("A")), 1)
    assert_equal(face.glyph_id(ord("日")), 2)
    assert_equal(face.glyph_id(ord("本")), 3)
    assert_equal(face.glyph_id(ord("語")), 4)
    assert_equal(face.glyph_id(0x20000), 5)
    assert_equal(face.glyph_id(ord("Z")), 0)
    assert_equal(face.glyph_id(-1), 0)
    assert_equal(face.glyph_id(0xD800), 0)
    assert_equal(face.glyph_id(0x110000), 0)

    assert_equal(face.advance_width(0), 500)
    assert_equal(face.advance_width(1), 600)
    assert_equal(face.advance_width(2), 1000)
    # Glyphs after numberOfHMetrics reuse the last long advance.
    assert_equal(face.advance_width(5), 1000)
    assert_equal(face.advance_width(-1), 0)
    assert_equal(face.advance_width(6), 0)


def test_format4_uses_binary_searched_bmp_segments() raises:
    var bytes = make_test_font(False)
    var face = FontFace.from_bytes(bytes^)
    assert_equal(face.glyph_id(ord("A")), 1)
    assert_equal(face.glyph_id(ord("日")), 2)
    assert_equal(face.glyph_id(ord("本")), 3)
    assert_equal(face.glyph_id(ord("語")), 4)
    assert_equal(face.glyph_id(0x20000), 0)


def test_ttc_face_selection() raises:
    var bytes = make_test_collection()
    var collection = FontCollection.from_bytes(bytes^)
    assert_equal(collection.face_count(), 2)

    var first = collection.face(0)
    assert_equal(first.glyph_id(ord("語")), 4)
    assert_equal(first.glyph_id(0x20000), 0)

    var second = collection.face(1)
    assert_equal(second.glyph_id(ord("語")), 4)
    assert_equal(second.glyph_id(0x20000), 5)

    with assert_raises(contains="face_index must be non-negative"):
        _ = collection.face(-1)
    with assert_raises(contains="face_index is out of range"):
        _ = collection.face(2)


def test_shared_face_outlives_collection_value() raises:
    var face = _face_after_collection_scope()
    assert_equal(face.glyph_id(ord("語")), 4)
    assert_equal(face.glyph_id(0x20000), 5)


def test_rejects_bad_face_indices_and_headers() raises:
    var single = make_test_font()
    with assert_raises(contains="face_index is out of range"):
        _ = FontFace.from_bytes(single^, face_index=1)
    var negative = make_test_font()
    with assert_raises(contains="face_index must be non-negative"):
        _ = FontFace.from_bytes(negative^, face_index=-1)
    var collection = make_test_collection()
    with assert_raises(contains="face_index is out of range"):
        _ = FontFace.from_bytes(collection^, face_index=2)
    var empty = List[UInt8]()
    with assert_raises(contains="truncated font header"):
        _ = FontFace.from_bytes(empty^)


def test_rejects_duplicate_and_out_of_bounds_tables() raises:
    var duplicate = make_duplicate_table_font()
    with assert_raises(contains="duplicate SFNT table"):
        _ = FontFace.from_bytes(duplicate^)
    var outside = make_out_of_bounds_table_font()
    with assert_raises(contains="truncated SFNT table"):
        _ = FontFace.from_bytes(outside^)


def test_rejects_malformed_cmap_and_metrics() raises:
    var cmap = make_truncated_cmap_font()
    with assert_raises(contains="invalid cmap format 12 length"):
        _ = FontFace.from_bytes(cmap^)
    var metrics = make_bad_metrics_font()
    with assert_raises(contains="invalid numberOfHMetrics"):
        _ = FontFace.from_bytes(metrics^)


def test_rejects_malformed_format4_structure() raises:
    var reserved = make_bad_format4_reserved_pad_font()
    with assert_raises(contains="invalid cmap format 4 reservedPad"):
        _ = FontFace.from_bytes(reserved^)

    var sentinel = make_bad_format4_sentinel_font()
    with assert_raises(contains="missing its sentinel segment"):
        _ = FontFace.from_bytes(sentinel^)

    var search = make_bad_format4_search_fields_font()
    with assert_raises(contains="invalid cmap format 4 search fields"):
        _ = FontFace.from_bytes(search^)

    var range_offset = make_bad_format4_range_lower_bound_font()
    with assert_raises(contains="idRangeOffset points before glyphIdArray"):
        _ = FontFace.from_bytes(range_offset^)


def test_rejects_incompatible_unicode_encoding_and_format() raises:
    var font = make_incompatible_format4_encoding_font()
    with assert_raises(contains="incompatible cmap platform, encoding, and format"):
        _ = FontFace.from_bytes(font^)


def test_reverse_sorted_large_directory_has_bounded_sorting_work() raises:
    comptime table_count = 4096
    var data = List[UInt8](length=12 + 16 * table_count, fill=UInt8(0))
    data[0] = 0x00
    data[1] = 0x01
    data[4] = UInt8((table_count >> 8) & 0xFF)
    data[5] = UInt8(table_count & 0xFF)
    for index in range(table_count):
        var tag = table_count - index
        var record = 12 + 16 * index
        data[record] = UInt8((tag >> 24) & 0xFF)
        data[record + 1] = UInt8((tag >> 16) & 0xFF)
        data[record + 2] = UInt8((tag >> 8) & 0xFF)
        data[record + 3] = UInt8(tag & 0xFF)

    var tables = _parse_directory(data, 0)
    assert_equal(len(tables), table_count)
    assert_equal(tables[0].tag, 1)
    assert_equal(tables[table_count - 1].tag, table_count)


def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
