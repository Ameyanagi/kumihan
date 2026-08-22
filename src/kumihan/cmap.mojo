"""Validated OpenType ``cmap`` format 4 and 12 lookup plans."""

from std.collections import List

from .binary import (
    _require_range,
    _scaled_size,
    _u16,
    _u16_unchecked,
    _u32,
    _u32_unchecked,
)


struct Cmap(Copyable, ImplicitlyCopyable):
    """A compact, allocation-free lookup descriptor selected at parse time."""

    var _format: Int
    var _offset: Int
    var _length: Int
    var _count: Int
    var _glyph_count: Int

    def __init__(
        out self,
        format: Int,
        offset: Int,
        length: Int,
        count: Int,
        glyph_count: Int,
    ):
        self._format = format
        self._offset = offset
        self._length = length
        self._count = count
        self._glyph_count = glyph_count

    def glyph_id(self, data: List[UInt8], codepoint: Int) -> Int:
        """Map a Unicode scalar value to a glyph ID, or return ``0``."""
        if codepoint < 0 or codepoint > 0x10FFFF:
            return 0
        if codepoint >= 0xD800 and codepoint <= 0xDFFF:
            return 0
        if self._format == 4:
            return self._glyph_id_format4(data, codepoint)
        return self._glyph_id_format12(data, codepoint)

    def _glyph_id_format4(self, data: List[UInt8], codepoint: Int) -> Int:
        if codepoint > 0xFFFF:
            return 0

        var segment_count = self._count
        var end_codes = self._offset + 14
        var start_codes = end_codes + 2 * segment_count + 2
        var deltas = start_codes + 2 * segment_count
        var range_offsets = deltas + 2 * segment_count

        var low = 0
        var high = segment_count
        while low < high:
            var middle = low + (high - low) // 2
            if _u16_unchecked(data, end_codes + 2 * middle) < codepoint:
                low = middle + 1
            else:
                high = middle
        if low == segment_count:
            return 0

        var start = _u16_unchecked(data, start_codes + 2 * low)
        if codepoint < start:
            return 0
        var delta = _u16_unchecked(data, deltas + 2 * low)
        var range_offset = _u16_unchecked(data, range_offsets + 2 * low)
        var glyph: Int
        if range_offset == 0:
            glyph = (codepoint + delta) & 0xFFFF
        else:
            var address = (
                range_offsets + 2 * low + range_offset + 2 * (codepoint - start)
            )
            glyph = _u16_unchecked(data, address)
            if glyph != 0:
                glyph = (glyph + delta) & 0xFFFF
        return glyph if glyph < self._glyph_count else 0

    def _glyph_id_format12(self, data: List[UInt8], codepoint: Int) -> Int:
        var groups = self._offset + 16
        var low = 0
        var high = self._count
        while low < high:
            var middle = low + (high - low) // 2
            var record = groups + 12 * middle
            var end = _u32_unchecked(data, record + 4)
            if end < codepoint:
                low = middle + 1
            else:
                high = middle
        if low == self._count:
            return 0
        var record = groups + 12 * low
        var start = _u32_unchecked(data, record)
        if codepoint < start:
            return 0
        var glyph = _u32_unchecked(data, record + 8) + codepoint - start
        return glyph if glyph < self._glyph_count else 0


def _cmap_rank(platform: Int, encoding: Int, format: Int) -> Int:
    """Rank only specification-compatible Unicode cmap combinations."""
    if format == 12:
        if platform == 3 and encoding == 10:
            return 500
        if platform == 0 and (encoding == 4 or encoding == 6):
            return 400
    elif format == 4:
        if platform == 3 and encoding == 1:
            return 300
        if platform == 0 and encoding >= 0 and encoding <= 3:
            return 200
    return -1


def _is_mismatched_unicode_encoding(platform: Int, encoding: Int, format: Int) -> Bool:
    """Detect a supported format paired with an incompatible Unicode ID."""
    if format != 4 and format != 12:
        return False
    if platform == 0:
        return _cmap_rank(platform, encoding, format) < 0
    if platform == 3 and (encoding == 1 or encoding == 10):
        return _cmap_rank(platform, encoding, format) < 0
    return False


