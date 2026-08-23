"""Validated OpenType GSUB selection and SingleSubst execution.

Kumihan initially executes required and ``locl`` features only.  Parsing still
accepts the other standard GSUB lookup types so fonts can carry unrelated
shaping data without making nominal CJK localization unusable.
"""

from std.collections import List, Set

from .binary import _require_range, _u16, _u16_unchecked, _u32, _u32_unchecked
from .layout import (
    Coverage,
    _parse_coverage,
    _require_layout_range,
    _require_layout_size,
    _resolve_offset16,
    _resolve_offset32,
    _validate_layout_tag,
)


comptime _TAG_DFLT = 0x44464C54
comptime _TAG_DFLT_LANGUAGE = 0x64666C74
comptime _TAG_LOCL = 0x6C6F636C
comptime _TAG_VERT = 0x76657274
comptime _TAG_VRT2 = 0x76727432
comptime _TAG_VRTR = 0x76727472
comptime _TAG_VKNA = 0x766B6E61


struct _ValidationMemo(Movable):
    """Parse-local interning sets for the GSUB child-table DAG."""

    var lookups: Set[Int]
    var singles: Set[Int]
    var extensions: Set[Int]
    var coverages: Set[Int]
    var features: Set[Int]
    var scripts: Set[Int]
    var language_systems: Set[Int]

    def __init__(out self):
        self.lookups = Set[Int]()
        self.singles = Set[Int]()
        self.extensions = Set[Int]()
        self.coverages = Set[Int]()
        self.features = Set[Int]()
        self.scripts = Set[Int]()
        self.language_systems = Set[Int]()


struct _GsubPlan(Copyable, ImplicitlyCopyable):
    """One preflighted selection into shared ordered lookup indices."""

    var _resolved: Bool
    var _lookup_list: Int
    var _selected_start: Int
    var _selected_count: Int

    def __init__(
        out self,
        resolved: Bool,
        lookup_list: Int,
        selected_start: Int,
        selected_count: Int,
    ):
        self._resolved = resolved
        self._lookup_list = lookup_list
        self._selected_start = selected_start
        self._selected_count = selected_count

    @staticmethod
    def unresolved() -> Self:
        return Self(False, -1, 0, 0)

    @staticmethod
    def no_op() -> Self:
        return Self(True, -1, 0, 0)

    def is_resolved(self) -> Bool:
        return self._resolved


