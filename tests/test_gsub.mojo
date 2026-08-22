from std.collections import List
from std.testing import TestSuite, assert_equal, assert_raises, assert_true

from kumihan.gsub import Gsub, _parse_gsub
from support.font_fixture import (
    _write_u16,
    _write_u32,
    make_gsub_cjk_selection,
    make_gsub_coverage2_two_ranges,
    make_gsub_extension_shared_reverse,
    make_gsub_feature_variation_record,
    make_gsub_feature_variations,
    make_gsub_first_subtable_wins,
    make_gsub_mark_filtering_lookup,
    make_gsub_no_specific_default,
    make_gsub_order_dedup_chain,
    make_gsub_selected_unsupported,
    make_gsub_single_format1,
    make_gsub_single_format2_coverage2,
)


comptime _DFLT = 0x44464C54
comptime _dflt = 0x64666C74
comptime _BOPO = 0x626F706F
comptime _HANG = 0x68616E67
comptime _HANI = 0x68616E69
comptime _KANA = 0x6B616E61
comptime _JAN = 0x4A414E20
comptime _KOR = 0x4B4F5220
comptime _ZHH = 0x5A484820
comptime _ZHS = 0x5A485320
comptime _ZHT = 0x5A485420
comptime _VERT = 0x76657274
comptime _VRT2 = 0x76727432
comptime _VRTR = 0x76727472
comptime _VKNA = 0x766B6E61


def _prefix(data: List[UInt8], length: Int) -> List[UInt8]:
    var result = List[UInt8](length=length, fill=UInt8(0))
    for index in range(length):
        result[index] = data[index]
    return result^


def _assert_maps(
    data: List[UInt8],
    script_tag: Int,
    language_tag: Int,
    expected: Int,
) raises:
    var gsub = _parse_gsub(data, 0, len(data), 16)
    var glyphs: List[Int] = [1]
    var changed = gsub.apply_locl(data, glyphs, script_tag, language_tag)
    assert_equal(glyphs[0], expected)
    assert_equal(changed, expected != 1)


def test_single_subst_format1_coverage1_and_coverage2() raises:
    var direct = make_gsub_single_format1()
    var direct_gsub = _parse_gsub(direct, 0, len(direct), 8)
    var glyphs: List[Int] = [0, 1, 2]
    assert_true(direct_gsub.apply_locl(direct, glyphs, _DFLT, 0))
    assert_equal(glyphs[0], 0)
    assert_equal(glyphs[1], 2)
    assert_equal(glyphs[2], 2)

    var negative = make_gsub_single_format1(delta=-1, coverage_format=2)
    var negative_gsub = _parse_gsub(negative, 0, len(negative), 8)
    var negative_glyphs: List[Int] = [1]
    assert_true(negative_gsub.apply_locl(negative, negative_glyphs, _DFLT, 0))
    # Glyph zero is an explicit substitution, not absence.
    assert_equal(negative_glyphs[0], 0)

    var unchanged = make_gsub_single_format1(delta=0)
    var unchanged_gsub = _parse_gsub(unchanged, 0, len(unchanged), 8)
    var unchanged_glyphs: List[Int] = [1]
    assert_true(not unchanged_gsub.apply_locl(unchanged, unchanged_glyphs, _DFLT, 0))
    assert_equal(unchanged_glyphs[0], 1)


def test_single_subst_format1_uses_unsigned_modulo_delta() raises:
    # 65,534 + 3 wraps to glyph 1. numGlyphs may be at most 65,535.
    var data = make_gsub_single_format1(input_glyph=65534, delta=3)
    var gsub = _parse_gsub(data, 0, len(data), 65535)
    var glyphs: List[Int] = [65534]
    assert_true(gsub.apply_locl(data, glyphs, _DFLT, 0))
    assert_equal(glyphs[0], 1)