def _validate_format4(
    data: List[UInt8], offset: Int, cmap_end: Int, glyph_count: Int
) raises -> Cmap:
    _require_range(data, offset, 14, "cmap format 4 header")
    var length = _u16(data, offset + 2, "cmap format 4 length")
    if length < 24 or length > cmap_end - offset:
        raise Error("invalid cmap format 4 length")
    var segment_bytes = _u16(data, offset + 6, "cmap format 4 segments")
    if segment_bytes == 0 or segment_bytes & 1 != 0:
        raise Error("invalid cmap format 4 segment count")
    var count = segment_bytes // 2
    var expected_power = 1
    var expected_selector = 0
    while expected_power * 2 <= count:
        expected_power *= 2
        expected_selector += 1
    var expected_search_range = 2 * expected_power
    var expected_range_shift = segment_bytes - expected_search_range
    if (
        _u16(data, offset + 8, "cmap format 4 searchRange") != expected_search_range
        or _u16(data, offset + 10, "cmap format 4 entrySelector") != expected_selector
        or _u16(data, offset + 12, "cmap format 4 rangeShift") != expected_range_shift
    ):
        raise Error("invalid cmap format 4 search fields")
    var minimum = _scaled_size(count, 8, 16, "cmap format 4")
    if length < minimum:
        raise Error("truncated cmap format 4 arrays")

    var end_codes = offset + 14
    var reserved_pad = end_codes + 2 * count
    if _u16(data, reserved_pad, "cmap format 4 reservedPad") != 0:
        raise Error("invalid cmap format 4 reservedPad")
    var start_codes = end_codes + 2 * count + 2
    var deltas = start_codes + 2 * count
    var range_offsets = deltas + 2 * count
    var glyph_array = range_offsets + 2 * count
    var previous_end = -1
    for index in range(count):
        var end = _u16(data, end_codes + 2 * index, "cmap format 4 endCode")
        var start = _u16(data, start_codes + 2 * index, "cmap format 4 startCode")
        if start > end or start <= previous_end:
            raise Error("unsorted or overlapping cmap format 4 segments")
        previous_end = end

        var range_offset = _u16(
            data, range_offsets + 2 * index, "cmap format 4 idRangeOffset"
        )
        if range_offset & 1 != 0:
            raise Error("unaligned cmap format 4 idRangeOffset")
        if range_offset != 0:
            var address = range_offsets + 2 * index
            if range_offset < glyph_array - address:
                raise Error("cmap format 4 idRangeOffset points before glyphIdArray")
            # Test the largest referenced glyph. The start is necessarily no
            # later, so this proves every lookup in the segment is bounded.
            var span = end - start
            if (
                range_offset > offset + length - address
                or 2 * span > offset + length - address - range_offset - 2
            ):
                raise Error("cmap format 4 glyph array is out of bounds")
    if (
        previous_end != 0xFFFF
        or _u16(data, start_codes + 2 * (count - 1), "cmap format 4 sentinel") != 0xFFFF
    ):
        raise Error("cmap format 4 is missing its sentinel segment")
    return Cmap(4, offset, length, count, glyph_count)


def _validate_format12(
    data: List[UInt8], offset: Int, cmap_end: Int, glyph_count: Int
) raises -> Cmap:
    _require_range(data, offset, 16, "cmap format 12 header")
    if _u16(data, offset + 2, "cmap format 12 reserved") != 0:
        raise Error("invalid cmap format 12 reserved field")
    var length = _u32(data, offset + 4, "cmap format 12 length")
    if length < 16 or length > cmap_end - offset:
        raise Error("invalid cmap format 12 length")
    var count = _u32(data, offset + 12, "cmap format 12 group count")
    var minimum = _scaled_size(count, 12, 16, "cmap format 12")
    if length < minimum:
        raise Error("truncated cmap format 12 groups")

    var previous_end = -1
    for index in range(count):
        var record = offset + 16 + 12 * index
        var start = _u32(data, record, "cmap format 12 startCharCode")
        var end = _u32(data, record + 4, "cmap format 12 endCharCode")
        var glyph = _u32(data, record + 8, "cmap format 12 startGlyphID")
        if start > end or end > 0x10FFFF or start <= previous_end:
            raise Error("unsorted or overlapping cmap format 12 groups")
        if start <= 0xDFFF and end >= 0xD800:
            raise Error("cmap format 12 maps surrogate codepoints")
        if glyph >= glyph_count or end - start >= glyph_count - glyph:
            raise Error("cmap format 12 glyph ID is out of range")
        previous_end = end
    return Cmap(12, offset, length, count, glyph_count)


def _parse_cmap(
    data: List[UInt8], table_offset: Int, table_length: Int, glyph_count: Int
) raises -> Cmap:
    """Select and validate the best Unicode subtable exactly once."""
    _require_range(data, table_offset, table_length, "cmap table")
    if table_length < 4 or _u16(data, table_offset, "cmap version") != 0:
        raise Error("invalid cmap table header")
    var count = _u16(data, table_offset + 2, "cmap encoding count")
    var records_size = _scaled_size(count, 8, 4, "cmap encoding records")
    if records_size > table_length:
        raise Error("truncated cmap encoding records")

    var best_rank = -1
    var best_offset = -1
    var best_format = -1
    var cmap_end = table_offset + table_length
    for index in range(count):
        var record = table_offset + 4 + 8 * index
        var platform = _u16(data, record, "cmap platform")
        var encoding = _u16(data, record + 2, "cmap encoding")
        var relative = _u32(data, record + 4, "cmap subtable offset")
        if relative > table_length - 2:
            raise Error("cmap subtable offset is out of bounds")
        var subtable = table_offset + relative
        var format = _u16(data, subtable, "cmap format")
        if _is_mismatched_unicode_encoding(platform, encoding, format):
            raise Error("incompatible cmap platform, encoding, and format")
        var rank = _cmap_rank(platform, encoding, format)
        if rank > best_rank:
            best_rank = rank
            best_offset = subtable
            best_format = format

    if best_rank < 0:
        raise Error("font has no supported Unicode cmap")
    if best_format == 4:
        return _validate_format4(data, best_offset, cmap_end, glyph_count)
    return _validate_format12(data, best_offset, cmap_end, glyph_count)