struct Gsub(Copyable, ImplicitlyCopyable):
    """Compact descriptor for one validated GSUB table, or an absent table."""

    var _offset: Int
    var _length: Int
    var _glyph_count: Int

    def __init__(out self, offset: Int, length: Int, glyph_count: Int):
        self._offset = offset
        self._length = length
        self._glyph_count = glyph_count

    @staticmethod
    def absent(glyph_count: Int) -> Self:
        """Construct a no-op descriptor for fonts without GSUB."""
        return Self(-1, 0, glyph_count)

    def apply_locl(
        self,
        data: List[UInt8],
        mut glyph_ids: List[Int],
        script_tag: Int,
        language_tag: Int,
    ) raises -> Bool:
        """Apply ``locl`` using temporary scratch; retained for focused tests."""
        var lookup_mask = List[UInt8]()
        var feature_offsets = List[Int]()
        return self.apply_locl_into(
            data,
            glyph_ids,
            script_tag,
            language_tag,
            lookup_mask,
            feature_offsets,
        )

    def apply_locl_into(
        self,
        data: List[UInt8],
        mut glyph_ids: List[Int],
        script_tag: Int,
        language_tag: Int,
        mut lookup_mask: List[UInt8],
        mut feature_offsets: List[Int],
    ) raises -> Bool:
        """Apply required and ``locl`` lookups to the complete glyph list."""
        return self.apply_locl_range_into(
            data,
            glyph_ids,
            0,
            len(glyph_ids),
            script_tag,
            language_tag,
            lookup_mask,
            feature_offsets,
        )

    def apply_locl_range_into(
        self,
        data: List[UInt8],
        mut glyph_ids: List[Int],
        glyph_start: Int,
        glyph_end: Int,
        script_tag: Int,
        language_tag: Int,
        mut lookup_mask: List[UInt8],
        mut feature_offsets: List[Int],
    ) raises -> Bool:
        """Apply required and ``locl`` lookups with caller-reusable selection.

        Physical Features are gathered and sorted in ``feature_offsets`` so
        aliases are traversed once while resolving the temporary mask. The
        selected lookup indices remain in LookupList order, so range execution
        skips every unselected lookup. Both scratch allocations are retained
        for the next call.
        """
        lookup_mask.clear()
        feature_offsets.clear()
        if glyph_start < 0 or glyph_end < glyph_start or glyph_end > len(glyph_ids):
            raise Error("input GSUB glyph range is out of bounds")
        if self._offset < 0:
            return False
        self._validate_locl_request(data, script_tag, language_tag)
        for glyph_index in range(glyph_start, glyph_end):
            var glyph_id = glyph_ids[glyph_index]
            if glyph_id < 0 or glyph_id >= self._glyph_count:
                raise Error("input GSUB glyph ID is out of range")
        if glyph_start == glyph_end:
            return False

        var selected_lookups = List[UInt16]()
        var plan = self._resolve_locl_plan_from_validated_into(
            data,
            script_tag,
            language_tag,
            lookup_mask,
            feature_offsets,
            selected_lookups,
        )
        return self._apply_locl_plan_range_from_validated_into(
            data, glyph_ids, glyph_start, glyph_end, plan, selected_lookups
        )

    def _validate_locl_request(
        self, data: List[UInt8], script_tag: Int, language_tag: Int
    ) raises:
        _require_range(data, self._offset, self._length, "GSUB table")
        if script_tag != 0:
            _validate_layout_tag(script_tag, "requested GSUB script")
        if language_tag != 0:
            _validate_layout_tag(language_tag, "requested GSUB language")

    def resolve_locl_plan_into(
        self,
        data: List[UInt8],
        script_tag: Int,
        language_tag: Int,
        mut lookup_mask: List[UInt8],
        mut feature_offsets: List[Int],
        mut selected_lookups: List[UInt16],
    ) raises -> _GsubPlan:
        """Resolve and preflight one reusable script/language lookup plan.

        The byte mask is temporary construction scratch. Ordered selected
        indices are appended to shared caller-owned storage so several compact
        plans can coexist for non-contiguous automatic-script runs. Both
        allocations retain capacity across resolutions.
        """
        lookup_mask.clear()
        feature_offsets.clear()
        if self._offset < 0:
            return _GsubPlan.no_op()
        self._validate_locl_request(data, script_tag, language_tag)
        return self._resolve_locl_plan_from_validated_into(
            data,
            script_tag,
            language_tag,
            lookup_mask,
            feature_offsets,
            selected_lookups,
        )

    def _resolve_locl_plan_from_validated_into(
        self,
        data: List[UInt8],
        script_tag: Int,
        language_tag: Int,
        mut lookup_mask: List[UInt8],
        mut feature_offsets: List[Int],
        mut selected_lookups: List[UInt16],
    ) raises -> _GsubPlan:
        var script_list = self._offset + _u16_unchecked(data, self._offset + 4)
        var feature_list = self._offset + _u16_unchecked(data, self._offset + 6)
        var lookup_list = self._offset + _u16_unchecked(data, self._offset + 8)
        var lang_sys = _select_lang_sys(data, script_list, script_tag, language_tag)
        if lang_sys < 0:
            return _GsubPlan.no_op()
        var lookup_count = _u16_unchecked(data, lookup_list)
        var selected_start = len(selected_lookups)
        try:
            _preflight_required_feature(data, lang_sys, feature_list)
            _gather_feature_offsets(data, lang_sys, feature_list, feature_offsets)
            if len(feature_offsets) == 0:
                return _GsubPlan.no_op()

            # The full byte mask is temporary plan-construction scratch only.
            lookup_mask.reserve(lookup_count)
            for _ in range(lookup_count):
                lookup_mask.append(UInt8(0))
            _resolve_lookup_mask(data, feature_offsets, lookup_mask)

            # Preflight precedes glyph mutation. On failure the partially
            # appended compact scratch is cleared with the temporary mask.
            for lookup_index in range(lookup_count):
                if lookup_mask[lookup_index] != 0:
                    var lookup = _lookup_at(data, lookup_list, lookup_index)
                    _preflight_selected_lookup(data, lookup)
                    selected_lookups.append(UInt16(lookup_index))
        except error:
            lookup_mask.clear()
            feature_offsets.clear()
            selected_lookups.clear()
            raise error

        return _GsubPlan(
            True,
            lookup_list,
            selected_start,
            len(selected_lookups) - selected_start,
        )

    def apply_locl_plan_range_into(
        self,
        data: List[UInt8],
        mut glyph_ids: List[Int],
        glyph_start: Int,
        glyph_end: Int,
        plan: _GsubPlan,
        selected_lookups: List[UInt16],
    ) raises -> Bool:
        """Execute one preflighted plan over a half-open glyph range."""
        if glyph_start < 0 or glyph_end < glyph_start or glyph_end > len(glyph_ids):
            raise Error("input GSUB glyph range is out of bounds")
        if self._offset < 0:
            return False
        for glyph_index in range(glyph_start, glyph_end):
            var glyph_id = glyph_ids[glyph_index]
            if glyph_id < 0 or glyph_id >= self._glyph_count:
                raise Error("input GSUB glyph ID is out of range")
        if glyph_start == glyph_end:
            return False
        if not plan.is_resolved():
            raise Error("unresolved GSUB plan")
        if plan._selected_count == 0:
            return False
        if (
            plan._selected_start < 0
            or plan._selected_start > len(selected_lookups)
            or plan._selected_count < 0
            or plan._selected_count > len(selected_lookups) - plan._selected_start
        ):
            raise Error("GSUB plan selected lookups are out of bounds")
        return self._apply_locl_plan_range_from_validated_into(
            data, glyph_ids, glyph_start, glyph_end, plan, selected_lookups
        )

    def _apply_locl_plan_range_from_validated_into(
        self,
        data: List[UInt8],
        mut glyph_ids: List[Int],
        glyph_start: Int,
        glyph_end: Int,
        plan: _GsubPlan,
        selected_lookups: List[UInt16],
    ) -> Bool:
        var changed = False
        for selected_offset in range(plan._selected_count):
            var lookup_index = Int(
                selected_lookups[plan._selected_start + selected_offset]
            )
            var lookup = _lookup_at(data, plan._lookup_list, lookup_index)
            if _apply_single_lookup_range(
                data, lookup, glyph_ids, glyph_start, glyph_end
            ):
                changed = True
        return changed