def test_single_subst_delta_validation_matches_scalar_oracle() raises:
    for glyph_count in [1, 8, 32768, 65535]:
        for delta in [-32768, -1, 0, 1, 32767]:
            var delta_mod = delta & 0xFFFF
            var invalid_start = (glyph_count - delta_mod) & 0xFFFF
            var invalid_end = (0xFFFF - delta_mod) & 0xFFFF
            var candidates = [
                0,
                glyph_count - 1,
                invalid_start,
                (invalid_start - 1) & 0xFFFF,
                (invalid_start + 1) & 0xFFFF,
                invalid_end,
                (invalid_end - 1) & 0xFFFF,
                (invalid_end + 1) & 0xFFFF,
            ]
            for input_glyph in candidates:
                if input_glyph >= glyph_count:
                    continue
                var expected = (input_glyph + delta) & 0xFFFF
                for coverage_format in [1, 2]:
                    var data = make_gsub_single_format1(
                        input_glyph=input_glyph,
                        delta=delta,
                        coverage_format=coverage_format,
                    )
                    if expected >= glyph_count:
                        with assert_raises(contains="GSUB substitution glyph ID"):
                            _ = _parse_gsub(data, 0, len(data), glyph_count)
                    else:
                        var gsub = _parse_gsub(data, 0, len(data), glyph_count)
                        var glyphs: List[Int] = [input_glyph]
                        var changed = gsub.apply_locl(data, glyphs, _DFLT, 0)
                        assert_equal(glyphs[0], expected)
                        assert_equal(changed, expected != input_glyph)


def test_single_subst_format2_coverage2_boundaries_gap_and_glyph_zero() raises:
    var range = make_gsub_single_format2_coverage2()
    var range_gsub = _parse_gsub(range, 0, len(range), 8)
    var range_glyphs: List[Int] = [0, 1, 2, 3, 4]
    assert_true(range_gsub.apply_locl(range, range_glyphs, _DFLT, 0))
    assert_equal(range_glyphs[0], 0)
    assert_equal(range_glyphs[1], 4)
    assert_equal(range_glyphs[2], 5)
    assert_equal(range_glyphs[3], 0)
    assert_equal(range_glyphs[4], 4)

    var gaps = make_gsub_coverage2_two_ranges()
    var gaps_gsub = _parse_gsub(gaps, 0, len(gaps), 8)
    var gap_glyphs: List[Int] = [1, 2, 3]
    assert_true(gaps_gsub.apply_locl(gaps, gap_glyphs, _DFLT, 0))
    assert_equal(gap_glyphs[0], 4)
    assert_equal(gap_glyphs[1], 2)
    assert_equal(gap_glyphs[2], 5)


def test_lookup_subtables_stop_after_the_first_match() raises:
    var data = make_gsub_first_subtable_wins()
    var gsub = _parse_gsub(data, 0, len(data), 8)
    var glyphs: List[Int] = [1]
    assert_true(gsub.apply_locl(data, glyphs, _DFLT, 0))
    assert_equal(glyphs[0], 2)


def test_extension_single_subst_accepts_shared_unaligned_reverse_children() raises:
    var data = make_gsub_extension_shared_reverse()
    var gsub = _parse_gsub(data, 0, len(data), 8)
    var glyphs: List[Int] = [1, 2]
    assert_true(gsub.apply_locl(data, glyphs, _DFLT, 0))
    assert_equal(glyphs[0], 5)
    assert_equal(glyphs[1], 2)


def test_exact_cjk_script_and_language_selection() raises:
    var data = make_gsub_cjk_selection()
    _assert_maps(data, _DFLT, 0, 2)  # required feature
    _assert_maps(data, _HANI, _JAN, 3)
    _assert_maps(data, _HANI, _ZHS, 4)
    _assert_maps(data, _HANI, _ZHH, 5)
    _assert_maps(data, _HANI, _ZHT, 6)
    _assert_maps(data, _HANG, _KOR, 7)
    _assert_maps(data, _KANA, _JAN, 3)
    _assert_maps(data, _BOPO, 0, 8)

    # An absent language uses the selected script's default LangSys. An
    # absent script uses DFLT, but an existing script without either requested
    # language or default must not fall through to DFLT.
    _assert_maps(data, _HANI, _KOR, 2)
    _assert_maps(data, _HANI, _dflt, 2)
    _assert_maps(data, 0x6C61746E, _JAN, 2)  # latn is absent
    var no_default = make_gsub_no_specific_default()
    _assert_maps(no_default, _HANI, _KOR, 1)


def test_required_lookup_order_deduplication_and_chaining() raises:
    var data = make_gsub_order_dedup_chain()
    var gsub = _parse_gsub(data, 0, len(data), 8)
    var glyphs: List[Int] = [1]
    assert_true(gsub.apply_locl(data, glyphs, _DFLT, 0))
    # Unique LookupList order 0,1,2 produces 1->2->3->4. Feature order would
    # produce another value, as would applying duplicate lookup zero twice.
    assert_equal(glyphs[0], 4)


