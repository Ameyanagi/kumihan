from kumihan._unicode_script_data import _unicode_script_data_version
from kumihan.itemize import _ScriptItemizer
from std.testing import TestSuite, assert_equal, assert_raises


comptime _DFLT = 0x44464C54
comptime _HANI = 0x68616E69
comptime _KANA = 0x6B616E61
comptime _HANG = 0x68616E67
comptime _BOPO = 0x626F706F


def _itemize(text: StringSlice) raises -> _ScriptItemizer:
    var result = _ScriptItemizer(capacity=text.byte_length())
    for scalar in text.codepoints():
        result.push(Int(scalar.to_u32()))
    result.finish()
    return result^


def _assert_run(
    itemizer: _ScriptItemizer, index: Int, start: Int, end: Int, tag: Int
) raises:
    assert_equal(itemizer.run_start(index), start)
    assert_equal(itemizer.run_end(index), end)
    assert_equal(itemizer.run_tag(index), tag)


def test_unicode_data_version_is_pinned() raises:
    assert_equal(_unicode_script_data_version(), "17.0.0")


def test_empty_neutral_unknown_and_non_cjk_are_deterministic_default() raises:
    var empty = _itemize("")
    assert_equal(empty.run_count(), 0)

    var neutral = _itemize(" ‘ ’ ")
    assert_equal(neutral.run_count(), 1)
    _assert_run(neutral, 0, 0, 5, _DFLT)

    var unknown = _itemize(chr(0x378))
    _assert_run(unknown, 0, 0, 1, _DFLT)
    var private_use = _itemize(chr(0xE000))
    _assert_run(private_use, 0, 0, 1, _DFLT)
    var noncharacter = _itemize(chr(0x10FFFF))
    _assert_run(noncharacter, 0, 0, 1, _DFLT)
    var non_cjk = _itemize("α")
    _assert_run(non_cjk, 0, 0, 1, _DFLT)


def test_all_five_open_type_outputs_and_generated_cjk_examples() raises:
    var mixed = _itemize("A日あ한ㄅ")
    assert_equal(mixed.run_count(), 5)
    _assert_run(mixed, 0, 0, 1, _DFLT)
    _assert_run(mixed, 1, 1, 2, _HANI)
    _assert_run(mixed, 2, 2, 3, _KANA)
    _assert_run(mixed, 3, 3, 4, _HANG)
    _assert_run(mixed, 4, 4, 5, _BOPO)

    var square_han = _itemize(chr(0x337B))
    _assert_run(square_han, 0, 0, 1, _HANI)
    var circled_kana = _itemize(chr(0x32D0))
    _assert_run(circled_kana, 0, 0, 1, _KANA)


def test_generated_cjk_ranges_include_supplementary_and_compatibility_forms() raises:
    var han = _itemize(chr(0x2E80) + chr(0x33479))
    _assert_run(han, 0, 0, 2, _HANI)

    # Unicode Hiragana and Katakana remain exact identities internally, but
    # both intentionally form one OpenType ``kana`` run.
    var kana = _itemize(chr(0x3041) + chr(0x1F200) + chr(0x30A1) + chr(0x1B167))
    _assert_run(kana, 0, 0, 4, _KANA)

    var hangul = _itemize(chr(0x1100) + chr(0xAC00) + chr(0xFFDC))
    _assert_run(hangul, 0, 0, 3, _HANG)

    var bopomofo = _itemize(chr(0x02EA) + chr(0x3105) + chr(0x31BF))
    _assert_run(bopomofo, 0, 0, 3, _BOPO)


def test_script_extensions_intersect_exact_unicode_scripts() raises:
    var prolonged = _itemize("ー")
    _assert_run(prolonged, 0, 0, 1, _KANA)

    var contextual_bopomofo = _itemize("ㄅˇ")
    assert_equal(contextual_bopomofo.run_count(), 1)
    _assert_run(contextual_bopomofo, 0, 0, 2, _BOPO)

    var isolated_caron = _itemize("ˇ")
    _assert_run(isolated_caron, 0, 0, 1, _DFLT)

    # U+02C7 has {Bopo, Latn}, not Greek. Preserving all 176 scripts prevents
    # the DFLT Greek run from swallowing it before the Bopomofo context.
    var cross_script = _itemize("αˇㄅ")
    assert_equal(cross_script.run_count(), 2)
    _assert_run(cross_script, 0, 0, 1, _DFLT)
    _assert_run(cross_script, 1, 1, 3, _BOPO)

    var han_then_kana = _itemize("日ーア")
    assert_equal(han_then_kana.run_count(), 2)
    _assert_run(han_then_kana, 0, 0, 1, _HANI)
    _assert_run(han_then_kana, 1, 1, 3, _KANA)

    var kana_then_han = _itemize("アー日")
    assert_equal(kana_then_han.run_count(), 2)
    _assert_run(kana_then_han, 0, 0, 2, _KANA)
    _assert_run(kana_then_han, 1, 2, 3, _HANI)


