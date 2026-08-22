"""AOT distribution benchmark for cached cmap lookup and nominal shaping."""

from kumihan import (
    FontCollection,
    FontFace,
    GlyphRun,
    Language,
    ShapeBuffer,
    TextStyle,
    shape_nominal,
    shape_nominal_into,
)
from std.benchmark import keep
from std.collections import List
from std.sys import argv
from std.time import perf_counter_ns

from support.font_fixture import make_test_collection, make_test_font


comptime _MEASUREMENTS = 31
comptime _WARMUP_ROUNDS = 3
comptime _LOOKUP_SAMPLE_BUDGET = 1 << 20
comptime _SHAPE_SAMPLE_BUDGET = 1 << 16
comptime _CONSTRUCTION_OPERATIONS = 4096
comptime _PROFILE_SCALARS = 4096
comptime _PROFILE_ITERATIONS = 8192


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


def _lookup_checksum(face: FontFace, codepoints: List[Int]) -> Int:
    var checksum = 0
    for index in range(len(codepoints)):
        # Include the position as well as the mapped glyph to catch reordering.
        checksum += (index + 1) * (face.glyph_id(codepoints[index]) + 1)
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
        raise Error("unknown benchmark mode: ", mode)
    print(
        "schema=kumihan-core-benchmark-v3 mojo=1.0.0 ",
        "build=mojo-build-O3 measurements=31 warmup_rounds=3 ",
        "statistic=nearest-rank-p50-p95 scope=synthetic-foundation ",
        "fixture=tests/support/font_fixture.make_test_font-format12",
        sep="",
    )
    var construction_template = make_test_font()
    _measure_face_construction(construction_template)
    var collection_bytes = make_test_collection()
    var collection = FontCollection.from_bytes(collection_bytes^)
    _measure_ttc_shared_faces(collection^)
    for count in [1024, 65536, 1048576]:
        _measure_lookup(face, count)
    for scalar_count in [256, 4096, 65536]:
        _measure_shape_paths(face, scalar_count)
