"""Safe, cached SFNT/TTC font-face parsing and horizontal metrics."""

from std.collections import List, Optional
from std.memory import ArcPointer

from .binary import _i16, _require_range, _scaled_size, _u16, _u16_unchecked, _u32
from .cmap import Cmap, _parse_cmap
from .gsub import Gsub, _parse_gsub


comptime _TAG_TTCF = 0x74746366
comptime _TAG_CMAP = 0x636D6170
comptime _TAG_GSUB = 0x47535542
comptime _TAG_HEAD = 0x68656164
comptime _TAG_HHEA = 0x68686561
comptime _TAG_HMTX = 0x686D7478
comptime _TAG_MAXP = 0x6D617870


struct TableRecord(Copyable, ImplicitlyCopyable):
    """One validated SFNT directory entry."""

    var tag: Int
    var offset: Int
    var length: Int

    def __init__(out self, tag: Int, offset: Int, length: Int):
        self.tag = tag
        self.offset = offset
        self.length = length


def _is_sfnt_version(value: Int) -> Bool:
    return (
        value == 0x00010000
        or value == 0x4F54544F  # OTTO
        or value == 0x74727565  # true
        or value == 0x74797031  # typ1
    )


def _face_offset(data: List[UInt8], face_index: Int) raises -> Int:
    if face_index < 0:
        raise Error("face_index must be non-negative")
    _require_range(data, 0, 4, "font header")
    var signature = _u32(data, 0, "font signature")
    if signature != _TAG_TTCF:
        if face_index != 0:
            raise Error("face_index is out of range for a single-face font")
        if not _is_sfnt_version(signature):
            raise Error("unsupported SFNT signature")
        return 0

    _require_range(data, 0, 12, "TTC header")
    var version = _u32(data, 4, "TTC version")
    if version != 0x00010000 and version != 0x00020000:
        raise Error("unsupported TTC version")
    var count = _u32(data, 8, "TTC face count")
    if count == 0:
        raise Error("TTC contains no faces")
    var offsets_size = _scaled_size(count, 4, 12, "TTC offsets")
    _require_range(data, 0, offsets_size, "TTC offsets")
    if face_index >= count:
        raise Error("face_index is out of range")
    var offset = _u32(data, 12 + 4 * face_index, "TTC face offset")
    _require_range(data, offset, 4, "TTC face")
    if not _is_sfnt_version(_u32(data, offset, "SFNT version")):
        raise Error("unsupported SFNT signature in TTC")
    return offset


def _sift_tables_down(mut tables: List[TableRecord], start: Int, end: Int):
    """Restore a max heap rooted at ``start`` within ``[start, end]``."""
    var root = start
    while 2 * root + 1 <= end:
        var child = 2 * root + 1
        if child + 1 <= end and tables[child].tag < tables[child + 1].tag:
            child += 1
        if tables[root].tag >= tables[child].tag:
            return
        tables.swap_elements(root, child)
        root = child


def _sort_tables_by_tag(mut tables: List[TableRecord]):
    """Sort records in-place in O(n log n) time and O(1) extra space."""
    if len(tables) < 2:
        return

    var start = (len(tables) - 2) // 2
    while True:
        _sift_tables_down(tables, start, len(tables) - 1)
        if start == 0:
            break
        start -= 1

    var end = len(tables) - 1
    while end > 0:
        tables.swap_elements(0, end)
        end -= 1
        _sift_tables_down(tables, 0, end)


def _reject_duplicate_tables(tables: List[TableRecord]) raises:
    for index in range(1, len(tables)):
        if tables[index - 1].tag == tables[index].tag:
            raise Error("duplicate SFNT table")


def _parse_directory(data: List[UInt8], offset: Int) raises -> List[TableRecord]:
    _require_range(data, offset, 12, "SFNT offset table")
    if not _is_sfnt_version(_u32(data, offset, "SFNT version")):
        raise Error("unsupported SFNT signature")
    var count = _u16(data, offset + 4, "SFNT table count")
    if count == 0:
        raise Error("SFNT contains no tables")
    var directory_size = _scaled_size(count, 16, 12, "SFNT directory")
    _require_range(data, offset, directory_size, "SFNT directory")

    var tables = List[TableRecord](capacity=count)
    for index in range(count):
        var record = offset + 12 + 16 * index
        var tag = _u32(data, record, "SFNT table tag")
        var table_offset = _u32(data, record + 8, "SFNT table offset")
        var table_length = _u32(data, record + 12, "SFNT table length")
        _require_range(data, table_offset, table_length, "SFNT table")
        tables.append(TableRecord(tag, table_offset, table_length))
    _sort_tables_by_tag(tables)
    _reject_duplicate_tables(tables)
    return tables^


