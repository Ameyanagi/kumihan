from kumihan.sfnt import FontFace
from kumihan.shape import GlyphRun, ShapeBuffer, shape_nominal, shape_nominal_into
from kumihan.style import Direction, Language, TextStyle
from std.testing import TestSuite, assert_equal, assert_raises, assert_true

from support.font_fixture import make_glyph_advance_overflow_font, make_test_font


def _test_face() raises -> FontFace:
    var bytes = make_test_font()
    return FontFace.from_bytes(bytes^)


def test_nominal_language_tags_and_directions_are_explicit() raises:
    assert_equal(Language.UND.tag(), "und")
    assert_equal(Language.ZH_HANS.tag(), "zh-Hans")
    assert_equal(Language.ZH_HANT.tag(), "zh-Hant")
    assert_equal(Language.ZH_HANT_HK.bcp47_tag(), "zh-Hant-HK")
    assert_equal(Language.JA.tag(), "ja")
    assert_equal(Language.KO.tag(), "ko")
    assert_equal(Language.ZH_HANS.open_type_tag(), "ZHS ")
    assert_equal(Language.ZH_HANT.open_type_tag(), "ZHT ")
    assert_equal(Language.ZH_HANT_HK.open_type_tag(), "ZHH ")
    assert_true(Language.from_bcp47("ZH-hAnT-hK") == Language.ZH_HANT_HK)
    with assert_raises(contains="unsupported Kumihan BCP-47 language tag"):
        _ = Language.from_bcp47("zh-HK")
    assert_true(Direction.LEFT_TO_RIGHT.is_horizontal())
    assert_true(Direction.RIGHT_TO_LEFT.is_horizontal())
    assert_true(not Direction.TOP_TO_BOTTOM.is_horizontal())
    assert_true(Direction.LEFT_TO_RIGHT.is_left_to_right())


def test_text_style_chain_returns_copies() raises:
    var original = TextStyle()
    var styled = (
        original.with_size(20.0)
        .with_language(Language.JA)
        .with_direction(Direction.LEFT_TO_RIGHT)
    )

    assert_true(original.size() == 16.0)
    assert_true(original.language() == Language.UND)
    assert_true(original.direction() == Direction.LEFT_TO_RIGHT)
    assert_true(styled.size() == 20.0)
    assert_true(styled.language() == Language.JA)
    assert_true(styled.direction() == Direction.LEFT_TO_RIGHT)


def test_text_style_rejects_invalid_values() raises:
    var style = TextStyle()
    with assert_raises(contains="text size must be finite and positive"):
        _ = style.with_size(0.0)
    with assert_raises(contains="text size must be finite and positive"):
        _ = style.with_size(Float64("inf"))
    with assert_raises(contains="invalid Kumihan language discriminant"):
        _ = style.with_language(Language(_value=99))
    with assert_raises(contains="invalid Kumihan direction discriminant"):
        _ = style.with_direction(Direction(_value=-1))


def test_shape_nominal_maps_cjk_once_and_preserves_utf8_clusters() raises:
    var face = _test_face()
    var style = TextStyle().with_size(20.0).with_language(Language.JA)
    var run = shape_nominal(face, "A日本語𠀀", style)

    assert_true(len(run) == 5)
    assert_true(run.source_byte_length() == 14)
    assert_true(run.language() == Language.JA)
    assert_true(run.direction() == Direction.LEFT_TO_RIGHT)
    assert_true(run.font_size() == 20.0)
    assert_true(run.missing_glyph_count() == 0)

    var glyphs = run.glyph_ids()
    var starts = run.cluster_starts()
    var ends = run.cluster_ends()
    var advances = run.x_advances()
    var y_advances = run.y_advances()
    var x_offsets = run.x_offsets()
    var y_offsets = run.y_offsets()
    var expected_starts = [0, 1, 4, 7, 10]
    var expected_ends = [1, 4, 7, 10, 14]
    for index in range(5):
        assert_true(glyphs[index] == index + 1)
        assert_true(starts[index] == expected_starts[index])
        assert_true(ends[index] == expected_ends[index])
        assert_true(y_advances[index] == 0.0)
        assert_true(x_offsets[index] == 0.0)
        assert_true(y_offsets[index] == 0.0)
    assert_true(advances[0] == 12.0)
    for index in range(1, 5):
        assert_true(advances[index] == 20.0)
    assert_true(run.total_x_advance() == 92.0)
    assert_true(run.ascender() == 16.0)
    assert_true(run.descender() == -4.0)
    assert_true(run.line_gap() == 2.0)
    run.validate()
    run.validate_against_source("A日本語𠀀")