def test_marks_stay_with_an_explicit_base_but_not_a_following_base() raises:
    var han_marks = _itemize("日\u0301\u3099")
    assert_equal(han_marks.run_count(), 1)
    _assert_run(han_marks, 0, 0, 3, _HANI)

    var kana_marks = _itemize("あ\u0301\u05B0")
    assert_equal(kana_marks.run_count(), 1)
    _assert_run(kana_marks, 0, 0, 3, _KANA)

    var leading = _itemize("\u0301あ")
    assert_equal(leading.run_count(), 2)
    _assert_run(leading, 0, 0, 1, _DFLT)
    _assert_run(leading, 1, 1, 2, _KANA)

    var standalone = _itemize("\u3099")
    _assert_run(standalone, 0, 0, 1, _DFLT)


def test_neutral_and_inherited_resolution_is_directionally_deterministic() raises:
    var leading_trailing = _itemize(" 日 ")
    assert_equal(leading_trailing.run_count(), 1)
    _assert_run(leading_trailing, 0, 0, 3, _HANI)

    var between = _itemize("日、あ")
    assert_equal(between.run_count(), 2)
    _assert_run(between, 0, 0, 2, _HANI)
    _assert_run(between, 1, 2, 3, _KANA)

    var leading_zwj = _itemize("\u200Dあ")
    assert_equal(leading_zwj.run_count(), 2)
    _assert_run(leading_zwj, 0, 0, 1, _DFLT)
    _assert_run(leading_zwj, 1, 1, 2, _KANA)

    var inherited_after_base = _itemize("日\u200D")
    assert_equal(inherited_after_base.run_count(), 1)
    _assert_run(inherited_after_base, 0, 0, 2, _HANI)


def test_canonical_nested_and_mismatched_bidi_brackets() raises:
    # U+2329 is canonically equivalent to U+3008 for bracket matching.
    var canonical = _itemize("日〈あ〉日")
    assert_equal(canonical.run_count(), 3)
    _assert_run(canonical, 0, 0, 2, _HANI)
    _assert_run(canonical, 1, 2, 3, _KANA)
    _assert_run(canonical, 2, 3, 5, _HANI)

    var nested = _itemize("日(あ[한]あ)日")
    assert_equal(nested.run_count(), 5)
    _assert_run(nested, 0, 0, 2, _HANI)
    _assert_run(nested, 1, 2, 4, _KANA)
    _assert_run(nested, 2, 4, 5, _HANG)
    _assert_run(nested, 3, 5, 7, _KANA)
    _assert_run(nested, 4, 7, 9, _HANI)

    var mismatched = _itemize("日(あ]한)日")
    assert_equal(mismatched.run_count(), 4)
    _assert_run(mismatched, 0, 0, 2, _HANI)
    _assert_run(mismatched, 1, 2, 4, _KANA)
    _assert_run(mismatched, 2, 4, 5, _HANG)
    _assert_run(mismatched, 3, 5, 7, _HANI)

    # Quotes are ordinary neutrals rather than synthesized bracket pairs.
    var quotes = _itemize("日‘あ’")
    assert_equal(quotes.run_count(), 2)
    _assert_run(quotes, 0, 0, 2, _HANI)
    _assert_run(quotes, 1, 2, 4, _KANA)


def test_brackets_keep_marks_with_their_base_and_bound_deep_nesting() raises:
    var marked = _itemize("日(゙あ)日")
    assert_equal(marked.run_count(), 3)
    _assert_run(marked, 0, 0, 3, _HANI)
    _assert_run(marked, 1, 3, 4, _KANA)
    _assert_run(marked, 2, 4, 6, _HANI)

    # Marks attached to either bracket stay in that bracket's cluster, but are
    # not themselves neighboring context for resolving the paired brackets.
    var marked_opener = _itemize("(\u05B0あ)")
    assert_equal(marked_opener.run_count(), 1)
    _assert_run(marked_opener, 0, 0, 4, _KANA)

    var marked_closer = _itemize("(あ)\u05B0日")
    assert_equal(marked_closer.run_count(), 3)
    _assert_run(marked_closer, 0, 0, 1, _HANI)
    _assert_run(marked_closer, 1, 1, 2, _KANA)
    _assert_run(marked_closer, 2, 2, 5, _HANI)

    var deep = String("日")
    for _ in range(64):
        deep += "("
    deep += "あ"
    for _ in range(64):
        deep += ")"
    deep += "日"
    var bounded = _itemize(deep)
    assert_equal(bounded.run_count(), 3)
    _assert_run(bounded, 0, 0, 65, _HANI)
    _assert_run(bounded, 1, 65, 130, _KANA)
    _assert_run(bounded, 2, 130, 131, _HANI)


def test_clear_reserve_reuse_and_scalar_validation() raises:
    var itemizer = _ScriptItemizer(capacity=1)
    itemizer.reserve(16)
    itemizer.push(0x65E5)
    itemizer.finish()
    _assert_run(itemizer, 0, 0, 1, _HANI)

    itemizer.clear()
    assert_equal(len(itemizer), 0)
    assert_equal(itemizer.run_count(), 0)
    itemizer.push(0xD55C)
    itemizer.finish()
    _assert_run(itemizer, 0, 0, 1, _HANG)

    with assert_raises(contains="capacity must not be negative"):
        itemizer.reserve(-1)
    with assert_raises(contains="invalid Unicode scalar"):
        itemizer.push(0xD800)
    with assert_raises(contains="invalid Unicode scalar"):
        itemizer.push(0x110000)


def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