def _require_table(tables: List[TableRecord], tag: Int) raises -> TableRecord:
    var low = 0
    var high = len(tables)
    while low < high:
        var middle = low + (high - low) // 2
        if tables[middle].tag < tag:
            low = middle + 1
        else:
            high = middle
    if low == len(tables) or tables[low].tag != tag:
        raise Error("font is missing a required SFNT table")
    return tables[low]


def _find_table(tables: List[TableRecord], tag: Int) -> Optional[TableRecord]:
    """Find an optional table in the sorted directory in O(log n) time."""
    var low = 0
    var high = len(tables)
    while low < high:
        var middle = low + (high - low) // 2
        if tables[middle].tag < tag:
            low = middle + 1
        else:
            high = middle
    if low == len(tables) or tables[low].tag != tag:
        return None
    return tables[low]


struct FontFace(Movable):
    """A validated font face sharing immutable bytes with its collection.

    Construction performs every structural check needed by hot lookups.
    ``glyph_id`` and ``advance_width`` are therefore allocation-free and do
    not raise. The face is movable rather than copyable so large font buffers
    are never duplicated implicitly. The backing bytes are reference counted,
    so faces from a TTC/OTC share one allocation.
    """

    var _data: ArcPointer[List[UInt8]]
    var _tables: List[TableRecord]
    var _cmap: Cmap
    var _gsub: Gsub
    var _units_per_em: Int
    var _ascender: Int
    var _descender: Int
    var _line_gap: Int
    var _glyph_count: Int
    var _hmtx_offset: Int
    var _horizontal_metric_count: Int

    def __init__(
        out self,
        var data: ArcPointer[List[UInt8]],
        var tables: List[TableRecord],
        cmap: Cmap,
        gsub: Gsub,
        units_per_em: Int,
        ascender: Int,
        descender: Int,
        line_gap: Int,
        glyph_count: Int,
        hmtx_offset: Int,
        horizontal_metric_count: Int,
    ):
        self._data = data^
        self._tables = tables^
        self._cmap = cmap
        self._gsub = gsub
        self._units_per_em = units_per_em
        self._ascender = ascender
        self._descender = descender
        self._line_gap = line_gap
        self._glyph_count = glyph_count
        self._hmtx_offset = hmtx_offset
        self._horizontal_metric_count = horizontal_metric_count

    @staticmethod
    def from_bytes(var data: List[UInt8], face_index: Int = 0) raises -> Self:
        """Own font bytes and parse one face; use FontCollection for many."""
        var directory_offset = _face_offset(data, face_index)
        var shared_data = ArcPointer(data^)
        return Self._from_shared(shared_data^, directory_offset)

    @staticmethod
    def _from_shared(
        var data: ArcPointer[List[UInt8]], directory_offset: Int
    ) raises -> Self:
        """Parse a face while retaining shared ownership of its font bytes."""
        var tables = _parse_directory(data[], directory_offset)
        var head = _require_table(tables, _TAG_HEAD)
        var maxp = _require_table(tables, _TAG_MAXP)
        var hhea = _require_table(tables, _TAG_HHEA)
        var hmtx = _require_table(tables, _TAG_HMTX)
        var cmap_table = _require_table(tables, _TAG_CMAP)

        if head.length < 54:
            raise Error("head table is too short")
        if _u32(data[], head.offset + 12, "head magic number") != 0x5F0F3CF5:
            raise Error("invalid head magic number")
        var units_per_em = _u16(data[], head.offset + 18, "unitsPerEm")
        if units_per_em < 16 or units_per_em > 16384:
            raise Error("unitsPerEm is outside the OpenType range")

        if maxp.length < 6:
            raise Error("maxp table is too short")
        var glyph_count = _u16(data[], maxp.offset + 4, "numGlyphs")
        if glyph_count == 0:
            raise Error("font contains no glyphs")

        if hhea.length < 36:
            raise Error("hhea table is too short")
        var ascender = _i16(data[], hhea.offset + 4, "hhea ascender")
        var descender = _i16(data[], hhea.offset + 6, "hhea descender")
        var line_gap = _i16(data[], hhea.offset + 8, "hhea lineGap")
        var horizontal_metric_count = _u16(data[], hhea.offset + 34, "numberOfHMetrics")
        if horizontal_metric_count == 0 or horizontal_metric_count > glyph_count:
            raise Error("invalid numberOfHMetrics")

        var long_metric_bytes = _scaled_size(
            horizontal_metric_count, 4, 0, "hmtx long metrics"
        )
        var bearing_bytes = _scaled_size(
            glyph_count - horizontal_metric_count, 2, 0, "hmtx bearings"
        )
        if bearing_bytes > Int.MAX - long_metric_bytes:
            raise Error("hmtx size overflow")
        if hmtx.length < long_metric_bytes + bearing_bytes:
            raise Error("hmtx table is too short")

        var cmap = _parse_cmap(
            data[], cmap_table.offset, cmap_table.length, glyph_count
        )
        var gsub = Gsub.absent(glyph_count)
        var gsub_table = _find_table(tables, _TAG_GSUB)
        if gsub_table:
            var record = gsub_table.value()
            gsub = _parse_gsub(data[], record.offset, record.length, glyph_count)
        return Self(
            data^,
            tables^,
            cmap,
            gsub,
            units_per_em,
            ascender,
            descender,
            line_gap,
            glyph_count,
            hmtx.offset,
            horizontal_metric_count,
        )

    def glyph_id(self, codepoint: Int) -> Int:
        """Return the mapped glyph ID, or ``0`` for an unmapped scalar."""
        return self._cmap.glyph_id(self._data[], codepoint)

    def variation_glyph_id(
        self, codepoint: Int, variation_selector: Int
    ) -> Optional[Int]:
        """Return a supported variation glyph, or ``None`` when unsupported.

        Default UVSes resolve through the primary Unicode cmap; non-default
        UVSes return their explicit format 14 glyph ID.
        """
        return self._cmap.variation_glyph_id(
            self._data[], codepoint, variation_selector
        )

    def _apply_locl(
        self,
        mut glyph_ids: List[Int],
        script_tag: Int,
        language_tag: Int,
    ) raises -> Bool:
        """Apply the parsed ``locl`` substitutions to glyph IDs in place."""
        return self._gsub.apply_locl(self._data[], glyph_ids, script_tag, language_tag)

    def _apply_locl_into(
        self,
        mut glyph_ids: List[Int],
        script_tag: Int,
        language_tag: Int,
        mut lookup_mask: List[UInt8],
        mut feature_offsets: List[Int],
    ) raises -> Bool:
        """Apply ``locl`` while retaining caller-owned selection scratch."""
        return self._gsub.apply_locl_into(
            self._data[],
            glyph_ids,
            script_tag,
            language_tag,
            lookup_mask,
            feature_offsets,
        )

    def advance_width(self, glyph_id: Int) -> Int:
        """Return a glyph's horizontal advance, or ``0`` for an invalid ID."""
        if glyph_id < 0 or glyph_id >= self._glyph_count:
            return 0
        var metric_index = min(glyph_id, self._horizontal_metric_count - 1)
        return _u16_unchecked(self._data[], self._hmtx_offset + 4 * metric_index)

    def units_per_em(self) -> Int:
        return self._units_per_em

    def ascender(self) -> Int:
        return self._ascender

    def descender(self) -> Int:
        return self._descender

    def line_gap(self) -> Int:
        return self._line_gap

    def glyph_count(self) -> Int:
        return self._glyph_count


