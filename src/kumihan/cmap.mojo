"""Validated OpenType Unicode and variation-sequence lookup plans."""

from std.collections import List, Optional

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
    var _variation_offset: Int
    var _variation_length: Int
    var _variation_count: Int

    def __init__(
        out self,
        format: Int,
        offset: Int,
        length: Int,
        count: Int,
        glyph_count: Int,
        variation_offset: Int = -1,
        variation_length: Int = 0,
        variation_count: Int = 0,
    ):
        self._format = format
        self._offset = offset
        self._length = length
        self._count = count
        self._glyph_count = glyph_count
        self._variation_offset = variation_offset
        self._variation_length = variation_length
        self._variation_count = variation_count

    def _with_variations(self, offset: Int, length: Int, count: Int) -> Self:
        return Self(
            self._format,
            self._offset,
            self._length,
            self._count,
            self._glyph_count,
            offset,
            length,
            count,
        )

    def glyph_id(self, data: List[UInt8], codepoint: Int) -> Int:
        """Map a Unicode scalar value to a glyph ID, or return ``0``."""
        if codepoint < 0 or codepoint > 0x10FFFF:
            return 0
        if codepoint >= 0xD800 and codepoint <= 0xDFFF:
            return 0
        if self._format == 4:
            return self._glyph_id_format4(data, codepoint)
        return self._glyph_id_format12(data, codepoint)

    def variation_glyph_id(
        self, data: List[UInt8], codepoint: Int, variation_selector: Int
    ) -> Optional[Int]:
        """Resolve a supported UVS, preserving absence as ``None``.

        A default UVS returns the glyph from the primary Unicode cmap. A
        non-default UVS returns the explicit format 14 glyph. An unknown
        selector or unsupported base/selector pair returns ``None``.
        """
        if not _is_unicode_scalar(codepoint):
            return None
        if not _is_variation_selector(variation_selector):
            return None
        if self._variation_offset < 0:
            return None

        var records = self._variation_offset + 10
        var low = 0
        var high = self._variation_count
        while low < high:
            var middle = low + (high - low) // 2
            var selector = _u24_unchecked(data, records + 11 * middle)
            if selector < variation_selector:
                low = middle + 1
            else:
                high = middle
        if low == self._variation_count:
            return None

        var record = records + 11 * low
        if _u24_unchecked(data, record) != variation_selector:
            return None

        # Non-default mappings take the explicit glyph. Validation guarantees
        # that a base cannot also appear in this selector's default ranges.
        var non_default_relative = _u32_unchecked(data, record + 7)
        if non_default_relative != 0:
            var table = self._variation_offset + non_default_relative
            var mapping_count = _u32_unchecked(data, table)
            var mapping_low = 0
            var mapping_high = mapping_count
            while mapping_low < mapping_high:
                var middle = mapping_low + (mapping_high - mapping_low) // 2
                var mapped = _u24_unchecked(data, table + 4 + 5 * middle)
                if mapped < codepoint:
                    mapping_low = middle + 1
                else:
                    mapping_high = middle
            if mapping_low < mapping_count:
                var mapping = table + 4 + 5 * mapping_low
                if _u24_unchecked(data, mapping) == codepoint:
                    return _u16_unchecked(data, mapping + 3)

        var default_relative = _u32_unchecked(data, record + 3)
        if default_relative == 0:
            return None
        var table = self._variation_offset + default_relative
        var range_count = _u32_unchecked(data, table)
        var range_low = 0
        var range_high = range_count
        while range_low < range_high:
            var middle = range_low + (range_high - range_low) // 2
            var range_record = table + 4 + 4 * middle
            var range_end = _u24_unchecked(data, range_record) + Int(
                data[range_record + 3]
            )
            if range_end < codepoint:
                range_low = middle + 1
            else:
                range_high = middle
        if range_low == range_count:
            return None
        var range_record = table + 4 + 4 * range_low
        if codepoint < _u24_unchecked(data, range_record):
            return None
        return self.glyph_id(data, codepoint)

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


def _u24_unchecked(data: List[UInt8], offset: Int) -> Int:
    return (
        (Int(data[offset]) << 16) | (Int(data[offset + 1]) << 8) | Int(data[offset + 2])
    )


def _is_unicode_scalar(value: Int) -> Bool:
    return value >= 0 and value <= 0x10FFFF and (value < 0xD800 or value > 0xDFFF)


def _is_variation_selector(value: Int) -> Bool:
    # Unicode 17 contains four Mongolian free variation selectors, sixteen
    # standardized selectors, and 240 ideographic variation selectors.
    return (
        (value >= 0x180B and value <= 0x180D)
        or value == 0x180F
        or (value >= 0xFE00 and value <= 0xFE0F)
        or (value >= 0xE0100 and value <= 0xE01EF)
    )


