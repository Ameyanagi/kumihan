from std.testing import TestSuite, assert_equal, assert_raises, assert_true

from kumihan.sfnt import FontFace
from support.font_fixture import (
    make_bad_cmap_subtable_before_records_font,
    make_bad_format14_child_offset_font,
    make_bad_cmap_encoding_order_font,
    make_bad_format14_default_count_font,
    make_bad_format14_default_scalar_font,
    make_bad_format14_encoding_font,
    make_bad_format14_length_font,
    make_bad_format14_non_default_glyph_font,
    make_bad_format14_non_default_count_font,
    make_bad_format14_partition_font,
    make_bad_format14_platform_font,
    make_bad_format14_selector_font,
    make_bad_format14_selector_180e_font,
    make_bad_format14_selector_order_font,
    make_bad_format12_language_font,
    make_bad_format4_language_font,
    make_format14_only_font,
    make_incompatible_format12_encoding6_font,
    make_test_empty_format14_font,
    make_test_mac_language_cmap_font,
    make_test_shared_cmap_subtable_font,
    make_test_uvs_empty_selector_font,
    make_test_uvs_explicit_glyph_zero_font,
    make_test_uvs_font,
    make_test_uvs_max_default_range_font,
    make_test_uvs_selector_180f_font,
)


def test_default_and_non_default_cjk_variation_lookup() raises:
    var bytes = make_test_uvs_font()
    var face = FontFace.from_bytes(bytes^)

    # The nominal hot path remains independent of format 14.
    assert_equal(face.glyph_id(0x65E5), 2)
    assert_equal(face.glyph_id(0x672C), 3)

    var default_variant = face.variation_glyph_id(0x65E5, 0xE0100)
    assert_true(default_variant)
    assert_equal(default_variant.value(), 2)

    var non_default_variant = face.variation_glyph_id(0x672C, 0xE0100)
    assert_true(non_default_variant)
    assert_equal(non_default_variant.value(), 5)

    # Exercise first, middle, and last non-default binary-search hits. These
    # mappings need not have corresponding nominal Unicode mappings.
    var first_mapping = face.variation_glyph_id(0x4E8C, 0xE0100)
    assert_true(first_mapping)
    assert_equal(first_mapping.value(), 1)
    var sequence_only = face.variation_glyph_id(0x9AA8, 0xE0100)
    assert_true(sequence_only)
    assert_equal(sequence_only.value(), 4)


def test_shared_reverse_ordered_unaligned_uvs_children() raises:
    var bytes = make_test_uvs_font()
    var face = FontFace.from_bytes(bytes^)

    var explicit_variant = face.variation_glyph_id(0x65E5, 0xE0101)
    assert_true(explicit_variant)
    assert_equal(explicit_variant.value(), 4)

    # E0102 aliases E0100's exact unaligned default child-table offset.
    var shared_default = face.variation_glyph_id(0x65E5, 0xE0102)
    assert_true(shared_default)
    assert_equal(shared_default.value(), 2)


def test_maximum_default_range_boundaries_and_gap_lookup() raises:
    var bytes = make_test_uvs_max_default_range_font()
    var face = FontFace.from_bytes(bytes^)

    var first = face.variation_glyph_id(0x3400, 0xE0100)
    var last = face.variation_glyph_id(0x34FF, 0xE0100)
    assert_true(first)
    assert_true(last)
    assert_equal(first.value(), 0)
    assert_equal(last.value(), 0)
    assert_true(not face.variation_glyph_id(0x3500, 0xE0100))
    var after_gap = face.variation_glyph_id(0x65E5, 0xE0100)
    assert_true(after_gap)
    assert_equal(after_gap.value(), 2)


def test_mongolian_selector_hole_and_boundary() raises:
    var valid_bytes = make_test_uvs_selector_180f_font()
    var face = FontFace.from_bytes(valid_bytes^)
    var variant = face.variation_glyph_id(0x672C, 0x180F)
    assert_true(variant)
    assert_equal(variant.value(), 5)

    var invalid_bytes = make_bad_format14_selector_180e_font()
    with assert_raises(contains="invalid variation selector"):
        _ = FontFace.from_bytes(invalid_bytes^)


def test_unsupported_and_default_missing_sequences_stay_distinct() raises:
    var bytes = make_test_uvs_font()
    var face = FontFace.from_bytes(bytes^)

    # A supported default UVS may resolve to nominal glyph zero.
    var supported_missing = face.variation_glyph_id(0x4E00, 0xE0100)
    assert_true(supported_missing)
    assert_equal(supported_missing.value(), 0)

    assert_true(not face.variation_glyph_id(0x8A9E, 0xE0100))
    assert_true(not face.variation_glyph_id(0x65E5, 0xE0103))
    assert_true(not face.variation_glyph_id(0xD800, 0xE0100))
    assert_true(not face.variation_glyph_id(0x65E5, 0x41))

    var explicit_zero_bytes = make_test_uvs_explicit_glyph_zero_font()
    var explicit_zero_face = FontFace.from_bytes(explicit_zero_bytes^)
    var explicit_zero = explicit_zero_face.variation_glyph_id(0x672C, 0xE0100)
    assert_true(explicit_zero)
    assert_equal(explicit_zero.value(), 0)