def test_reusable_lookup_mask_resolves_feature_edges_once() raises:
    var data = make_gsub_cjk_selection()
    var gsub = _parse_gsub(data, 0, len(data), 16)
    var mask = List[UInt8](capacity=7)
    var features = List[Int](capacity=4)
    var glyphs: List[Int] = [1]

    assert_true(gsub.apply_locl_into(data, glyphs, _HANI, _JAN, mask, features))
    assert_equal(glyphs[0], 3)
    assert_equal(len(mask), 7)
    for index in range(7):
        assert_equal(mask[index], UInt8(1 if index == 1 else 0))
    var retained_capacity = mask.capacity()
    var first_feature = features[0]
    var retained_feature_capacity = features.capacity()

    glyphs[0] = 1
    assert_true(gsub.apply_locl_into(data, glyphs, _HANI, _ZHS, mask, features))
    assert_equal(glyphs[0], 4)
    assert_equal(mask.capacity(), retained_capacity)
    for index in range(7):
        assert_equal(mask[index], UInt8(1 if index == 2 else 0))
    assert_equal(len(features), 1)
    assert_true(features[0] != first_feature)
    assert_equal(features.capacity(), retained_feature_capacity)


def test_later_unsupported_lookup_preflight_is_transactional() raises:
    var data = make_gsub_order_dedup_chain()
    # Lookup zero is supported and would map 1->2. Lookup one is selected too,
    # but making it a valid unsupported type must fail before lookup zero runs.
    comptime lookup_one = 96
    _write_u16(data, lookup_one, 2)
    var gsub = _parse_gsub(data, 0, len(data), 8)
    var glyphs: List[Int] = [1]
    var mask = List[UInt8]()
    var features = List[Int]()
    with assert_raises(contains="unsupported selected GSUB lookup type"):
        _ = gsub.apply_locl_into(data, glyphs, _DFLT, 0, mask, features)
    assert_equal(glyphs[0], 1)
    assert_equal(len(mask), 0)
    assert_equal(len(features), 0)


def test_shared_physical_locl_is_gathered_but_traversed_once() raises:
    var data = make_gsub_order_dedup_chain()
    # Required feature zero and optional locl feature one alias one physical
    # Feature table. The scratch records both references for sorted dedup.
    _write_u16(data, 42, 14)
    var gsub = _parse_gsub(data, 0, len(data), 8)
    var glyphs: List[Int] = [1]
    var mask = List[UInt8]()
    var features = List[Int]()
    assert_true(not gsub.apply_locl_into(data, glyphs, _DFLT, 0, mask, features))
    assert_equal(len(features), 2)
    assert_equal(features[0], features[1])
    assert_equal(mask[0], UInt8(0))
    assert_equal(mask[1], UInt8(0))
    assert_equal(mask[2], UInt8(1))


def test_no_selected_features_skips_lookup_mask_fill() raises:
    var data = make_gsub_cjk_selection()
    # hani's default LangSys selects no features while the font still carries
    # a seven-entry LookupList.
    _write_u16(data, 120, 0xFFFF)  # no required feature
    _write_u16(data, 122, 0)  # no optional features
    var gsub = _parse_gsub(data, 0, len(data), 16)
    var glyphs: List[Int] = [1]
    var mask = List[UInt8](capacity=32)
    var features = List[Int](capacity=4)
    assert_true(not gsub.apply_locl_into(data, glyphs, _HANI, 0, mask, features))
    assert_equal(len(mask), 0)
    assert_equal(len(features), 0)
    assert_equal(glyphs[0], 1)


def test_unrelated_features_do_not_grow_selection_scratch() raises:
    var data = make_gsub_order_dedup_chain()
    _write_u16(data, 24, 0xFFFF)  # no required feature
    _write_u32(data, 38, 0x74657374)  # optional feature one is `test`
    var gsub = _parse_gsub(data, 0, len(data), 8)
    var glyphs: List[Int] = [1]
    var mask = List[UInt8]()
    var features = List[Int]()
    assert_true(not gsub.apply_locl_into(data, glyphs, _DFLT, 0, mask, features))
    assert_equal(len(mask), 0)
    assert_equal(len(features), 0)
    assert_equal(features.capacity(), 0)