def _coverage_from_validated(data: List[UInt8], offset: Int) -> Coverage:
    var format = _u16_unchecked(data, offset)
    var record_count = _u16_unchecked(data, offset + 2)
    var coverage_count = record_count
    if format == 2:
        coverage_count = 0
        if record_count != 0:
            var last = offset + 4 + 6 * (record_count - 1)
            coverage_count = (
                _u16_unchecked(data, last + 4)
                + _u16_unchecked(data, last + 2)
                - _u16_unchecked(data, last)
                + 1
            )
    return Coverage(format, offset, record_count, coverage_count)


def _validate_coverage_once(
    data: List[UInt8],
    offset: Int,
    root_offset: Int,
    root_length: Int,
    glyph_count: Int,
    mut memo: _ValidationMemo,
) raises -> Coverage:
    if offset in memo.coverages:
        return _coverage_from_validated(data, offset)
    var coverage = _parse_coverage(data, offset, root_offset, root_length, glyph_count)
    memo.coverages.add(offset)
    return coverage


def _validate_single_subst(
    data: List[UInt8],
    offset: Int,
    root_offset: Int,
    root_length: Int,
    glyph_count: Int,
    mut memo: _ValidationMemo,
) raises:
    if offset in memo.singles:
        return
    _require_layout_range(data, offset, 6, root_offset, root_length, "GSUB SingleSubst")
    var format = _u16(data, offset, "GSUB SingleSubst format")
    if format == 1:
        var coverage_relative = _u16(
            data, offset + 2, "GSUB SingleSubst coverage offset"
        )
        var coverage_offset = _resolve_offset16(
            data,
            offset,
            coverage_relative,
            6,
            4,
            root_offset,
            root_length,
            "GSUB SingleSubst coverage",
        )
        var coverage = _validate_coverage_once(
            data,
            coverage_offset,
            root_offset,
            root_length,
            glyph_count,
            memo,
        )
        var delta = _u16(data, offset + 4, "GSUB SingleSubst delta")
        # Invalid outputs form one cyclic interval in input-glyph space.
        # Binary-searching coverage proves every delta result in O(log C), so
        # distinct SingleSubsts sharing a large Coverage cannot multiply work.
        var invalid_start = (glyph_count - delta) & 0xFFFF
        var invalid_end = (0xFFFF - delta) & 0xFFFF
        var invalid_output = coverage.intersects(data, invalid_start, invalid_end)
        if invalid_start > invalid_end:
            invalid_output = coverage.intersects(
                data, invalid_start, 0xFFFF
            ) or coverage.intersects(data, 0, invalid_end)
        if invalid_output:
            raise Error("GSUB substitution glyph ID is out of range")
        memo.singles.add(offset)
        return

    if format == 2:
        var substitute_count = _u16(
            data, offset + 4, "GSUB SingleSubst substitute count"
        )
        var subtable_size = _require_layout_size(
            data,
            offset,
            substitute_count,
            2,
            6,
            root_offset,
            root_length,
            "GSUB SingleSubst format 2",
        )
        var coverage_relative = _u16(
            data, offset + 2, "GSUB SingleSubst coverage offset"
        )
        var coverage_offset = _resolve_offset16(
            data,
            offset,
            coverage_relative,
            subtable_size,
            4,
            root_offset,
            root_length,
            "GSUB SingleSubst coverage",
        )
        var coverage = _validate_coverage_once(
            data,
            coverage_offset,
            root_offset,
            root_length,
            glyph_count,
            memo,
        )
        if coverage.size() != substitute_count:
            raise Error("GSUB SingleSubst coverage and substitute counts differ")
        for index in range(substitute_count):
            if (
                _u16(data, offset + 6 + 2 * index, "GSUB substitute glyph")
                >= glyph_count
            ):
                raise Error("GSUB substitution glyph ID is out of range")
        memo.singles.add(offset)
        return

    raise Error("unsupported GSUB SingleSubst format")


