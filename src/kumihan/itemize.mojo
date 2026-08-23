"""Internal exact-script itemization for automatic CJK shaping.

Unicode Script and Script_Extensions provide candidate sets, but UAX #24 does
not prescribe one exact itemization algorithm. Kumihan forms maximal runs by
intersecting exact Unicode script candidates. Marks stay with their base,
matched canonical BidiBrackets use an enclosing script when possible, and
remaining ambiguity is resolved deterministically before mapping to Kumihan's
five OpenType script tags. This scalar policy is not an extended-grapheme or
emoji-sequence implementation.
"""

from std.bit import count_trailing_zeros
from std.collections import List

from ._unicode_script_data import (
    _BRACKET_CLOSE,
    _BRACKET_OPEN,
    _CJK_SCRIPT_WORD0,
    _CJK_SCRIPT_WORD1,
    _CJK_SCRIPT_WORD2,
    _SCRIPT_BOPOMOFO,
    _SCRIPT_HAN,
    _SCRIPT_HANGUL,
    _SCRIPT_HIRAGANA,
    _SCRIPT_KATAKANA,
    _SCRIPT_UNKNOWN,
    _UNICODE_SCRIPT_COUNT,
    _ScriptCandidateSet,
    _unicode_bracket_property,
    _unicode_script_candidates,
    _unicode_script_property,
)


comptime _TAG_DEFAULT = 0x44464C54  # DFLT
comptime _TAG_HAN = 0x68616E69  # hani
comptime _TAG_KANA = 0x6B616E61  # kana
comptime _TAG_HANGUL = 0x68616E67  # hang
comptime _TAG_BOPOMOFO = 0x626F706F  # bopo
comptime _MAX_BRACKET_DEPTH = 63
comptime _SCALAR_MASK = 0x1FFFFF
comptime _FLAG_COMMON_OR_INHERITED = 3
comptime _FLAG_INHERITED = 2
comptime _FLAG_MARK = 4
comptime _DESCRIPTOR_FLAG_BITS = 3


def _contains_script(word0: UInt64, word1: UInt64, word2: UInt64, script: Int) -> Bool:
    var bit = UInt64(1) << UInt64(script % 64)
    if script < 64:
        return (word0 & bit) != UInt64(0)
    if script < 128:
        return (word1 & bit) != UInt64(0)
    return (word2 & bit) != UInt64(0)


def _first_script(word0: UInt64, word1: UInt64, word2: UInt64) -> Int:
    if word0 != UInt64(0):
        return Int(count_trailing_zeros(word0))
    if word1 != UInt64(0):
        return 64 + Int(count_trailing_zeros(word1))
    if word2 != UInt64(0):
        return 128 + Int(count_trailing_zeros(word2))
    return _SCRIPT_UNKNOWN


def _choose_script(word0: UInt64, word1: UInt64, word2: UInt64) -> Int:
    var has_han = _contains_script(word0, word1, word2, _SCRIPT_HAN)
    var has_kana = _contains_script(
        word0, word1, word2, _SCRIPT_HIRAGANA
    ) or _contains_script(word0, word1, word2, _SCRIPT_KATAKANA)
    var has_hangul = _contains_script(word0, word1, word2, _SCRIPT_HANGUL)
    var has_bopomofo = _contains_script(word0, word1, word2, _SCRIPT_BOPOMOFO)
    var has_default = (
        (word0 & ~UInt64(_CJK_SCRIPT_WORD0)) != UInt64(0)
        or (word1 & ~UInt64(_CJK_SCRIPT_WORD1)) != UInt64(0)
        or (word2 & ~UInt64(_CJK_SCRIPT_WORD2)) != UInt64(0)
    )
    var output_count = Int(has_default)
    output_count += Int(has_han)
    output_count += Int(has_kana)
    output_count += Int(has_hangul)
    output_count += Int(has_bopomofo)
    if output_count != 1:
        return _SCRIPT_UNKNOWN
    if has_han:
        return _SCRIPT_HAN
    if has_kana:
        return _SCRIPT_HIRAGANA
    if has_hangul:
        return _SCRIPT_HANGUL
    if has_bopomofo:
        return _SCRIPT_BOPOMOFO
    return _first_script(word0, word1, word2)