def test_required_vertical_single_features_are_transactional() raises:
    for tag in [_VERT, _VRT2, _VRTR, _VKNA]:
        var data = make_gsub_single_format1()
        _write_u16(data, 24, 0)  # requiredFeatureIndex
        _write_u32(data, 32, tag)
        var gsub = _parse_gsub(data, 0, len(data), 8)
        var glyphs: List[Int] = [1]
        with assert_raises(contains="required GSUB vertical feature"):
            _ = gsub.apply_locl(data, glyphs, _DFLT, 0)
        assert_equal(glyphs[0], 1)


def test_gsub_1_1_uses_default_features_safely() raises:
    var zero = make_gsub_single_format1(version_1_1=True)
    _assert_maps(zero, _DFLT, 0, 2)
    var empty_feature_variations = make_gsub_feature_variations()
    _assert_maps(empty_feature_variations, _DFLT, 0, 2)
    var contained_feature_variation = make_gsub_feature_variation_record()
    _assert_maps(contained_feature_variation, _DFLT, 0, 2)


def test_feature_list_order_is_not_a_validation_or_execution_order() raises:
    var data = make_gsub_order_dedup_chain()
    # Feature records need not be tag-sorted. The second record remains locl,
    # while the first required feature is renamed to sort after it.
    _write_u32(data, 32, 0x7A7A7A7A)  # zzzz
    var gsub = _parse_gsub(data, 0, len(data), 8)
    var glyphs: List[Int] = [1]
    assert_true(gsub.apply_locl(data, glyphs, _DFLT, 0))
    assert_equal(glyphs[0], 4)


def test_shared_feature_still_checks_contextual_feature_params() raises:
    var data = make_gsub_order_dedup_chain()
    # Feature zero is first treated as a generic tag with parameters. Feature
    # one remains locl but aliases the same physical Feature table.
    _write_u32(data, 32, 0x74657374)  # test
    _write_u16(data, 44, 6)  # generic FeatureParams points past its header
    _write_u16(data, 42, 14)  # second Feature record aliases feature zero
    with assert_raises(contains="FeatureParams must be zero"):
        _ = _parse_gsub(data, 0, len(data), 8)


def test_distinct_single_substs_may_share_one_coverage() raises:
    var data = make_gsub_first_subtable_wins()
    comptime first_single = 58
    comptime second_single = 72
    comptime shared_coverage = 80
    for single, delta in [(first_single, 1), (second_single, 2)]:
        _write_u16(data, single, 1)
        _write_u16(data, single + 2, shared_coverage - single)
        _write_u16(data, single + 4, delta)
    var gsub = _parse_gsub(data, 0, len(data), 8)
    var glyphs: List[Int] = [1]
    assert_true(gsub.apply_locl(data, glyphs, _DFLT, 0))
    assert_equal(glyphs[0], 2)  # first matching subtable still wins


def test_absent_gsub_is_an_allocation_free_noop() raises:
    var gsub = Gsub.absent(8)
    var data = List[UInt8]()
    var glyphs: List[Int] = [1, 0, 7]
    assert_true(not gsub.apply_locl(data, glyphs, _HANI, _JAN))
    assert_equal(glyphs[0], 1)
    assert_equal(glyphs[1], 0)
    assert_equal(glyphs[2], 7)


def test_lookup_flags_accept_rtl_but_preflight_gdef_dependent_filters() raises:
    comptime lookup_flags = 50
    var rtl = make_gsub_single_format1()
    _write_u16(rtl, lookup_flags, 0x0001)
    _assert_maps(rtl, _DFLT, 0, 2)

    for flag in [0x0002, 0x0004, 0x0008, 0x0100]:
        var filtered = make_gsub_single_format1()
        _write_u16(filtered, lookup_flags, flag)
        var gsub = _parse_gsub(filtered, 0, len(filtered), 8)
        var glyphs: List[Int] = [1]
        with assert_raises(contains="unsupported GDEF filtering"):
            _ = gsub.apply_locl(filtered, glyphs, _DFLT, 0)
        assert_equal(glyphs[0], 1)

    var mark_filtering = make_gsub_mark_filtering_lookup()
    var mark_gsub = _parse_gsub(mark_filtering, 0, len(mark_filtering), 8)
    var mark_glyphs: List[Int] = [1]
    with assert_raises(contains="unsupported GDEF filtering"):
        _ = mark_gsub.apply_locl(mark_filtering, mark_glyphs, _DFLT, 0)
    assert_equal(mark_glyphs[0], 1)