def _validate_extension_subst(
    data: List[UInt8],
    offset: Int,
    root_offset: Int,
    root_length: Int,
    glyph_count: Int,
    mut memo: _ValidationMemo,
) raises -> Int:
    if offset in memo.extensions:
        return _u16_unchecked(data, offset + 2)
    _require_layout_range(
        data, offset, 8, root_offset, root_length, "GSUB ExtensionSubst"
    )
    if _u16(data, offset, "GSUB ExtensionSubst format") != 1:
        raise Error("invalid GSUB ExtensionSubst format")
    var lookup_type = _u16(data, offset + 2, "GSUB extension lookup type")
    if lookup_type < 1 or lookup_type > 8 or lookup_type == 7:
        raise Error("invalid GSUB extension lookup type")
    var relative = _u32(data, offset + 4, "GSUB extension offset")
    var child = _resolve_offset32(
        data,
        offset,
        relative,
        8,
        2,
        root_offset,
        root_length,
        "GSUB extension subtable",
    )
    if lookup_type == 1:
        _validate_single_subst(data, child, root_offset, root_length, glyph_count, memo)
    memo.extensions.add(offset)
    return lookup_type


def _validate_lookup(
    data: List[UInt8],
    offset: Int,
    root_offset: Int,
    root_length: Int,
    glyph_count: Int,
    mut memo: _ValidationMemo,
) raises:
    if offset in memo.lookups:
        return
    _require_layout_range(data, offset, 6, root_offset, root_length, "GSUB lookup")
    var lookup_type = _u16(data, offset, "GSUB lookup type")
    if lookup_type < 1 or lookup_type > 8:
        raise Error("invalid GSUB lookup type")
    var flags = _u16(data, offset + 2, "GSUB lookup flags")
    if flags & 0x00E0 != 0:
        raise Error("invalid GSUB lookup flags reserved bits")
    var count = _u16(data, offset + 4, "GSUB subtable count")
    var lookup_size = _require_layout_size(
        data,
        offset,
        count,
        2,
        6,
        root_offset,
        root_length,
        "GSUB lookup",
    )
    if flags & 0x0010:
        _require_layout_range(
            data,
            offset + lookup_size,
            2,
            root_offset,
            root_length,
            "GSUB mark filtering set",
        )
        lookup_size += 2

    var extension_type = -1
    for index in range(count):
        var relative = _u16(data, offset + 6 + 2 * index, "GSUB subtable offset")
        var subtable = _resolve_offset16(
            data,
            offset,
            relative,
            lookup_size,
            2,
            root_offset,
            root_length,
            "GSUB lookup subtable",
        )
        if lookup_type == 1:
            _validate_single_subst(
                data, subtable, root_offset, root_length, glyph_count, memo
            )
        elif lookup_type == 7:
            var child_type = _validate_extension_subst(
                data, subtable, root_offset, root_length, glyph_count, memo
            )
            if extension_type >= 0 and child_type != extension_type:
                raise Error("GSUB ExtensionSubst lookup types do not match")
            extension_type = child_type
    memo.lookups.add(offset)


def _validate_lookup_list(
    data: List[UInt8],
    offset: Int,
    root_offset: Int,
    root_length: Int,
    glyph_count: Int,
    mut memo: _ValidationMemo,
) raises -> Int:
    _require_layout_range(data, offset, 2, root_offset, root_length, "GSUB LookupList")
    var count = _u16(data, offset, "GSUB lookup count")
    var list_size = _require_layout_size(
        data,
        offset,
        count,
        2,
        2,
        root_offset,
        root_length,
        "GSUB LookupList",
    )
    for index in range(count):
        var relative = _u16(data, offset + 2 + 2 * index, "GSUB lookup offset")
        var lookup = _resolve_offset16(
            data,
            offset,
            relative,
            list_size,
            6,
            root_offset,
            root_length,
            "GSUB lookup",
        )
        _validate_lookup(data, lookup, root_offset, root_length, glyph_count, memo)
    return count