struct FontCollection(Movable):
    """An owned SFNT/TTC buffer that can create zero-copy shared faces."""

    var _data: ArcPointer[List[UInt8]]
    var _face_offsets: List[Int]

    def __init__(
        out self, var data: ArcPointer[List[UInt8]], var face_offsets: List[Int]
    ):
        self._data = data^
        self._face_offsets = face_offsets^

    @staticmethod
    def from_bytes(var data: List[UInt8]) raises -> Self:
        """Validate the collection header once and take ownership of bytes."""
        _require_range(data, 0, 4, "font header")
        var signature = _u32(data, 0, "font signature")
        var offsets = List[Int]()
        if signature != _TAG_TTCF:
            if not _is_sfnt_version(signature):
                raise Error("unsupported SFNT signature")
            offsets.append(0)
        else:
            _require_range(data, 0, 12, "TTC header")
            var version = _u32(data, 4, "TTC version")
            if version != 0x00010000 and version != 0x00020000:
                raise Error("unsupported TTC version")
            var count = _u32(data, 8, "TTC face count")
            if count == 0:
                raise Error("TTC contains no faces")
            var offsets_size = _scaled_size(count, 4, 12, "TTC offsets")
            _require_range(data, 0, offsets_size, "TTC offsets")
            offsets = List[Int](capacity=count)
            for index in range(count):
                var offset = _u32(data, 12 + 4 * index, "TTC face offset")
                _require_range(data, offset, 4, "TTC face")
                if not _is_sfnt_version(_u32(data, offset, "SFNT version")):
                    raise Error("unsupported SFNT signature in TTC")
                offsets.append(offset)
        var shared_data = ArcPointer(data^)
        return Self(shared_data^, offsets^)

    def face_count(self) -> Int:
        """Return the number of faces in this font or collection."""
        return len(self._face_offsets)

    def face(self, face_index: Int = 0) raises -> FontFace:
        """Parse one face while sharing this collection's backing bytes."""
        if face_index < 0:
            raise Error("face_index must be non-negative")
        if face_index >= len(self._face_offsets):
            raise Error("face_index is out of range")
        return FontFace._from_shared(self._data, self._face_offsets[face_index])
