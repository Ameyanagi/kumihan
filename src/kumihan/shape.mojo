"""Renderer-neutral glyph runs and deliberately nominal horizontal shaping.

``shape_nominal`` and ``shape_nominal_into`` perform one Unicode-scalar pass,
cmap lookup, and hmtx scaling.  They do not yet apply OpenType GSUB or GPOS,
normalize text, perform bidi reordering, choose fallback fonts, or provide
vertical substitutions.  Callers that need full OpenType shaping must not
treat these APIs as such.
"""

from std.collections import List
from std.math import isfinite

from .sfnt import FontFace
from .style import Direction, Language, TextStyle


struct ShapeBuffer(Movable, Sized):
    """Reusable structure-of-arrays storage for positioned glyph output.

    ``shape_nominal_into`` clears logical lengths while retaining every list's
    allocation.  One buffer may serve repeated sequential calls, but must not
    be aliased across concurrent calls.  Cluster ranges are byte offsets; call
    ``validate_against_source`` when their UTF-8 boundary relationship to a
    particular source must also be checked.
    """

    var _glyph_ids: List[Int]
    var _cluster_starts: List[Int]
    var _cluster_ends: List[Int]
    var _x_advances: List[Float64]
    var _y_advances: List[Float64]
    var _x_offsets: List[Float64]
    var _y_offsets: List[Float64]
    var _source_byte_length: Int
    var _font_size: Float64
    var _language: Language
    var _direction: Direction
    var _ascender: Float64
    var _descender: Float64
    var _line_gap: Float64
    var _total_x_advance: Float64
    var _missing_glyph_count: Int

    def __init__(out self):
        """Construct empty reusable output without allocating glyph storage."""
        self._glyph_ids = List[Int]()
        self._cluster_starts = List[Int]()
        self._cluster_ends = List[Int]()
        self._x_advances = List[Float64]()
        self._y_advances = List[Float64]()
        self._x_offsets = List[Float64]()
        self._y_offsets = List[Float64]()
        self._source_byte_length = 0
        self._font_size = 16.0
        self._language = Language.UND
        self._direction = Direction.LEFT_TO_RIGHT
        self._ascender = 0.0
        self._descender = 0.0
        self._line_gap = 0.0
        self._total_x_advance = 0.0
        self._missing_glyph_count = 0

    def __init__(out self, *, capacity: Int) raises:
        """Construct empty reusable output reserved for ``capacity`` glyphs."""
        if capacity < 0:
            raise Error("shape-buffer capacity must not be negative; got ", capacity)
        self._glyph_ids = List[Int](capacity=capacity)
        self._cluster_starts = List[Int](capacity=capacity)
        self._cluster_ends = List[Int](capacity=capacity)
        self._x_advances = List[Float64](capacity=capacity)
        self._y_advances = List[Float64](capacity=capacity)
        self._x_offsets = List[Float64](capacity=capacity)
        self._y_offsets = List[Float64](capacity=capacity)
        self._source_byte_length = 0
        self._font_size = 16.0
        self._language = Language.UND
        self._direction = Direction.LEFT_TO_RIGHT
        self._ascender = 0.0
        self._descender = 0.0
        self._line_gap = 0.0
        self._total_x_advance = 0.0
        self._missing_glyph_count = 0

    def _reset_metadata(mut self):
        self._source_byte_length = 0
        self._font_size = 16.0
        self._language = Language.UND
        self._direction = Direction.LEFT_TO_RIGHT
        self._ascender = 0.0
        self._descender = 0.0
        self._line_gap = 0.0
        self._total_x_advance = 0.0
        self._missing_glyph_count = 0

    def clear(mut self):
        """Clear logical output while retaining all allocated capacity."""
        self._glyph_ids.clear()
        self._cluster_starts.clear()
        self._cluster_ends.clear()
        self._x_advances.clear()
        self._y_advances.clear()
        self._x_offsets.clear()
        self._y_offsets.clear()
        self._reset_metadata()

    def reserve(mut self, capacity: Int) raises:
        """Reserve every parallel array for at least ``capacity`` glyphs."""
        if capacity < 0:
            raise Error("shape-buffer capacity must not be negative; got ", capacity)
        if capacity <= self.capacity():
            return
        self._glyph_ids.reserve(capacity)
        self._cluster_starts.reserve(capacity)
        self._cluster_ends.reserve(capacity)
        self._x_advances.reserve(capacity)
        self._y_advances.reserve(capacity)
        self._x_offsets.reserve(capacity)
        self._y_offsets.reserve(capacity)

    def capacity(self) -> Int:
        """Return the minimum capacity among all parallel output arrays."""
        return min(
            self._glyph_ids.capacity(),
            min(
                self._cluster_starts.capacity(),
                min(
                    self._cluster_ends.capacity(),
                    min(
                        self._x_advances.capacity(),
                        min(
                            self._y_advances.capacity(),
                            min(
                                self._x_offsets.capacity(),
                                self._y_offsets.capacity(),
                            ),
                        ),
                    ),
                ),
            ),
        )

    def __len__(self) -> Int:
        return len(self._glyph_ids)

    def is_empty(self) -> Bool:
        return len(self._glyph_ids) == 0

    def glyph_ids(self) -> Span[Int, origin_of(self._glyph_ids)]:
        return Span(self._glyph_ids)

    def cluster_starts(self) -> Span[Int, origin_of(self._cluster_starts)]:
        """Return source-byte start offsets, one for each output glyph."""
        return Span(self._cluster_starts)

    def cluster_ends(self) -> Span[Int, origin_of(self._cluster_ends)]:
        """Return source-byte exclusive end offsets for output glyphs."""
        return Span(self._cluster_ends)

    def x_advances(self) -> Span[Float64, origin_of(self._x_advances)]:
        return Span(self._x_advances)

    def y_advances(self) -> Span[Float64, origin_of(self._y_advances)]:
        return Span(self._y_advances)

    def x_offsets(self) -> Span[Float64, origin_of(self._x_offsets)]:
        return Span(self._x_offsets)

    def y_offsets(self) -> Span[Float64, origin_of(self._y_offsets)]:
        return Span(self._y_offsets)

    def source_byte_length(self) -> Int:
        return self._source_byte_length

    def font_size(self) -> Float64:
        return self._font_size

    def language(self) -> Language:
        return self._language

    def direction(self) -> Direction:
        return self._direction

    def ascender(self) -> Float64:
        return self._ascender

    def descender(self) -> Float64:
        return self._descender

    def line_gap(self) -> Float64:
        return self._line_gap

    def total_x_advance(self) -> Float64:
        return self._total_x_advance

    def missing_glyph_count(self) -> Int:
        return self._missing_glyph_count

    def validate(self) raises:
        """Validate array shapes, numeric values, and byte-range bounds.

        This structural check does not own the source and therefore cannot
        prove that byte offsets are UTF-8 boundaries.  Use
        ``validate_against_source`` for that stronger check.
        """
        var count = len(self._glyph_ids)
        if (
            len(self._cluster_starts) != count
            or len(self._cluster_ends) != count
            or len(self._x_advances) != count
            or len(self._y_advances) != count
            or len(self._x_offsets) != count
            or len(self._y_offsets) != count
        ):
            raise Error("glyph-run structure-of-arrays lengths do not match")
        if self._source_byte_length < 0:
            raise Error("glyph-run source byte length must not be negative")
        if not isfinite(self._font_size) or self._font_size <= 0.0:
            raise Error("glyph-run font size must be finite and positive")
        self._language.validate()
        self._direction.validate()
        if not self._direction.is_left_to_right():
            raise Error("nominal glyph runs currently require left-to-right direction")
        if (
            not isfinite(self._ascender)
            or not isfinite(self._descender)
            or not isfinite(self._line_gap)
            or not isfinite(self._total_x_advance)
        ):
            raise Error("glyph-run metrics must be finite")
        if self._missing_glyph_count < 0 or self._missing_glyph_count > count:
            raise Error("glyph-run missing-glyph count is outside its valid range")

        var previous_start = 0
        var computed_advance = 0.0
        var computed_missing = 0
        for index in range(count):
            if self._glyph_ids[index] < 0:
                raise Error("glyph-run glyph IDs must not be negative")
            if self._glyph_ids[index] == 0:
                computed_missing += 1
            var start = self._cluster_starts[index]
            var end = self._cluster_ends[index]
            # Repeated ranges are valid for future substitutions that emit
            # multiple glyphs from one source cluster.  Visual-order LTR runs
            # must still keep cluster starts monotonic.
            if (
                start < previous_start
                or start < 0
                or end <= start
                or end > self._source_byte_length
            ):
                raise Error("glyph-run contains an invalid source byte cluster")
            previous_start = start
            var x_advance = self._x_advances[index]
            if (
                not isfinite(x_advance)
                or x_advance < 0.0
                or not isfinite(self._y_advances[index])
                or not isfinite(self._x_offsets[index])
                or not isfinite(self._y_offsets[index])
            ):
                raise Error("glyph-run positioning values must be finite")
            if x_advance > Float64.MAX_FINITE - computed_advance:
                raise Error("glyph-run total advance overflows Float64")
            computed_advance += x_advance
        if computed_advance != self._total_x_advance:
            raise Error("glyph-run total advance does not match its glyph advances")
        if computed_missing != self._missing_glyph_count:
            raise Error("glyph-run missing-glyph count does not match its glyph IDs")

    def validate_against_source(self, source: StringSlice) raises:
        """Also prove cluster bounds are UTF-8 boundaries in ``source``."""
        self.validate()
        if source.byte_length() != self._source_byte_length:
            raise Error("glyph-run source byte length does not match validation source")
        for index in range(len(self._glyph_ids)):
            if not source.is_codepoint_boundary(
                self._cluster_starts[index]
            ) or not source.is_codepoint_boundary(self._cluster_ends[index]):
                raise Error("glyph-run cluster is not bounded by UTF-8 boundaries")