def _validate_feature(
    data: List[UInt8],
    offset: Int,
    tag: Int,
    root_offset: Int,
    root_length: Int,
    lookup_count: Int,
    mut memo: _ValidationMemo,
) raises:
    _require_layout_range(data, offset, 4, root_offset, root_length, "GSUB feature")
    var feature_lookup_count = _u16(data, offset + 2, "GSUB feature lookup count")
    var feature_size = _require_layout_size(
        data,
        offset,
        feature_lookup_count,
        2,
        4,
        root_offset,
        root_length,
        "GSUB feature",
    )
    var params_relative = _u16(data, offset, "GSUB feature parameters offset")
    # FeatureParams validity depends on the referencing tag, so a shared
    # physical Feature must still run this check after it is memoized.
    if params_relative != 0 and (
        tag == _TAG_LOCL
        or tag == _TAG_VERT
        or tag == _TAG_VRT2
        or tag == _TAG_VRTR
        or tag == _TAG_VKNA
    ):
        raise Error("GSUB locl/vertical FeatureParams must be zero")
    if offset in memo.features:
        return
    if params_relative != 0:
        _ = _resolve_offset16(
            data,
            offset,
            params_relative,
            feature_size,
            1,
            root_offset,
            root_length,
            "GSUB feature parameters",
        )
    for lookup_position in range(feature_lookup_count):
        var lookup_index = _u16(
            data,
            offset + 4 + 2 * lookup_position,
            "GSUB feature lookup index",
        )
        if lookup_index >= lookup_count:
            raise Error("GSUB lookup index is out of range")
    memo.features.add(offset)


def _validate_feature_list(
    data: List[UInt8],
    offset: Int,
    root_offset: Int,
    root_length: Int,
    lookup_count: Int,
    mut memo: _ValidationMemo,
) raises -> Int:
    _require_layout_range(data, offset, 2, root_offset, root_length, "GSUB FeatureList")
    var count = _u16(data, offset, "GSUB feature count")
    var list_size = _require_layout_size(
        data,
        offset,
        count,
        6,
        2,
        root_offset,
        root_length,
        "GSUB FeatureList",
    )
    for index in range(count):
        var record = offset + 2 + 6 * index
        var tag = _u32(data, record, "GSUB feature tag")
        _validate_layout_tag(tag, "GSUB feature")
        # FeatureList ordering is recommended but not required, and duplicate
        # tags are needed by fonts with language-specific feature tables.
        var relative = _u16(data, record + 4, "GSUB feature offset")
        var feature = _resolve_offset16(
            data,
            offset,
            relative,
            list_size,
            4,
            root_offset,
            root_length,
            "GSUB feature",
        )
        _validate_feature(
            data, feature, tag, root_offset, root_length, lookup_count, memo
        )
    return count


def _validate_lang_sys(
    data: List[UInt8],
    offset: Int,
    root_offset: Int,
    root_length: Int,
    feature_count: Int,
    mut memo: _ValidationMemo,
) raises:
    if offset in memo.language_systems:
        return
    _require_layout_range(data, offset, 6, root_offset, root_length, "GSUB LangSys")
    if _u16(data, offset, "GSUB LangSys lookupOrder") != 0:
        raise Error("invalid GSUB LangSys lookupOrder")
    var required = _u16(data, offset + 2, "GSUB required feature index")
    if required != 0xFFFF and required >= feature_count:
        raise Error("GSUB feature index is out of range")
    var count = _u16(data, offset + 4, "GSUB LangSys feature count")
    _ = _require_layout_size(
        data,
        offset,
        count,
        2,
        6,
        root_offset,
        root_length,
        "GSUB LangSys",
    )
    for index in range(count):
        if _u16(data, offset + 6 + 2 * index, "GSUB feature index") >= feature_count:
            raise Error("GSUB feature index is out of range")
    memo.language_systems.add(offset)