def test_shape_nominal_handles_empty_and_missing_text() raises:
    var face = _test_face()
    var empty = shape_nominal(face, "", TextStyle())
    assert_true(empty.is_empty())
    assert_true(empty.source_byte_length() == 0)
    assert_true(empty.total_x_advance() == 0.0)
    empty.validate()

    var missing = shape_nominal(face, "B", TextStyle())
    assert_true(len(missing) == 1)
    assert_true(missing.glyph_ids()[0] == 0)
    assert_true(missing.missing_glyph_count() == 1)
    assert_true(missing.cluster_starts()[0] == 0)
    assert_true(missing.cluster_ends()[0] == 1)


def test_shape_nominal_rejects_unimplemented_directions() raises:
    var face = _test_face()
    with assert_raises(contains="only horizontal left-to-right"):
        _ = shape_nominal(
            face,
            "日本語",
            TextStyle().with_direction(Direction.RIGHT_TO_LEFT),
        )


def test_shape_nominal_into_reuses_all_output_capacity() raises:
    var face = _test_face()
    var output = ShapeBuffer(capacity=16)
    shape_nominal_into(face, "A日本語𠀀", TextStyle(), output)
    var retained_capacity = output.capacity()
    assert_true(retained_capacity >= 16)
    assert_true(len(output) == 5)
    output.validate_against_source("A日本語𠀀")

    shape_nominal_into(
        face, "A", TextStyle().with_language(Language.ZH_HANT_HK), output
    )
    assert_true(len(output) == 1)
    assert_true(output.capacity() == retained_capacity)
    assert_true(output.glyph_ids()[0] == 1)
    assert_true(output.language() == Language.ZH_HANT_HK)
    output.validate_against_source("A")

    output.clear()
    assert_true(output.is_empty())
    assert_true(output.capacity() == retained_capacity)
    output.validate_against_source("")


def test_shaping_rejects_scaled_metric_and_total_advance_overflow() raises:
    var bad_metrics_face = _test_face()
    bad_metrics_face._ascender = 32767
    with assert_raises(contains="text size overflows scaled ascender"):
        _ = shape_nominal(
            bad_metrics_face,
            "A",
            TextStyle().with_size(Float64.MAX_FINITE),
        )

    var face = _test_face()
    var output = ShapeBuffer(capacity=4)
    shape_nominal_into(face, "A", TextStyle(), output)
    var retained_capacity = output.capacity()
    with assert_raises(contains="total horizontal advance"):
        shape_nominal_into(
            face,
            "AA",
            TextStyle().with_size(Float64.MAX_FINITE),
            output,
        )
    assert_true(output.is_empty())
    assert_true(output.capacity() == retained_capacity)

    var overflow_bytes = make_glyph_advance_overflow_font()
    var overflow_face = FontFace.from_bytes(overflow_bytes^)
    shape_nominal_into(overflow_face, "A日", TextStyle(), output)
    with assert_raises(contains="scaled glyph advance"):
        shape_nominal_into(
            overflow_face,
            "A日",
            TextStyle().with_size(Float64.MAX_FINITE / 1000.0),
            output,
        )
    assert_true(output.is_empty())
    assert_true(output.capacity() == retained_capacity)

    with assert_raises(contains="too small to scale"):
        _ = shape_nominal(
            face,
            "A",
            TextStyle().with_size(Float64("5e-324")),
        )
    with assert_raises(contains="only horizontal left-to-right"):
        _ = shape_nominal(
            face,
            "日本語",
            TextStyle().with_direction(Direction.TOP_TO_BOTTOM),
        )


def test_glyph_run_validation_catches_parallel_array_and_cluster_corruption() raises:
    var face = _test_face()
    var bad_length = shape_nominal(face, "日本", TextStyle())
    _ = bad_length._buffer._x_offsets.pop()
    with assert_raises(contains="structure-of-arrays lengths do not match"):
        bad_length.validate()

    var bad_cluster = shape_nominal(face, "日本", TextStyle())
    bad_cluster._buffer._cluster_starts[1] = -1
    with assert_raises(contains="invalid source byte cluster"):
        bad_cluster.validate()


def test_source_validation_detects_utf8_interior_cluster_boundaries() raises:
    var face = _test_face()
    var run = shape_nominal(face, "日本", TextStyle())
    run._buffer._cluster_starts[1] = 2
    # Numeric range validation cannot claim knowledge of an unowned source.
    run.validate()
    with assert_raises(contains="not bounded by UTF-8 boundaries"):
        run.validate_against_source("日本")
    with assert_raises(contains="source byte length does not match"):
        run.validate_against_source("日本語")


def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