def _cmap_rank(platform: Int, encoding: Int, format: Int) -> Int:
    """Rank only specification-compatible Unicode cmap combinations."""
    if format == 12:
        if platform == 3 and encoding == 10:
            return 500
        if platform == 0 and encoding == 4:
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
    if _u16(data, offset + 4, "cmap format 4 language") != 0:
        raise Error("Unicode cmap format 4 language must be zero")
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
    if _u32(data, offset + 8, "cmap format 12 language") != 0:
        raise Error("Unicode cmap format 12 language must be zero")
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


def _checked_uvs_table_offset(
    format_offset: Int,
    format_length: Int,
    records_length: Int,
    relative: Int,
    context: String,
) raises -> Int:
    """Resolve a non-zero format 14 child offset within the subtable."""
    if relative < records_length or relative > format_length - 4:
        raise Error(context + " offset is out of bounds")
    return format_offset + relative


def _validate_default_uvs(
    data: List[UInt8],
    format_offset: Int,
    format_length: Int,
    records_length: Int,
    relative: Int,
) raises:
    var offset = _checked_uvs_table_offset(
        format_offset,
        format_length,
        records_length,
        relative,
        "cmap format 14 default UVS",
    )
    var count = _u32(data, offset, "cmap format 14 default UVS range count")
    var length = _scaled_size(count, 4, 4, "cmap format 14 default UVS")
    if length > format_length - relative:
        raise Error("truncated cmap format 14 default UVS ranges")

    var previous_end = -1
    for index in range(count):
        var record = offset + 4 + 4 * index
        var start = _u24_unchecked(data, record)
        var end = start + Int(data[record + 3])
        if not _is_unicode_scalar(start) or not _is_unicode_scalar(end):
            raise Error("cmap format 14 default UVS contains a non-scalar value")
        if start <= previous_end:
            raise Error("unsorted or overlapping cmap format 14 default UVS ranges")
        previous_end = end


def _validate_non_default_uvs(
    data: List[UInt8],
    format_offset: Int,
    format_length: Int,
    records_length: Int,
    relative: Int,
    glyph_count: Int,
) raises:
    var offset = _checked_uvs_table_offset(
        format_offset,
        format_length,
        records_length,
        relative,
        "cmap format 14 non-default UVS",
    )
    var count = _u32(data, offset, "cmap format 14 non-default UVS mapping count")
    var length = _scaled_size(count, 5, 4, "cmap format 14 non-default UVS")
    if length > format_length - relative:
        raise Error("truncated cmap format 14 non-default UVS mappings")

    var previous = -1
    for index in range(count):
        var record = offset + 4 + 5 * index
        var codepoint = _u24_unchecked(data, record)
        var glyph = _u16_unchecked(data, record + 3)
        if not _is_unicode_scalar(codepoint):
            raise Error("cmap format 14 non-default UVS contains a non-scalar value")
        if codepoint <= previous:
            raise Error("unsorted cmap format 14 non-default UVS mappings")
        if glyph >= glyph_count:
            raise Error("cmap format 14 non-default glyph ID is out of range")
        previous = codepoint


def _validate_uvs_partition(
    data: List[UInt8],
    format_offset: Int,
    default_relative: Int,
    non_default_relative: Int,
) raises:
    """Reject a base listed as both default and non-default for one selector."""
    var default_table = format_offset + default_relative
    var non_default_table = format_offset + non_default_relative
    var range_count = _u32_unchecked(data, default_table)
    var mapping_count = _u32_unchecked(data, non_default_table)
    var range_index = 0
    var mapping_index = 0
    while range_index < range_count and mapping_index < mapping_count:
        var range_record = default_table + 4 + 4 * range_index
        var start = _u24_unchecked(data, range_record)
        var end = start + Int(data[range_record + 3])
        var mapping_record = non_default_table + 4 + 5 * mapping_index
        var codepoint = _u24_unchecked(data, mapping_record)
        if codepoint < start:
            mapping_index += 1
        elif codepoint > end:
            range_index += 1
        else:
            raise Error("cmap format 14 base is both default and non-default")


def _list_contains(values: List[Int], value: Int) -> Bool:
    for candidate in values:
        if candidate == value:
            return True
    return False


def _pair_is_cached(
    defaults: List[Int], non_defaults: List[Int], default: Int, non_default: Int
) -> Bool:
    for index in range(len(defaults)):
        if defaults[index] == default and non_defaults[index] == non_default:
            return True
    return False