def test_selected_unsupported_is_transactional_and_empty_lookup_is_noop() raises:
    var unsupported = make_gsub_selected_unsupported()
    var gsub = _parse_gsub(unsupported, 0, len(unsupported), 8)
    var unselected: List[Int] = [1]
    with assert_raises(contains="unsupported selected GSUB lookup type"):
        _ = gsub.apply_locl(unsupported, unselected, _DFLT, 0)
    assert_equal(unselected[0], 1)

    var empty = make_gsub_single_format1()
    _write_u16(empty, 52, 0)  # Lookup.subTableCount
    var empty_gsub = _parse_gsub(empty, 0, len(empty), 8)
    var glyphs: List[Int] = [1]
    assert_true(not empty_gsub.apply_locl(empty, glyphs, _DFLT, 0))
    assert_equal(glyphs[0], 1)

    var empty_coverage = make_gsub_single_format1()
    _write_u16(empty_coverage, 64, 0)  # Coverage.glyphCount
    var empty_coverage_gsub = _parse_gsub(empty_coverage, 0, len(empty_coverage), 8)
    assert_true(not empty_coverage_gsub.apply_locl(empty_coverage, glyphs, _DFLT, 0))
    assert_equal(glyphs[0], 1)


def test_rejects_bad_gsub_headers_offsets_and_tags() raises:
    var base = make_gsub_single_format1()
    var truncated = _prefix(base, 3)
    with assert_raises(contains="truncated GSUB"):
        _ = _parse_gsub(truncated, 0, len(truncated), 8)

    var version = make_gsub_single_format1()
    _write_u16(version, 2, 2)
    with assert_raises(contains="invalid GSUB version"):
        _ = _parse_gsub(version, 0, len(version), 8)

    var offset = make_gsub_single_format1()
    _write_u16(offset, 4, 0)
    with assert_raises(contains="invalid GSUB ScriptList offset"):
        _ = _parse_gsub(offset, 0, len(offset), 8)

    var script_tag = make_gsub_single_format1()
    _write_u32(script_tag, 12, 0x44462054)  # internal padding: "DF T"
    with assert_raises(contains="invalid GSUB script tag"):
        _ = _parse_gsub(script_tag, 0, len(script_tag), 8)

    var feature_tag = make_gsub_single_format1()
    _write_u32(feature_tag, 32, 0x6C6F206C)  # internal padding: "lo l"
    with assert_raises(contains="invalid GSUB feature tag"):
        _ = _parse_gsub(feature_tag, 0, len(feature_tag), 8)

    var leading_space = make_gsub_single_format1()
    _write_u32(leading_space, 12, 0x2044464C)  # " DFL"
    with assert_raises(contains="invalid GSUB script tag"):
        _ = _parse_gsub(leading_space, 0, len(leading_space), 8)

    var trailing_spaces = make_gsub_single_format1()
    _write_u32(trailing_spaces, 12, 0x44462020)  # "DF  " is canonical
    _ = _parse_gsub(trailing_spaces, 0, len(trailing_spaces), 8)


def test_rejects_script_and_langsys_ordering_defaults_and_indices() raises:
    var script_order = make_gsub_cjk_selection()
    _write_u32(script_order, 18, _DFLT)
    with assert_raises(contains="unsorted or duplicate GSUB script tags"):
        _ = _parse_gsub(script_order, 0, len(script_order), 16)

    var language_order = make_gsub_cjk_selection()
    _write_u32(language_order, 100, _JAN)
    with assert_raises(contains="unsorted or duplicate GSUB language tags"):
        _ = _parse_gsub(language_order, 0, len(language_order), 16)

    var reserved_language = make_gsub_cjk_selection()
    _write_u32(reserved_language, 94, _DFLT)
    with assert_raises(contains="reserved GSUB LangSys tag"):
        _ = _parse_gsub(reserved_language, 0, len(reserved_language), 16)

    var missing_default = make_gsub_cjk_selection()
    _write_u16(missing_default, 42, 0)
    with assert_raises(contains="DFLT Script requires a default LangSys"):
        _ = _parse_gsub(missing_default, 0, len(missing_default), 16)

    var lookup_order = make_gsub_single_format1()
    _write_u16(lookup_order, 22, 1)
    with assert_raises(contains="GSUB LangSys lookupOrder"):
        _ = _parse_gsub(lookup_order, 0, len(lookup_order), 8)

    var required_feature = make_gsub_single_format1()
    _write_u16(required_feature, 24, 1)
    with assert_raises(contains="GSUB feature index"):
        _ = _parse_gsub(required_feature, 0, len(required_feature), 8)

    var optional_feature = make_gsub_single_format1()
    _write_u16(optional_feature, 28, 1)
    with assert_raises(contains="GSUB feature index"):
        _ = _parse_gsub(optional_feature, 0, len(optional_feature), 8)

    var lookup_index = make_gsub_single_format1()
    _write_u16(lookup_index, 42, 1)
    with assert_raises(contains="GSUB lookup index"):
        _ = _parse_gsub(lookup_index, 0, len(lookup_index), 8)


