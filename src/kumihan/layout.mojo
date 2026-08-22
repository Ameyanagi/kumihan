"""Shared validated OpenType Layout primitives.

This module deliberately contains only representation-independent helpers.
GSUB execution lives in ``gsub.mojo``; future GPOS support can reuse the same
bounded tag, offset, and Coverage-table machinery.
"""

from std.collections import List

from .binary import _require_range, _scaled_size, _u16, _u16_unchecked


def _require_layout_range(
    data: List[UInt8],
    offset: Int,
    length: Int,
    root_offset: Int,
    root_length: Int,
    context: String,
) raises:
    """Require a child range to remain inside its validated Layout table."""
    _require_range(data, root_offset, root_length, "OpenType Layout table")
    if (
        offset < root_offset
        or length < 0
        or offset > root_offset + root_length
        or length > root_offset + root_length - offset
    ):
        raise Error("invalid " + context + " offset or length")


def _resolve_offset16(
    data: List[UInt8],
    base: Int,
    relative: Int,
    minimum_relative: Int,
    minimum_length: Int,
    root_offset: Int,
    root_length: Int,
    context: String,
) raises -> Int:
    """Resolve a required Offset16 without assuming child-table ordering."""
    if relative == 0 or relative < minimum_relative:
        raise Error("invalid " + context + " offset")
    var root_end = root_offset + root_length
    if base < root_offset or base > root_end or relative > root_end - base:
        raise Error("invalid " + context + " offset")
    var result = base + relative
    _require_layout_range(
        data, result, minimum_length, root_offset, root_length, context
    )
    return result


def _resolve_offset32(
    data: List[UInt8],
    base: Int,
    relative: Int,
    minimum_relative: Int,
    minimum_length: Int,
    root_offset: Int,
    root_length: Int,
    context: String,
) raises -> Int:
    """Resolve a required Offset32 with overflow-free root containment."""
    if relative == 0 or relative < minimum_relative:
        raise Error("invalid " + context + " offset")
    var root_end = root_offset + root_length
    if base < root_offset or base > root_end or relative > root_end - base:
        raise Error("invalid " + context + " offset")
    var result = base + relative
    _require_layout_range(
        data, result, minimum_length, root_offset, root_length, context
    )
    return result


def _require_layout_size(
    data: List[UInt8],
    offset: Int,
    count: Int,
    stride: Int,
    base_size: Int,
    root_offset: Int,
    root_length: Int,
    context: String,
) raises -> Int:
    """Validate one count-driven Layout table and return its byte size."""
    var size = _scaled_size(count, stride, base_size, context)
    _require_layout_range(data, offset, size, root_offset, root_length, context)
    return size


def _validate_layout_tag(tag: Int, context: String) raises:
    """Require one to four printable bytes followed only by spaces."""
    if tag < 0 or tag > 0xFFFFFFFF:
        raise Error("invalid " + context + " tag")
    var saw_trailing_space = False
    for index in range(4):
        var byte = (tag >> (24 - 8 * index)) & 0xFF
        if byte == 0x20:
            if index == 0:
                raise Error("invalid " + context + " tag")
            saw_trailing_space = True
        elif byte < 0x21 or byte > 0x7E or saw_trailing_space:
            raise Error("invalid " + context + " tag")