struct GlyphRun(Movable, Sized):
    """Own one immutable-by-contract positioned run.

    The run wraps the same SoA representation as ``ShapeBuffer``.  The
    allocating ``shape_nominal`` convenience API returns this ownership form;
    repeated callers should inspect a retained ``ShapeBuffer`` instead.
    """

    var _buffer: ShapeBuffer

    def __init__(out self, *, var _buffer: ShapeBuffer):
        self._buffer = _buffer^

    def __len__(self) -> Int:
        return len(self._buffer)

    def is_empty(self) -> Bool:
        return self._buffer.is_empty()

    def glyph_ids(self) -> Span[Int, origin_of(self._buffer._glyph_ids)]:
        return Span(self._buffer._glyph_ids)

    def cluster_starts(self) -> Span[Int, origin_of(self._buffer._cluster_starts)]:
        return Span(self._buffer._cluster_starts)

    def cluster_ends(self) -> Span[Int, origin_of(self._buffer._cluster_ends)]:
        return Span(self._buffer._cluster_ends)

    def x_advances(self) -> Span[Float64, origin_of(self._buffer._x_advances)]:
        return Span(self._buffer._x_advances)

    def y_advances(self) -> Span[Float64, origin_of(self._buffer._y_advances)]:
        return Span(self._buffer._y_advances)

    def x_offsets(self) -> Span[Float64, origin_of(self._buffer._x_offsets)]:
        return Span(self._buffer._x_offsets)

    def y_offsets(self) -> Span[Float64, origin_of(self._buffer._y_offsets)]:
        return Span(self._buffer._y_offsets)

    def source_byte_length(self) -> Int:
        return self._buffer.source_byte_length()

    def font_size(self) -> Float64:
        return self._buffer.font_size()

    def language(self) -> Language:
        return self._buffer.language()

    def direction(self) -> Direction:
        return self._buffer.direction()

    def ascender(self) -> Float64:
        return self._buffer.ascender()

    def descender(self) -> Float64:
        return self._buffer.descender()

    def line_gap(self) -> Float64:
        return self._buffer.line_gap()

    def total_x_advance(self) -> Float64:
        return self._buffer.total_x_advance()

    def missing_glyph_count(self) -> Int:
        return self._buffer.missing_glyph_count()

    def validate(self) raises:
        self._buffer.validate()

    def validate_against_source(self, source: StringSlice) raises:
        self._buffer.validate_against_source(source)