def test_rejects_lookup_headers_flags_and_offsets() raises:
    var lookup_type = make_gsub_single_format1()
    _write_u16(lookup_type, 48, 9)
    with assert_raises(contains="GSUB lookup type"):
        _ = _parse_gsub(lookup_type, 0, len(lookup_type), 8)

    var flags = make_gsub_single_format1()
    _write_u16(flags, 50, 0x0020)
    with assert_raises(contains="invalid GSUB lookup flags"):
        _ = _parse_gsub(flags, 0, len(flags), 8)

    var subtable_offset = make_gsub_single_format1()
    _write_u16(subtable_offset, 54, 0)
    with assert_raises(contains="invalid GSUB lookup subtable offset"):
        _ = _parse_gsub(subtable_offset, 0, len(subtable_offset), 8)

    var filtering = make_gsub_single_format1()
    _write_u16(filtering, 50, 0x0010)
    var missing_filtering_set = _prefix(filtering, 56)
    with assert_raises(contains="GSUB mark filtering set"):
        _ = _parse_gsub(missing_filtering_set, 0, len(missing_filtering_set), 8)

    var feature_params = make_gsub_single_format1()
    _write_u16(feature_params, 38, 6)
    with assert_raises(contains="FeatureParams must be zero"):
        _ = _parse_gsub(feature_params, 0, len(feature_params), 8)

    for tag in [_VERT, _VRT2, _VRTR, _VKNA]:
        var vertical_params = make_gsub_single_format1()
        _write_u32(vertical_params, 32, tag)
        _write_u16(vertical_params, 38, 6)
        with assert_raises(contains="FeatureParams must be zero"):
            _ = _parse_gsub(vertical_params, 0, len(vertical_params), 8)

    var unrelated_params = make_gsub_single_format1()
    _write_u32(unrelated_params, 32, 0x74657374)  # test
    _write_u16(unrelated_params, 38, 6)
    _ = _parse_gsub(unrelated_params, 0, len(unrelated_params), 8)


def test_rejects_malformed_coverage_tables() raises:
    var duplicate = make_gsub_order_dedup_chain()
    # Lookup zero's Coverage format 1 glyph array is [1, 2].
    _write_u16(duplicate, 92, 1)
    with assert_raises(contains="GSUB coverage"):
        _ = _parse_gsub(duplicate, 0, len(duplicate), 8)

    var bad_format = make_gsub_single_format2_coverage2()
    _write_u16(bad_format, 68, 3)
    with assert_raises(contains="GSUB coverage format"):
        _ = _parse_gsub(bad_format, 0, len(bad_format), 8)

    var reversed_range = make_gsub_single_format2_coverage2()
    _write_u16(reversed_range, 72, 4)
    with assert_raises(contains="GSUB coverage range"):
        _ = _parse_gsub(reversed_range, 0, len(reversed_range), 8)

    var bad_start_index = make_gsub_single_format2_coverage2()
    _write_u16(bad_start_index, 76, 1)
    with assert_raises(contains="GSUB coverage start index"):
        _ = _parse_gsub(bad_start_index, 0, len(bad_start_index), 8)

    var overlap = make_gsub_coverage2_two_ranges()
    _write_u16(overlap, 76, 1)
    with assert_raises(contains="GSUB coverage range"):
        _ = _parse_gsub(overlap, 0, len(overlap), 8)

    var noncontiguous = make_gsub_coverage2_two_ranges()
    _write_u16(noncontiguous, 80, 2)
    with assert_raises(contains="GSUB coverage start index"):
        _ = _parse_gsub(noncontiguous, 0, len(noncontiguous), 8)

    var glyph = make_gsub_single_format1(input_glyph=8)
    with assert_raises(contains="GSUB coverage glyph ID"):
        _ = _parse_gsub(glyph, 0, len(glyph), 8)


