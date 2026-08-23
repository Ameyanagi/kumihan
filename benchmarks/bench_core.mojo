"""AOT distribution benchmark for cached cmap lookup and shaping."""

from kumihan import (
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
from std.benchmark import keep
from std.collections import List
from std.sys import argv
from std.time import perf_counter_ns

from support.font_fixture import (
    make_gsub_single_format1,
    make_gsub_single_format2_coverage2,
    make_test_collection,
    make_test_auto_cjk_gsub_font,
    make_test_cjk_gsub_font,
    make_test_font,
    make_test_font_with_gsub,
    make_test_uvs_font,
)


comptime _MEASUREMENTS = 31
comptime _WARMUP_ROUNDS = 3
comptime _LOOKUP_SAMPLE_BUDGET = 1 << 20
comptime _VARIATION_QUERY_COUNT = 1 << 16
comptime _VARIATION_SAMPLE_BUDGET = 1 << 20
comptime _SHAPE_SAMPLE_BUDGET = 1 << 16
comptime _GSUB_SAMPLE_BUDGET = 1 << 15
comptime _CONSTRUCTION_OPERATIONS = 4096
comptime _PROFILE_SCALARS = 4096
comptime _PROFILE_ITERATIONS = 8192
comptime _PROFILE_IVS_SEQUENCES = 2048


def _sort(mut values: List[Int]):
    # The fixed 31-sample set keeps benchmark-local insertion sort negligible.
    for index in range(1, len(values)):
        var value = values[index]
        var position = index
        while position > 0 and values[position - 1] > value:
            values[position] = values[position - 1]
            position -= 1
        values[position] = value


def _percentiles(mut elapsed: List[Int]) -> Tuple[Int, Int]:
    _sort(elapsed)
    return (
        elapsed[_MEASUREMENTS // 2],
        elapsed[(_MEASUREMENTS * 95 + 99) // 100 - 1],
    )


def _codepoint(index: Int) -> Int:
    # Hits and misses cover ASCII, BMP CJK, supplementary CJK, and Korean.
    var position = index % 9
    if position == 0:
        return 0x41  # A: mapped ASCII
    if position == 1:
        return 0x7A  # z: unmapped ASCII
    if position == 2:
        return 0x65E5  # 日
    if position == 3:
        return 0x672C  # 本
    if position == 4:
        return 0x8A9E  # 語
    if position == 5:
        return 0x20000  # 𠀀: mapped supplementary CJK
    if position == 6:
        return 0x4E2D  # 中: unmapped CJK
    if position == 7:
        return 0xD55C  # 한: unmapped Hangul
    return 0x39  # 9: unmapped ASCII digit


def _codepoints(count: Int) -> List[Int]:
    var values = List[Int](capacity=count)
    for index in range(count):
        values.append(_codepoint(index))
    return values^


def _mixed_text(scalar_count: Int) -> String:
    var text = String()
    for index in range(scalar_count):
        var position = index % 9
        if position == 0:
            text += "A"
        elif position == 1:
            text += "z"
        elif position == 2:
            text += "日"
        elif position == 3:
            text += "本"
        elif position == 4:
            text += "語"
        elif position == 5:
            text += "𠀀"
        elif position == 6:
            text += "中"
        elif position == 7:
            text += "한"
        else:
            text += "9"
    return text^


def _ivs_text(sequence_count: Int) -> String:
    """Build equal supported-default, explicit, and unsupported CJK IVSes."""
    var text = String()
    for index in range(sequence_count):
        var position = index % 3
        if position == 0:
            text += "日"  # Supported default mapping to nominal glyph 2.
        elif position == 1:
            text += "本"  # Supported explicit mapping to glyph 5.
        else:
            text += "語"  # Unsupported UVS; preserve nominal glyph 4.
        text += chr(0xE0100)
    return text^


def _gsub_text(table_case: Int, scalar_count: Int) -> String:
    """Build all-hit text for the benchmark's two synthetic GSUB tables."""
    var text = String()
    for index in range(scalar_count):
        if table_case == 0:
            text += "A"  # cmap glyph 1; format 1 maps it to glyph 2.
        else:
            var position = index % 3
            if position == 0:
                text += "A"  # glyph 1 -> glyph 4
            elif position == 1:
                text += "日"  # glyph 2 -> glyph 5
            else:
                text += "本"  # glyph 3 -> glyph zero
    return text^


def _auto_cjk_text(scalar_count: Int) -> String:
    """Build alternating DFLT, Han, Kana, Hangul, and Bopomofo text."""
    var text = String()
    for index in range(scalar_count):
        var position = index % 6
        if position == 0:
            text += "A"
        elif position == 1:
            text += "日"
        elif position == 2:
            text += "あ"
        elif position == 3:
            text += "ア"
        elif position == 4:
            text += "한"
        else:
            text += "ㄅ"
    return text^


def _han_text(scalar_count: Int) -> String:
    """Build homogeneous Han text for AUTO-versus-explicit isolation."""
    var text = String()
    for _ in range(scalar_count):
        text += "日"
    return text^


def _ivs_locl_text(sequence_count: Int) -> String:
    """Build explicit CJK IVSes whose glyph 5 result is localized to glyph 1."""
    var text = String()
    for _ in range(sequence_count):
        text += "本"
        text += chr(0xE0100)
    return text^


def _lookup_checksum(face: FontFace, codepoints: List[Int]) -> Int:
    var checksum = 0
    for index in range(len(codepoints)):
        # Include the position as well as the mapped glyph to catch reordering.
        checksum += (index + 1) * (face.glyph_id(codepoints[index]) + 1)
    return checksum


def _variation_codepoints(category: Int, count: Int) -> List[Int]:
    var values = List[Int](capacity=count)
    for index in range(count):
        var position = index % 3
        if category == 0:
            # All are supported default UVSes; U+4E00 deliberately maps to
            # glyph zero and proves Optional presence remains observable.
            values.append(0x65E5 if position != 2 else 0x4E00)
        elif category == 1:
            if position == 0:
                values.append(0x672C)
            elif position == 1:
                values.append(0x9AA8)
            else:
                values.append(0x65E5)
        else:
            if position == 0:
                values.append(0x8A9E)
            elif position == 1:
                values.append(0x65E5)
            else:
                values.append(0x41)
    return values^


def _variation_selectors(category: Int, count: Int) -> List[Int]:
    var values = List[Int](capacity=count)
    for index in range(count):
        var position = index % 3
        if category == 0:
            values.append(0xE0102 if position == 1 else 0xE0100)
        elif category == 1:
            values.append(0xE0101 if position == 2 else 0xE0100)
        else:
            values.append(0xE0103 if position == 1 else 0xE0100)
    return values^


def _variation_checksum(
    face: FontFace, codepoints: List[Int], selectors: List[Int]
) -> Int:
    var checksum = 0
    for index in range(len(codepoints)):
        var glyph = face.variation_glyph_id(codepoints[index], selectors[index])
        if glyph:
            # Adding one distinguishes a supported glyph-zero UVS from None.
            checksum += (index + 1) * (glyph.value() + 1)
    return checksum


def _shape_checksum(run: GlyphRun) -> Int:
    # Consume each public semantic output array, not object identity or capacity.
    var checksum = run.source_byte_length() + 17 * run.missing_glyph_count()
    var glyphs = run.glyph_ids()
    var starts = run.cluster_starts()
    var ends = run.cluster_ends()
    var advances = run.x_advances()
    for index in range(len(run)):
        checksum += (
            (index + 1) * (glyphs[index] + 1)
            + 3 * starts[index]
            + 5 * ends[index]
            + 7 * Int(advances[index] * 1000.0)
        )
    return checksum


def _shape_buffer_checksum(buffer: ShapeBuffer) -> Int:
    var checksum = buffer.source_byte_length() + 17 * buffer.missing_glyph_count()
    var glyphs = buffer.glyph_ids()
    var starts = buffer.cluster_starts()
    var ends = buffer.cluster_ends()
    var advances = buffer.x_advances()
    for index in range(len(buffer)):
        checksum += (
            (index + 1) * (glyphs[index] + 1)
            + 3 * starts[index]
            + 5 * ends[index]
            + 7 * Int(advances[index] * 1000.0)
        )
    return checksum


def _face_checksum(face: FontFace) -> Int:
    return (
        face.units_per_em()
        + 3 * face.ascender()
        + 5 * face.descender()
        + 7 * face.line_gap()
        + 11 * face.glyph_count()
        + 13 * face.glyph_id(0x41)
        + 17 * face.glyph_id(0x65E5)
        + 19 * face.glyph_id(0x20000)
    )


def _font_inputs(template: List[UInt8], count: Int) -> List[List[UInt8]]:
    """Prepare owned inputs outside the construction timing region."""
    var inputs = List[List[UInt8]](capacity=count)
    for _ in range(count):
        inputs.append(template.copy())
    return inputs^


def _measure_face_construction(template: List[UInt8]) raises:
    var initial = template.copy()
    var face = FontFace.from_bytes(initial^)
    var expected = _face_checksum(face)

    for _ in range(_WARMUP_ROUNDS):
        var inputs = _font_inputs(template, _CONSTRUCTION_OPERATIONS)
        for _ in range(_CONSTRUCTION_OPERATIONS):
            var data = inputs.pop()
            face = FontFace.from_bytes(data^)
            keep(face)
        if _face_checksum(face) != expected:
            raise Error("font construction checksum changed during warmup")

    var elapsed = List[Int](capacity=_MEASUREMENTS)
    var measured_checksum = 0
    for _ in range(_MEASUREMENTS):
        # Fixture generation and byte copying are deliberately outside timing.
        var inputs = _font_inputs(template, _CONSTRUCTION_OPERATIONS)
        var started = perf_counter_ns()
        for _ in range(_CONSTRUCTION_OPERATIONS):
            var data = inputs.pop()
            face = FontFace.from_bytes(data^)
            keep(face)
        elapsed.append(perf_counter_ns() - started)
        measured_checksum = _face_checksum(face)
        if measured_checksum != expected:
            raise Error("font construction checksum changed")

    var percentiles = _percentiles(elapsed)
    print(
        "case=font_face_construction_synthetic input_bytes=",
        len(template),
        " constructions=",
        _CONSTRUCTION_OPERATIONS,
        " input_preparation=excluded p50_elapsed_ns=",
        percentiles[0],
        " p95_elapsed_ns=",
        percentiles[1],
        " p50_ns_per_construction=",
        Float64(percentiles[0]) / Float64(_CONSTRUCTION_OPERATIONS),
        " p95_ns_per_construction=",
        Float64(percentiles[1]) / Float64(_CONSTRUCTION_OPERATIONS),
        " p50_constructions_per_second=",
        Float64(_CONSTRUCTION_OPERATIONS) * 1.0e9 / Float64(percentiles[0]),
        " checksum=",
        measured_checksum,
        sep="",
    )


def _measure_ttc_shared_faces(var collection: FontCollection) raises:
    var first = collection.face(0)
    var second = collection.face(1)
    var expected = 23 * _face_checksum(first) + 29 * _face_checksum(second)

    for _ in range(_WARMUP_ROUNDS):
        for _ in range(_CONSTRUCTION_OPERATIONS):
            first = collection.face(0)
            second = collection.face(1)
            keep(first)
            keep(second)
        var checksum = 23 * _face_checksum(first) + 29 * _face_checksum(second)
        if checksum != expected:
            raise Error("shared TTC face checksum changed during warmup")

    var elapsed = List[Int](capacity=_MEASUREMENTS)
    var measured_checksum = 0
    for _ in range(_MEASUREMENTS):
        var started = perf_counter_ns()
        for _ in range(_CONSTRUCTION_OPERATIONS):
            first = collection.face(0)
            second = collection.face(1)
            keep(first)
            keep(second)
        elapsed.append(perf_counter_ns() - started)
        measured_checksum = 23 * _face_checksum(first) + 29 * _face_checksum(second)
        if measured_checksum != expected:
            raise Error("shared TTC face checksum changed")

    var percentiles = _percentiles(elapsed)
    var faces = 2 * _CONSTRUCTION_OPERATIONS
    print(
        "case=ttc_shared_two_face_construction_synthetic face_pairs=",
        _CONSTRUCTION_OPERATIONS,
        " faces=",
        faces,
        " collection_construction=excluded backing_bytes=shared ",
        "p50_elapsed_ns=",
        percentiles[0],
        " p95_elapsed_ns=",
        percentiles[1],
        " p50_ns_per_face=",
        Float64(percentiles[0]) / Float64(faces),
        " p95_ns_per_face=",
        Float64(percentiles[1]) / Float64(faces),
        " p50_faces_per_second=",
        Float64(faces) * 1.0e9 / Float64(percentiles[0]),
        " checksum=",
        measured_checksum,
        sep="",
    )


def _measure_lookup(face: FontFace, count: Int) raises:
    var codepoints = _codepoints(count)
    var iterations = max(1, _LOOKUP_SAMPLE_BUDGET // count)
    var expected = _lookup_checksum(face, codepoints)

    for _ in range(_WARMUP_ROUNDS):
        var checksum = 0
        for _ in range(iterations):
            checksum += _lookup_checksum(face, codepoints)
        keep(checksum)
        if checksum != expected * iterations:
            raise Error("cached cmap benchmark checksum changed during warmup")

    var elapsed = List[Int](capacity=_MEASUREMENTS)
    var measured_checksum = 0
    for _ in range(_MEASUREMENTS):
        var checksum = 0
        var started = perf_counter_ns()
        for _ in range(iterations):
            checksum += _lookup_checksum(face, codepoints)
        elapsed.append(perf_counter_ns() - started)
        keep(checksum)
        if checksum != expected * iterations:
            raise Error("cached cmap benchmark checksum changed")
        measured_checksum = checksum

    var percentiles = _percentiles(elapsed)
    var operations = count * iterations
    print(
        "case=cached_cmap_lookup scalars=",
        count,
        " iterations=",
        iterations,
        " scalar_operations=",
        operations,
        " p50_elapsed_ns=",
        percentiles[0],
        " p95_elapsed_ns=",
        percentiles[1],
        " p50_ns_per_scalar=",
        Float64(percentiles[0]) / Float64(operations),
        " p95_ns_per_scalar=",
        Float64(percentiles[1]) / Float64(operations),
        " p50_million_scalars_per_second=",
        Float64(operations) * 1000.0 / Float64(percentiles[0]),
        " checksum=",
        measured_checksum,
        sep="",
    )


def _measure_variation_lookup(face: FontFace, category: Int, identity: String) raises:
    var codepoints = _variation_codepoints(category, _VARIATION_QUERY_COUNT)
    var selectors = _variation_selectors(category, _VARIATION_QUERY_COUNT)
    var iterations = _VARIATION_SAMPLE_BUDGET // _VARIATION_QUERY_COUNT
    var expected = _variation_checksum(face, codepoints, selectors)

    for _ in range(_WARMUP_ROUNDS):
        var checksum = 0
        for _ in range(iterations):
            checksum += _variation_checksum(face, codepoints, selectors)
        keep(checksum)
        if checksum != expected * iterations:
            raise Error("cmap14 variation checksum changed during warmup")

    var elapsed = List[Int](capacity=_MEASUREMENTS)
    var measured_checksum = 0
    for _ in range(_MEASUREMENTS):
        var checksum = 0
        var started = perf_counter_ns()
        for _ in range(iterations):
            checksum += _variation_checksum(face, codepoints, selectors)
        elapsed.append(perf_counter_ns() - started)
        keep(checksum)
        if checksum != expected * iterations:
            raise Error("cmap14 variation checksum changed")
        measured_checksum = checksum

    var percentiles = _percentiles(elapsed)
    var operations = _VARIATION_QUERY_COUNT * iterations
    print(
        "case=cached_cmap14_",
        identity,
        " queries=",
        _VARIATION_QUERY_COUNT,
        " iterations=",
        iterations,
        " variation_operations=",
        operations,
        " p50_elapsed_ns=",
        percentiles[0],
        " p95_elapsed_ns=",
        percentiles[1],
        " p50_ns_per_variation=",
        Float64(percentiles[0]) / Float64(operations),
        " p95_ns_per_variation=",
        Float64(percentiles[1]) / Float64(operations),
        " p50_million_variations_per_second=",
        Float64(operations) * 1000.0 / Float64(percentiles[0]),
        " checksum=",
        measured_checksum,
        sep="",
    )


def _measure_shape_paths(face: FontFace, scalar_count: Int) raises:
    var text = _mixed_text(scalar_count)
    var style = TextStyle().with_size(16.0).with_language(Language.JA)
    var iterations = max(1, _SHAPE_SAMPLE_BUDGET // scalar_count)
    var run = shape_nominal(face, text, style)
    var expected = _shape_checksum(run)
    var buffer = ShapeBuffer(capacity=scalar_count)
    shape_nominal_into(face, text, style, buffer)
    if _shape_buffer_checksum(buffer) != expected:
        raise Error("allocating and reusable nominal shaping checksums differ")

    for _ in range(_WARMUP_ROUNDS):
        for _ in range(iterations):
            run = shape_nominal(face, text, style)
            keep(run)
        for _ in range(iterations):
            shape_nominal_into(face, text, style, buffer)
            keep(buffer)
        if _shape_checksum(run) != expected:
            raise Error("allocating shaping checksum changed during warmup")
        if _shape_buffer_checksum(buffer) != expected:
            raise Error("reusable shaping checksum changed during warmup")

    var allocating_elapsed = List[Int](capacity=_MEASUREMENTS)
    var reusable_elapsed = List[Int](capacity=_MEASUREMENTS)
    for sample in range(_MEASUREMENTS):
        if sample % 2 == 0:
            var started = perf_counter_ns()
            for _ in range(iterations):
                run = shape_nominal(face, text, style)
                keep(run)
            allocating_elapsed.append(perf_counter_ns() - started)

            started = perf_counter_ns()
            for _ in range(iterations):
                shape_nominal_into(face, text, style, buffer)
                keep(buffer)
            reusable_elapsed.append(perf_counter_ns() - started)
        else:
            var started = perf_counter_ns()
            for _ in range(iterations):
                shape_nominal_into(face, text, style, buffer)
                keep(buffer)
            reusable_elapsed.append(perf_counter_ns() - started)

            started = perf_counter_ns()
            for _ in range(iterations):
                run = shape_nominal(face, text, style)
                keep(run)
            allocating_elapsed.append(perf_counter_ns() - started)

        if _shape_checksum(run) != expected:
            raise Error("allocating shaping checksum changed")
        if _shape_buffer_checksum(buffer) != expected:
            raise Error("reusable shaping checksum changed")

    var allocating_percentiles = _percentiles(allocating_elapsed)
    var reusable_percentiles = _percentiles(reusable_elapsed)
    var operations = scalar_count * iterations
    print(
        "case=shape_nominal_allocating_mixed scalar_count=",
        scalar_count,
        " utf8_bytes=",
        text.byte_length(),
        " iterations=",
        iterations,
        " scalar_operations=",
        operations,
        " p50_elapsed_ns=",
        allocating_percentiles[0],
        " p95_elapsed_ns=",
        allocating_percentiles[1],
        " p50_ns_per_scalar=",
        Float64(allocating_percentiles[0]) / Float64(operations),
        " p95_ns_per_scalar=",
        Float64(allocating_percentiles[1]) / Float64(operations),
        " p50_million_scalars_per_second=",
        Float64(operations) * 1000.0 / Float64(allocating_percentiles[0]),
        " checksum=",
        expected,
        sep="",
    )
    print(
        "case=shape_nominal_into_reuse_mixed scalar_count=",
        scalar_count,
        " utf8_bytes=",
        text.byte_length(),
        " iterations=",
        iterations,
        " scalar_operations=",
        operations,
        " retained_capacity=",
        buffer.capacity(),
        " p50_elapsed_ns=",
        reusable_percentiles[0],
        " p95_elapsed_ns=",
        reusable_percentiles[1],
        " p50_ns_per_scalar=",
        Float64(reusable_percentiles[0]) / Float64(operations),
        " p95_ns_per_scalar=",
        Float64(reusable_percentiles[1]) / Float64(operations),
        " p50_million_scalars_per_second=",
        Float64(operations) * 1000.0 / Float64(reusable_percentiles[0]),
        " checksum=",
        expected,
        sep="",
    )


def _measure_ivs_shape_reuse(face: FontFace, sequence_count: Int) raises:
    var text = _ivs_text(sequence_count)
    var style = TextStyle().with_size(16.0).with_language(Language.JA)
    var input_scalars = 2 * sequence_count
    var iterations = max(1, _SHAPE_SAMPLE_BUDGET // input_scalars)
    var buffer = ShapeBuffer(capacity=sequence_count)
    shape_nominal_into(face, text, style, buffer)
    var expected = _shape_buffer_checksum(buffer)
    if len(buffer) != sequence_count:
        raise Error("IVS benchmark must emit one glyph per variation sequence")

    for _ in range(_WARMUP_ROUNDS):
        for _ in range(iterations):
            shape_nominal_into(face, text, style, buffer)
            keep(buffer)
        if _shape_buffer_checksum(buffer) != expected:
            raise Error("IVS shaping checksum changed during warmup")

    var elapsed = List[Int](capacity=_MEASUREMENTS)
    for _ in range(_MEASUREMENTS):
        var started = perf_counter_ns()
        for _ in range(iterations):
            shape_nominal_into(face, text, style, buffer)
            keep(buffer)
        elapsed.append(perf_counter_ns() - started)
        if _shape_buffer_checksum(buffer) != expected:
            raise Error("IVS shaping checksum changed")

    var percentiles = _percentiles(elapsed)
    var scalar_operations = input_scalars * iterations
    var sequence_operations = sequence_count * iterations
    print(
        "case=shape_nominal_into_reuse_ivs_mixed sequences=",
        sequence_count,
        " input_scalars=",
        input_scalars,
        " output_glyphs=",
        len(buffer),
        " utf8_bytes=",
        text.byte_length(),
        " iterations=",
        iterations,
        " scalar_operations=",
        scalar_operations,
        " sequence_operations=",
        sequence_operations,
        " retained_capacity=",
        buffer.capacity(),
        " p50_elapsed_ns=",
        percentiles[0],
        " p95_elapsed_ns=",
        percentiles[1],
        " p50_ns_per_input_scalar=",
        Float64(percentiles[0]) / Float64(scalar_operations),
        " p95_ns_per_input_scalar=",
        Float64(percentiles[1]) / Float64(scalar_operations),
        " p50_ns_per_sequence=",
        Float64(percentiles[0]) / Float64(sequence_operations),
        " p50_million_sequences_per_second=",
        Float64(sequence_operations) * 1000.0 / Float64(percentiles[0]),
        " checksum=",
        expected,
        sep="",
    )


def _print_gsub_distribution(
    case_identity: String,
    fixture_identity: String,
    run_identity: String,
    input_scalars: Int,
    output_glyphs: Int,
    iterations: Int,
    retained_capacity: Int,
    checksum: Int,
    mut elapsed: List[Int],
):
    var percentiles = _percentiles(elapsed)
    var operations = input_scalars * iterations
    print(
        "case=",
        case_identity,
        " fixture=",
        fixture_identity,
        " run=",
        run_identity,
        " input_scalars=",
        input_scalars,
        " output_glyphs=",
        output_glyphs,
        " iterations=",
        iterations,
        " scalar_operations=",
        operations,
        " retained_capacity=",
        retained_capacity,
        " p50_elapsed_ns=",
        percentiles[0],
        " p95_elapsed_ns=",
        percentiles[1],
        " p50_ns_per_input_scalar=",
        Float64(percentiles[0]) / Float64(operations),
        " p95_ns_per_input_scalar=",
        Float64(percentiles[1]) / Float64(operations),
        " p50_million_input_scalars_per_second=",
        Float64(operations) * 1000.0 / Float64(percentiles[0]),
        " checksum=",
        checksum,
        sep="",
    )


def _measure_gsub_paths(
    face: FontFace,
    fixture_identity: String,
    run_identity: String,
    text: String,
    input_scalars: Int,
    style: TextStyle,
) raises:
    """Compare the public nominal oracle, allocating GSUB, and reused GSUB."""
    var iterations = max(1, _GSUB_SAMPLE_BUDGET // input_scalars)
    var nominal = shape_nominal(face, text, style)
    var localized = shape(face, text, style)
    var buffer = ShapeBuffer(capacity=len(localized))
    shape_into(face, text, style, buffer)
    var expected_nominal = _shape_checksum(nominal)
    var expected_localized = _shape_checksum(localized)
    if _shape_buffer_checksum(buffer) != expected_localized:
        raise Error("allocating and reusable GSUB shaping checksums differ")
    if expected_nominal == expected_localized:
        raise Error("GSUB fixture did not change the nominal oracle")

    for _ in range(_WARMUP_ROUNDS):
        for _ in range(iterations):
            nominal = shape_nominal(face, text, style)
            keep(nominal)
        for _ in range(iterations):
            localized = shape(face, text, style)
            keep(localized)
        for _ in range(iterations):
            shape_into(face, text, style, buffer)
            keep(buffer)
        if _shape_checksum(nominal) != expected_nominal:
            raise Error("nominal GSUB oracle checksum changed during warmup")
        if _shape_checksum(localized) != expected_localized:
            raise Error("allocating GSUB checksum changed during warmup")
        if _shape_buffer_checksum(buffer) != expected_localized:
            raise Error("reusable GSUB checksum changed during warmup")

    var nominal_elapsed = List[Int](capacity=_MEASUREMENTS)
    var allocating_elapsed = List[Int](capacity=_MEASUREMENTS)
    var reusable_elapsed = List[Int](capacity=_MEASUREMENTS)
    for sample in range(_MEASUREMENTS):
        if sample % 3 == 0:
            var started = perf_counter_ns()
            for _ in range(iterations):
                nominal = shape_nominal(face, text, style)
                keep(nominal)
            nominal_elapsed.append(perf_counter_ns() - started)

            started = perf_counter_ns()
            for _ in range(iterations):
                localized = shape(face, text, style)
                keep(localized)
            allocating_elapsed.append(perf_counter_ns() - started)

            started = perf_counter_ns()
            for _ in range(iterations):
                shape_into(face, text, style, buffer)
                keep(buffer)
            reusable_elapsed.append(perf_counter_ns() - started)
        elif sample % 3 == 1:
            var started = perf_counter_ns()
            for _ in range(iterations):
                localized = shape(face, text, style)
                keep(localized)
            allocating_elapsed.append(perf_counter_ns() - started)

            started = perf_counter_ns()
            for _ in range(iterations):
                shape_into(face, text, style, buffer)
                keep(buffer)
            reusable_elapsed.append(perf_counter_ns() - started)

            started = perf_counter_ns()
            for _ in range(iterations):
                nominal = shape_nominal(face, text, style)
                keep(nominal)
            nominal_elapsed.append(perf_counter_ns() - started)
        else:
            var started = perf_counter_ns()
            for _ in range(iterations):
                shape_into(face, text, style, buffer)
                keep(buffer)
            reusable_elapsed.append(perf_counter_ns() - started)

            started = perf_counter_ns()
            for _ in range(iterations):
                nominal = shape_nominal(face, text, style)
                keep(nominal)
            nominal_elapsed.append(perf_counter_ns() - started)

            started = perf_counter_ns()
            for _ in range(iterations):
                localized = shape(face, text, style)
                keep(localized)
            allocating_elapsed.append(perf_counter_ns() - started)

        if _shape_checksum(nominal) != expected_nominal:
            raise Error("nominal GSUB oracle checksum changed")
        if _shape_checksum(localized) != expected_localized:
            raise Error("allocating GSUB checksum changed")
        if _shape_buffer_checksum(buffer) != expected_localized:
            raise Error("reusable GSUB checksum changed")

    _print_gsub_distribution(
        "shape_nominal_allocating_gsub_oracle",
        fixture_identity,
        run_identity,
        input_scalars,
        len(nominal),
        iterations,
        0,
        expected_nominal,
        nominal_elapsed,
    )
    _print_gsub_distribution(
        "shape_locl_allocating",
        fixture_identity,
        run_identity,
        input_scalars,
        len(localized),
        iterations,
        0,
        expected_localized,
        allocating_elapsed,
    )
    _print_gsub_distribution(
        "shape_into_locl_reuse",
        fixture_identity,
        run_identity,
        input_scalars,
        len(buffer),
        iterations,
        buffer.capacity(),
        expected_localized,
        reusable_elapsed,
    )


def _measure_selection_scaling(
    face: FontFace,
    fixture_identity: String,
    run_identity: String,
    scalar_count: Int,
) raises:
    """Measure public end-to-end lookup selection when no plan API exists."""
    var text = _gsub_text(0, scalar_count)
    var style = (
        TextStyle().with_size(16.0).with_language(Language.JA).with_script(Script.HAN)
    )
    var iterations = max(1, _GSUB_SAMPLE_BUDGET // scalar_count)
    var buffer = ShapeBuffer(capacity=scalar_count)
    shape_into(face, text, style, buffer)
    var expected = _shape_buffer_checksum(buffer)

    for _ in range(_WARMUP_ROUNDS):
        for _ in range(iterations):
            shape_into(face, text, style, buffer)
            keep(buffer)
        if _shape_buffer_checksum(buffer) != expected:
            raise Error("GSUB selector scaling checksum changed during warmup")

    var elapsed = List[Int](capacity=_MEASUREMENTS)
    for _ in range(_MEASUREMENTS):
        var started = perf_counter_ns()
        for _ in range(iterations):
            shape_into(face, text, style, buffer)
            keep(buffer)
        elapsed.append(perf_counter_ns() - started)
        if _shape_buffer_checksum(buffer) != expected:
            raise Error("GSUB selector scaling checksum changed")

    _print_gsub_distribution(
        "shape_into_locl_selection_probe",
        fixture_identity,
        run_identity,
        scalar_count,
        len(buffer),
        iterations,
        buffer.capacity(),
        expected,
        elapsed,
    )


def _profile_allocating(face: FontFace) raises:
    var text = _mixed_text(_PROFILE_SCALARS)
    var style = TextStyle().with_size(16.0).with_language(Language.JA)
    var run = shape_nominal(face, text, style)
    var expected = _shape_checksum(run)
    for _ in range(_PROFILE_ITERATIONS):
        run = shape_nominal(face, text, style)
        keep(run)
    if _shape_checksum(run) != expected:
        raise Error("allocating profile checksum changed")
    print(
        "profile=shape_nominal_allocating scalar_count=",
        _PROFILE_SCALARS,
        " iterations=",
        _PROFILE_ITERATIONS,
        " scalar_operations=",
        _PROFILE_SCALARS * _PROFILE_ITERATIONS,
        " checksum=",
        expected,
        sep="",
    )


def _profile_reuse(face: FontFace) raises:
    var text = _mixed_text(_PROFILE_SCALARS)
    var style = TextStyle().with_size(16.0).with_language(Language.JA)
    var buffer = ShapeBuffer(capacity=_PROFILE_SCALARS)
    shape_nominal_into(face, text, style, buffer)
    var expected = _shape_buffer_checksum(buffer)
    for _ in range(_PROFILE_ITERATIONS):
        shape_nominal_into(face, text, style, buffer)
        keep(buffer)
    if _shape_buffer_checksum(buffer) != expected:
        raise Error("reusable profile checksum changed")
    print(
        "profile=shape_nominal_into_reuse scalar_count=",
        _PROFILE_SCALARS,
        " iterations=",
        _PROFILE_ITERATIONS,
        " scalar_operations=",
        _PROFILE_SCALARS * _PROFILE_ITERATIONS,
        " retained_capacity=",
        buffer.capacity(),
        " checksum=",
        expected,
        sep="",
    )


def _profile_ivs_reuse(face: FontFace) raises:
    var text = _ivs_text(_PROFILE_IVS_SEQUENCES)
    var style = TextStyle().with_size(16.0).with_language(Language.JA)
    var buffer = ShapeBuffer(capacity=_PROFILE_IVS_SEQUENCES)
    shape_nominal_into(face, text, style, buffer)
    var expected = _shape_buffer_checksum(buffer)
    for _ in range(_PROFILE_ITERATIONS):
        shape_nominal_into(face, text, style, buffer)
        keep(buffer)
    if _shape_buffer_checksum(buffer) != expected:
        raise Error("IVS reusable profile checksum changed")
    print(
        "profile=shape_nominal_into_reuse_ivs sequence_count=",
        _PROFILE_IVS_SEQUENCES,
        " input_scalars=",
        2 * _PROFILE_IVS_SEQUENCES,
        " iterations=",
        _PROFILE_ITERATIONS,
        " scalar_operations=",
        2 * _PROFILE_IVS_SEQUENCES * _PROFILE_ITERATIONS,
        " retained_capacity=",
        buffer.capacity(),
        " checksum=",
        expected,
        sep="",
    )


def _profile_gsub_format2_long(face: FontFace) raises:
    var text = _gsub_text(1, _PROFILE_SCALARS)
    var style = TextStyle().with_size(16.0).with_script(Script.DEFAULT)
    var buffer = ShapeBuffer(capacity=_PROFILE_SCALARS)
    shape_into(face, text, style, buffer)
    var expected = _shape_buffer_checksum(buffer)
    for _ in range(_PROFILE_ITERATIONS):
        shape_into(face, text, style, buffer)
        keep(buffer)
    if _shape_buffer_checksum(buffer) != expected:
        raise Error("GSUB format 2 reusable profile checksum changed")
    print(
        "profile=shape_into_locl_format2_coverage2_long scalar_count=",
        _PROFILE_SCALARS,
        " iterations=",
        _PROFILE_ITERATIONS,
        " scalar_operations=",
        _PROFILE_SCALARS * _PROFILE_ITERATIONS,
        " retained_capacity=",
        buffer.capacity(),
        " checksum=",
        expected,
        sep="",
    )


def _profile_auto_scripts_long(face: FontFace) raises:
    var text = _auto_cjk_text(_PROFILE_SCALARS)
    var style = TextStyle().with_size(16.0).with_language(Language.JA)
    var buffer = ShapeBuffer(capacity=_PROFILE_SCALARS)
    shape_into(face, text, style, buffer)
    var expected = _shape_buffer_checksum(buffer)
    for _ in range(_PROFILE_ITERATIONS):
        shape_into(face, text, style, buffer)
        keep(buffer)
    if _shape_buffer_checksum(buffer) != expected:
        raise Error("automatic script reusable profile checksum changed")
    print(
        "profile=shape_into_auto_scripts_long scalar_count=",
        _PROFILE_SCALARS,
        " iterations=",
        _PROFILE_ITERATIONS,
        " scalar_operations=",
        _PROFILE_SCALARS * _PROFILE_ITERATIONS,
        " retained_capacity=",
        buffer.capacity(),
        " script_runs=",
        buffer._script_itemizer.run_count(),
        " distinct_script_tags=5 temporary_lookup_mask_bytes=",
        len(buffer._gsub_lookup_mask),
        " selected_lookup_indices=",
        len(buffer._gsub_selected_lookups),
        " checksum=",
        expected,
        sep="",
    )


def _profile_forced_dflt_scripts_long(face: FontFace) raises:
    var text = _auto_cjk_text(_PROFILE_SCALARS)
    var style = TextStyle().with_size(16.0).with_script(Script.DEFAULT)
    var buffer = ShapeBuffer(capacity=_PROFILE_SCALARS)
    shape_into(face, text, style, buffer)
    var expected = _shape_buffer_checksum(buffer)
    for _ in range(_PROFILE_ITERATIONS):
        shape_into(face, text, style, buffer)
        keep(buffer)
    if _shape_buffer_checksum(buffer) != expected:
        raise Error("forced DFLT reusable profile checksum changed")
    print(
        "profile=shape_into_forced_dflt_scripts_long scalar_count=",
        _PROFILE_SCALARS,
        " iterations=",
        _PROFILE_ITERATIONS,
        " scalar_operations=",
        _PROFILE_SCALARS * _PROFILE_ITERATIONS,
        " retained_capacity=",
        buffer.capacity(),
        " checksum=",
        expected,
        sep="",
    )


def main() raises:
    # Parse reusable hot-path fixtures exactly once before their timing regions.
    var font_bytes = make_test_font()
    var face = FontFace.from_bytes(font_bytes^)
    var arguments = argv()
    if len(arguments) > 1:
        var mode = String(arguments[1])
        if mode == "--profile-allocating":
            _profile_allocating(face)
            return
        if mode == "--profile-reuse":
            _profile_reuse(face)
            return
        if mode == "--profile-ivs-reuse":
            var uvs_profile_bytes = make_test_uvs_font()
            var uvs_profile_face = FontFace.from_bytes(uvs_profile_bytes^)
            _profile_ivs_reuse(uvs_profile_face)
            return
        if mode == "--profile-gsub-format2-long":
            var profile_gsub = make_gsub_single_format2_coverage2()
            var profile_bytes = make_test_font_with_gsub(profile_gsub^)
            var profile_face = FontFace.from_bytes(profile_bytes^)
            _profile_gsub_format2_long(profile_face)
            return
        if mode == "--profile-auto-scripts-long":
            var auto_profile_bytes = make_test_auto_cjk_gsub_font()
            var auto_profile_face = FontFace.from_bytes(auto_profile_bytes^)
            _profile_auto_scripts_long(auto_profile_face)
            return
        if mode == "--profile-forced-dflt-scripts-long":
            var dflt_profile_bytes = make_test_auto_cjk_gsub_font()
            var dflt_profile_face = FontFace.from_bytes(dflt_profile_bytes^)
            _profile_forced_dflt_scripts_long(dflt_profile_face)
            return
        raise Error("unknown benchmark mode: ", mode)
    print(
        "schema=kumihan-core-benchmark-v7 mojo=1.0.0 ",
        "build=mojo-build-O3 measurements=31 warmup_rounds=3 ",
        "statistic=nearest-rank-p50-p95 scope=synthetic-foundation-and-gsub ",
        "fixtures=format12,format14,gsub-single1-coverage1,",
        "gsub-single2-coverage2,gsub-cjk-seven-lookup",
        sep="",
    )
    var construction_template = make_test_font()
    _measure_face_construction(construction_template)
    var collection_bytes = make_test_collection()
    var collection = FontCollection.from_bytes(collection_bytes^)
    _measure_ttc_shared_faces(collection^)
    for count in [1024, 65536, 1048576]:
        _measure_lookup(face, count)
    var uvs_bytes = make_test_uvs_font()
    var uvs_face = FontFace.from_bytes(uvs_bytes^)
    _measure_variation_lookup(uvs_face, 0, "supported_default")
    _measure_variation_lookup(uvs_face, 1, "supported_explicit")
    _measure_variation_lookup(uvs_face, 2, "unsupported")
    for scalar_count in [256, 4096, 65536]:
        _measure_shape_paths(face, scalar_count)
    for sequence_count in [128, 2048, 32768]:
        _measure_ivs_shape_reuse(uvs_face, sequence_count)

    var gsub1 = make_gsub_single_format1()
    var gsub1_bytes = make_test_font_with_gsub(gsub1^)
    var gsub1_face = FontFace.from_bytes(gsub1_bytes^)
    var gsub2 = make_gsub_single_format2_coverage2()
    var gsub2_bytes = make_test_font_with_gsub(gsub2^)
    var gsub2_face = FontFace.from_bytes(gsub2_bytes^)
    var gsub_style = TextStyle().with_size(16.0).with_script(Script.DEFAULT)
    for scalar_count in [16, 4096]:
        var run_identity = "short" if scalar_count == 16 else "long"
        var format1_text = _gsub_text(0, scalar_count)
        _measure_gsub_paths(
            gsub1_face,
            "single_format1_coverage1",
            run_identity,
            format1_text^,
            scalar_count,
            gsub_style,
        )
        var format2_text = _gsub_text(1, scalar_count)
        _measure_gsub_paths(
            gsub2_face,
            "single_format2_coverage2",
            run_identity,
            format2_text^,
            scalar_count,
            gsub_style,
        )

    var cjk_bytes = make_test_cjk_gsub_font()
    var cjk_face = FontFace.from_bytes(cjk_bytes^)
    for scalar_count in [16, 4096]:
        var run_identity = "short" if scalar_count == 16 else "long"
        _measure_selection_scaling(
            gsub1_face,
            "dflt_one_lookup",
            run_identity,
            scalar_count,
        )
        _measure_selection_scaling(
            cjk_face,
            "hani_jan_seven_lookup",
            run_identity,
            scalar_count,
        )

    var auto_bytes = make_test_auto_cjk_gsub_font()
    var auto_face = FontFace.from_bytes(auto_bytes^)
    for scalar_count in [16, 4096]:
        var run_identity = "short" if scalar_count == 16 else "long"
        var auto_text = _auto_cjk_text(scalar_count)
        _measure_gsub_paths(
            auto_face,
            "automatic_fragmented_mixed_cjk",
            run_identity,
            auto_text.copy(),
            scalar_count,
            TextStyle().with_size(16.0).with_language(Language.JA),
        )
        _measure_gsub_paths(
            auto_face,
            "forced_dflt_mixed_control",
            run_identity,
            auto_text^,
            scalar_count,
            TextStyle().with_size(16.0).with_script(Script.DEFAULT),
        )

        var han_text = _han_text(scalar_count)
        _measure_gsub_paths(
            auto_face,
            "automatic_homogeneous_han",
            run_identity,
            han_text.copy(),
            scalar_count,
            TextStyle().with_size(16.0).with_language(Language.JA),
        )
        _measure_gsub_paths(
            auto_face,
            "explicit_homogeneous_han_control",
            run_identity,
            han_text^,
            scalar_count,
            TextStyle()
            .with_size(16.0)
            .with_language(Language.JA)
            .with_script(Script.HAN),
        )

    var ivs_locl_gsub = make_gsub_single_format1(input_glyph=5, delta=-4)
    var ivs_locl_bytes = make_test_font_with_gsub(ivs_locl_gsub^, with_uvs=True)
    var ivs_locl_face = FontFace.from_bytes(ivs_locl_bytes^)
    for sequence_count in [8, 2048]:
        var run_identity = "short" if sequence_count == 8 else "long"
        var ivs_locl = _ivs_locl_text(sequence_count)
        _measure_gsub_paths(
            ivs_locl_face,
            "explicit_ivs_then_single_format1_coverage1",
            run_identity,
            ivs_locl^,
            2 * sequence_count,
            gsub_style,
        )