def _validate_format14(
    data: List[UInt8], offset: Int, cmap_end: Int, glyph_count: Int
) raises -> Tuple[Int, Int]:
    """Validate one Unicode variation-sequence subtable exactly once."""
    _require_range(data, offset, 10, "cmap format 14 header")
    var length = _u32(data, offset + 2, "cmap format 14 length")
    if length < 10 or length > cmap_end - offset:
        raise Error("invalid cmap format 14 length")
    var count = _u32(data, offset + 6, "cmap format 14 selector count")
    var records_length = _scaled_size(count, 11, 10, "cmap format 14 records")
    if records_length > length:
        raise Error("truncated cmap format 14 selector records")

    var previous_selector = -1
    for index in range(count):
        var record = offset + 10 + 11 * index
        var selector = _u24_unchecked(data, record)
        if not _is_variation_selector(selector):
            raise Error("cmap format 14 record has an invalid variation selector")
        if selector <= previous_selector:
            raise Error("unsorted or duplicate cmap format 14 variation selectors")
        previous_selector = selector
        var default_relative = _u32_unchecked(data, record + 3)
        var non_default_relative = _u32_unchecked(data, record + 7)
        if default_relative != 0:
            _ = _checked_uvs_table_offset(
                offset,
                length,
                records_length,
                default_relative,
                "cmap format 14 default UVS",
            )
        if non_default_relative != 0:
            _ = _checked_uvs_table_offset(
                offset,
                length,
                records_length,
                non_default_relative,
                "cmap format 14 non-default UVS",
            )

    # Exact offsets may be shared by multiple selector records. Cache each
    # (kind, offset) validation so aliases cannot amplify array scans. Because
    # valid Unicode has only 260 variation selectors, these tiny linear caches
    # perform at most 67,600 integer comparisons even for hostile input.
    var validated_defaults = List[Int](capacity=count)
    var validated_non_defaults = List[Int](capacity=count)
    var partition_defaults = List[Int](capacity=count)
    var partition_non_defaults = List[Int](capacity=count)
    for index in range(count):
        var record = offset + 10 + 11 * index
        var default_relative = _u32_unchecked(data, record + 3)
        var non_default_relative = _u32_unchecked(data, record + 7)
        if default_relative != 0 and not _list_contains(
            validated_defaults, default_relative
        ):
            _validate_default_uvs(
                data, offset, length, records_length, default_relative
            )
            validated_defaults.append(default_relative)
        if non_default_relative != 0 and not _list_contains(
            validated_non_defaults, non_default_relative
        ):
            _validate_non_default_uvs(
                data,
                offset,
                length,
                records_length,
                non_default_relative,
                glyph_count,
            )
            validated_non_defaults.append(non_default_relative)
        if (
            default_relative != 0
            and non_default_relative != 0
            and not _pair_is_cached(
                partition_defaults,
                partition_non_defaults,
                default_relative,
                non_default_relative,
            )
        ):
            _validate_uvs_partition(
                data, offset, default_relative, non_default_relative
            )
            partition_defaults.append(default_relative)
            partition_non_defaults.append(non_default_relative)
    return (length, count)


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
    var variation_offset = -1
    var previous_encoding_key = -1
    var cmap_end = table_offset + table_length
    for index in range(count):
        var record = table_offset + 4 + 8 * index
        var platform = _u16(data, record, "cmap platform")
        var encoding = _u16(data, record + 2, "cmap encoding")
        var encoding_key = (platform << 16) | encoding
        if encoding_key < previous_encoding_key:
            raise Error("unsorted cmap encoding records")
        var repeats_encoding = encoding_key == previous_encoding_key
        previous_encoding_key = encoding_key
        var relative = _u32(data, record + 4, "cmap subtable offset")
        if relative < records_size or relative > table_length - 2:
            raise Error("cmap subtable offset is out of bounds")
        var subtable = table_offset + relative
        var format = _u16(data, subtable, "cmap format")
        if format == 14:
            if platform != 0 or encoding != 5:
                raise Error("cmap format 14 requires platform 0 encoding 5")
            if variation_offset >= 0:
                raise Error("font has duplicate cmap format 14 subtables")
            variation_offset = subtable
            continue
        if platform == 0 and encoding == 5:
            raise Error("cmap platform 0 encoding 5 requires format 14")
        if _is_mismatched_unicode_encoding(platform, encoding, format):
            raise Error("incompatible cmap platform, encoding, and format")
        var rank = _cmap_rank(platform, encoding, format)
        if repeats_encoding and rank >= 0:
            raise Error("duplicate supported Unicode cmap encoding")
        if rank > best_rank:
            best_rank = rank
            best_offset = subtable
            best_format = format

    if best_rank < 0:
        raise Error("font has no supported Unicode cmap")
    var cmap: Cmap
    if best_format == 4:
        cmap = _validate_format4(data, best_offset, cmap_end, glyph_count)
    else:
        cmap = _validate_format12(data, best_offset, cmap_end, glyph_count)
    if variation_offset >= 0:
        var variation_length, variation_count = _validate_format14(
            data, variation_offset, cmap_end, glyph_count
        )
        return cmap._with_variations(
            variation_offset, variation_length, variation_count
        )
    return cmap
