"""Small renderer-neutral language, direction, and text-style values."""

from std.math import isfinite


struct Language(Copyable, Equatable, ImplicitlyCopyable):
    """A nominal language used to select future OpenType behavior.

    Kumihan v0.1 distinguishes the CJK language systems whose unified Han
    characters can require different glyph forms.  ``UND`` means that the
    caller has no language preference.  The value is intentionally compact so
    every glyph run can retain it without owning or copying a language tag.
    """

    var _value: Int

    comptime UND = Language(_value=0)
    comptime ZH_HANS = Language(_value=1)
    comptime ZH_HANT = Language(_value=2)
    comptime JA = Language(_value=3)
    comptime KO = Language(_value=4)
    comptime ZH_HANT_HK = Language(_value=5)

    def __init__(out self, *, _value: Int):
        self._value = _value

    def validate(self) raises:
        """Reject discriminants outside Kumihan's supported language set."""
        if self._value < 0 or self._value > 5:
            raise Error("invalid Kumihan language discriminant: ", self._value)

    @staticmethod
    def from_bcp47(tag: StringSlice) raises -> Self:
        """Parse Kumihan's supported BCP-47 tags case-insensitively.

        Parsing allocates once at the configuration boundary; stored language
        values remain one compact integer in shaping hot paths.
        """
        var normalized = String(tag).lower()
        if normalized == "und":
            return Self.UND
        if normalized == "zh-hans":
            return Self.ZH_HANS
        if normalized == "zh-hant":
            return Self.ZH_HANT
        if normalized == "zh-hant-hk":
            return Self.ZH_HANT_HK
        if normalized == "ja":
            return Self.JA
        if normalized == "ko":
            return Self.KO
        raise Error("unsupported Kumihan BCP-47 language tag: ", tag)

    def bcp47_tag(self) -> String:
        """Return the normalized BCP-47 spelling for this nominal value."""
        if self == Self.ZH_HANS:
            return String("zh-Hans")
        if self == Self.ZH_HANT:
            return String("zh-Hant")
        if self == Self.ZH_HANT_HK:
            return String("zh-Hant-HK")
        if self == Self.JA:
            return String("ja")
        if self == Self.KO:
            return String("ko")
        return String("und")

    def tag(self) -> String:
        """Return ``bcp47_tag``; retained as the compact v0.1 spelling."""
        return self.bcp47_tag()

    def open_type_tag(self) -> String:
        """Return the four-byte OpenType language-system tag.

        Hong Kong Traditional Chinese deliberately maps to ``ZHH `` rather
        than the generic Traditional Chinese ``ZHT `` language system.
        """
        if self == Self.ZH_HANS:
            return String("ZHS ")
        if self == Self.ZH_HANT:
            return String("ZHT ")
        if self == Self.ZH_HANT_HK:
            return String("ZHH ")
        if self == Self.JA:
            return String("JAN ")
        if self == Self.KO:
            return String("KOR ")
        return String("dflt")

    def __eq__(self, other: Self) -> Bool:
        return self._value == other._value


struct Direction(Copyable, Equatable, ImplicitlyCopyable):
    """A nominal logical direction for a text run.

    All four values are represented now so later OpenType and vertical-layout
    work does not have to change ``TextStyle``.  The first nominal shaper only
    accepts ``LEFT_TO_RIGHT``; accepting another value before bidi or vertical
    substitution is implemented would silently promise incorrect shaping.
    """

    var _value: Int

    comptime LEFT_TO_RIGHT = Direction(_value=0)
    comptime RIGHT_TO_LEFT = Direction(_value=1)
    comptime TOP_TO_BOTTOM = Direction(_value=2)
    comptime BOTTOM_TO_TOP = Direction(_value=3)

    def __init__(out self, *, _value: Int):
        self._value = _value

    def validate(self) raises:
        """Reject discriminants outside Kumihan's direction vocabulary."""
        if self._value < 0 or self._value > 3:
            raise Error("invalid Kumihan direction discriminant: ", self._value)

    def is_horizontal(self) -> Bool:
        """Return whether this direction uses horizontal advances."""
        return self._value == 0 or self._value == 1

    def is_left_to_right(self) -> Bool:
        """Return whether logical and visual order both proceed left to right."""
        return self._value == 0

    def __eq__(self, other: Self) -> Bool:
        return self._value == other._value


struct TextStyle(Copyable, Equatable, ImplicitlyCopyable):
    """Validated shaping inputs with immutable, copy-returning chaining.

    The size is expressed in downstream device-independent units.  Font-unit
    metrics and advances are scaled to this size by ``shape_nominal``.
    """

    var _size: Float64
    var _language: Language
    var _direction: Direction

    def __init__(out self):
        """Construct a 16-unit, undetermined-language horizontal style."""
        self._size = 16.0
        self._language = Language.UND
        self._direction = Direction.LEFT_TO_RIGHT

    def __init__(
        out self,
        *,
        size: Float64,
        language: Language = Language.UND,
        direction: Direction = Direction.LEFT_TO_RIGHT,
    ) raises:
        """Construct and validate all style fields in deterministic order."""
        self._size = size
        self._language = language
        self._direction = direction
        self.validate()

    def with_size(self, size: Float64) raises -> Self:
        """Return a copy using a finite, strictly positive nominal size."""
        if not isfinite(size) or size <= 0.0:
            raise Error("text size must be finite and positive; got ", size)
        var result = self.copy()
        result._size = size
        return result^

    def with_language(self, language: Language) raises -> Self:
        """Return a validated copy using ``language``."""
        language.validate()
        var result = self.copy()
        result._language = language
        return result^

    def with_direction(self, direction: Direction) raises -> Self:
        """Return a validated copy using ``direction``."""
        direction.validate()
        var result = self.copy()
        result._direction = direction
        return result^

    def validate(self) raises:
        """Validate size, language, and direction without changing the value."""
        if not isfinite(self._size) or self._size <= 0.0:
            raise Error("text size must be finite and positive; got ", self._size)
        self._language.validate()
        self._direction.validate()

    def size(self) -> Float64:
        return self._size

    def language(self) -> Language:
        return self._language

    def direction(self) -> Direction:
        return self._direction

    def __eq__(self, other: Self) -> Bool:
        return (
            self._size == other._size
            and self._language == other._language
            and self._direction == other._direction
        )
