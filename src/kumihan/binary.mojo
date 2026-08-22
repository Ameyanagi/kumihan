"""Internal bounded big-endian readers for OpenType font data."""

from std.collections import List


def _require_range(
    data: List[UInt8], offset: Int, length: Int, context: String = "font data"
) raises:
    """Reject negative, overflowing, and truncated byte ranges."""
    if offset < 0 or length < 0 or offset > len(data) or length > len(data) - offset:
        raise Error("truncated " + context)


def _checked_table_range(
    data: List[UInt8], table_offset: Int, table_length: Int, context: String
) raises:
    """Validate one absolute table range without overflow-prone addition."""
    _require_range(data, table_offset, table_length, context)


def _u8(data: List[UInt8], offset: Int, context: String = "font data") raises -> Int:
    _require_range(data, offset, 1, context)
    return Int(data[offset])


def _u16(data: List[UInt8], offset: Int, context: String = "font data") raises -> Int:
    _require_range(data, offset, 2, context)
    return (Int(data[offset]) << 8) | Int(data[offset + 1])


def _i16(data: List[UInt8], offset: Int, context: String = "font data") raises -> Int:
    var value = _u16(data, offset, context)
    return value - 0x10000 if value >= 0x8000 else value


def _u32(data: List[UInt8], offset: Int, context: String = "font data") raises -> Int:
    _require_range(data, offset, 4, context)
    return (
        (Int(data[offset]) << 24)
        | (Int(data[offset + 1]) << 16)
        | (Int(data[offset + 2]) << 8)
        | Int(data[offset + 3])
    )


def _u16_unchecked(data: List[UInt8], offset: Int) -> Int:
    """Read after construction-time validation has proved the range live."""
    return (Int(data[offset]) << 8) | Int(data[offset + 1])


def _u32_unchecked(data: List[UInt8], offset: Int) -> Int:
    """Read after construction-time validation has proved the range live."""
    return (
        (Int(data[offset]) << 24)
        | (Int(data[offset + 1]) << 16)
        | (Int(data[offset + 2]) << 8)
        | Int(data[offset + 3])
    )


def _scaled_size(count: Int, stride: Int, base: Int, context: String) raises -> Int:
    """Compute ``base + count * stride`` with explicit integer checks."""
    if count < 0 or stride < 0 or base < 0:
        raise Error("invalid " + context + " size")
    # Counts read from SFNT are at most UInt32. This form avoids performing an
    # overflowing multiplication before it can be rejected.
    if stride != 0 and count > (Int.MAX - base) // stride:
        raise Error(context + " size overflow")
    return base + count * stride