def test_empty_format14_and_selector_records_are_accepted() raises:
    var empty_selector_bytes = make_test_uvs_empty_selector_font()
    var empty_selector_face = FontFace.from_bytes(empty_selector_bytes^)
    assert_true(not empty_selector_face.variation_glyph_id(0x65E5, 0xE0102))
    assert_equal(empty_selector_face.glyph_id(0x65E5), 2)

    var empty_format14_bytes = make_test_empty_format14_font()
    var empty_format14_face = FontFace.from_bytes(empty_format14_bytes^)
    assert_true(not empty_format14_face.variation_glyph_id(0x65E5, 0xE0100))
    assert_equal(empty_format14_face.glyph_id(0x65E5), 2)


def test_format14_requires_exact_unicode_encoding_pair() raises:
    var platform = make_bad_format14_platform_font()
    with assert_raises(contains="cmap format 14 requires platform 0 encoding 5"):
        _ = FontFace.from_bytes(platform^)

    var encoding = make_bad_format14_encoding_font()
    with assert_raises(contains="cmap format 14 requires platform 0 encoding 5"):
        _ = FontFace.from_bytes(encoding^)

    var encoding6 = make_incompatible_format12_encoding6_font()
    with assert_raises(contains="incompatible cmap platform, encoding, and format"):
        _ = FontFace.from_bytes(encoding6^)


def test_format14_never_replaces_the_primary_unicode_cmap() raises:
    var bytes = make_format14_only_font()
    with assert_raises(contains="font has no supported Unicode cmap"):
        _ = FontFace.from_bytes(bytes^)


def test_unicode_cmap_records_and_language_fields_are_canonical() raises:
    var records = make_bad_cmap_encoding_order_font()
    with assert_raises(contains="unsorted cmap encoding records"):
        _ = FontFace.from_bytes(records^)

    var format4 = make_bad_format4_language_font()
    with assert_raises(contains="Unicode cmap format 4 language must be zero"):
        _ = FontFace.from_bytes(format4^)

    var format12 = make_bad_format12_language_font()
    with assert_raises(contains="Unicode cmap format 12 language must be zero"):
        _ = FontFace.from_bytes(format12^)


def test_repeated_macintosh_encoding_records_can_differ_by_language() raises:
    var bytes = make_test_mac_language_cmap_font()
    var face = FontFace.from_bytes(bytes^)
    assert_equal(face.glyph_id(0x65E5), 2)
    assert_equal(face.glyph_id(0x20000), 5)


def test_cmap_subtables_follow_records_and_may_be_shared() raises:
    var before_records = make_bad_cmap_subtable_before_records_font()
    with assert_raises(contains="cmap subtable offset is out of bounds"):
        _ = FontFace.from_bytes(before_records^)

    var shared_bytes = make_test_shared_cmap_subtable_font()
    var shared_face = FontFace.from_bytes(shared_bytes^)
    assert_equal(shared_face.glyph_id(0x65E5), 2)
    assert_equal(shared_face.glyph_id(0x20000), 5)


def test_rejects_malformed_format14_header_and_selectors() raises:
    var length = make_bad_format14_length_font()
    with assert_raises(contains="invalid cmap format 14 length"):
        _ = FontFace.from_bytes(length^)

    var order = make_bad_format14_selector_order_font()
    with assert_raises(contains="unsorted or duplicate cmap format 14"):
        _ = FontFace.from_bytes(order^)

    var selector = make_bad_format14_selector_font()
    with assert_raises(contains="invalid variation selector"):
        _ = FontFace.from_bytes(selector^)


def test_rejects_malformed_format14_children() raises:
    var child_offset = make_bad_format14_child_offset_font()
    with assert_raises(contains="default UVS offset is out of bounds"):
        _ = FontFace.from_bytes(child_offset^)

    var default_count = make_bad_format14_default_count_font()
    with assert_raises(contains="truncated cmap format 14 default UVS ranges"):
        _ = FontFace.from_bytes(default_count^)

    var non_default_count = make_bad_format14_non_default_count_font()
    with assert_raises(contains="truncated cmap format 14 non-default UVS mappings"):
        _ = FontFace.from_bytes(non_default_count^)

    var scalar = make_bad_format14_default_scalar_font()
    with assert_raises(contains="default UVS contains a non-scalar value"):
        _ = FontFace.from_bytes(scalar^)

    var glyph = make_bad_format14_non_default_glyph_font()
    with assert_raises(contains="non-default glyph ID is out of range"):
        _ = FontFace.from_bytes(glyph^)

    var partition = make_bad_format14_partition_font()
    with assert_raises(contains="base is both default and non-default"):
        _ = FontFace.from_bytes(partition^)


def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