def _validate_script(
    data: List[UInt8],
    offset: Int,
    root_offset: Int,
    root_length: Int,
    feature_count: Int,
    script_tag: Int,
    mut memo: _ValidationMemo,
) raises:
    _require_layout_range(data, offset, 4, root_offset, root_length, "GSUB Script")
    var count = _u16(data, offset + 2, "GSUB language count")
    var script_size = _require_layout_size(
        data,
        offset,
        count,
        6,
        4,
        root_offset,
        root_length,
        "GSUB Script",
    )
    var default_relative = _u16(data, offset, "GSUB default language system offset")
    if script_tag == _TAG_DFLT and default_relative == 0:
        raise Error("GSUB DFLT Script requires a default LangSys")
    # The mandatory DFLT default is contextual when Script records share one
    # physical child, so this check intentionally precedes memoization.
    if offset in memo.scripts:
        return
    if default_relative != 0:
        var default_lang_sys = _resolve_offset16(
            data,
            offset,
            default_relative,
            script_size,
            6,
            root_offset,
            root_length,
            "GSUB default LangSys",
        )
        _validate_lang_sys(
            data, default_lang_sys, root_offset, root_length, feature_count, memo
        )

    var previous_tag = -1
    for index in range(count):
        var record = offset + 4 + 6 * index
        var tag = _u32(data, record, "GSUB language tag")
        _validate_layout_tag(tag, "GSUB language")
        if tag == _TAG_DFLT or tag == _TAG_DFLT_LANGUAGE:
            raise Error("reserved GSUB LangSys tag")
        if tag <= previous_tag:
            raise Error("unsorted or duplicate GSUB language tags")
        previous_tag = tag
        var relative = _u16(data, record + 4, "GSUB LangSys offset")
        var lang_sys = _resolve_offset16(
            data,
            offset,
            relative,
            script_size,
            6,
            root_offset,
            root_length,
            "GSUB LangSys",
        )
        _validate_lang_sys(
            data, lang_sys, root_offset, root_length, feature_count, memo
        )
    memo.scripts.add(offset)


def _validate_script_list(
    data: List[UInt8],
    offset: Int,
    root_offset: Int,
    root_length: Int,
    feature_count: Int,
    mut memo: _ValidationMemo,
) raises:
    _require_layout_range(data, offset, 2, root_offset, root_length, "GSUB ScriptList")
    var count = _u16(data, offset, "GSUB script count")
    var list_size = _require_layout_size(
        data,
        offset,
        count,
        6,
        2,
        root_offset,
        root_length,
        "GSUB ScriptList",
    )
    var previous_tag = -1
    for index in range(count):
        var record = offset + 2 + 6 * index
        var tag = _u32(data, record, "GSUB script tag")
        _validate_layout_tag(tag, "GSUB script")
        if tag <= previous_tag:
            raise Error("unsorted or duplicate GSUB script tags")
        previous_tag = tag
        var relative = _u16(data, record + 4, "GSUB script offset")
        var script = _resolve_offset16(
            data,
            offset,
            relative,
            list_size,
            4,
            root_offset,
            root_length,
            "GSUB Script",
        )
        _validate_script(
            data, script, root_offset, root_length, feature_count, tag, memo
        )


def _validate_feature_variations(
    data: List[UInt8],
    offset: Int,
    root_offset: Int,
    root_length: Int,
) raises:
    _require_layout_range(
        data, offset, 8, root_offset, root_length, "GSUB FeatureVariations"
    )
    if (
        _u16(data, offset, "GSUB FeatureVariations major version") != 1
        or _u16(data, offset + 2, "GSUB FeatureVariations minor version") != 0
    ):
        raise Error("invalid GSUB FeatureVariations version")
    var count = _u32(data, offset + 4, "GSUB FeatureVariations record count")
    var variations_size = _require_layout_size(
        data,
        offset,
        count,
        8,
        8,
        root_offset,
        root_length,
        "GSUB FeatureVariations",
    )
    for index in range(count):
        var record = offset + 8 + 8 * index
        var conditions_relative = _u32(data, record, "GSUB ConditionSet offset")
        if conditions_relative != 0:
            _ = _resolve_offset32(
                data,
                offset,
                conditions_relative,
                variations_size,
                2,
                root_offset,
                root_length,
                "GSUB ConditionSet",
            )
        var substitutions_relative = _u32(
            data, record + 4, "GSUB FeatureTableSubstitution offset"
        )
        if substitutions_relative != 0:
            _ = _resolve_offset32(
                data,
                offset,
                substitutions_relative,
                variations_size,
                6,
                root_offset,
                root_length,
                "GSUB FeatureTableSubstitution",
            )