def _script_tag(script: Int) -> Int:
    if script == _SCRIPT_HAN:
        return _TAG_HAN
    if script == _SCRIPT_HIRAGANA or script == _SCRIPT_KATAKANA:
        return _TAG_KANA
    if script == _SCRIPT_HANGUL:
        return _TAG_HANGUL
    if script == _SCRIPT_BOPOMOFO:
        return _TAG_BOPOMOFO
    return _TAG_DEFAULT


struct _ScriptItemizer(Movable, Sized):
    """Reusable glyph-index script itemizer with compact retained scratch."""

    # candidate_id << 3 | Common/Inherited/Mark flags. Unicode 17 uses fewer
    # than 8192 singleton-plus-unique-scx IDs, so one UInt16 is sufficient.
    var _descriptors: List[UInt16]
    var _resolved_scripts: List[UInt8]
    # Brackets are sparse: retain only matched pair indices and a bounded stack.
    var _pair_opens: List[Int]
    var _pair_closes: List[Int]
    var _bracket_stack_indices: List[Int]
    var _bracket_stack_packed: List[Int]
    var _bracket_matching_disabled: Bool
    # Run ends are derived from the next start (or glyph count for the last).
    var _run_starts: List[Int]
    var _run_tags: List[Int]

    def __init__(out self):
        self._descriptors = List[UInt16]()
        self._resolved_scripts = List[UInt8]()
        self._pair_opens = List[Int]()
        self._pair_closes = List[Int]()
        self._bracket_stack_indices = List[Int]()
        self._bracket_stack_packed = List[Int]()
        self._bracket_matching_disabled = False
        self._run_starts = List[Int]()
        self._run_tags = List[Int]()

    def __init__(out self, *, capacity: Int) raises:
        if capacity < 0:
            raise Error("script-itemizer capacity must not be negative; got ", capacity)
        self._descriptors = List[UInt16](capacity=capacity)
        self._resolved_scripts = List[UInt8](capacity=capacity)
        self._pair_opens = List[Int]()
        self._pair_closes = List[Int]()
        self._bracket_stack_indices = List[Int]()
        self._bracket_stack_packed = List[Int]()
        self._bracket_matching_disabled = False
        self._run_starts = List[Int](capacity=capacity)
        self._run_tags = List[Int](capacity=capacity)

    def __len__(self) -> Int:
        return len(self._descriptors)

    def clear(mut self):
        """Clear inputs and runs while retaining all reusable allocations."""
        self._descriptors.clear()
        self._resolved_scripts.clear()
        self._pair_opens.clear()
        self._pair_closes.clear()
        self._bracket_stack_indices.clear()
        self._bracket_stack_packed.clear()
        self._bracket_matching_disabled = False
        self._run_starts.clear()
        self._run_tags.clear()

    def reserve(mut self, capacity: Int) raises:
        """Reserve per-glyph and worst-case run scratch."""
        if capacity < 0:
            raise Error("script-itemizer capacity must not be negative; got ", capacity)
        self._descriptors.reserve(capacity)
        self._resolved_scripts.reserve(capacity)
        self._run_starts.reserve(capacity)
        self._run_tags.reserve(capacity)

    def _match_bracket(mut self, glyph_index: Int, packed: Int):
        if self._bracket_matching_disabled:
            return
        var kind = packed & 3
        if kind == _BRACKET_OPEN:
            if len(self._bracket_stack_indices) < _MAX_BRACKET_DEPTH:
                self._bracket_stack_indices.append(glyph_index)
                self._bracket_stack_packed.append(packed)
            else:
                # Beyond Unicode's bounded paired-bracket depth, stop pairing
                # this input rather than shifting every later closer onto the
                # wrong stored opener.
                self._bracket_stack_indices.clear()
                self._bracket_stack_packed.clear()
                self._bracket_matching_disabled = True
            return
        if kind != _BRACKET_CLOSE:
            return

        var canonical = (packed >> 23) & _SCALAR_MASK
        var stack_index = len(self._bracket_stack_indices)
        while stack_index > 0:
            stack_index -= 1
            var expected = (self._bracket_stack_packed[stack_index] >> 2) & _SCALAR_MASK
            if expected != canonical:
                continue
            self._pair_opens.append(self._bracket_stack_indices[stack_index])
            self._pair_closes.append(glyph_index)
            while len(self._bracket_stack_indices) > stack_index:
                _ = self._bracket_stack_indices.pop(
                    len(self._bracket_stack_indices) - 1
                )
                _ = self._bracket_stack_packed.pop(len(self._bracket_stack_packed) - 1)
            return

    def push(mut self, code_point: Int) raises:
        """Classify one emitted glyph's Unicode scalar exactly once."""
        if (
            code_point < 0
            or code_point > 0x10FFFF
            or (code_point >= 0xD800 and code_point <= 0xDFFF)
        ):
            raise Error("invalid Unicode scalar for script itemization: ", code_point)
        var script = _unicode_script_property(code_point)
        var descriptor = (script.candidate_id() << _DESCRIPTOR_FLAG_BITS) | Int(
            script._flags
        )
        self._descriptors.append(UInt16(descriptor))
        var packed = _unicode_bracket_property(code_point).packed()
        if packed != 0:
            self._match_bracket(len(self._descriptors) - 1, packed)

    def _candidate_id(self, index: Int) -> Int:
        return Int(self._descriptors[index] >> UInt16(_DESCRIPTOR_FLAG_BITS))

    def _flags(self, index: Int) -> UInt8:
        return UInt8(self._descriptors[index] & UInt16(7))

    def _candidates(self, index: Int) -> _ScriptCandidateSet:
        var candidate_id = self._candidate_id(index)
        if candidate_id < _UNICODE_SCRIPT_COUNT and (
            self._flags(index) & UInt8(_FLAG_COMMON_OR_INHERITED)
        ) != UInt8(0):
            return _ScriptCandidateSet(
                UInt64(0xFFFFFFFFFFFFFFFF),
                UInt64(0xFFFFFFFFFFFFFFFF),
                UInt64(0xFFFFFFFFFFFF),
            )
        return _unicode_script_candidates(candidate_id)

    def _cluster_candidates(self, start: Int, end: Int) -> _ScriptCandidateSet:
        var flags = self._flags(start)
        if (flags & UInt8(_FLAG_MARK)) != UInt8(0):
            return _unicode_script_candidates(_SCRIPT_UNKNOWN)
        if (
            start == 0
            and self._candidate_id(start) < _UNICODE_SCRIPT_COUNT
            and (flags & UInt8(_FLAG_INHERITED)) != UInt8(0)
        ):
            return _unicode_script_candidates(_SCRIPT_UNKNOWN)

        var source = start
        var base_is_implicit = self._candidate_id(start) < _UNICODE_SCRIPT_COUNT and (
            flags & UInt8(_FLAG_COMMON_OR_INHERITED)
        ) != UInt8(0)
        if base_is_implicit:
            for mark in range(start + 1, end):
                if self._candidate_id(mark) >= _UNICODE_SCRIPT_COUNT or (
                    self._flags(mark) & UInt8(_FLAG_COMMON_OR_INHERITED)
                ) == UInt8(0):
                    source = mark
                    break
        return self._candidates(source)

    def _fill_resolved(mut self, start: Int, end: Int, script: Int):
        debug_assert(len(self._resolved_scripts) == start)
        for _ in range(start, end):
            self._resolved_scripts.append(UInt8(script))

    def _resolve_intersections(mut self):
        self._resolved_scripts.clear()
        if len(self) == 0:
            return

        var run_start = 0
        var scalar_index = 0
        var have_intersection = False
        var intersection0 = UInt64(0)
        var intersection1 = UInt64(0)
        var intersection2 = UInt64(0)
        while scalar_index < len(self):
            var cluster_start = scalar_index
            var cluster_end = cluster_start + 1
            if (self._flags(cluster_start) & UInt8(_FLAG_MARK)) == UInt8(0):
                while cluster_end < len(self) and (
                    self._flags(cluster_end) & UInt8(_FLAG_MARK)
                ) != UInt8(0):
                    cluster_end += 1
            var candidates = self._cluster_candidates(cluster_start, cluster_end)
            if not have_intersection:
                run_start = cluster_start
                intersection0 = candidates.word0
                intersection1 = candidates.word1
                intersection2 = candidates.word2
                have_intersection = True
            else:
                var next0 = intersection0 & candidates.word0
                var next1 = intersection1 & candidates.word1
                var next2 = intersection2 & candidates.word2
                if next0 == UInt64(0) and next1 == UInt64(0) and next2 == UInt64(0):
                    self._fill_resolved(
                        run_start,
                        cluster_start,
                        _choose_script(intersection0, intersection1, intersection2),
                    )
                    run_start = cluster_start
                    intersection0 = candidates.word0
                    intersection1 = candidates.word1
                    intersection2 = candidates.word2
                else:
                    intersection0 = next0
                    intersection1 = next1
                    intersection2 = next2
            scalar_index = cluster_end

        self._fill_resolved(
            run_start,
            len(self),
            _choose_script(intersection0, intersection1, intersection2),
        )

    def _pair_allows(self, open_index: Int, close_index: Int, script: Int) -> Bool:
        var opening = self._candidates(open_index)
        var closing = self._candidates(close_index)
        return _contains_script(
            opening.word0, opening.word1, opening.word2, script
        ) and _contains_script(closing.word0, closing.word1, closing.word2, script)

    def _cluster_end(self, start: Int) -> Int:
        var end = start + 1
        while end < len(self) and (self._flags(end) & UInt8(_FLAG_MARK)) != UInt8(0):
            end += 1
        return end

    def _set_cluster_script(mut self, start: Int, script: Int):
        self._resolved_scripts[start] = UInt8(script)
        var index = start + 1
        var end = self._cluster_end(start)
        while index < end:
            self._resolved_scripts[index] = UInt8(script)
            index += 1

    def _resolve_brackets(mut self):
        for pair_index in range(len(self._pair_opens)):
            var open_index = self._pair_opens[pair_index]
            var close_index = self._pair_closes[pair_index]
            var open_cluster_end = self._cluster_end(open_index)
            var close_cluster_end = self._cluster_end(close_index)
            var selected = -1
            if open_index > 0:
                var left = Int(self._resolved_scripts[open_index - 1])
                if self._pair_allows(open_index, close_index, left):
                    selected = left
            if selected < 0 and close_cluster_end < len(self):
                var right = Int(self._resolved_scripts[close_cluster_end])
                if self._pair_allows(open_index, close_index, right):
                    selected = right
            if selected < 0:
                for inside in range(open_cluster_end, close_index):
                    var inner = Int(self._resolved_scripts[inside])
                    if self._pair_allows(open_index, close_index, inner):
                        selected = inner
                        break
            if selected < 0:
                var opening = self._candidates(open_index)
                var closing = self._candidates(close_index)
                selected = _choose_script(
                    opening.word0 & closing.word0,
                    opening.word1 & closing.word1,
                    opening.word2 & closing.word2,
                )
            self._set_cluster_script(open_index, selected)
            self._set_cluster_script(close_index, selected)

    def _build_runs(mut self):
        self._run_starts.clear()
        self._run_tags.clear()
        if len(self) == 0:
            return
        self._run_starts.append(0)
        var tag = _script_tag(Int(self._resolved_scripts[0]))
        self._run_tags.append(tag)
        for index in range(1, len(self)):
            var next_tag = _script_tag(Int(self._resolved_scripts[index]))
            if next_tag == tag:
                continue
            self._run_starts.append(index)
            self._run_tags.append(next_tag)
            tag = next_tag

    def finish(mut self):
        """Resolve exact candidates and rebuild maximal packed-tag runs."""
        self._resolve_intersections()
        self._resolve_brackets()
        self._build_runs()

    def run_count(self) -> Int:
        return len(self._run_starts)

    def run_start(self, index: Int) -> Int:
        return self._run_starts[index]

    def run_end(self, index: Int) -> Int:
        if index + 1 < len(self._run_starts):
            return self._run_starts[index + 1]
        return len(self._descriptors)

    def run_tag(self, index: Int) -> Int:
        return self._run_tags[index]