def _initial_capacity(source_byte_length: Int) -> Int:
    # A small cap avoids retaining seven byte-sized overallocations for long
    # ASCII inputs while still eliminating growth for the common short run.
    return min(source_byte_length, 256)


def _scaled_metric(value: Int, scale: Float64, name: StringSlice) raises -> Float64:
    var result = Float64(value) * scale
    if not isfinite(result):
        raise Error("text size overflows scaled ", name)
    return result


def _is_variation_selector(value: Int) -> Bool:
    """Return whether ``value`` is a Unicode variation selector."""
    return (
        (value >= 0x180B and value <= 0x180D)
        or value == 0x180F
        or (value >= 0xFE00 and value <= 0xFE0F)
        or (value >= 0xE0100 and value <= 0xE01EF)
    )


def shape_nominal_into(
    face: FontFace,
    text: StringSlice,
    style: TextStyle,
    mut output: ShapeBuffer,
) raises:
    """Map horizontal LTR text into caller-owned reusable output.

    The source is decoded exactly once.  Ordinary scalars produce one glyph.
    A variation selector extends the immediately preceding scalar's cluster
    and selects its supported default or non-default cmap glyph; unsupported
    pairs retain the base glyph.  Leading selectors are ignored; further
    consecutive selectors do not reselect the glyph but remain covered by its
    cluster. ``output`` retains allocations across calls. If an advance or
    running total overflows, output is cleared before raising.

    This intentionally is not full OpenType shaping: GSUB, GPOS, bidi,
    normalization, fallback, and vertical layout are not implemented by this
    function.
    """
    style.validate()
    if not style.direction().is_left_to_right():
        raise Error(
            "shape_nominal currently supports only horizontal left-to-right runs"
        )
    var units_per_em = face.units_per_em()
    if units_per_em <= 0:
        raise Error("font units-per-em must be positive; got ", units_per_em)

    var scale = style.size() / Float64(units_per_em)
    if scale == 0.0:
        raise Error("text size is too small to scale in this font")
    var ascender = _scaled_metric(face.ascender(), scale, "ascender")
    var descender = _scaled_metric(face.descender(), scale, "descender")
    var line_gap = _scaled_metric(face.line_gap(), scale, "line gap")

    output.clear()
    output.reserve(_initial_capacity(text.byte_length()))
    var byte_offset = 0
    var total_x_advance = 0.0
    var missing_glyph_count = 0
    var previous_is_base = False
    var previous_has_glyph = False
    var previous_base = 0
    var total_before_previous = 0.0

    # Do not split this into a counting pass and a mapping pass: codepoint
    # decoding is intentionally paid exactly once per source scalar.
    for scalar in text.codepoints():
        var cluster_end = byte_offset + scalar.utf8_byte_length()
        var scalar_value = Int(scalar.to_u32())
        if _is_variation_selector(scalar_value):
            if previous_is_base:
                var previous_index = len(output._glyph_ids) - 1
                var glyph_id = output._glyph_ids[previous_index]
                var variation = face.variation_glyph_id(previous_base, scalar_value)
                if variation:
                    glyph_id = variation.value()
                if glyph_id != output._glyph_ids[previous_index]:
                    var x_advance = Float64(face.advance_width(glyph_id)) * scale
                    if not isfinite(x_advance):
                        output.clear()
                        raise Error("text size overflows scaled glyph advance")
                    if x_advance > Float64.MAX_FINITE - total_before_previous:
                        output.clear()
                        raise Error(
                            "text size overflows the run's total horizontal advance"
                        )
                    var previous_glyph = output._glyph_ids[previous_index]
                    if previous_glyph == 0 and glyph_id != 0:
                        missing_glyph_count -= 1
                    elif previous_glyph != 0 and glyph_id == 0:
                        missing_glyph_count += 1
                    output._glyph_ids[previous_index] = glyph_id
                    output._x_advances[previous_index] = x_advance
                    total_x_advance = total_before_previous + x_advance
            if previous_has_glyph:
                # Only the first selector chooses a glyph, but UAX #29 GB9
                # keeps every trailing selector in that glyph's source cluster.
                output._cluster_ends[len(output._cluster_ends) - 1] = cluster_end
            # A selector can select only for the immediately preceding
            # non-selector scalar. Stacked selectors remain default-ignorable.
            previous_is_base = False
            byte_offset = cluster_end
            continue

        var glyph_id = face.glyph_id(scalar_value)
        var x_advance = Float64(face.advance_width(glyph_id)) * scale
        if not isfinite(x_advance):
            output.clear()
            raise Error("text size overflows scaled glyph advance")
        if x_advance > Float64.MAX_FINITE - total_x_advance:
            output.clear()
            raise Error("text size overflows the run's total horizontal advance")
        total_before_previous = total_x_advance
        output._glyph_ids.append(glyph_id)
        output._cluster_starts.append(byte_offset)
        output._cluster_ends.append(cluster_end)
        output._x_advances.append(x_advance)
        output._y_advances.append(0.0)
        output._x_offsets.append(0.0)
        output._y_offsets.append(0.0)
        total_x_advance += x_advance
        if glyph_id == 0:
            missing_glyph_count += 1
        previous_is_base = True
        previous_has_glyph = True
        previous_base = scalar_value
        byte_offset = cluster_end

    output._source_byte_length = text.byte_length()
    output._font_size = style.size()
    output._language = style.language()
    output._direction = style.direction()
    output._ascender = ascender
    output._descender = descender
    output._line_gap = line_gap
    output._total_x_advance = total_x_advance
    output._missing_glyph_count = missing_glyph_count


def shape_nominal(
    face: FontFace, text: StringSlice, style: TextStyle
) raises -> GlyphRun:
    """Allocate and return nominal horizontal shaping output.

    Repeated or latency-sensitive callers should retain a ``ShapeBuffer`` and
    call ``shape_nominal_into`` to reuse all seven output allocations.
    """
    var output = ShapeBuffer(capacity=_initial_capacity(text.byte_length()))
    shape_nominal_into(face, text, style, output)
    return GlyphRun(_buffer=output^)
