"""One bounded input per process; fixture bytes are synthetic repository data."""

from std.collections import List, Optional
from std.sys import argv
from std.testing import assert_true

from kumihan import FontCollection, FontFace, GlyphRun, Language, TextStyle, shape
from support.font_fixture import (
    make_gsub_feature_variation_record,
    make_gsub_order_dedup_chain,
    make_gsub_single_format2_coverage2,
    make_test_cjk_gsub_font,
    make_test_collection,
    make_test_font,
    make_test_font_with_gsub,
    make_test_gsub_font,
    make_test_uvs_font,
)


def _emit(name: String, data: List[UInt8]):
    var encoded = String()
    for byte in data:
        var high = Int(byte) >> 4
        var low = Int(byte) & 15
        encoded += chr(high + 48 if high < 10 else high + 87)
        encoded += chr(low + 48 if low < 10 else low + 87)
    print(name, encoded)


def _corpus():
    _emit("sfnt-cmap4", make_test_font(False))
    _emit("sfnt-cmap12", make_test_font(True))
    _emit("ttc", make_test_collection())
    _emit("cmap14", make_test_uvs_font())
    _emit("gsub-single1", make_test_gsub_font())
    _emit("gsub-cjk", make_test_cjk_gsub_font())
    _emit(
        "gsub-coverage2",
        make_test_font_with_gsub(make_gsub_single_format2_coverage2()),
    )
    _emit(
        "gsub-variations",
        make_test_font_with_gsub(make_gsub_feature_variation_record()),
    )
    _emit(
        "gsub-order",
        make_test_font_with_gsub(make_gsub_order_dedup_chain()),
    )


def _collection(var data: List[UInt8]) -> Optional[FontCollection]:
    try:
        return FontCollection.from_bytes(data^)
    except:
        return None


def _face(collection: FontCollection, index: Int) -> Optional[FontFace]:
    try:
        return collection.face(index)
    except:
        return None


def _run(face: FontFace, text: String, style: TextStyle) -> Optional[GlyphRun]:
    try:
        return shape(face, text, style)
    except:
        return None


def _exercise(var data: List[UInt8]) raises:
    var maybe_collection = _collection(data^)
    if not maybe_collection:
        print("PARSE_ERROR")
        return
    var collection = maybe_collection.take()
    var valid_runs = 0
    for index in range(collection.face_count()):
        var maybe_face = _face(collection, index)
        if not maybe_face:
            continue
        var face = maybe_face.take()
        for language in [Language.UND, Language.JA, Language.ZH_HANS]:
            var style = TextStyle().with_language(language)
            var text = String("A日本語𠀀日") + chr(0xE0100)
            var maybe_run = _run(face, text, style)
            if not maybe_run:
                continue
            var run = maybe_run.take()
            # Invariant failures must escape main, never become PARSE_ERROR.
            run.validate()
            run.validate_against_source(text)
            for glyph in run.glyph_ids():
                assert_true(glyph >= 0 and glyph < face.glyph_count())
            assert_true(run.source_byte_length() == text.byte_length())
            valid_runs += 1
    print("VALID" if valid_runs else "PARSE_ERROR")


def main() raises:
    var args = argv()
    if len(args) == 2 and args[1] == "--corpus":
        _corpus()
        return
    if len(args) != 2:
        raise Error("expected one hex-encoded font input or --corpus")
    var encoded = args[1]
    if encoded.byte_length() > 32768 or encoded.byte_length() % 2 != 0:
        raise Error("font input must contain at most 16384 hex-encoded bytes")
    var data = List[UInt8](capacity=encoded.byte_length() // 2)
    var high = -1
    for character in encoded.codepoints():
        var value = Int(character)
        if value >= 48 and value <= 57:
            value -= 48
        elif value >= 97 and value <= 102:
            value -= 87
        else:
            raise Error("font input must use lowercase hexadecimal digits")
        if high < 0:
            high = value
        else:
            data.append(UInt8((high << 4) | value))
            high = -1
    _exercise(data^)