def test_rejects_malformed_single_substitutions() raises:
    var format = make_gsub_single_format1()
    _write_u16(format, 56, 3)
    with assert_raises(contains="GSUB SingleSubst format"):
        _ = _parse_gsub(format, 0, len(format), 8)

    var delta_output = make_gsub_single_format1(input_glyph=5, delta=1)
    with assert_raises(contains="GSUB substitution glyph ID"):
        _ = _parse_gsub(delta_output, 0, len(delta_output), 6)

    var count = make_gsub_single_format2_coverage2()
    _write_u16(count, 60, 2)
    with assert_raises(contains="coverage and substitute counts"):
        _ = _parse_gsub(count, 0, len(count), 8)

    var output = make_gsub_single_format2_coverage2()
    _write_u16(output, 62, 8)
    with assert_raises(contains="GSUB substitution glyph ID"):
        _ = _parse_gsub(output, 0, len(output), 8)


def test_rejects_malformed_extension_substitutions() raises:
    comptime early_wrapper = 58
    comptime late_wrapper = 67
    var format = make_gsub_extension_shared_reverse()
    _write_u16(format, early_wrapper, 2)
    with assert_raises(contains="GSUB ExtensionSubst format"):
        _ = _parse_gsub(format, 0, len(format), 8)

    var recursive = make_gsub_extension_shared_reverse()
    _write_u16(recursive, early_wrapper + 2, 7)
    with assert_raises(contains="GSUB extension lookup type"):
        _ = _parse_gsub(recursive, 0, len(recursive), 8)

    var mixed = make_gsub_extension_shared_reverse()
    _write_u16(mixed, late_wrapper + 2, 2)
    with assert_raises(contains="GSUB ExtensionSubst lookup types"):
        _ = _parse_gsub(mixed, 0, len(mixed), 8)

    var offset = make_gsub_extension_shared_reverse()
    _write_u32(offset, late_wrapper + 4, 0x7FFFFFFF)
    with assert_raises(contains="GSUB extension subtable"):
        _ = _parse_gsub(offset, 0, len(offset), 8)


def test_rejects_malformed_feature_variations_metadata() raises:
    var offset = make_gsub_single_format1(version_1_1=True)
    _write_u32(offset, 10, len(offset) + 1)
    with assert_raises(contains="GSUB FeatureVariations"):
        _ = _parse_gsub(offset, 0, len(offset), 8)

    var version = make_gsub_feature_variations()
    var feature_variations = len(version) - 8
    _write_u16(version, feature_variations, 2)
    with assert_raises(contains="GSUB FeatureVariations"):
        _ = _parse_gsub(version, 0, len(version), 8)

    var records = make_gsub_feature_variations()
    feature_variations = len(records) - 8
    _write_u32(records, feature_variations + 4, 1)
    with assert_raises(contains="GSUB FeatureVariations"):
        _ = _parse_gsub(records, 0, len(records), 8)

    var condition_zero = make_gsub_feature_variation_record()
    feature_variations = len(condition_zero) - 36
    _write_u32(condition_zero, feature_variations + 8, 0)
    _assert_maps(condition_zero, _DFLT, 0, 2)

    var condition_oob = make_gsub_feature_variation_record()
    feature_variations = len(condition_oob) - 36
    _write_u32(condition_oob, feature_variations + 8, 0x7FFFFFFF)
    with assert_raises(contains="GSUB ConditionSet offset"):
        _ = _parse_gsub(condition_oob, 0, len(condition_oob), 8)

    var substitution_zero = make_gsub_feature_variation_record()
    feature_variations = len(substitution_zero) - 36
    _write_u32(substitution_zero, feature_variations + 12, 0)
    _assert_maps(substitution_zero, _DFLT, 0, 2)

    var substitution_oob = make_gsub_feature_variation_record()
    feature_variations = len(substitution_oob) - 36
    _write_u32(substitution_oob, feature_variations + 12, 0x7FFFFFFF)
    with assert_raises(contains="GSUB FeatureTableSubstitution offset"):
        _ = _parse_gsub(substitution_oob, 0, len(substitution_oob), 8)


def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