struct Coverage(Copyable, ImplicitlyCopyable):
    """A validated Coverage format 1 or 2 lookup descriptor."""

    var _format: Int
    var _offset: Int
    var _record_count: Int
    var _coverage_count: Int

    def __init__(
        out self,
        format: Int,
        offset: Int,
        record_count: Int,
        coverage_count: Int,
    ):
        self._format = format
        self._offset = offset
        self._record_count = record_count
        self._coverage_count = coverage_count

    def size(self) -> Int:
        """Return the number of glyphs represented by this coverage."""
        return self._coverage_count

    def index(self, data: List[UInt8], glyph_id: Int) -> Int:
        """Return a glyph's coverage index, or ``-1`` when it is absent."""
        if self._format == 1:
            var low = 0
            var high = self._record_count
            while low < high:
                var middle = low + (high - low) // 2
                var candidate = _u16_unchecked(data, self._offset + 4 + 2 * middle)
                if candidate < glyph_id:
                    low = middle + 1
                else:
                    high = middle
            if low < self._record_count:
                if _u16_unchecked(data, self._offset + 4 + 2 * low) == glyph_id:
                    return low
            return -1

        var low = 0
        var high = self._record_count
        while low < high:
            var middle = low + (high - low) // 2
            var record = self._offset + 4 + 6 * middle
            if _u16_unchecked(data, record + 2) < glyph_id:
                low = middle + 1
            else:
                high = middle
        if low == self._record_count:
            return -1
        var record = self._offset + 4 + 6 * low
        var start = _u16_unchecked(data, record)
        if glyph_id < start:
            return -1
        return _u16_unchecked(data, record + 4) + glyph_id - start

    def glyph_at(self, data: List[UInt8], coverage_index: Int) -> Int:
        """Return the glyph at a previously bounded coverage index."""
        if self._format == 1:
            return _u16_unchecked(data, self._offset + 4 + 2 * coverage_index)

        var low = 0
        var high = self._record_count
        while low < high:
            var middle = low + (high - low) // 2
            var record = self._offset + 4 + 6 * middle
            if _u16_unchecked(data, record + 4) <= coverage_index:
                low = middle + 1
            else:
                high = middle
        var record = self._offset + 4 + 6 * (low - 1)
        return (
            _u16_unchecked(data, record)
            + coverage_index
            - _u16_unchecked(data, record + 4)
        )

    def intersects(self, data: List[UInt8], start: Int, end: Int) -> Bool:
        """Return whether coverage contains a glyph in a bounded interval."""
        if start > end or self._record_count == 0:
            return False
        if self._format == 1:
            var low = 0
            var high = self._record_count
            while low < high:
                var middle = low + (high - low) // 2
                if _u16_unchecked(data, self._offset + 4 + 2 * middle) < start:
                    low = middle + 1
                else:
                    high = middle
            return (
                low < self._record_count
                and _u16_unchecked(data, self._offset + 4 + 2 * low) <= end
            )

        var low = 0
        var high = self._record_count
        while low < high:
            var middle = low + (high - low) // 2
            var record = self._offset + 4 + 6 * middle
            if _u16_unchecked(data, record + 2) < start:
                low = middle + 1
            else:
                high = middle
        if low == self._record_count:
            return False
        return _u16_unchecked(data, self._offset + 4 + 6 * low) <= end


def _parse_coverage(
    data: List[UInt8],
    offset: Int,
    root_offset: Int,
    root_length: Int,
    glyph_count: Int,
) raises -> Coverage:
    """Validate Coverage format 1 or 2, including canonical ordering."""
    _require_layout_range(data, offset, 4, root_offset, root_length, "GSUB coverage")
    var format = _u16(data, offset, "GSUB coverage format")
    var count = _u16(data, offset + 2, "GSUB coverage count")

    if format == 1:
        _ = _require_layout_size(
            data,
            offset,
            count,
            2,
            4,
            root_offset,
            root_length,
            "GSUB coverage format 1",
        )
        var previous = -1
        for index in range(count):
            var glyph = _u16(data, offset + 4 + 2 * index, "GSUB coverage glyph")
            if glyph <= previous:
                raise Error("unsorted or duplicate GSUB coverage glyphs")
            if glyph >= glyph_count:
                raise Error("GSUB coverage glyph ID is out of range")
            previous = glyph
        return Coverage(1, offset, count, count)

    if format == 2:
        _ = _require_layout_size(
            data,
            offset,
            count,
            6,
            4,
            root_offset,
            root_length,
            "GSUB coverage format 2",
        )
        var previous_end = -1
        var coverage_count = 0
        for index in range(count):
            var record = offset + 4 + 6 * index
            var start = _u16(data, record, "GSUB coverage range start")
            var end = _u16(data, record + 2, "GSUB coverage range end")
            var start_index = _u16(data, record + 4, "GSUB coverage start index")
            if start > end or start <= previous_end:
                raise Error("unsorted or overlapping GSUB coverage ranges")
            if end >= glyph_count:
                raise Error("GSUB coverage glyph ID is out of range")
            if start_index != coverage_count:
                raise Error("invalid GSUB coverage start index")
            coverage_count += end - start + 1
            if coverage_count > 0x10000:
                raise Error("GSUB coverage index overflows UInt16")
            previous_end = end
        return Coverage(2, offset, count, coverage_count)

    raise Error("unsupported GSUB coverage format")