def _parse_gsub(
    data: List[UInt8], offset: Int, length: Int, glyph_count: Int
) raises -> Gsub:
    """Validate GSUB 1.0/1.1 and return a compact execution descriptor."""
    if glyph_count <= 0 or glyph_count >= 0x10000:
        raise Error("invalid GSUB glyph count")
    _require_range(data, offset, length, "GSUB table")
    if length < 10:
        raise Error("truncated GSUB header")
    var major = _u16(data, offset, "GSUB major version")
    var minor = _u16(data, offset + 2, "GSUB minor version")
    if major != 1 or (minor != 0 and minor != 1):
        raise Error("invalid GSUB version")
    var header_size = 10 if minor == 0 else 14
    if length < header_size:
        raise Error("truncated GSUB header")

    var script_list = _resolve_offset16(
        data,
        offset,
        _u16(data, offset + 4, "GSUB ScriptList offset"),
        header_size,
        2,
        offset,
        length,
        "GSUB ScriptList",
    )
    var feature_list = _resolve_offset16(
        data,
        offset,
        _u16(data, offset + 6, "GSUB FeatureList offset"),
        header_size,
        2,
        offset,
        length,
        "GSUB FeatureList",
    )
    var lookup_list = _resolve_offset16(
        data,
        offset,
        _u16(data, offset + 8, "GSUB LookupList offset"),
        header_size,
        2,
        offset,
        length,
        "GSUB LookupList",
    )

    var variations = -1
    if minor == 1:
        var variations_relative = _u32(
            data, offset + 10, "GSUB FeatureVariations offset"
        )
        if variations_relative != 0:
            variations = _resolve_offset32(
                data,
                offset,
                variations_relative,
                header_size,
                8,
                offset,
                length,
                "GSUB FeatureVariations",
            )
    var memo = _ValidationMemo()
    var lookup_count = _validate_lookup_list(
        data, lookup_list, offset, length, glyph_count, memo
    )
    var feature_count = _validate_feature_list(
        data, feature_list, offset, length, lookup_count, memo
    )
    if variations >= 0:
        _validate_feature_variations(data, variations, offset, length)
    _validate_script_list(data, script_list, offset, length, feature_count, memo)
    return Gsub(offset, length, glyph_count)


def _record_index(
    data: List[UInt8], records: Int, count: Int, stride: Int, tag: Int
) -> Int:
    var low = 0
    var high = count
    while low < high:
        var middle = low + (high - low) // 2
        if _u32_unchecked(data, records + stride * middle) < tag:
            low = middle + 1
        else:
            high = middle
    if low < count and _u32_unchecked(data, records + stride * low) == tag:
        return low
    return -1


def _select_lang_sys(
    data: List[UInt8], script_list: Int, script_tag: Int, language_tag: Int
) -> Int:
    var script_count = _u16_unchecked(data, script_list)
    var script_records = script_list + 2
    var script_index = -1
    if script_tag != 0:
        script_index = _record_index(data, script_records, script_count, 6, script_tag)
    if script_index < 0 and script_tag != _TAG_DFLT:
        script_index = _record_index(data, script_records, script_count, 6, _TAG_DFLT)
    if script_index < 0:
        return -1
    var script_record = script_records + 6 * script_index
    var script = script_list + _u16_unchecked(data, script_record + 4)

    if language_tag != 0 and language_tag != _TAG_DFLT_LANGUAGE:
        var language_count = _u16_unchecked(data, script + 2)
        var language_records = script + 4
        var language_index = _record_index(
            data, language_records, language_count, 6, language_tag
        )
        if language_index >= 0:
            return script + _u16_unchecked(
                data, language_records + 6 * language_index + 4
            )
    var default_relative = _u16_unchecked(data, script)
    return script + default_relative if default_relative != 0 else -1


def _feature_at(data: List[UInt8], feature_list: Int, feature_index: Int) -> Int:
    var record = feature_list + 2 + 6 * feature_index
    return feature_list + _u16_unchecked(data, record + 4)


def _preflight_required_feature(
    data: List[UInt8], lang_sys: Int, feature_list: Int
) raises:
    """Reject required vertical features under the horizontal run contract."""
    var required = _u16_unchecked(data, lang_sys + 2)
    if required == 0xFFFF:
        return
    var feature_record = feature_list + 2 + 6 * required
    var tag = _u32_unchecked(data, feature_record)
    if tag == _TAG_VERT or tag == _TAG_VRT2 or tag == _TAG_VRTR or tag == _TAG_VKNA:
        raise Error(
            "required GSUB vertical feature is unsupported in horizontal shaping"
        )


def _sift_feature_offsets_down(mut offsets: List[Int], start: Int, end: Int):
    var root = start
    while 2 * root + 1 <= end:
        var child = 2 * root + 1
        if child + 1 <= end and offsets[child] < offsets[child + 1]:
            child += 1
        if offsets[root] >= offsets[child]:
            return
        offsets.swap_elements(root, child)
        root = child


def _sort_feature_offsets(mut offsets: List[Int]):
    """Heap-sort physical Feature offsets in O(F log F), in place."""
    if len(offsets) < 2:
        return
    var start = (len(offsets) - 2) // 2
    while True:
        _sift_feature_offsets_down(offsets, start, len(offsets) - 1)
        if start == 0:
            break
        start -= 1
    var end = len(offsets) - 1
    while end > 0:
        offsets.swap_elements(0, end)
        end -= 1
        _sift_feature_offsets_down(offsets, 0, end)


def _mark_feature_lookups(
    data: List[UInt8],
    feature: Int,
    mut lookup_mask: List[UInt8],
):
    var count = _u16_unchecked(data, feature + 2)
    for index in range(count):
        var lookup_index = _u16_unchecked(data, feature + 4 + 2 * index)
        lookup_mask[lookup_index] = UInt8(1)


def _gather_feature_offsets(
    data: List[UInt8],
    lang_sys: Int,
    feature_list: Int,
    mut feature_offsets: List[Int],
):
    var count = _u16_unchecked(data, lang_sys + 4)
    var required = _u16_unchecked(data, lang_sys + 2)
    if required != 0xFFFF:
        feature_offsets.append(_feature_at(data, feature_list, required))

    for index in range(count):
        var feature_index = _u16_unchecked(data, lang_sys + 6 + 2 * index)
        var feature_record = feature_list + 2 + 6 * feature_index
        if _u32_unchecked(data, feature_record) != _TAG_LOCL:
            continue
        feature_offsets.append(
            feature_list + _u16_unchecked(data, feature_record + 4),
        )

    _sort_feature_offsets(feature_offsets)


def _resolve_lookup_mask(
    data: List[UInt8],
    feature_offsets: List[Int],
    mut lookup_mask: List[UInt8],
):
    var previous = -1
    for feature in feature_offsets:
        if feature != previous:
            _mark_feature_lookups(data, feature, lookup_mask)
            previous = feature


def _lookup_at(data: List[UInt8], lookup_list: Int, lookup_index: Int) -> Int:
    return lookup_list + _u16_unchecked(data, lookup_list + 2 + 2 * lookup_index)


def _preflight_selected_lookup(data: List[UInt8], lookup: Int) raises:
    var lookup_type = _u16_unchecked(data, lookup)
    var flags = _u16_unchecked(data, lookup + 2)
    # RIGHT_TO_LEFT affects only cursive attachment behavior and is inert for
    # SingleSubst. Every other non-zero flag needs GDEF glyph classification.
    if flags & 0xFF1E != 0:
        raise Error("selected GSUB lookup flags require unsupported GDEF filtering")
    if lookup_type != 1 and lookup_type != 7:
        raise Error("unsupported selected GSUB lookup type")
    if lookup_type == 7:
        var count = _u16_unchecked(data, lookup + 4)
        for index in range(count):
            var extension = lookup + _u16_unchecked(data, lookup + 6 + 2 * index)
            if _u16_unchecked(data, extension + 2) != 1:
                raise Error("unsupported selected GSUB extension lookup type")


def _validated_coverage(data: List[UInt8], offset: Int) -> Coverage:
    var format = _u16_unchecked(data, offset)
    var count = _u16_unchecked(data, offset + 2)
    return Coverage(format, offset, count, count)


def _single_substitute(data: List[UInt8], subtable: Int, glyph_id: Int) -> Int:
    var format = _u16_unchecked(data, subtable)
    var coverage = _validated_coverage(
        data, subtable + _u16_unchecked(data, subtable + 2)
    )
    var coverage_index = coverage.index(data, glyph_id)
    if coverage_index < 0:
        return -1
    if format == 1:
        var delta = _u16_unchecked(data, subtable + 4)
        if delta >= 0x8000:
            delta -= 0x10000
        return (glyph_id + delta) & 0xFFFF
    return _u16_unchecked(data, subtable + 6 + 2 * coverage_index)


def _apply_single_lookup_range(
    data: List[UInt8],
    lookup: Int,
    mut glyph_ids: List[Int],
    glyph_start: Int,
    glyph_end: Int,
) -> Bool:
    var lookup_type = _u16_unchecked(data, lookup)
    var subtable_count = _u16_unchecked(data, lookup + 4)
    var changed = False
    for glyph_index in range(glyph_start, glyph_end):
        for subtable_index in range(subtable_count):
            var subtable = lookup + _u16_unchecked(
                data, lookup + 6 + 2 * subtable_index
            )
            if lookup_type == 7:
                subtable += _u32_unchecked(data, subtable + 4)
            var substituted = _single_substitute(data, subtable, glyph_ids[glyph_index])
            if substituted >= 0:
                if substituted != glyph_ids[glyph_index]:
                    glyph_ids[glyph_index] = substituted
                    changed = True
                break
    return changed
