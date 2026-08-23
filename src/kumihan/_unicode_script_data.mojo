"""Generated exact Unicode script lookup data. Do not edit."""

# Unicode version: 17.0.0
# Sources and SHA-256 digests:
# - https://www.unicode.org/Public/17.0.0/ucd/Scripts.txt
#   9f5e50d3abaee7d6ce09480f325c706f485ae3240912527e651954d2d6b035bf  Scripts.txt
# - https://www.unicode.org/Public/17.0.0/ucd/ScriptExtensions.txt
#   ec2107e58825a1586acee8e0911ce18260394ac8b87e535ca325f1ccbeb06bc6  ScriptExtensions.txt
# - https://www.unicode.org/Public/17.0.0/ucd/PropertyValueAliases.txt
#   64e9a5f76f7a1e8b5a47d6a1f9a26522a251208f5276bdfa1559dac7cf2e827a  PropertyValueAliases.txt
# - https://www.unicode.org/Public/17.0.0/ucd/extracted/DerivedGeneralCategory.txt
#   d62e5bab70ca74f099343f71224fa051cb1fdd61a1ab45c0488c44cfc0b6102e  DerivedGeneralCategory.txt
# - https://www.unicode.org/Public/17.0.0/ucd/BidiBrackets.txt
#   dadbaf38a0d0246e5b805bf8725cb81b7c621f93d030595635f5ba2c2f179428  BidiBrackets.txt

comptime _UNICODE_SCRIPT_COUNT = 176
comptime _SCRIPT_HAN = 50
comptime _SCRIPT_HIRAGANA = 54
comptime _SCRIPT_KATAKANA = 63
comptime _SCRIPT_HANGUL = 49
comptime _SCRIPT_BOPOMOFO = 14
comptime _SCRIPT_COMMON = 174
comptime _SCRIPT_INHERITED = 173
comptime _SCRIPT_UNKNOWN = 175
comptime _CJK_SCRIPT_WORD0 = 0x8046000000004000
comptime _CJK_SCRIPT_WORD1 = 0x0
comptime _CJK_SCRIPT_WORD2 = 0x0
comptime _SCRIPT_FLAG_COMMON = 1
comptime _SCRIPT_FLAG_INHERITED = 2
comptime _SCRIPT_FLAG_MARK = 4
comptime _BRACKET_OPEN = 1
comptime _BRACKET_CLOSE = 2


struct _UnicodeScriptProperty(Copyable, ImplicitlyCopyable):
    var _candidate_id: Int
    var _flags: UInt8

    def __init__(out self, candidate_id: Int, flags: UInt8):
        self._candidate_id = candidate_id
        self._flags = flags

    def candidate_id(self) -> Int:
        return self._candidate_id

    def is_common_or_inherited(self) -> Bool:
        return (self._flags & UInt8(3)) != UInt8(0)

    def is_mark(self) -> Bool:
        return (self._flags & UInt8(4)) != UInt8(0)


struct _ScriptCandidateSet(Copyable, ImplicitlyCopyable):
    var word0: UInt64
    var word1: UInt64
    var word2: UInt64

    def __init__(out self):
        self.word0 = UInt64(0)
        self.word1 = UInt64(0)
        self.word2 = UInt64(0)

    def __init__(out self, word0: UInt64, word1: UInt64, word2: UInt64):
        self.word0 = word0
        self.word1 = word1
        self.word2 = word2


struct _UnicodeBracketProperty(Copyable, ImplicitlyCopyable):
    var _packed: Int

    def __init__(out self, packed: Int):
        self._packed = packed

    def packed(self) -> Int:
        return self._packed


def _unicode_script_data_version() -> String:
    return "17.0.0"


def _unicode_script_candidates(candidate_id: Int) -> _ScriptCandidateSet:
    if candidate_id >= 0 and candidate_id < 176:
        var bit = UInt64(1) << UInt64(candidate_id % 64)
        if candidate_id < 64:
            return _ScriptCandidateSet(bit, UInt64(0), UInt64(0))
        if candidate_id < 128:
            return _ScriptCandidateSet(UInt64(0), bit, UInt64(0))
        return _ScriptCandidateSet(UInt64(0), UInt64(0), bit)
    if candidate_id < 235:
        if candidate_id < 205:
            if candidate_id < 190:
                if candidate_id < 183:
                    if candidate_id < 179:
                        if candidate_id < 177:
                            if candidate_id < 176:
                                return _ScriptCandidateSet()
                            if candidate_id > 176:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x9), UInt64(0x0), UInt64(0x0)
                            )
                        if candidate_id > 177:
                            if candidate_id < 178:
                                return _ScriptCandidateSet()
                            if candidate_id > 178:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x800000000000009), UInt64(0x0), UInt64(0x0)
                            )
                        return _ScriptCandidateSet(
                            UInt64(0x4000000009),
                            UInt64(0x800008000000000),
                            UInt64(0x40004004000),
                        )
                    if candidate_id > 179:
                        if candidate_id < 181:
                            if candidate_id < 180:
                                return _ScriptCandidateSet()
                            if candidate_id > 180:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x280012800002),
                                UInt64(0x400000000400),
                                UInt64(0x81004000),
                            )
                        if candidate_id > 181:
                            if candidate_id < 182:
                                return _ScriptCandidateSet()
                            if candidate_id > 182:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x2), UInt64(0x400), UInt64(0x80000000)
                            )
                        return _ScriptCandidateSet(
                            UInt64(0x80000800002), UInt64(0x400), UInt64(0x8005000)
                        )
                    return _ScriptCandidateSet(
                        UInt64(0x9), UInt64(0x841000000300000), UInt64(0x4080)
                    )
                if candidate_id > 183:
                    if candidate_id < 187:
                        if candidate_id < 185:
                            if candidate_id < 184:
                                return _ScriptCandidateSet()
                            if candidate_id > 184:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x4000000008),
                                UInt64(0x800008000000000),
                                UInt64(0x40004004000),
                            )
                        if candidate_id > 185:
                            if candidate_id < 186:
                                return _ScriptCandidateSet()
                            if candidate_id > 186:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x8), UInt64(0x800000000000000), UInt64(0x0)
                            )
                        return _ScriptCandidateSet(
                            UInt64(0x8), UInt64(0x8000000000), UInt64(0x0)
                        )
                    if candidate_id > 187:
                        if candidate_id < 189:
                            if candidate_id < 188:
                                return _ScriptCandidateSet()
                            if candidate_id > 188:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x8), UInt64(0x0), UInt64(0x4004000)
                            )
                        if candidate_id > 189:
                            return _ScriptCandidateSet()
                        return _ScriptCandidateSet(
                            UInt64(0x8), UInt64(0x0), UInt64(0x4000000)
                        )
                    return _ScriptCandidateSet(UInt64(0x8), UInt64(0x0), UInt64(0x4000))
                return _ScriptCandidateSet(UInt64(0x2000008), UInt64(0x0), UInt64(0x0))
            if candidate_id > 190:
                if candidate_id < 198:
                    if candidate_id < 194:
                        if candidate_id < 192:
                            if candidate_id < 191:
                                return _ScriptCandidateSet()
                            if candidate_id > 191:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x20280210000020),
                                UInt64(0x8000000000400),
                                UInt64(0x1024000),
                            )
                        if candidate_id > 192:
                            if candidate_id < 193:
                                return _ScriptCandidateSet()
                            if candidate_id > 193:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x42B8A02200040),
                                UInt64(0x8000000060400),
                                UInt64(0x2),
                            )
                        return _ScriptCandidateSet(
                            UInt64(0x18000000020), UInt64(0x0), UInt64(0x0)
                        )
                    if candidate_id > 194:
                        if candidate_id < 196:
                            if candidate_id < 195:
                                return _ScriptCandidateSet()
                            if candidate_id > 195:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x40), UInt64(0x100000000000), UInt64(0x0)
                            )
                        if candidate_id > 196:
                            if candidate_id < 197:
                                return _ScriptCandidateSet()
                            if candidate_id > 197:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x80800), UInt64(0x0), UInt64(0x2000)
                            )
                        return _ScriptCandidateSet(
                            UInt64(0x800), UInt64(0x0), UInt64(0x0)
                        )
                    return _ScriptCandidateSet(
                        UInt64(0x800008000200040),
                        UInt64(0x2000000000020080),
                        UInt64(0x0),
                    )
                if candidate_id > 198:
                    if candidate_id < 202:
                        if candidate_id < 200:
                            if candidate_id < 199:
                                return _ScriptCandidateSet()
                            if candidate_id > 199:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x20000800), UInt64(0x0), UInt64(0x0)
                            )
                        if candidate_id > 200:
                            if candidate_id < 201:
                                return _ScriptCandidateSet()
                            if candidate_id > 201:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x15600A0000800),
                                UInt64(0x280808040020),
                                UInt64(0x20892060),
                            )
                        return _ScriptCandidateSet(
                            UInt64(0x1D600A0000800),
                            UInt64(0x280808041020),
                            UInt64(0x20892060),
                        )
                    if candidate_id > 202:
                        if candidate_id < 204:
                            if candidate_id < 203:
                                return _ScriptCandidateSet()
                            if candidate_id > 203:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x1500020000800),
                                UInt64(0x204008000420),
                                UInt64(0x20880000),
                            )
                        if candidate_id > 204:
                            return _ScriptCandidateSet()
                        return _ScriptCandidateSet(
                            UInt64(0x100020000800), UInt64(0x20), UInt64(0x0)
                        )
                    return _ScriptCandidateSet(
                        UInt64(0x1500020000800),
                        UInt64(0x204808000420),
                        UInt64(0x20880004),
                    )
                return _ScriptCandidateSet(
                    UInt64(0x30000800), UInt64(0x8400), UInt64(0x208000000)
                )
            return _ScriptCandidateSet(UInt64(0x8), UInt64(0x0), UInt64(0x40004000000))
        if candidate_id > 205:
            if candidate_id < 220:
                if candidate_id < 213:
                    if candidate_id < 209:
                        if candidate_id < 207:
                            if candidate_id < 206:
                                return _ScriptCandidateSet()
                            if candidate_id > 206:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x20000800), UInt64(0x4000000000), UInt64(0x4)
                            )
                        if candidate_id > 207:
                            if candidate_id < 208:
                                return _ScriptCandidateSet()
                            if candidate_id > 208:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x20000800),
                                UInt64(0x4000000000),
                                UInt64(0x20800000),
                            )
                        return _ScriptCandidateSet(
                            UInt64(0x20000800), UInt64(0x4000000000), UInt64(0x800000)
                        )
                    if candidate_id > 209:
                        if candidate_id < 211:
                            if candidate_id < 210:
                                return _ScriptCandidateSet()
                            if candidate_id > 210:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x20000800), UInt64(0x0), UInt64(0x800000)
                            )
                        if candidate_id > 211:
                            if candidate_id < 212:
                                return _ScriptCandidateSet()
                            if candidate_id > 212:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x8046000000004000), UInt64(0x0), UInt64(0x0)
                            )
                        return _ScriptCandidateSet(
                            UInt64(0x20000800), UInt64(0x0), UInt64(0x400000000)
                        )
                    return _ScriptCandidateSet(
                        UInt64(0x20000800), UInt64(0x0), UInt64(0x4)
                    )
                if candidate_id > 213:
                    if candidate_id < 217:
                        if candidate_id < 215:
                            if candidate_id < 214:
                                return _ScriptCandidateSet()
                            if candidate_id > 214:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x8046000000004000),
                                UInt64(0x10000020000000),
                                UInt64(0x80000000000),
                            )
                        if candidate_id > 215:
                            if candidate_id < 216:
                                return _ScriptCandidateSet()
                            if candidate_id > 216:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x8046000000004000),
                                UInt64(0x20000000),
                                UInt64(0x80000000000),
                            )
                        return _ScriptCandidateSet(
                            UInt64(0x8046000000004000),
                            UInt64(0x20000000),
                            UInt64(0x80010000000),
                        )
                    if candidate_id > 217:
                        if candidate_id < 219:
                            if candidate_id < 218:
                                return _ScriptCandidateSet()
                            if candidate_id > 218:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x4000000004000), UInt64(0x0), UInt64(0x0)
                            )
                        if candidate_id > 219:
                            return _ScriptCandidateSet()
                        return _ScriptCandidateSet(
                            UInt64(0x4000), UInt64(0x400), UInt64(0x0)
                        )
                    return _ScriptCandidateSet(
                        UInt64(0x8046000000004000), UInt64(0x0), UInt64(0x80000000000)
                    )
                return _ScriptCandidateSet(
                    UInt64(0x8046000000004000),
                    UInt64(0x20008000),
                    UInt64(0x80010000000),
                )
            if candidate_id > 220:
                if candidate_id < 228:
                    if candidate_id < 224:
                        if candidate_id < 222:
                            if candidate_id < 221:
                                return _ScriptCandidateSet()
                            if candidate_id > 221:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x8000000040000), UInt64(0x0), UInt64(0x2008000)
                            )
                        if candidate_id > 222:
                            if candidate_id < 223:
                                return _ScriptCandidateSet()
                            if candidate_id > 223:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x800018000200000),
                                UInt64(0x100000010000),
                                UInt64(0x0),
                            )
                        return _ScriptCandidateSet(
                            UInt64(0x80000), UInt64(0x200000000), UInt64(0x20000)
                        )
                    if candidate_id > 224:
                        if candidate_id < 226:
                            if candidate_id < 225:
                                return _ScriptCandidateSet()
                            if candidate_id > 225:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x200012800000),
                                UInt64(0x8000000000400),
                                UInt64(0x21000),
                            )
                        if candidate_id > 226:
                            if candidate_id < 227:
                                return _ScriptCandidateSet()
                            if candidate_id > 227:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x10800000), UInt64(0x400000000400), UInt64(0x0)
                            )
                        return _ScriptCandidateSet(
                            UInt64(0x200010800000),
                            UInt64(0x400000000400),
                            UInt64(0x80021000),
                        )
                    return _ScriptCandidateSet(
                        UInt64(0x800200000200000), UInt64(0x4000000), UInt64(0x0)
                    )
                if candidate_id > 228:
                    if candidate_id < 232:
                        if candidate_id < 230:
                            if candidate_id < 229:
                                return _ScriptCandidateSet()
                            if candidate_id > 229:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x8000000200800000),
                                UInt64(0x400),
                                UInt64(0x1004000),
                            )
                        if candidate_id > 230:
                            if candidate_id < 231:
                                return _ScriptCandidateSet()
                            if candidate_id > 231:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x800000), UInt64(0x400), UInt64(0x4000)
                            )
                        return _ScriptCandidateSet(
                            UInt64(0x200800000), UInt64(0x400), UInt64(0x4000)
                        )
                    if candidate_id > 232:
                        if candidate_id < 234:
                            if candidate_id < 233:
                                return _ScriptCandidateSet()
                            if candidate_id > 233:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x20000202000000),
                                UInt64(0x8000000000400),
                                UInt64(0x81024000),
                            )
                        if candidate_id > 234:
                            return _ScriptCandidateSet()
                        return _ScriptCandidateSet(
                            UInt64(0x8000090802000000), UInt64(0x400), UInt64(0x0)
                        )
                    return _ScriptCandidateSet(
                        UInt64(0x800000), UInt64(0x400), UInt64(0x20000)
                    )
                return _ScriptCandidateSet(
                    UInt64(0x10800000), UInt64(0x400), UInt64(0x1000000)
                )
            return _ScriptCandidateSet(
                UInt64(0x2000000000020000), UInt64(0x0), UInt64(0x0)
            )
        return _ScriptCandidateSet(
            UInt64(0x100020000800), UInt64(0x200808000020), UInt64(0x420800040)
        )
    if candidate_id > 235:
        if candidate_id < 265:
            if candidate_id < 250:
                if candidate_id < 243:
                    if candidate_id < 239:
                        if candidate_id < 237:
                            if candidate_id < 236:
                                return _ScriptCandidateSet()
                            if candidate_id > 236:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x2000000), UInt64(0x400), UInt64(0x0)
                            )
                        if candidate_id > 237:
                            if candidate_id < 238:
                                return _ScriptCandidateSet()
                            if candidate_id > 238:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x8000000), UInt64(0x6000), UInt64(0x0)
                            )
                        return _ScriptCandidateSet(
                            UInt64(0xC000000), UInt64(0x4000), UInt64(0x0)
                        )
                    if candidate_id > 239:
                        if candidate_id < 241:
                            if candidate_id < 240:
                                return _ScriptCandidateSet()
                            if candidate_id > 240:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x10010000000), UInt64(0x0), UInt64(0x0)
                            )
                        if candidate_id > 241:
                            if candidate_id < 242:
                                return _ScriptCandidateSet()
                            if candidate_id > 242:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x10000000), UInt64(0x400), UInt64(0x0)
                            )
                        return _ScriptCandidateSet(
                            UInt64(0x200010000000),
                            UInt64(0x8000000000400),
                            UInt64(0x1000000),
                        )
                    return _ScriptCandidateSet(
                        UInt64(0x8000000), UInt64(0x4000), UInt64(0x0)
                    )
                if candidate_id > 243:
                    if candidate_id < 247:
                        if candidate_id < 245:
                            if candidate_id < 244:
                                return _ScriptCandidateSet()
                            if candidate_id > 244:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x10000000), UInt64(0x400), UInt64(0x80000000)
                            )
                        if candidate_id > 245:
                            if candidate_id < 246:
                                return _ScriptCandidateSet()
                            if candidate_id > 246:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x20000000), UInt64(0x0), UInt64(0x0)
                            )
                        return _ScriptCandidateSet(
                            UInt64(0x10000000), UInt64(0x8000000000000), UInt64(0x0)
                        )
                    if candidate_id > 247:
                        if candidate_id < 249:
                            if candidate_id < 248:
                                return _ScriptCandidateSet()
                            if candidate_id > 248:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x14000A0000000),
                                UInt64(0x8100400A8),
                                UInt64(0x420010024),
                            )
                        if candidate_id > 249:
                            return _ScriptCandidateSet()
                        return _ScriptCandidateSet(
                            UInt64(0x14000A0000000),
                            UInt64(0x10040088),
                            UInt64(0x20010024),
                        )
                    return _ScriptCandidateSet(
                        UInt64(0x14000A0000000),
                        UInt64(0x8180400A8),
                        UInt64(0x420010024),
                    )
                return _ScriptCandidateSet(
                    UInt64(0x10000000), UInt64(0x400), UInt64(0x4000)
                )
            if candidate_id > 250:
                if candidate_id < 258:
                    if candidate_id < 254:
                        if candidate_id < 252:
                            if candidate_id < 251:
                                return _ScriptCandidateSet()
                            if candidate_id > 251:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0xA0000000), UInt64(0x40080), UInt64(0x0)
                            )
                        if candidate_id > 252:
                            if candidate_id < 253:
                                return _ScriptCandidateSet()
                            if candidate_id > 253:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x100020000000), UInt64(0x20), UInt64(0x0)
                            )
                        return _ScriptCandidateSet(
                            UInt64(0x100020000000), UInt64(0x0), UInt64(0x0)
                        )
                    if candidate_id > 254:
                        if candidate_id < 256:
                            if candidate_id < 255:
                                return _ScriptCandidateSet()
                            if candidate_id > 255:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x100020000000), UInt64(0x400), UInt64(0x0)
                            )
                        if candidate_id > 256:
                            if candidate_id < 257:
                                return _ScriptCandidateSet()
                            if candidate_id > 257:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x20000000), UInt64(0x4800000000), UInt64(0x0)
                            )
                        return _ScriptCandidateSet(
                            UInt64(0x20000000), UInt64(0x200008000020), UInt64(0x880000)
                        )
                    return _ScriptCandidateSet(
                        UInt64(0x100020000000), UInt64(0x20), UInt64(0x400000000)
                    )
                if candidate_id > 258:
                    if candidate_id < 262:
                        if candidate_id < 260:
                            if candidate_id < 259:
                                return _ScriptCandidateSet()
                            if candidate_id > 259:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x20000000), UInt64(0x4000000000), UInt64(0x4)
                            )
                        if candidate_id > 260:
                            if candidate_id < 261:
                                return _ScriptCandidateSet()
                            if candidate_id > 261:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x20000000), UInt64(0x0), UInt64(0x4)
                            )
                        return _ScriptCandidateSet(
                            UInt64(0x20000000), UInt64(0x4000000000), UInt64(0x20000000)
                        )
                    if candidate_id > 262:
                        if candidate_id < 264:
                            if candidate_id < 263:
                                return _ScriptCandidateSet()
                            if candidate_id > 263:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x200000000), UInt64(0x0), UInt64(0x0)
                            )
                        if candidate_id > 264:
                            return _ScriptCandidateSet()
                        return _ScriptCandidateSet(
                            UInt64(0x200000000), UInt64(0x400), UInt64(0x4000)
                        )
                    return _ScriptCandidateSet(
                        UInt64(0x20000000), UInt64(0x0), UInt64(0x80000)
                    )
                return _ScriptCandidateSet(
                    UInt64(0x20000000), UInt64(0x4000000000), UInt64(0x0)
                )
            return _ScriptCandidateSet(
                UInt64(0x14000A0000000), UInt64(0x10040088), UInt64(0x20010020)
            )
        if candidate_id > 265:
            if candidate_id < 280:
                if candidate_id < 273:
                    if candidate_id < 269:
                        if candidate_id < 267:
                            if candidate_id < 266:
                                return _ScriptCandidateSet()
                            if candidate_id > 266:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x18000000000), UInt64(0x400), UInt64(0x0)
                            )
                        if candidate_id > 267:
                            if candidate_id < 268:
                                return _ScriptCandidateSet()
                            if candidate_id > 268:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x100000000000), UInt64(0x0), UInt64(0x80000)
                            )
                        return _ScriptCandidateSet(
                            UInt64(0x10000000000), UInt64(0x400), UInt64(0x8005000)
                        )
                    if candidate_id > 269:
                        if candidate_id < 271:
                            if candidate_id < 270:
                                return _ScriptCandidateSet()
                            if candidate_id > 270:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x200000000000),
                                UInt64(0x8000000000400),
                                UInt64(0x80000000),
                            )
                        if candidate_id > 271:
                            if candidate_id < 272:
                                return _ScriptCandidateSet()
                            if candidate_id > 272:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x1000000000000),
                                UInt64(0x100000000),
                                UInt64(0x0),
                            )
                        return _ScriptCandidateSet(
                            UInt64(0x400000000000), UInt64(0x8), UInt64(0x0)
                        )
                    return _ScriptCandidateSet(
                        UInt64(0x200000000000), UInt64(0x0), UInt64(0x0)
                    )
                if candidate_id > 273:
                    if candidate_id < 277:
                        if candidate_id < 275:
                            if candidate_id < 274:
                                return _ScriptCandidateSet()
                            if candidate_id > 274:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x8044000000000000), UInt64(0x0), UInt64(0x0)
                            )
                        if candidate_id > 275:
                            if candidate_id < 276:
                                return _ScriptCandidateSet()
                            if candidate_id > 276:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x4000000000000), UInt64(0x0), UInt64(0x100000)
                            )
                        return _ScriptCandidateSet(
                            UInt64(0x4000000000000), UInt64(0x400), UInt64(0x0)
                        )
                    if candidate_id > 277:
                        if candidate_id < 279:
                            if candidate_id < 278:
                                return _ScriptCandidateSet()
                            if candidate_id > 278:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x4000000000000000),
                                UInt64(0x200000400),
                                UInt64(0x0),
                            )
                        if candidate_id > 279:
                            return _ScriptCandidateSet()
                        return _ScriptCandidateSet(
                            UInt64(0x0), UInt64(0x800000020), UInt64(0x400000000)
                        )
                    return _ScriptCandidateSet(
                        UInt64(0x8040000000000000), UInt64(0x0), UInt64(0x0)
                    )
                return _ScriptCandidateSet(
                    UInt64(0x4000000000000), UInt64(0x0), UInt64(0x0)
                )
            if candidate_id > 280:
                if candidate_id < 287:
                    if candidate_id < 284:
                        if candidate_id < 282:
                            if candidate_id < 281:
                                return _ScriptCandidateSet()
                            if candidate_id > 281:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x0), UInt64(0x8400), UInt64(0x0)
                            )
                        if candidate_id > 282:
                            if candidate_id < 283:
                                return _ScriptCandidateSet()
                            if candidate_id > 283:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x0), UInt64(0x400000000400), UInt64(0x0)
                            )
                        return _ScriptCandidateSet(
                            UInt64(0x0), UInt64(0x10000020000400), UInt64(0x0)
                        )
                    if candidate_id > 284:
                        if candidate_id < 286:
                            if candidate_id < 285:
                                return _ScriptCandidateSet()
                            if candidate_id > 285:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x0), UInt64(0x400), UInt64(0x5000)
                            )
                        if candidate_id > 286:
                            return _ScriptCandidateSet()
                        return _ScriptCandidateSet(
                            UInt64(0x0), UInt64(0x400), UInt64(0x4000)
                        )
                    return _ScriptCandidateSet(
                        UInt64(0x0), UInt64(0x400), UInt64(0x1000)
                    )
                if candidate_id > 287:
                    if candidate_id < 291:
                        if candidate_id < 289:
                            if candidate_id < 288:
                                return _ScriptCandidateSet()
                            if candidate_id > 288:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x0), UInt64(0x400), UInt64(0x8000000)
                            )
                        if candidate_id > 289:
                            if candidate_id < 290:
                                return _ScriptCandidateSet()
                            if candidate_id > 290:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x0), UInt64(0x10000020000000), UInt64(0x0)
                            )
                        return _ScriptCandidateSet(
                            UInt64(0x0), UInt64(0x1000000200000), UInt64(0x0)
                        )
                    if candidate_id > 291:
                        if candidate_id < 293:
                            if candidate_id < 292:
                                return _ScriptCandidateSet()
                            if candidate_id > 292:
                                return _ScriptCandidateSet()
                            return _ScriptCandidateSet(
                                UInt64(0x0), UInt64(0x1000000000000000), UInt64(0x0)
                            )
                        if candidate_id > 293:
                            return _ScriptCandidateSet()
                        return _ScriptCandidateSet(
                            UInt64(0x0), UInt64(0x0), UInt64(0x4000)
                        )
                    return _ScriptCandidateSet(
                        UInt64(0x0), UInt64(0x800000000), UInt64(0x0)
                    )
                return _ScriptCandidateSet(
                    UInt64(0x0), UInt64(0x400), UInt64(0x1000000)
                )
            return _ScriptCandidateSet(UInt64(0x0), UInt64(0x400), UInt64(0x0))
        return _ScriptCandidateSet(UInt64(0x2000000000), UInt64(0x400), UInt64(0x0))
    return _ScriptCandidateSet(UInt64(0x200002000000), UInt64(0x0), UInt64(0x0))


def _unicode_script_property(value: Int) -> _UnicodeScriptProperty:
    if value < 0 or value > 0x10FFFF:
        return _UnicodeScriptProperty(175, UInt8(0))
    if value < 0xA708:
        if value < 0xF00:
            if value < 0x958:
                if value < 0x485:
                    if value < 0x30D:
                        if value < 0x2CD:
                            if value < 0xC0:
                                if value < 0xAA:
                                    if value < 0x5B:
                                        if value < 0x41:
                                            if value < 0x0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x40:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x5A:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(74, UInt8(0))
                                    if value > 0x60:
                                        if value < 0x7B:
                                            if value < 0x61:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x7A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(74, UInt8(0))
                                        if value > 0xA9:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                if value > 0xAA:
                                    if value < 0xB8:
                                        if value < 0xB7:
                                            if value < 0xAB:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xB6:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0xB7:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(193, UInt8(1))
                                    if value > 0xB9:
                                        if value < 0xBB:
                                            if value < 0xBA:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xBA:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(74, UInt8(0))
                                        if value > 0xBF:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                return _UnicodeScriptProperty(74, UInt8(0))
                            if value > 0xD6:
                                if value < 0x2BC:
                                    if value < 0xF7:
                                        if value < 0xD8:
                                            if value < 0xD7:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xD7:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0xF6:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(74, UInt8(0))
                                    if value > 0xF7:
                                        if value < 0x2B9:
                                            if value < 0xF8:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x2B8:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(74, UInt8(0))
                                        if value > 0x2BB:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                if value > 0x2BC:
                                    if value < 0x2C8:
                                        if value < 0x2C7:
                                            if value < 0x2BD:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x2C6:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x2C7:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(219, UInt8(1))
                                    if value > 0x2C8:
                                        if value < 0x2CC:
                                            if value < 0x2C9:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x2CB:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(219, UInt8(1))
                                        if value > 0x2CC:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                return _UnicodeScriptProperty(198, UInt8(1))
                            return _UnicodeScriptProperty(74, UInt8(0))
                        if value > 0x2CD:
                            if value < 0x302:
                                if value < 0x2E0:
                                    if value < 0x2D8:
                                        if value < 0x2D7:
                                            if value < 0x2CE:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x2D6:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x2D7:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(288, UInt8(1))
                                    if value > 0x2D8:
                                        if value < 0x2DA:
                                            if value < 0x2D9:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x2D9:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(219, UInt8(1))
                                        if value > 0x2DF:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                if value > 0x2E4:
                                    if value < 0x2EC:
                                        if value < 0x2EA:
                                            if value < 0x2E5:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x2E9:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x2EB:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(14, UInt8(0))
                                    if value > 0x2FF:
                                        if value < 0x301:
                                            if value < 0x300:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x300:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(225, UInt8(6))
                                        if value > 0x301:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(226, UInt8(6))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                return _UnicodeScriptProperty(74, UInt8(0))
                            if value > 0x302:
                                if value < 0x308:
                                    if value < 0x305:
                                        if value < 0x304:
                                            if value < 0x303:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x303:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(267, UInt8(6))
                                        if value > 0x304:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(180, UInt8(6))
                                    if value > 0x305:
                                        if value < 0x307:
                                            if value < 0x306:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x306:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(241, UInt8(6))
                                        if value > 0x307:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(233, UInt8(6))
                                    return _UnicodeScriptProperty(234, UInt8(6))
                                if value > 0x308:
                                    if value < 0x30B:
                                        if value < 0x30A:
                                            if value < 0x309:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x309:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(287, UInt8(6))
                                        if value > 0x30A:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(264, UInt8(6))
                                    if value > 0x30B:
                                        if value < 0x30C:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0x30C:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(232, UInt8(6))
                                    return _UnicodeScriptProperty(227, UInt8(6))
                                return _UnicodeScriptProperty(191, UInt8(6))
                            return _UnicodeScriptProperty(228, UInt8(6))
                        return _UnicodeScriptProperty(281, UInt8(1))
                    if value > 0x30D:
                        if value < 0x35E:
                            if value < 0x32D:
                                if value < 0x313:
                                    if value < 0x310:
                                        if value < 0x30F:
                                            if value < 0x30E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x30E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(265, UInt8(6))
                                        if value > 0x30F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(173, UInt8(6))
                                    if value > 0x310:
                                        if value < 0x312:
                                            if value < 0x311:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x311:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(244, UInt8(6))
                                        if value > 0x312:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(173, UInt8(6))
                                    return _UnicodeScriptProperty(284, UInt8(6))
                                if value > 0x313:
                                    if value < 0x324:
                                        if value < 0x323:
                                            if value < 0x314:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x322:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(173, UInt8(6))
                                        if value > 0x323:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(229, UInt8(6))
                                    if value > 0x324:
                                        if value < 0x326:
                                            if value < 0x325:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x325:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(286, UInt8(6))
                                        if value > 0x32C:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(173, UInt8(6))
                                    return _UnicodeScriptProperty(230, UInt8(6))
                                return _UnicodeScriptProperty(270, UInt8(6))
                            if value > 0x32D:
                                if value < 0x342:
                                    if value < 0x330:
                                        if value < 0x32F:
                                            if value < 0x32E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x32E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(286, UInt8(6))
                                        if value > 0x32F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(173, UInt8(6))
                                    if value > 0x330:
                                        if value < 0x332:
                                            if value < 0x331:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x331:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(181, UInt8(6))
                                        if value > 0x341:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(173, UInt8(6))
                                    return _UnicodeScriptProperty(231, UInt8(6))
                                if value > 0x342:
                                    if value < 0x346:
                                        if value < 0x345:
                                            if value < 0x343:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x344:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(173, UInt8(6))
                                        if value > 0x345:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(269, UInt8(6))
                                    if value > 0x357:
                                        if value < 0x359:
                                            if value < 0x358:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x358:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(283, UInt8(6))
                                        if value > 0x35D:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(173, UInt8(6))
                                    return _UnicodeScriptProperty(173, UInt8(6))
                                return _UnicodeScriptProperty(269, UInt8(6))
                            return _UnicodeScriptProperty(285, UInt8(6))
                        if value > 0x35E:
                            if value < 0x386:
                                if value < 0x376:
                                    if value < 0x370:
                                        if value < 0x363:
                                            if value < 0x35F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x362:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(173, UInt8(6))
                                        if value > 0x36F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(280, UInt8(6))
                                    if value > 0x373:
                                        if value < 0x375:
                                            if value < 0x374:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x374:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(235, UInt8(1))
                                        if value > 0x375:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(235, UInt8(0))
                                    return _UnicodeScriptProperty(45, UInt8(0))
                                if value > 0x377:
                                    if value < 0x37F:
                                        if value < 0x37E:
                                            if value < 0x37A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x37D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(45, UInt8(0))
                                        if value > 0x37E:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    if value > 0x37F:
                                        if value < 0x385:
                                            if value < 0x384:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x384:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(45, UInt8(0))
                                        if value > 0x385:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(45, UInt8(0))
                                return _UnicodeScriptProperty(45, UInt8(0))
                            if value > 0x386:
                                if value < 0x3E2:
                                    if value < 0x38C:
                                        if value < 0x388:
                                            if value < 0x387:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x387:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x38A:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(45, UInt8(0))
                                    if value > 0x38C:
                                        if value < 0x3A3:
                                            if value < 0x38E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x3A1:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(45, UInt8(0))
                                        if value > 0x3E1:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(45, UInt8(0))
                                    return _UnicodeScriptProperty(45, UInt8(0))
                                if value > 0x3EF:
                                    if value < 0x483:
                                        if value < 0x400:
                                            if value < 0x3F0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x3FF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(45, UInt8(0))
                                        if value > 0x482:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(28, UInt8(0))
                                    if value > 0x483:
                                        if value < 0x484:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0x484:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(240, UInt8(4))
                                    return _UnicodeScriptProperty(245, UInt8(4))
                                return _UnicodeScriptProperty(25, UInt8(0))
                            return _UnicodeScriptProperty(45, UInt8(0))
                        return _UnicodeScriptProperty(182, UInt8(6))
                    return _UnicodeScriptProperty(284, UInt8(6))
                if value > 0x486:
                    if value < 0x6E9:
                        if value < 0x60D:
                            if value < 0x5C0:
                                if value < 0x589:
                                    if value < 0x48A:
                                        if value < 0x488:
                                            if value < 0x487:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x487:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(240, UInt8(4))
                                        if value > 0x489:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(28, UInt8(4))
                                    if value > 0x52F:
                                        if value < 0x559:
                                            if value < 0x531:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x556:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(5, UInt8(0))
                                        if value > 0x588:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(5, UInt8(0))
                                    return _UnicodeScriptProperty(28, UInt8(0))
                                if value > 0x589:
                                    if value < 0x591:
                                        if value < 0x58D:
                                            if value < 0x58A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x58A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(5, UInt8(0))
                                        if value > 0x58F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(5, UInt8(0))
                                    if value > 0x5BD:
                                        if value < 0x5BF:
                                            if value < 0x5BE:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x5BE:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(53, UInt8(0))
                                        if value > 0x5BF:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(53, UInt8(4))
                                    return _UnicodeScriptProperty(53, UInt8(4))
                                return _UnicodeScriptProperty(192, UInt8(0))
                            if value > 0x5C0:
                                if value < 0x5D0:
                                    if value < 0x5C4:
                                        if value < 0x5C3:
                                            if value < 0x5C1:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x5C2:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(53, UInt8(4))
                                        if value > 0x5C3:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(53, UInt8(0))
                                    if value > 0x5C5:
                                        if value < 0x5C7:
                                            if value < 0x5C6:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x5C6:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(53, UInt8(0))
                                        if value > 0x5C7:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(53, UInt8(4))
                                    return _UnicodeScriptProperty(53, UInt8(4))
                                if value > 0x5EA:
                                    if value < 0x605:
                                        if value < 0x600:
                                            if value < 0x5EF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x5F4:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(53, UInt8(0))
                                        if value > 0x604:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(3, UInt8(0))
                                    if value > 0x605:
                                        if value < 0x60C:
                                            if value < 0x606:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x60B:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(3, UInt8(0))
                                        if value > 0x60C:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(184, UInt8(1))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                return _UnicodeScriptProperty(53, UInt8(0))
                            return _UnicodeScriptProperty(53, UInt8(0))
                        if value > 0x60F:
                            if value < 0x66A:
                                if value < 0x620:
                                    if value < 0x61C:
                                        if value < 0x61B:
                                            if value < 0x610:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x61A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(3, UInt8(4))
                                        if value > 0x61B:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(184, UInt8(1))
                                    if value > 0x61C:
                                        if value < 0x61F:
                                            if value < 0x61D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x61E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(3, UInt8(0))
                                        if value > 0x61F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(177, UInt8(1))
                                    return _UnicodeScriptProperty(188, UInt8(0))
                                if value > 0x63F:
                                    if value < 0x64B:
                                        if value < 0x641:
                                            if value < 0x640:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x640:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(179, UInt8(1))
                                        if value > 0x64A:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(3, UInt8(0))
                                    if value > 0x655:
                                        if value < 0x660:
                                            if value < 0x656:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x65F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(3, UInt8(4))
                                        if value > 0x669:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(190, UInt8(0))
                                    return _UnicodeScriptProperty(187, UInt8(6))
                                return _UnicodeScriptProperty(3, UInt8(0))
                            if value > 0x66F:
                                if value < 0x6DD:
                                    if value < 0x6D4:
                                        if value < 0x671:
                                            if value < 0x670:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x670:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(187, UInt8(6))
                                        if value > 0x6D3:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(3, UInt8(0))
                                    if value > 0x6D4:
                                        if value < 0x6D6:
                                            if value < 0x6D5:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x6D5:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(3, UInt8(0))
                                        if value > 0x6DC:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(3, UInt8(4))
                                    return _UnicodeScriptProperty(186, UInt8(0))
                                if value > 0x6DD:
                                    if value < 0x6E5:
                                        if value < 0x6DF:
                                            if value < 0x6DE:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x6DE:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(3, UInt8(0))
                                        if value > 0x6E4:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(3, UInt8(4))
                                    if value > 0x6E6:
                                        if value < 0x6E7:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0x6E8:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(3, UInt8(4))
                                    return _UnicodeScriptProperty(3, UInt8(0))
                                return _UnicodeScriptProperty(174, UInt8(1))
                            return _UnicodeScriptProperty(3, UInt8(0))
                        return _UnicodeScriptProperty(3, UInt8(0))
                    if value > 0x6E9:
                        if value < 0x828:
                            if value < 0x7B1:
                                if value < 0x712:
                                    if value < 0x700:
                                        if value < 0x6EE:
                                            if value < 0x6EA:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x6ED:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(3, UInt8(4))
                                        if value > 0x6FF:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(3, UInt8(0))
                                    if value > 0x70D:
                                        if value < 0x711:
                                            if value < 0x70F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x710:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(142, UInt8(0))
                                        if value > 0x711:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(142, UInt8(4))
                                    return _UnicodeScriptProperty(142, UInt8(0))
                                if value > 0x72F:
                                    if value < 0x750:
                                        if value < 0x74D:
                                            if value < 0x730:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x74A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(142, UInt8(4))
                                        if value > 0x74F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(142, UInt8(0))
                                    if value > 0x77F:
                                        if value < 0x7A6:
                                            if value < 0x780:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x7A5:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(154, UInt8(0))
                                        if value > 0x7B0:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(154, UInt8(4))
                                    return _UnicodeScriptProperty(3, UInt8(0))
                                return _UnicodeScriptProperty(142, UInt8(0))
                            if value > 0x7B1:
                                if value < 0x800:
                                    if value < 0x7F4:
                                        if value < 0x7EB:
                                            if value < 0x7C0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x7EA:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(103, UInt8(0))
                                        if value > 0x7F3:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(103, UInt8(4))
                                    if value > 0x7FA:
                                        if value < 0x7FE:
                                            if value < 0x7FD:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x7FD:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(103, UInt8(4))
                                        if value > 0x7FF:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(103, UInt8(0))
                                    return _UnicodeScriptProperty(103, UInt8(0))
                                if value > 0x815:
                                    if value < 0x81B:
                                        if value < 0x81A:
                                            if value < 0x816:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x819:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(125, UInt8(4))
                                        if value > 0x81A:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(125, UInt8(0))
                                    if value > 0x823:
                                        if value < 0x825:
                                            if value < 0x824:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x824:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(125, UInt8(0))
                                        if value > 0x827:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(125, UInt8(4))
                                    return _UnicodeScriptProperty(125, UInt8(4))
                                return _UnicodeScriptProperty(125, UInt8(0))
                            return _UnicodeScriptProperty(154, UInt8(0))
                        if value > 0x828:
                            if value < 0x8E3:
                                if value < 0x860:
                                    if value < 0x840:
                                        if value < 0x830:
                                            if value < 0x829:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x82D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(125, UInt8(4))
                                        if value > 0x83E:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(125, UInt8(0))
                                    if value > 0x858:
                                        if value < 0x85E:
                                            if value < 0x859:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x85B:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(84, UInt8(4))
                                        if value > 0x85E:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(84, UInt8(0))
                                    return _UnicodeScriptProperty(84, UInt8(0))
                                if value > 0x86A:
                                    if value < 0x8A0:
                                        if value < 0x897:
                                            if value < 0x870:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x891:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(3, UInt8(0))
                                        if value > 0x89F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(3, UInt8(4))
                                    if value > 0x8C9:
                                        if value < 0x8E2:
                                            if value < 0x8CA:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x8E1:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(3, UInt8(4))
                                        if value > 0x8E2:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(3, UInt8(0))
                                return _UnicodeScriptProperty(142, UInt8(0))
                            if value > 0x8FF:
                                if value < 0x950:
                                    if value < 0x93A:
                                        if value < 0x904:
                                            if value < 0x900:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x903:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(29, UInt8(4))
                                        if value > 0x939:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(29, UInt8(0))
                                    if value > 0x93C:
                                        if value < 0x93E:
                                            if value < 0x93D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x93D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(29, UInt8(0))
                                        if value > 0x94F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(29, UInt8(4))
                                    return _UnicodeScriptProperty(29, UInt8(4))
                                if value > 0x950:
                                    if value < 0x953:
                                        if value < 0x952:
                                            if value < 0x951:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x951:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(202, UInt8(6))
                                        if value > 0x952:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(203, UInt8(6))
                                    if value > 0x954:
                                        if value < 0x955:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0x957:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(29, UInt8(4))
                                    return _UnicodeScriptProperty(173, UInt8(6))
                                return _UnicodeScriptProperty(29, UInt8(0))
                            return _UnicodeScriptProperty(3, UInt8(4))
                        return _UnicodeScriptProperty(125, UInt8(0))
                    return _UnicodeScriptProperty(3, UInt8(0))
                return _UnicodeScriptProperty(242, UInt8(6))
            if value > 0x961:
                if value < 0xBBE:
                    if value < 0xA81:
                        if value < 0x9E6:
                            if value < 0x9B2:
                                if value < 0x980:
                                    if value < 0x965:
                                        if value < 0x964:
                                            if value < 0x962:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x963:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(29, UInt8(4))
                                        if value > 0x964:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(201, UInt8(1))
                                    if value > 0x965:
                                        if value < 0x970:
                                            if value < 0x966:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x96F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(251, UInt8(0))
                                        if value > 0x97F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(29, UInt8(0))
                                    return _UnicodeScriptProperty(200, UInt8(1))
                                if value > 0x980:
                                    if value < 0x98F:
                                        if value < 0x985:
                                            if value < 0x981:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x983:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(11, UInt8(4))
                                        if value > 0x98C:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(11, UInt8(0))
                                    if value > 0x990:
                                        if value < 0x9AA:
                                            if value < 0x993:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x9A8:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(11, UInt8(0))
                                        if value > 0x9B0:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(11, UInt8(0))
                                    return _UnicodeScriptProperty(11, UInt8(0))
                                return _UnicodeScriptProperty(11, UInt8(0))
                            if value > 0x9B2:
                                if value < 0x9CB:
                                    if value < 0x9BD:
                                        if value < 0x9BC:
                                            if value < 0x9B6:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x9B9:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(11, UInt8(0))
                                        if value > 0x9BC:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(11, UInt8(4))
                                    if value > 0x9BD:
                                        if value < 0x9C7:
                                            if value < 0x9BE:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x9C4:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(11, UInt8(4))
                                        if value > 0x9C8:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(11, UInt8(4))
                                    return _UnicodeScriptProperty(11, UInt8(0))
                                if value > 0x9CD:
                                    if value < 0x9DC:
                                        if value < 0x9D7:
                                            if value < 0x9CE:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x9CE:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(11, UInt8(0))
                                        if value > 0x9D7:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(11, UInt8(4))
                                    if value > 0x9DD:
                                        if value < 0x9E2:
                                            if value < 0x9DF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x9E1:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(11, UInt8(0))
                                        if value > 0x9E3:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(11, UInt8(4))
                                    return _UnicodeScriptProperty(11, UInt8(0))
                                return _UnicodeScriptProperty(11, UInt8(4))
                            return _UnicodeScriptProperty(11, UInt8(0))
                        if value > 0x9EF:
                            if value < 0xA3E:
                                if value < 0xA13:
                                    if value < 0xA01:
                                        if value < 0x9FE:
                                            if value < 0x9F0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x9FD:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(11, UInt8(0))
                                        if value > 0x9FE:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(11, UInt8(4))
                                    if value > 0xA03:
                                        if value < 0xA0F:
                                            if value < 0xA05:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xA0A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(48, UInt8(0))
                                        if value > 0xA10:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(48, UInt8(0))
                                    return _UnicodeScriptProperty(48, UInt8(4))
                                if value > 0xA28:
                                    if value < 0xA35:
                                        if value < 0xA32:
                                            if value < 0xA2A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xA30:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(48, UInt8(0))
                                        if value > 0xA33:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(48, UInt8(0))
                                    if value > 0xA36:
                                        if value < 0xA3C:
                                            if value < 0xA38:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xA39:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(48, UInt8(0))
                                        if value > 0xA3C:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(48, UInt8(4))
                                    return _UnicodeScriptProperty(48, UInt8(0))
                                return _UnicodeScriptProperty(48, UInt8(0))
                            if value > 0xA42:
                                if value < 0xA66:
                                    if value < 0xA51:
                                        if value < 0xA4B:
                                            if value < 0xA47:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xA48:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(48, UInt8(4))
                                        if value > 0xA4D:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(48, UInt8(4))
                                    if value > 0xA51:
                                        if value < 0xA5E:
                                            if value < 0xA59:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xA5C:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(48, UInt8(0))
                                        if value > 0xA5E:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(48, UInt8(0))
                                    return _UnicodeScriptProperty(48, UInt8(4))
                                if value > 0xA6F:
                                    if value < 0xA75:
                                        if value < 0xA72:
                                            if value < 0xA70:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xA71:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(48, UInt8(4))
                                        if value > 0xA74:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(48, UInt8(0))
                                    if value > 0xA75:
                                        if value < 0xA76:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0xA76:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(48, UInt8(0))
                                    return _UnicodeScriptProperty(48, UInt8(4))
                                return _UnicodeScriptProperty(272, UInt8(0))
                            return _UnicodeScriptProperty(48, UInt8(4))
                        return _UnicodeScriptProperty(197, UInt8(0))
                    if value > 0xA83:
                        if value < 0xB32:
                            if value < 0xAD0:
                                if value < 0xAB5:
                                    if value < 0xA93:
                                        if value < 0xA8F:
                                            if value < 0xA85:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xA8D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(46, UInt8(0))
                                        if value > 0xA91:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(46, UInt8(0))
                                    if value > 0xAA8:
                                        if value < 0xAB2:
                                            if value < 0xAAA:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xAB0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(46, UInt8(0))
                                        if value > 0xAB3:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(46, UInt8(0))
                                    return _UnicodeScriptProperty(46, UInt8(0))
                                if value > 0xAB9:
                                    if value < 0xABE:
                                        if value < 0xABD:
                                            if value < 0xABC:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xABC:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(46, UInt8(4))
                                        if value > 0xABD:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(46, UInt8(0))
                                    if value > 0xAC5:
                                        if value < 0xACB:
                                            if value < 0xAC7:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xAC9:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(46, UInt8(4))
                                        if value > 0xACD:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(46, UInt8(4))
                                    return _UnicodeScriptProperty(46, UInt8(4))
                                return _UnicodeScriptProperty(46, UInt8(0))
                            if value > 0xAD0:
                                if value < 0xAFA:
                                    if value < 0xAE6:
                                        if value < 0xAE2:
                                            if value < 0xAE0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xAE1:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(46, UInt8(0))
                                        if value > 0xAE3:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(46, UInt8(4))
                                    if value > 0xAEF:
                                        if value < 0xAF9:
                                            if value < 0xAF0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xAF1:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(46, UInt8(0))
                                        if value > 0xAF9:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(46, UInt8(0))
                                    return _UnicodeScriptProperty(271, UInt8(0))
                                if value > 0xAFF:
                                    if value < 0xB0F:
                                        if value < 0xB05:
                                            if value < 0xB01:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xB03:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(109, UInt8(4))
                                        if value > 0xB0C:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(109, UInt8(0))
                                    if value > 0xB10:
                                        if value < 0xB2A:
                                            if value < 0xB13:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xB28:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(109, UInt8(0))
                                        if value > 0xB30:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(109, UInt8(0))
                                    return _UnicodeScriptProperty(109, UInt8(0))
                                return _UnicodeScriptProperty(46, UInt8(4))
                            return _UnicodeScriptProperty(46, UInt8(0))
                        if value > 0xB33:
                            if value < 0xB82:
                                if value < 0xB4B:
                                    if value < 0xB3D:
                                        if value < 0xB3C:
                                            if value < 0xB35:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xB39:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(109, UInt8(0))
                                        if value > 0xB3C:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(109, UInt8(4))
                                    if value > 0xB3D:
                                        if value < 0xB47:
                                            if value < 0xB3E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xB44:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(109, UInt8(4))
                                        if value > 0xB48:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(109, UInt8(4))
                                    return _UnicodeScriptProperty(109, UInt8(0))
                                if value > 0xB4D:
                                    if value < 0xB5F:
                                        if value < 0xB5C:
                                            if value < 0xB55:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xB57:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(109, UInt8(4))
                                        if value > 0xB5D:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(109, UInt8(0))
                                    if value > 0xB61:
                                        if value < 0xB66:
                                            if value < 0xB62:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xB63:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(109, UInt8(4))
                                        if value > 0xB77:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(109, UInt8(0))
                                    return _UnicodeScriptProperty(109, UInt8(0))
                                return _UnicodeScriptProperty(109, UInt8(4))
                            if value > 0xB82:
                                if value < 0xB9C:
                                    if value < 0xB8E:
                                        if value < 0xB85:
                                            if value < 0xB83:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xB83:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(147, UInt8(0))
                                        if value > 0xB8A:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(147, UInt8(0))
                                    if value > 0xB90:
                                        if value < 0xB99:
                                            if value < 0xB92:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xB95:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(147, UInt8(0))
                                        if value > 0xB9A:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(147, UInt8(0))
                                    return _UnicodeScriptProperty(147, UInt8(0))
                                if value > 0xB9C:
                                    if value < 0xBA8:
                                        if value < 0xBA3:
                                            if value < 0xB9E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xB9F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(147, UInt8(0))
                                        if value > 0xBA4:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(147, UInt8(0))
                                    if value > 0xBAA:
                                        if value < 0xBAE:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0xBB9:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(147, UInt8(0))
                                    return _UnicodeScriptProperty(147, UInt8(0))
                                return _UnicodeScriptProperty(147, UInt8(0))
                            return _UnicodeScriptProperty(147, UInt8(4))
                        return _UnicodeScriptProperty(109, UInt8(0))
                    return _UnicodeScriptProperty(46, UInt8(4))
                if value > 0xBC2:
                    if value < 0xD3B:
                        if value < 0xC80:
                            if value < 0xC3C:
                                if value < 0xBF4:
                                    if value < 0xBD0:
                                        if value < 0xBCA:
                                            if value < 0xBC6:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xBC8:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(147, UInt8(4))
                                        if value > 0xBCD:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(147, UInt8(4))
                                    if value > 0xBD0:
                                        if value < 0xBE6:
                                            if value < 0xBD7:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xBD7:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(147, UInt8(4))
                                        if value > 0xBF3:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(268, UInt8(0))
                                    return _UnicodeScriptProperty(147, UInt8(0))
                                if value > 0xBFA:
                                    if value < 0xC0E:
                                        if value < 0xC05:
                                            if value < 0xC00:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xC04:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(151, UInt8(4))
                                        if value > 0xC0C:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(151, UInt8(0))
                                    if value > 0xC10:
                                        if value < 0xC2A:
                                            if value < 0xC12:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xC28:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(151, UInt8(0))
                                        if value > 0xC39:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(151, UInt8(0))
                                    return _UnicodeScriptProperty(151, UInt8(0))
                                return _UnicodeScriptProperty(147, UInt8(0))
                            if value > 0xC3C:
                                if value < 0xC58:
                                    if value < 0xC46:
                                        if value < 0xC3E:
                                            if value < 0xC3D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xC3D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(151, UInt8(0))
                                        if value > 0xC44:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(151, UInt8(4))
                                    if value > 0xC48:
                                        if value < 0xC55:
                                            if value < 0xC4A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xC4D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(151, UInt8(4))
                                        if value > 0xC56:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(151, UInt8(4))
                                    return _UnicodeScriptProperty(151, UInt8(4))
                                if value > 0xC5A:
                                    if value < 0xC62:
                                        if value < 0xC60:
                                            if value < 0xC5C:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xC5D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(151, UInt8(0))
                                        if value > 0xC61:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(151, UInt8(0))
                                    if value > 0xC63:
                                        if value < 0xC77:
                                            if value < 0xC66:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xC6F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(151, UInt8(0))
                                        if value > 0xC7F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(151, UInt8(0))
                                    return _UnicodeScriptProperty(151, UInt8(4))
                                return _UnicodeScriptProperty(151, UInt8(0))
                            return _UnicodeScriptProperty(151, UInt8(4))
                        if value > 0xC80:
                            if value < 0xCD5:
                                if value < 0xCB5:
                                    if value < 0xC8E:
                                        if value < 0xC84:
                                            if value < 0xC81:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xC83:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(69, UInt8(4))
                                        if value > 0xC8C:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(69, UInt8(0))
                                    if value > 0xC90:
                                        if value < 0xCAA:
                                            if value < 0xC92:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xCA8:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(69, UInt8(0))
                                        if value > 0xCB3:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(69, UInt8(0))
                                    return _UnicodeScriptProperty(69, UInt8(0))
                                if value > 0xCB9:
                                    if value < 0xCBE:
                                        if value < 0xCBD:
                                            if value < 0xCBC:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xCBC:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(69, UInt8(4))
                                        if value > 0xCBD:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(69, UInt8(0))
                                    if value > 0xCC4:
                                        if value < 0xCCA:
                                            if value < 0xCC6:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xCC8:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(69, UInt8(4))
                                        if value > 0xCCD:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(69, UInt8(4))
                                    return _UnicodeScriptProperty(69, UInt8(4))
                                return _UnicodeScriptProperty(69, UInt8(0))
                            if value > 0xCD6:
                                if value < 0xCF3:
                                    if value < 0xCE2:
                                        if value < 0xCE0:
                                            if value < 0xCDC:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xCDE:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(69, UInt8(0))
                                        if value > 0xCE1:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(69, UInt8(0))
                                    if value > 0xCE3:
                                        if value < 0xCF1:
                                            if value < 0xCE6:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xCEF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(279, UInt8(0))
                                        if value > 0xCF2:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(69, UInt8(0))
                                    return _UnicodeScriptProperty(69, UInt8(4))
                                if value > 0xCF3:
                                    if value < 0xD0E:
                                        if value < 0xD04:
                                            if value < 0xD00:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xD03:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(91, UInt8(4))
                                        if value > 0xD0C:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(91, UInt8(0))
                                    if value > 0xD10:
                                        if value < 0xD12:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0xD3A:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(91, UInt8(0))
                                    return _UnicodeScriptProperty(91, UInt8(0))
                                return _UnicodeScriptProperty(69, UInt8(4))
                            return _UnicodeScriptProperty(69, UInt8(4))
                        return _UnicodeScriptProperty(69, UInt8(0))
                    if value > 0xD3C:
                        if value < 0xE01:
                            if value < 0xD85:
                                if value < 0xD54:
                                    if value < 0xD46:
                                        if value < 0xD3E:
                                            if value < 0xD3D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xD3D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(91, UInt8(0))
                                        if value > 0xD44:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(91, UInt8(4))
                                    if value > 0xD48:
                                        if value < 0xD4E:
                                            if value < 0xD4A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xD4D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(91, UInt8(4))
                                        if value > 0xD4F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(91, UInt8(0))
                                    return _UnicodeScriptProperty(91, UInt8(4))
                                if value > 0xD56:
                                    if value < 0xD62:
                                        if value < 0xD58:
                                            if value < 0xD57:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xD57:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(91, UInt8(4))
                                        if value > 0xD61:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(91, UInt8(0))
                                    if value > 0xD63:
                                        if value < 0xD81:
                                            if value < 0xD66:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xD7F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(91, UInt8(0))
                                        if value > 0xD83:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(134, UInt8(4))
                                    return _UnicodeScriptProperty(91, UInt8(4))
                                return _UnicodeScriptProperty(91, UInt8(0))
                            if value > 0xD96:
                                if value < 0xDCF:
                                    if value < 0xDBD:
                                        if value < 0xDB3:
                                            if value < 0xD9A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xDB1:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(134, UInt8(0))
                                        if value > 0xDBB:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(134, UInt8(0))
                                    if value > 0xDBD:
                                        if value < 0xDCA:
                                            if value < 0xDC0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xDC6:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(134, UInt8(0))
                                        if value > 0xDCA:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(134, UInt8(4))
                                    return _UnicodeScriptProperty(134, UInt8(0))
                                if value > 0xDD4:
                                    if value < 0xDE6:
                                        if value < 0xDD8:
                                            if value < 0xDD6:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xDD6:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(134, UInt8(4))
                                        if value > 0xDDF:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(134, UInt8(4))
                                    if value > 0xDEF:
                                        if value < 0xDF4:
                                            if value < 0xDF2:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xDF3:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(134, UInt8(4))
                                        if value > 0xDF4:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(134, UInt8(0))
                                    return _UnicodeScriptProperty(134, UInt8(0))
                                return _UnicodeScriptProperty(134, UInt8(4))
                            return _UnicodeScriptProperty(134, UInt8(0))
                        if value > 0xE30:
                            if value < 0xEA5:
                                if value < 0xE47:
                                    if value < 0xE34:
                                        if value < 0xE32:
                                            if value < 0xE31:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xE31:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(155, UInt8(4))
                                        if value > 0xE33:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(155, UInt8(0))
                                    if value > 0xE3A:
                                        if value < 0xE40:
                                            if value < 0xE3F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xE3F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0xE46:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(155, UInt8(0))
                                    return _UnicodeScriptProperty(155, UInt8(4))
                                if value > 0xE4E:
                                    if value < 0xE84:
                                        if value < 0xE81:
                                            if value < 0xE4F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xE5B:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(155, UInt8(0))
                                        if value > 0xE82:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(73, UInt8(0))
                                    if value > 0xE84:
                                        if value < 0xE8C:
                                            if value < 0xE86:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xE8A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(73, UInt8(0))
                                        if value > 0xEA3:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(73, UInt8(0))
                                    return _UnicodeScriptProperty(73, UInt8(0))
                                return _UnicodeScriptProperty(155, UInt8(4))
                            if value > 0xEA5:
                                if value < 0xEC0:
                                    if value < 0xEB2:
                                        if value < 0xEB1:
                                            if value < 0xEA7:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xEB0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(73, UInt8(0))
                                        if value > 0xEB1:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(73, UInt8(4))
                                    if value > 0xEB3:
                                        if value < 0xEBD:
                                            if value < 0xEB4:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xEBC:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(73, UInt8(4))
                                        if value > 0xEBD:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(73, UInt8(0))
                                    return _UnicodeScriptProperty(73, UInt8(0))
                                if value > 0xEC4:
                                    if value < 0xED0:
                                        if value < 0xEC8:
                                            if value < 0xEC6:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xEC6:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(73, UInt8(0))
                                        if value > 0xECE:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(73, UInt8(4))
                                    if value > 0xED9:
                                        if value < 0xEDC:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0xEDF:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(73, UInt8(0))
                                    return _UnicodeScriptProperty(73, UInt8(0))
                                return _UnicodeScriptProperty(73, UInt8(0))
                            return _UnicodeScriptProperty(73, UInt8(0))
                        return _UnicodeScriptProperty(155, UInt8(0))
                    return _UnicodeScriptProperty(91, UInt8(4))
                return _UnicodeScriptProperty(147, UInt8(4))
            return _UnicodeScriptProperty(29, UInt8(0))
        if value > 0xF17:
            if value < 0x1CFA:
                if value < 0x17F0:
                    if value < 0x10CD:
                        if value < 0x1000:
                            if value < 0xF71:
                                if value < 0xF38:
                                    if value < 0xF35:
                                        if value < 0xF1A:
                                            if value < 0xF18:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xF19:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(156, UInt8(4))
                                        if value > 0xF34:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(156, UInt8(0))
                                    if value > 0xF35:
                                        if value < 0xF37:
                                            if value < 0xF36:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xF36:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(156, UInt8(0))
                                        if value > 0xF37:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(156, UInt8(4))
                                    return _UnicodeScriptProperty(156, UInt8(4))
                                if value > 0xF38:
                                    if value < 0xF3E:
                                        if value < 0xF3A:
                                            if value < 0xF39:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xF39:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(156, UInt8(4))
                                        if value > 0xF3D:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(156, UInt8(0))
                                    if value > 0xF3F:
                                        if value < 0xF49:
                                            if value < 0xF40:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xF47:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(156, UInt8(0))
                                        if value > 0xF6C:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(156, UInt8(0))
                                    return _UnicodeScriptProperty(156, UInt8(4))
                                return _UnicodeScriptProperty(156, UInt8(0))
                            if value > 0xF84:
                                if value < 0xFBE:
                                    if value < 0xF88:
                                        if value < 0xF86:
                                            if value < 0xF85:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xF85:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(156, UInt8(0))
                                        if value > 0xF87:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(156, UInt8(4))
                                    if value > 0xF8C:
                                        if value < 0xF99:
                                            if value < 0xF8D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xF97:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(156, UInt8(4))
                                        if value > 0xFBC:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(156, UInt8(4))
                                    return _UnicodeScriptProperty(156, UInt8(0))
                                if value > 0xFC5:
                                    if value < 0xFCE:
                                        if value < 0xFC7:
                                            if value < 0xFC6:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xFC6:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(156, UInt8(4))
                                        if value > 0xFCC:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(156, UInt8(0))
                                    if value > 0xFD4:
                                        if value < 0xFD9:
                                            if value < 0xFD5:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xFD8:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0xFDA:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(156, UInt8(0))
                                    return _UnicodeScriptProperty(156, UInt8(0))
                                return _UnicodeScriptProperty(156, UInt8(0))
                            return _UnicodeScriptProperty(156, UInt8(4))
                        if value > 0x102A:
                            if value < 0x106E:
                                if value < 0x105A:
                                    if value < 0x1040:
                                        if value < 0x103F:
                                            if value < 0x102B:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x103E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(97, UInt8(4))
                                        if value > 0x103F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(97, UInt8(0))
                                    if value > 0x1049:
                                        if value < 0x1056:
                                            if value < 0x104A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1055:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(97, UInt8(0))
                                        if value > 0x1059:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(97, UInt8(4))
                                    return _UnicodeScriptProperty(222, UInt8(0))
                                if value > 0x105D:
                                    if value < 0x1062:
                                        if value < 0x1061:
                                            if value < 0x105E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1060:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(97, UInt8(4))
                                        if value > 0x1061:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(97, UInt8(0))
                                    if value > 0x1064:
                                        if value < 0x1067:
                                            if value < 0x1065:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1066:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(97, UInt8(0))
                                        if value > 0x106D:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(97, UInt8(4))
                                    return _UnicodeScriptProperty(97, UInt8(4))
                                return _UnicodeScriptProperty(97, UInt8(0))
                            if value > 0x1070:
                                if value < 0x1090:
                                    if value < 0x1082:
                                        if value < 0x1075:
                                            if value < 0x1071:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1074:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(97, UInt8(4))
                                        if value > 0x1081:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(97, UInt8(0))
                                    if value > 0x108D:
                                        if value < 0x108F:
                                            if value < 0x108E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x108E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(97, UInt8(0))
                                        if value > 0x108F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(97, UInt8(4))
                                    return _UnicodeScriptProperty(97, UInt8(4))
                                if value > 0x1099:
                                    if value < 0x10A0:
                                        if value < 0x109E:
                                            if value < 0x109A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x109D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(97, UInt8(4))
                                        if value > 0x109F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(97, UInt8(0))
                                    if value > 0x10C5:
                                        if value < 0x10C7:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0x10C7:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(39, UInt8(0))
                                    return _UnicodeScriptProperty(39, UInt8(0))
                                return _UnicodeScriptProperty(97, UInt8(0))
                            return _UnicodeScriptProperty(97, UInt8(0))
                        return _UnicodeScriptProperty(97, UInt8(0))
                    if value > 0x10CD:
                        if value < 0x13A0:
                            if value < 0x1290:
                                if value < 0x124A:
                                    if value < 0x10FC:
                                        if value < 0x10FB:
                                            if value < 0x10D0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x10FA:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(39, UInt8(0))
                                        if value > 0x10FB:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(266, UInt8(1))
                                    if value > 0x10FF:
                                        if value < 0x1200:
                                            if value < 0x1100:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11FF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(49, UInt8(0))
                                        if value > 0x1248:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(37, UInt8(0))
                                    return _UnicodeScriptProperty(39, UInt8(0))
                                if value > 0x124D:
                                    if value < 0x125A:
                                        if value < 0x1258:
                                            if value < 0x1250:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1256:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(37, UInt8(0))
                                        if value > 0x1258:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(37, UInt8(0))
                                    if value > 0x125D:
                                        if value < 0x128A:
                                            if value < 0x1260:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1288:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(37, UInt8(0))
                                        if value > 0x128D:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(37, UInt8(0))
                                    return _UnicodeScriptProperty(37, UInt8(0))
                                return _UnicodeScriptProperty(37, UInt8(0))
                            if value > 0x12B0:
                                if value < 0x12D8:
                                    if value < 0x12C0:
                                        if value < 0x12B8:
                                            if value < 0x12B2:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x12B5:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(37, UInt8(0))
                                        if value > 0x12BE:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(37, UInt8(0))
                                    if value > 0x12C0:
                                        if value < 0x12C8:
                                            if value < 0x12C2:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x12C5:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(37, UInt8(0))
                                        if value > 0x12D6:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(37, UInt8(0))
                                    return _UnicodeScriptProperty(37, UInt8(0))
                                if value > 0x1310:
                                    if value < 0x135D:
                                        if value < 0x1318:
                                            if value < 0x1312:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1315:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(37, UInt8(0))
                                        if value > 0x135A:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(37, UInt8(0))
                                    if value > 0x135F:
                                        if value < 0x1380:
                                            if value < 0x1360:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x137C:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(37, UInt8(0))
                                        if value > 0x1399:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(37, UInt8(0))
                                    return _UnicodeScriptProperty(37, UInt8(4))
                                return _UnicodeScriptProperty(37, UInt8(0))
                            return _UnicodeScriptProperty(37, UInt8(0))
                        if value > 0x13F5:
                            if value < 0x1735:
                                if value < 0x16EE:
                                    if value < 0x1680:
                                        if value < 0x1400:
                                            if value < 0x13F8:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x13FD:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(23, UInt8(0))
                                        if value > 0x167F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(20, UInt8(0))
                                    if value > 0x169C:
                                        if value < 0x16EB:
                                            if value < 0x16A0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x16EA:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(124, UInt8(0))
                                        if value > 0x16ED:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(292, UInt8(1))
                                    return _UnicodeScriptProperty(105, UInt8(0))
                                if value > 0x16F8:
                                    if value < 0x171F:
                                        if value < 0x1712:
                                            if value < 0x1700:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1711:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(153, UInt8(0))
                                        if value > 0x1715:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(153, UInt8(4))
                                    if value > 0x171F:
                                        if value < 0x1732:
                                            if value < 0x1720:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1731:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(51, UInt8(0))
                                        if value > 0x1734:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(51, UInt8(4))
                                    return _UnicodeScriptProperty(153, UInt8(0))
                                return _UnicodeScriptProperty(124, UInt8(0))
                            if value > 0x1736:
                                if value < 0x1780:
                                    if value < 0x1760:
                                        if value < 0x1752:
                                            if value < 0x1740:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1751:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(18, UInt8(0))
                                        if value > 0x1753:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(18, UInt8(4))
                                    if value > 0x176C:
                                        if value < 0x1772:
                                            if value < 0x176E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1770:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(143, UInt8(0))
                                        if value > 0x1773:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(143, UInt8(4))
                                    return _UnicodeScriptProperty(143, UInt8(0))
                                if value > 0x17B3:
                                    if value < 0x17DD:
                                        if value < 0x17D4:
                                            if value < 0x17B4:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x17D3:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(66, UInt8(4))
                                        if value > 0x17DC:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(66, UInt8(0))
                                    if value > 0x17DD:
                                        if value < 0x17E0:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0x17E9:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(66, UInt8(0))
                                    return _UnicodeScriptProperty(66, UInt8(4))
                                return _UnicodeScriptProperty(66, UInt8(0))
                            return _UnicodeScriptProperty(221, UInt8(1))
                        return _UnicodeScriptProperty(23, UInt8(0))
                    return _UnicodeScriptProperty(39, UInt8(0))
                if value > 0x17F9:
                    if value < 0x1B74:
                        if value < 0x1980:
                            if value < 0x1885:
                                if value < 0x180B:
                                    if value < 0x1804:
                                        if value < 0x1802:
                                            if value < 0x1800:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1801:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(93, UInt8(0))
                                        if value > 0x1803:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(290, UInt8(1))
                                    if value > 0x1804:
                                        if value < 0x1806:
                                            if value < 0x1805:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1805:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(290, UInt8(1))
                                        if value > 0x180A:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(93, UInt8(0))
                                    return _UnicodeScriptProperty(93, UInt8(0))
                                if value > 0x180D:
                                    if value < 0x1810:
                                        if value < 0x180F:
                                            if value < 0x180E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x180E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(93, UInt8(0))
                                        if value > 0x180F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(93, UInt8(4))
                                    if value > 0x1819:
                                        if value < 0x1880:
                                            if value < 0x1820:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1878:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(93, UInt8(0))
                                        if value > 0x1884:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(93, UInt8(0))
                                    return _UnicodeScriptProperty(93, UInt8(0))
                                return _UnicodeScriptProperty(93, UInt8(4))
                            if value > 0x1886:
                                if value < 0x1920:
                                    if value < 0x18AA:
                                        if value < 0x18A9:
                                            if value < 0x1887:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x18A8:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(93, UInt8(0))
                                        if value > 0x18A9:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(93, UInt8(4))
                                    if value > 0x18AA:
                                        if value < 0x1900:
                                            if value < 0x18B0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x18F5:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(20, UInt8(0))
                                        if value > 0x191E:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(76, UInt8(0))
                                    return _UnicodeScriptProperty(93, UInt8(0))
                                if value > 0x192B:
                                    if value < 0x1944:
                                        if value < 0x1940:
                                            if value < 0x1930:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x193B:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(76, UInt8(4))
                                        if value > 0x1940:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(76, UInt8(0))
                                    if value > 0x194F:
                                        if value < 0x1970:
                                            if value < 0x1950:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x196D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(145, UInt8(0))
                                        if value > 0x1974:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(145, UInt8(0))
                                    return _UnicodeScriptProperty(76, UInt8(0))
                                return _UnicodeScriptProperty(76, UInt8(4))
                            return _UnicodeScriptProperty(93, UInt8(4))
                        if value > 0x19AB:
                            if value < 0x1A80:
                                if value < 0x1A17:
                                    if value < 0x19DE:
                                        if value < 0x19D0:
                                            if value < 0x19B0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x19C9:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(146, UInt8(0))
                                        if value > 0x19DA:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(146, UInt8(0))
                                    if value > 0x19DF:
                                        if value < 0x1A00:
                                            if value < 0x19E0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x19FF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(66, UInt8(0))
                                        if value > 0x1A16:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(17, UInt8(0))
                                    return _UnicodeScriptProperty(146, UInt8(0))
                                if value > 0x1A1B:
                                    if value < 0x1A55:
                                        if value < 0x1A20:
                                            if value < 0x1A1E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1A1F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(17, UInt8(0))
                                        if value > 0x1A54:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(72, UInt8(0))
                                    if value > 0x1A5E:
                                        if value < 0x1A7F:
                                            if value < 0x1A60:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1A7C:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(72, UInt8(4))
                                        if value > 0x1A7F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(72, UInt8(4))
                                    return _UnicodeScriptProperty(72, UInt8(4))
                                return _UnicodeScriptProperty(17, UInt8(4))
                            if value > 0x1A89:
                                if value < 0x1B05:
                                    if value < 0x1AB0:
                                        if value < 0x1AA0:
                                            if value < 0x1A90:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1A99:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(72, UInt8(0))
                                        if value > 0x1AAD:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(72, UInt8(0))
                                    if value > 0x1ADD:
                                        if value < 0x1B00:
                                            if value < 0x1AE0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1AEB:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(173, UInt8(6))
                                        if value > 0x1B04:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(7, UInt8(4))
                                    return _UnicodeScriptProperty(173, UInt8(6))
                                if value > 0x1B33:
                                    if value < 0x1B4E:
                                        if value < 0x1B45:
                                            if value < 0x1B34:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1B44:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(7, UInt8(4))
                                        if value > 0x1B4C:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(7, UInt8(0))
                                    if value > 0x1B6A:
                                        if value < 0x1B6B:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0x1B73:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(7, UInt8(4))
                                    return _UnicodeScriptProperty(7, UInt8(0))
                                return _UnicodeScriptProperty(7, UInt8(0))
                            return _UnicodeScriptProperty(72, UInt8(0))
                        return _UnicodeScriptProperty(146, UInt8(0))
                    if value > 0x1B7F:
                        if value < 0x1CD7:
                            if value < 0x1C50:
                                if value < 0x1BE6:
                                    if value < 0x1BA1:
                                        if value < 0x1B83:
                                            if value < 0x1B80:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1B82:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(139, UInt8(4))
                                        if value > 0x1BA0:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(139, UInt8(0))
                                    if value > 0x1BAD:
                                        if value < 0x1BC0:
                                            if value < 0x1BAE:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1BBF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(139, UInt8(0))
                                        if value > 0x1BE5:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(10, UInt8(0))
                                    return _UnicodeScriptProperty(139, UInt8(4))
                                if value > 0x1BF3:
                                    if value < 0x1C24:
                                        if value < 0x1C00:
                                            if value < 0x1BFC:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1BFF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(10, UInt8(0))
                                        if value > 0x1C23:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(75, UInt8(0))
                                    if value > 0x1C37:
                                        if value < 0x1C4D:
                                            if value < 0x1C3B:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1C49:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(75, UInt8(0))
                                        if value > 0x1C4F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(75, UInt8(0))
                                    return _UnicodeScriptProperty(75, UInt8(4))
                                return _UnicodeScriptProperty(10, UInt8(4))
                            if value > 0x1C7F:
                                if value < 0x1CD1:
                                    if value < 0x1CBD:
                                        if value < 0x1C90:
                                            if value < 0x1C80:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1C8A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(28, UInt8(0))
                                        if value > 0x1CBA:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(39, UInt8(0))
                                    if value > 0x1CBF:
                                        if value < 0x1CD0:
                                            if value < 0x1CC0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1CC7:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(139, UInt8(0))
                                        if value > 0x1CD0:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(204, UInt8(6))
                                    return _UnicodeScriptProperty(39, UInt8(0))
                                if value > 0x1CD1:
                                    if value < 0x1CD4:
                                        if value < 0x1CD3:
                                            if value < 0x1CD2:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1CD2:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(204, UInt8(6))
                                        if value > 0x1CD3:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(253, UInt8(1))
                                    if value > 0x1CD4:
                                        if value < 0x1CD6:
                                            if value < 0x1CD5:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1CD5:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(208, UInt8(6))
                                        if value > 0x1CD6:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(210, UInt8(6))
                                    return _UnicodeScriptProperty(246, UInt8(6))
                                return _UnicodeScriptProperty(246, UInt8(6))
                            return _UnicodeScriptProperty(106, UInt8(0))
                        if value > 0x1CD7:
                            if value < 0x1CEA:
                                if value < 0x1CDE:
                                    if value < 0x1CDA:
                                        if value < 0x1CD9:
                                            if value < 0x1CD8:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1CD8:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(207, UInt8(6))
                                        if value > 0x1CD9:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(261, UInt8(6))
                                    if value > 0x1CDA:
                                        if value < 0x1CDC:
                                            if value < 0x1CDB:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1CDB:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(246, UInt8(6))
                                        if value > 0x1CDD:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(261, UInt8(6))
                                    return _UnicodeScriptProperty(256, UInt8(6))
                                if value > 0x1CDF:
                                    if value < 0x1CE2:
                                        if value < 0x1CE1:
                                            if value < 0x1CE0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1CE0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(261, UInt8(6))
                                        if value > 0x1CE1:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(199, UInt8(5))
                                    if value > 0x1CE2:
                                        if value < 0x1CE9:
                                            if value < 0x1CE3:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1CE8:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(246, UInt8(6))
                                        if value > 0x1CE9:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(257, UInt8(1))
                                    return _UnicodeScriptProperty(260, UInt8(6))
                                return _UnicodeScriptProperty(246, UInt8(6))
                            if value > 0x1CEA:
                                if value < 0x1CF3:
                                    if value < 0x1CED:
                                        if value < 0x1CEC:
                                            if value < 0x1CEB:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1CEB:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(258, UInt8(1))
                                        if value > 0x1CEC:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(246, UInt8(1))
                                    if value > 0x1CED:
                                        if value < 0x1CF2:
                                            if value < 0x1CEE:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1CF1:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(246, UInt8(1))
                                        if value > 0x1CF2:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(205, UInt8(1))
                                    return _UnicodeScriptProperty(206, UInt8(6))
                                if value > 0x1CF3:
                                    if value < 0x1CF7:
                                        if value < 0x1CF5:
                                            if value < 0x1CF4:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1CF4:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(254, UInt8(6))
                                        if value > 0x1CF6:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(199, UInt8(1))
                                    if value > 0x1CF7:
                                        if value < 0x1CF8:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0x1CF9:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(252, UInt8(6))
                                    return _UnicodeScriptProperty(196, UInt8(5))
                                return _UnicodeScriptProperty(252, UInt8(1))
                            return _UnicodeScriptProperty(209, UInt8(1))
                        return _UnicodeScriptProperty(259, UInt8(6))
                    return _UnicodeScriptProperty(7, UInt8(0))
                return _UnicodeScriptProperty(66, UInt8(0))
            if value > 0x1CFA:
                if value < 0x2E00:
                    if value < 0x2071:
                        if value < 0x1F59:
                            if value < 0x1DC0:
                                if value < 0x1D62:
                                    if value < 0x1D2B:
                                        if value < 0x1D26:
                                            if value < 0x1D00:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1D25:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(74, UInt8(0))
                                        if value > 0x1D2A:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(45, UInt8(0))
                                    if value > 0x1D2B:
                                        if value < 0x1D5D:
                                            if value < 0x1D2C:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1D5C:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(74, UInt8(0))
                                        if value > 0x1D61:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(45, UInt8(0))
                                    return _UnicodeScriptProperty(28, UInt8(0))
                                if value > 0x1D65:
                                    if value < 0x1D78:
                                        if value < 0x1D6B:
                                            if value < 0x1D66:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1D6A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(45, UInt8(0))
                                        if value > 0x1D77:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(74, UInt8(0))
                                    if value > 0x1D78:
                                        if value < 0x1DBF:
                                            if value < 0x1D79:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1DBE:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(74, UInt8(0))
                                        if value > 0x1DBF:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(45, UInt8(0))
                                    return _UnicodeScriptProperty(28, UInt8(0))
                                return _UnicodeScriptProperty(74, UInt8(0))
                            if value > 0x1DC1:
                                if value < 0x1E00:
                                    if value < 0x1DF9:
                                        if value < 0x1DF8:
                                            if value < 0x1DC2:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1DF7:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(173, UInt8(6))
                                        if value > 0x1DF8:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(243, UInt8(6))
                                    if value > 0x1DF9:
                                        if value < 0x1DFB:
                                            if value < 0x1DFA:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1DFA:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(293, UInt8(6))
                                        if value > 0x1DFF:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(173, UInt8(6))
                                    return _UnicodeScriptProperty(173, UInt8(6))
                                if value > 0x1EFF:
                                    if value < 0x1F20:
                                        if value < 0x1F18:
                                            if value < 0x1F00:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1F15:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(45, UInt8(0))
                                        if value > 0x1F1D:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(45, UInt8(0))
                                    if value > 0x1F45:
                                        if value < 0x1F50:
                                            if value < 0x1F48:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1F4D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(45, UInt8(0))
                                        if value > 0x1F57:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(45, UInt8(0))
                                    return _UnicodeScriptProperty(45, UInt8(0))
                                return _UnicodeScriptProperty(74, UInt8(0))
                            return _UnicodeScriptProperty(269, UInt8(6))
                        if value > 0x1F59:
                            if value < 0x200C:
                                if value < 0x1FC6:
                                    if value < 0x1F5F:
                                        if value < 0x1F5D:
                                            if value < 0x1F5B:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1F5B:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(45, UInt8(0))
                                        if value > 0x1F5D:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(45, UInt8(0))
                                    if value > 0x1F7D:
                                        if value < 0x1FB6:
                                            if value < 0x1F80:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1FB4:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(45, UInt8(0))
                                        if value > 0x1FC4:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(45, UInt8(0))
                                    return _UnicodeScriptProperty(45, UInt8(0))
                                if value > 0x1FD3:
                                    if value < 0x1FF2:
                                        if value < 0x1FDD:
                                            if value < 0x1FD6:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1FDB:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(45, UInt8(0))
                                        if value > 0x1FEF:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(45, UInt8(0))
                                    if value > 0x1FF4:
                                        if value < 0x2000:
                                            if value < 0x1FF6:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1FFE:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(45, UInt8(0))
                                        if value > 0x200B:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(45, UInt8(0))
                                return _UnicodeScriptProperty(45, UInt8(0))
                            if value > 0x200D:
                                if value < 0x205A:
                                    if value < 0x2030:
                                        if value < 0x202F:
                                            if value < 0x200E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x202E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x202F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(282, UInt8(1))
                                    if value > 0x204E:
                                        if value < 0x2050:
                                            if value < 0x204F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x204F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(176, UInt8(1))
                                        if value > 0x2059:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                if value > 0x205A:
                                    if value < 0x205E:
                                        if value < 0x205D:
                                            if value < 0x205B:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x205C:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x205D:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(224, UInt8(1))
                                    if value > 0x2064:
                                        if value < 0x2066:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0x2070:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                return _UnicodeScriptProperty(223, UInt8(1))
                            return _UnicodeScriptProperty(173, UInt8(2))
                        return _UnicodeScriptProperty(45, UInt8(0))
                    if value > 0x2071:
                        if value < 0x2B76:
                            if value < 0x212C:
                                if value < 0x20D0:
                                    if value < 0x2080:
                                        if value < 0x207F:
                                            if value < 0x2074:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x207E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x207F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(74, UInt8(0))
                                    if value > 0x208E:
                                        if value < 0x20A0:
                                            if value < 0x2090:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x209C:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(74, UInt8(0))
                                        if value > 0x20C1:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                if value > 0x20EF:
                                    if value < 0x2126:
                                        if value < 0x2100:
                                            if value < 0x20F0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x20F0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(255, UInt8(6))
                                        if value > 0x2125:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    if value > 0x2126:
                                        if value < 0x212A:
                                            if value < 0x2127:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x2129:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x212B:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(74, UInt8(0))
                                    return _UnicodeScriptProperty(45, UInt8(0))
                                return _UnicodeScriptProperty(173, UInt8(6))
                            if value > 0x2131:
                                if value < 0x2189:
                                    if value < 0x214E:
                                        if value < 0x2133:
                                            if value < 0x2132:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x2132:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(74, UInt8(0))
                                        if value > 0x214D:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    if value > 0x214E:
                                        if value < 0x2160:
                                            if value < 0x214F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x215F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x2188:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(74, UInt8(0))
                                    return _UnicodeScriptProperty(74, UInt8(0))
                                if value > 0x218B:
                                    if value < 0x2460:
                                        if value < 0x2440:
                                            if value < 0x2190:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x2429:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x244A:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    if value > 0x27FF:
                                        if value < 0x2900:
                                            if value < 0x2800:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x28FF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(16, UInt8(0))
                                        if value > 0x2B73:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                return _UnicodeScriptProperty(174, UInt8(1))
                            return _UnicodeScriptProperty(174, UInt8(1))
                        if value > 0x2BFF:
                            if value < 0x2D7F:
                                if value < 0x2CF9:
                                    if value < 0x2C80:
                                        if value < 0x2C60:
                                            if value < 0x2C00:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x2C5F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(40, UInt8(0))
                                        if value > 0x2C7F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(74, UInt8(0))
                                    if value > 0x2CEE:
                                        if value < 0x2CF2:
                                            if value < 0x2CEF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x2CF1:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(25, UInt8(4))
                                        if value > 0x2CF3:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(25, UInt8(0))
                                    return _UnicodeScriptProperty(25, UInt8(0))
                                if value > 0x2CFF:
                                    if value < 0x2D2D:
                                        if value < 0x2D27:
                                            if value < 0x2D00:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x2D25:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(39, UInt8(0))
                                        if value > 0x2D27:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(39, UInt8(0))
                                    if value > 0x2D2D:
                                        if value < 0x2D6F:
                                            if value < 0x2D30:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x2D67:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(152, UInt8(0))
                                        if value > 0x2D70:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(152, UInt8(0))
                                    return _UnicodeScriptProperty(39, UInt8(0))
                                return _UnicodeScriptProperty(25, UInt8(0))
                            if value > 0x2D7F:
                                if value < 0x2DC0:
                                    if value < 0x2DA8:
                                        if value < 0x2DA0:
                                            if value < 0x2D80:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x2D96:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(37, UInt8(0))
                                        if value > 0x2DA6:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(37, UInt8(0))
                                    if value > 0x2DAE:
                                        if value < 0x2DB8:
                                            if value < 0x2DB0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x2DB6:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(37, UInt8(0))
                                        if value > 0x2DBE:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(37, UInt8(0))
                                    return _UnicodeScriptProperty(37, UInt8(0))
                                if value > 0x2DC6:
                                    if value < 0x2DD8:
                                        if value < 0x2DD0:
                                            if value < 0x2DC8:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x2DCE:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(37, UInt8(0))
                                        if value > 0x2DD6:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(37, UInt8(0))
                                    if value > 0x2DDE:
                                        if value < 0x2DE0:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0x2DFF:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(28, UInt8(4))
                                    return _UnicodeScriptProperty(37, UInt8(0))
                                return _UnicodeScriptProperty(37, UInt8(0))
                            return _UnicodeScriptProperty(152, UInt8(4))
                        return _UnicodeScriptProperty(174, UInt8(1))
                    return _UnicodeScriptProperty(74, UInt8(0))
                if value > 0x2E16:
                    if value < 0x30A1:
                        if value < 0x3008:
                            if value < 0x2E80:
                                if value < 0x2E3C:
                                    if value < 0x2E30:
                                        if value < 0x2E18:
                                            if value < 0x2E17:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x2E17:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(236, UInt8(1))
                                        if value > 0x2E2F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    if value > 0x2E30:
                                        if value < 0x2E32:
                                            if value < 0x2E31:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x2E31:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(194, UInt8(1))
                                        if value > 0x2E3B:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(195, UInt8(1))
                                if value > 0x2E3C:
                                    if value < 0x2E42:
                                        if value < 0x2E41:
                                            if value < 0x2E3D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x2E40:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x2E41:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(178, UInt8(1))
                                    if value > 0x2E42:
                                        if value < 0x2E44:
                                            if value < 0x2E43:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x2E43:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(240, UInt8(1))
                                        if value > 0x2E5D:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                return _UnicodeScriptProperty(263, UInt8(1))
                            if value > 0x2E99:
                                if value < 0x3002:
                                    if value < 0x2FF0:
                                        if value < 0x2F00:
                                            if value < 0x2E9B:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x2EF3:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(50, UInt8(0))
                                        if value > 0x2FD5:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(50, UInt8(0))
                                    if value > 0x2FFF:
                                        if value < 0x3001:
                                            if value < 0x3000:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x3000:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x3001:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(216, UInt8(1))
                                    return _UnicodeScriptProperty(276, UInt8(1))
                                if value > 0x3002:
                                    if value < 0x3005:
                                        if value < 0x3004:
                                            if value < 0x3003:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x3003:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(212, UInt8(1))
                                        if value > 0x3004:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    if value > 0x3005:
                                        if value < 0x3007:
                                            if value < 0x3006:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x3006:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(273, UInt8(1))
                                        if value > 0x3007:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(50, UInt8(0))
                                    return _UnicodeScriptProperty(50, UInt8(0))
                                return _UnicodeScriptProperty(214, UInt8(1))
                            return _UnicodeScriptProperty(50, UInt8(0))
                        if value > 0x3009:
                            if value < 0x3031:
                                if value < 0x301C:
                                    if value < 0x3012:
                                        if value < 0x300C:
                                            if value < 0x300A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x300B:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(213, UInt8(1))
                                        if value > 0x3011:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(217, UInt8(1))
                                    if value > 0x3012:
                                        if value < 0x3014:
                                            if value < 0x3013:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x3013:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(212, UInt8(1))
                                        if value > 0x301B:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(217, UInt8(1))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                if value > 0x301F:
                                    if value < 0x302A:
                                        if value < 0x3021:
                                            if value < 0x3020:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x3020:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x3029:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(50, UInt8(0))
                                    if value > 0x302D:
                                        if value < 0x3030:
                                            if value < 0x302E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x302F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(49, UInt8(4))
                                        if value > 0x3030:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(212, UInt8(1))
                                    return _UnicodeScriptProperty(218, UInt8(6))
                                return _UnicodeScriptProperty(212, UInt8(1))
                            if value > 0x3035:
                                if value < 0x3041:
                                    if value < 0x3038:
                                        if value < 0x3037:
                                            if value < 0x3036:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x3036:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x3037:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(212, UInt8(1))
                                    if value > 0x303B:
                                        if value < 0x303E:
                                            if value < 0x303C:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x303D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(274, UInt8(1))
                                        if value > 0x303F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(273, UInt8(1))
                                    return _UnicodeScriptProperty(50, UInt8(0))
                                if value > 0x3096:
                                    if value < 0x309D:
                                        if value < 0x309B:
                                            if value < 0x3099:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x309A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(277, UInt8(6))
                                        if value > 0x309C:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(277, UInt8(1))
                                    if value > 0x309F:
                                        if value < 0x30A0:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0x30A0:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(277, UInt8(1))
                                    return _UnicodeScriptProperty(54, UInt8(0))
                                return _UnicodeScriptProperty(54, UInt8(0))
                            return _UnicodeScriptProperty(277, UInt8(1))
                        return _UnicodeScriptProperty(215, UInt8(1))
                    if value > 0x30FA:
                        if value < 0x3371:
                            if value < 0x3220:
                                if value < 0x3190:
                                    if value < 0x30FD:
                                        if value < 0x30FC:
                                            if value < 0x30FB:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x30FB:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(217, UInt8(1))
                                        if value > 0x30FC:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(277, UInt8(1))
                                    if value > 0x30FF:
                                        if value < 0x3131:
                                            if value < 0x3105:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x312F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(14, UInt8(0))
                                        if value > 0x318E:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(49, UInt8(0))
                                    return _UnicodeScriptProperty(63, UInt8(0))
                                if value > 0x319F:
                                    if value < 0x31EF:
                                        if value < 0x31C0:
                                            if value < 0x31A0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x31BF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(14, UInt8(0))
                                        if value > 0x31E5:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(273, UInt8(1))
                                    if value > 0x31EF:
                                        if value < 0x3200:
                                            if value < 0x31F0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x31FF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(63, UInt8(0))
                                        if value > 0x321E:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(49, UInt8(0))
                                    return _UnicodeScriptProperty(276, UInt8(1))
                                return _UnicodeScriptProperty(273, UInt8(1))
                            if value > 0x3247:
                                if value < 0x32C0:
                                    if value < 0x327F:
                                        if value < 0x3260:
                                            if value < 0x3248:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x325F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x327E:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(49, UInt8(0))
                                    if value > 0x327F:
                                        if value < 0x32B1:
                                            if value < 0x3280:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x32B0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(273, UInt8(1))
                                        if value > 0x32BF:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                if value > 0x32CB:
                                    if value < 0x32FF:
                                        if value < 0x32D0:
                                            if value < 0x32CC:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x32CF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x32FE:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(63, UInt8(0))
                                    if value > 0x32FF:
                                        if value < 0x3358:
                                            if value < 0x3300:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x3357:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(63, UInt8(0))
                                        if value > 0x3370:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(273, UInt8(1))
                                    return _UnicodeScriptProperty(273, UInt8(1))
                                return _UnicodeScriptProperty(273, UInt8(1))
                            return _UnicodeScriptProperty(273, UInt8(1))
                        if value > 0x337A:
                            if value < 0xA640:
                                if value < 0x4DC0:
                                    if value < 0x33E0:
                                        if value < 0x3380:
                                            if value < 0x337B:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x337F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(273, UInt8(1))
                                        if value > 0x33DF:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    if value > 0x33FE:
                                        if value < 0x3400:
                                            if value < 0x33FF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x33FF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x4DBF:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(50, UInt8(0))
                                    return _UnicodeScriptProperty(273, UInt8(1))
                                if value > 0x4DFF:
                                    if value < 0xA490:
                                        if value < 0xA000:
                                            if value < 0x4E00:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x9FFF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(50, UInt8(0))
                                        if value > 0xA48C:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(171, UInt8(0))
                                    if value > 0xA4C6:
                                        if value < 0xA500:
                                            if value < 0xA4D0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xA4FF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(79, UInt8(0))
                                        if value > 0xA62B:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(164, UInt8(0))
                                    return _UnicodeScriptProperty(171, UInt8(0))
                                return _UnicodeScriptProperty(174, UInt8(1))
                            if value > 0xA66E:
                                if value < 0xA69E:
                                    if value < 0xA673:
                                        if value < 0xA670:
                                            if value < 0xA66F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xA66F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(240, UInt8(4))
                                        if value > 0xA672:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(28, UInt8(4))
                                    if value > 0xA673:
                                        if value < 0xA67E:
                                            if value < 0xA674:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xA67D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(28, UInt8(4))
                                        if value > 0xA69D:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(28, UInt8(0))
                                    return _UnicodeScriptProperty(28, UInt8(0))
                                if value > 0xA69F:
                                    if value < 0xA6F2:
                                        if value < 0xA6F0:
                                            if value < 0xA6A0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xA6EF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(8, UInt8(0))
                                        if value > 0xA6F1:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(8, UInt8(4))
                                    if value > 0xA6F7:
                                        if value < 0xA700:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0xA707:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(275, UInt8(1))
                                    return _UnicodeScriptProperty(8, UInt8(0))
                                return _UnicodeScriptProperty(28, UInt8(4))
                            return _UnicodeScriptProperty(28, UInt8(0))
                        return _UnicodeScriptProperty(174, UInt8(1))
                    return _UnicodeScriptProperty(63, UInt8(0))
                return _UnicodeScriptProperty(174, UInt8(1))
            return _UnicodeScriptProperty(291, UInt8(1))
        return _UnicodeScriptProperty(156, UInt8(0))
    if value > 0xA721:
        if value < 0x115AF:
            if value < 0x10597:
                if value < 0xD7B0:
                    if value < 0xA9E5:
                        if value < 0xA8CE:
                            if value < 0xA823:
                                if value < 0xA802:
                                    if value < 0xA78B:
                                        if value < 0xA788:
                                            if value < 0xA722:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xA787:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(74, UInt8(0))
                                        if value > 0xA78A:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    if value > 0xA7DC:
                                        if value < 0xA800:
                                            if value < 0xA7F1:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xA7FF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(74, UInt8(0))
                                        if value > 0xA801:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(141, UInt8(0))
                                    return _UnicodeScriptProperty(74, UInt8(0))
                                if value > 0xA802:
                                    if value < 0xA807:
                                        if value < 0xA806:
                                            if value < 0xA803:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xA805:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(141, UInt8(0))
                                        if value > 0xA806:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(141, UInt8(4))
                                    if value > 0xA80A:
                                        if value < 0xA80C:
                                            if value < 0xA80B:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xA80B:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(141, UInt8(4))
                                        if value > 0xA822:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(141, UInt8(0))
                                    return _UnicodeScriptProperty(141, UInt8(0))
                                return _UnicodeScriptProperty(141, UInt8(4))
                            if value > 0xA827:
                                if value < 0xA838:
                                    if value < 0xA830:
                                        if value < 0xA82C:
                                            if value < 0xA828:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xA82B:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(141, UInt8(0))
                                        if value > 0xA82C:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(141, UInt8(4))
                                    if value > 0xA832:
                                        if value < 0xA836:
                                            if value < 0xA833:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xA835:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(248, UInt8(1))
                                        if value > 0xA837:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(250, UInt8(1))
                                    return _UnicodeScriptProperty(247, UInt8(1))
                                if value > 0xA838:
                                    if value < 0xA880:
                                        if value < 0xA840:
                                            if value < 0xA839:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xA839:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(250, UInt8(1))
                                        if value > 0xA877:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(116, UInt8(0))
                                    if value > 0xA881:
                                        if value < 0xA8B4:
                                            if value < 0xA882:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xA8B3:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(127, UInt8(0))
                                        if value > 0xA8C5:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(127, UInt8(4))
                                    return _UnicodeScriptProperty(127, UInt8(4))
                                return _UnicodeScriptProperty(249, UInt8(1))
                            return _UnicodeScriptProperty(141, UInt8(4))
                        if value > 0xA8D9:
                            if value < 0xA947:
                                if value < 0xA8FF:
                                    if value < 0xA8F2:
                                        if value < 0xA8F1:
                                            if value < 0xA8E0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xA8F0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(29, UInt8(4))
                                        if value > 0xA8F1:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(211, UInt8(4))
                                    if value > 0xA8F2:
                                        if value < 0xA8F4:
                                            if value < 0xA8F3:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xA8F3:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(262, UInt8(0))
                                        if value > 0xA8FE:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(29, UInt8(0))
                                    return _UnicodeScriptProperty(29, UInt8(0))
                                if value > 0xA8FF:
                                    if value < 0xA92E:
                                        if value < 0xA926:
                                            if value < 0xA900:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xA925:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(62, UInt8(0))
                                        if value > 0xA92D:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(62, UInt8(4))
                                    if value > 0xA92E:
                                        if value < 0xA930:
                                            if value < 0xA92F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xA92F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(62, UInt8(0))
                                        if value > 0xA946:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(122, UInt8(0))
                                    return _UnicodeScriptProperty(278, UInt8(1))
                                return _UnicodeScriptProperty(29, UInt8(4))
                            if value > 0xA953:
                                if value < 0xA9C1:
                                    if value < 0xA980:
                                        if value < 0xA960:
                                            if value < 0xA95F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xA95F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(122, UInt8(0))
                                        if value > 0xA97C:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(49, UInt8(0))
                                    if value > 0xA983:
                                        if value < 0xA9B3:
                                            if value < 0xA984:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xA9B2:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(61, UInt8(0))
                                        if value > 0xA9C0:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(61, UInt8(4))
                                    return _UnicodeScriptProperty(61, UInt8(4))
                                if value > 0xA9CD:
                                    if value < 0xA9DE:
                                        if value < 0xA9D0:
                                            if value < 0xA9CF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xA9CF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(220, UInt8(1))
                                        if value > 0xA9D9:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(61, UInt8(0))
                                    if value > 0xA9DF:
                                        if value < 0xA9E0:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0xA9E4:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(97, UInt8(0))
                                    return _UnicodeScriptProperty(61, UInt8(0))
                                return _UnicodeScriptProperty(61, UInt8(0))
                            return _UnicodeScriptProperty(122, UInt8(4))
                        return _UnicodeScriptProperty(127, UInt8(0))
                    if value > 0xA9E5:
                        if value < 0xAADB:
                            if value < 0xAA7E:
                                if value < 0xAA44:
                                    if value < 0xAA29:
                                        if value < 0xAA00:
                                            if value < 0xA9E6:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xA9FE:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(97, UInt8(0))
                                        if value > 0xAA28:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(22, UInt8(0))
                                    if value > 0xAA36:
                                        if value < 0xAA43:
                                            if value < 0xAA40:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xAA42:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(22, UInt8(0))
                                        if value > 0xAA43:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(22, UInt8(4))
                                    return _UnicodeScriptProperty(22, UInt8(4))
                                if value > 0xAA4B:
                                    if value < 0xAA5C:
                                        if value < 0xAA50:
                                            if value < 0xAA4C:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xAA4D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(22, UInt8(4))
                                        if value > 0xAA59:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(22, UInt8(0))
                                    if value > 0xAA5F:
                                        if value < 0xAA7B:
                                            if value < 0xAA60:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xAA7A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(97, UInt8(0))
                                        if value > 0xAA7D:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(97, UInt8(4))
                                    return _UnicodeScriptProperty(22, UInt8(0))
                                return _UnicodeScriptProperty(22, UInt8(0))
                            if value > 0xAA7F:
                                if value < 0xAAB7:
                                    if value < 0xAAB1:
                                        if value < 0xAAB0:
                                            if value < 0xAA80:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xAAAF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(149, UInt8(0))
                                        if value > 0xAAB0:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(149, UInt8(4))
                                    if value > 0xAAB1:
                                        if value < 0xAAB5:
                                            if value < 0xAAB2:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xAAB4:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(149, UInt8(4))
                                        if value > 0xAAB6:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(149, UInt8(0))
                                    return _UnicodeScriptProperty(149, UInt8(0))
                                if value > 0xAAB8:
                                    if value < 0xAAC0:
                                        if value < 0xAABE:
                                            if value < 0xAAB9:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xAABD:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(149, UInt8(0))
                                        if value > 0xAABF:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(149, UInt8(4))
                                    if value > 0xAAC0:
                                        if value < 0xAAC2:
                                            if value < 0xAAC1:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xAAC1:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(149, UInt8(4))
                                        if value > 0xAAC2:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(149, UInt8(0))
                                    return _UnicodeScriptProperty(149, UInt8(0))
                                return _UnicodeScriptProperty(149, UInt8(4))
                            return _UnicodeScriptProperty(97, UInt8(0))
                        if value > 0xAADF:
                            if value < 0xAB5C:
                                if value < 0xAB09:
                                    if value < 0xAAF0:
                                        if value < 0xAAEB:
                                            if value < 0xAAE0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xAAEA:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(95, UInt8(0))
                                        if value > 0xAAEF:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(95, UInt8(4))
                                    if value > 0xAAF4:
                                        if value < 0xAB01:
                                            if value < 0xAAF5:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xAAF6:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(95, UInt8(4))
                                        if value > 0xAB06:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(37, UInt8(0))
                                    return _UnicodeScriptProperty(95, UInt8(0))
                                if value > 0xAB0E:
                                    if value < 0xAB28:
                                        if value < 0xAB20:
                                            if value < 0xAB11:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xAB16:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(37, UInt8(0))
                                        if value > 0xAB26:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(37, UInt8(0))
                                    if value > 0xAB2E:
                                        if value < 0xAB5B:
                                            if value < 0xAB30:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xAB5A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(74, UInt8(0))
                                        if value > 0xAB5B:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(37, UInt8(0))
                                return _UnicodeScriptProperty(37, UInt8(0))
                            if value > 0xAB64:
                                if value < 0xABE3:
                                    if value < 0xAB6A:
                                        if value < 0xAB66:
                                            if value < 0xAB65:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xAB65:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(45, UInt8(0))
                                        if value > 0xAB69:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(74, UInt8(0))
                                    if value > 0xAB6B:
                                        if value < 0xABC0:
                                            if value < 0xAB70:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xABBF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(23, UInt8(0))
                                        if value > 0xABE2:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(95, UInt8(0))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                if value > 0xABEA:
                                    if value < 0xABF0:
                                        if value < 0xABEC:
                                            if value < 0xABEB:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xABEB:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(95, UInt8(0))
                                        if value > 0xABED:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(95, UInt8(4))
                                    if value > 0xABF9:
                                        if value < 0xAC00:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0xD7A3:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(49, UInt8(0))
                                    return _UnicodeScriptProperty(95, UInt8(0))
                                return _UnicodeScriptProperty(95, UInt8(4))
                            return _UnicodeScriptProperty(74, UInt8(0))
                        return _UnicodeScriptProperty(149, UInt8(0))
                    return _UnicodeScriptProperty(97, UInt8(4))
                if value > 0xD7C6:
                    if value < 0xFFD2:
                        if value < 0xFE20:
                            if value < 0xFB43:
                                if value < 0xFB1D:
                                    if value < 0xFA70:
                                        if value < 0xF900:
                                            if value < 0xD7CB:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xD7FB:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(49, UInt8(0))
                                        if value > 0xFA6D:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(50, UInt8(0))
                                    if value > 0xFAD9:
                                        if value < 0xFB13:
                                            if value < 0xFB00:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xFB06:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(74, UInt8(0))
                                        if value > 0xFB17:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(5, UInt8(0))
                                    return _UnicodeScriptProperty(50, UInt8(0))
                                if value > 0xFB1D:
                                    if value < 0xFB38:
                                        if value < 0xFB1F:
                                            if value < 0xFB1E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xFB1E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(53, UInt8(4))
                                        if value > 0xFB36:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(53, UInt8(0))
                                    if value > 0xFB3C:
                                        if value < 0xFB40:
                                            if value < 0xFB3E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xFB3E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(53, UInt8(0))
                                        if value > 0xFB41:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(53, UInt8(0))
                                    return _UnicodeScriptProperty(53, UInt8(0))
                                return _UnicodeScriptProperty(53, UInt8(0))
                            if value > 0xFB44:
                                if value < 0xFDF2:
                                    if value < 0xFD3E:
                                        if value < 0xFB50:
                                            if value < 0xFB46:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xFB4F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(53, UInt8(0))
                                        if value > 0xFD3D:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(3, UInt8(0))
                                    if value > 0xFD3F:
                                        if value < 0xFDF0:
                                            if value < 0xFD40:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xFDCF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(3, UInt8(0))
                                        if value > 0xFDF1:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(3, UInt8(0))
                                    return _UnicodeScriptProperty(185, UInt8(1))
                                if value > 0xFDF2:
                                    if value < 0xFDFE:
                                        if value < 0xFDFD:
                                            if value < 0xFDF3:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xFDFC:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(3, UInt8(0))
                                        if value > 0xFDFD:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(189, UInt8(0))
                                    if value > 0xFDFF:
                                        if value < 0xFE10:
                                            if value < 0xFE00:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xFE0F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(173, UInt8(6))
                                        if value > 0xFE19:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(3, UInt8(0))
                                return _UnicodeScriptProperty(189, UInt8(0))
                            return _UnicodeScriptProperty(53, UInt8(0))
                        if value > 0xFE2D:
                            if value < 0xFF3B:
                                if value < 0xFE68:
                                    if value < 0xFE45:
                                        if value < 0xFE30:
                                            if value < 0xFE2E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xFE2F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(28, UInt8(4))
                                        if value > 0xFE44:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    if value > 0xFE46:
                                        if value < 0xFE54:
                                            if value < 0xFE47:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xFE52:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0xFE66:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(212, UInt8(1))
                                if value > 0xFE6B:
                                    if value < 0xFEFF:
                                        if value < 0xFE76:
                                            if value < 0xFE70:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xFE74:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(3, UInt8(0))
                                        if value > 0xFEFC:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(3, UInt8(0))
                                    if value > 0xFEFF:
                                        if value < 0xFF21:
                                            if value < 0xFF01:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xFF20:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0xFF3A:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(74, UInt8(0))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                return _UnicodeScriptProperty(174, UInt8(1))
                            if value > 0xFF40:
                                if value < 0xFF71:
                                    if value < 0xFF61:
                                        if value < 0xFF5B:
                                            if value < 0xFF41:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xFF5A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(74, UInt8(0))
                                        if value > 0xFF60:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    if value > 0xFF65:
                                        if value < 0xFF70:
                                            if value < 0xFF66:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xFF6F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(63, UInt8(0))
                                        if value > 0xFF70:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(277, UInt8(1))
                                    return _UnicodeScriptProperty(217, UInt8(1))
                                if value > 0xFF9D:
                                    if value < 0xFFC2:
                                        if value < 0xFFA0:
                                            if value < 0xFF9E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xFF9F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(277, UInt8(1))
                                        if value > 0xFFBE:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(49, UInt8(0))
                                    if value > 0xFFC7:
                                        if value < 0xFFCA:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0xFFCF:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(49, UInt8(0))
                                    return _UnicodeScriptProperty(49, UInt8(0))
                                return _UnicodeScriptProperty(63, UInt8(0))
                            return _UnicodeScriptProperty(174, UInt8(1))
                        return _UnicodeScriptProperty(173, UInt8(6))
                    if value > 0xFFD7:
                        if value < 0x102E1:
                            if value < 0x10100:
                                if value < 0x1000D:
                                    if value < 0xFFE8:
                                        if value < 0xFFE0:
                                            if value < 0xFFDA:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xFFDC:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(49, UInt8(0))
                                        if value > 0xFFE6:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    if value > 0xFFEE:
                                        if value < 0x10000:
                                            if value < 0xFFF9:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0xFFFD:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x1000B:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(78, UInt8(0))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                if value > 0x10026:
                                    if value < 0x1003F:
                                        if value < 0x1003C:
                                            if value < 0x10028:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1003A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(78, UInt8(0))
                                        if value > 0x1003D:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(78, UInt8(0))
                                    if value > 0x1004D:
                                        if value < 0x10080:
                                            if value < 0x10050:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1005D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(78, UInt8(0))
                                        if value > 0x100FA:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(78, UInt8(0))
                                    return _UnicodeScriptProperty(78, UInt8(0))
                                return _UnicodeScriptProperty(78, UInt8(0))
                            if value > 0x10101:
                                if value < 0x101A0:
                                    if value < 0x10137:
                                        if value < 0x10107:
                                            if value < 0x10102:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x10102:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(239, UInt8(1))
                                        if value > 0x10133:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(238, UInt8(1))
                                    if value > 0x1013F:
                                        if value < 0x10190:
                                            if value < 0x10140:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1018E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(45, UInt8(0))
                                        if value > 0x1019C:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(239, UInt8(1))
                                if value > 0x101A0:
                                    if value < 0x10280:
                                        if value < 0x101FD:
                                            if value < 0x101D0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x101FC:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x101FD:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(173, UInt8(6))
                                    if value > 0x1029C:
                                        if value < 0x102E0:
                                            if value < 0x102A0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x102D0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(21, UInt8(0))
                                        if value > 0x102E0:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(183, UInt8(6))
                                    return _UnicodeScriptProperty(80, UInt8(0))
                                return _UnicodeScriptProperty(45, UInt8(0))
                            return _UnicodeScriptProperty(237, UInt8(1))
                        if value > 0x102FB:
                            if value < 0x10480:
                                if value < 0x10380:
                                    if value < 0x10330:
                                        if value < 0x1032D:
                                            if value < 0x10300:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x10323:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(60, UInt8(0))
                                        if value > 0x1032F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(60, UInt8(0))
                                    if value > 0x1034A:
                                        if value < 0x10376:
                                            if value < 0x10350:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x10375:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(115, UInt8(0))
                                        if value > 0x1037A:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(115, UInt8(4))
                                    return _UnicodeScriptProperty(43, UInt8(0))
                                if value > 0x1039D:
                                    if value < 0x103C8:
                                        if value < 0x103A0:
                                            if value < 0x1039F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1039F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(163, UInt8(0))
                                        if value > 0x103C3:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(168, UInt8(0))
                                    if value > 0x103D5:
                                        if value < 0x10450:
                                            if value < 0x10400:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1044F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(32, UInt8(0))
                                        if value > 0x1047F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(129, UInt8(0))
                                    return _UnicodeScriptProperty(168, UInt8(0))
                                return _UnicodeScriptProperty(163, UInt8(0))
                            if value > 0x1049D:
                                if value < 0x1056F:
                                    if value < 0x104D8:
                                        if value < 0x104B0:
                                            if value < 0x104A0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x104A9:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(111, UInt8(0))
                                        if value > 0x104D3:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(110, UInt8(0))
                                    if value > 0x104FB:
                                        if value < 0x10530:
                                            if value < 0x10500:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x10527:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(35, UInt8(0))
                                        if value > 0x10563:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(1, UInt8(0))
                                    return _UnicodeScriptProperty(110, UInt8(0))
                                if value > 0x1056F:
                                    if value < 0x1058C:
                                        if value < 0x1057C:
                                            if value < 0x10570:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1057A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(165, UInt8(0))
                                        if value > 0x1058A:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(165, UInt8(0))
                                    if value > 0x10592:
                                        if value < 0x10594:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0x10595:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(165, UInt8(0))
                                    return _UnicodeScriptProperty(165, UInt8(0))
                                return _UnicodeScriptProperty(1, UInt8(0))
                            return _UnicodeScriptProperty(111, UInt8(0))
                        return _UnicodeScriptProperty(183, UInt8(1))
                    return _UnicodeScriptProperty(49, UInt8(0))
                return _UnicodeScriptProperty(49, UInt8(0))
            if value > 0x105A1:
                if value < 0x11070:
                    if value < 0x10AC0:
                        if value < 0x108FB:
                            if value < 0x10808:
                                if value < 0x10740:
                                    if value < 0x105BB:
                                        if value < 0x105B3:
                                            if value < 0x105A3:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x105B1:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(165, UInt8(0))
                                        if value > 0x105B9:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(165, UInt8(0))
                                    if value > 0x105BC:
                                        if value < 0x10600:
                                            if value < 0x105C0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x105F3:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(159, UInt8(0))
                                        if value > 0x10736:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(77, UInt8(0))
                                    return _UnicodeScriptProperty(165, UInt8(0))
                                if value > 0x10755:
                                    if value < 0x10787:
                                        if value < 0x10780:
                                            if value < 0x10760:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x10767:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(77, UInt8(0))
                                        if value > 0x10785:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(74, UInt8(0))
                                    if value > 0x107B0:
                                        if value < 0x10800:
                                            if value < 0x107B2:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x107BA:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(74, UInt8(0))
                                        if value > 0x10805:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(27, UInt8(0))
                                    return _UnicodeScriptProperty(74, UInt8(0))
                                return _UnicodeScriptProperty(77, UInt8(0))
                            if value > 0x10808:
                                if value < 0x10857:
                                    if value < 0x1083C:
                                        if value < 0x10837:
                                            if value < 0x1080A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x10835:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(27, UInt8(0))
                                        if value > 0x10838:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(27, UInt8(0))
                                    if value > 0x1083C:
                                        if value < 0x10840:
                                            if value < 0x1083F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1083F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(27, UInt8(0))
                                        if value > 0x10855:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(4, UInt8(0))
                                    return _UnicodeScriptProperty(27, UInt8(0))
                                if value > 0x1085F:
                                    if value < 0x108A7:
                                        if value < 0x10880:
                                            if value < 0x10860:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1087F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(113, UInt8(0))
                                        if value > 0x1089E:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(101, UInt8(0))
                                    if value > 0x108AF:
                                        if value < 0x108F4:
                                            if value < 0x108E0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x108F2:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(52, UInt8(0))
                                        if value > 0x108F5:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(52, UInt8(0))
                                    return _UnicodeScriptProperty(101, UInt8(0))
                                return _UnicodeScriptProperty(4, UInt8(0))
                            return _UnicodeScriptProperty(27, UInt8(0))
                        if value > 0x108FF:
                            if value < 0x10A05:
                                if value < 0x10980:
                                    if value < 0x10920:
                                        if value < 0x1091F:
                                            if value < 0x10900:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1091B:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(119, UInt8(0))
                                        if value > 0x1091F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(119, UInt8(0))
                                    if value > 0x10939:
                                        if value < 0x10940:
                                            if value < 0x1093F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1093F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(81, UInt8(0))
                                        if value > 0x10959:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(132, UInt8(0))
                                    return _UnicodeScriptProperty(81, UInt8(0))
                                if value > 0x1099F:
                                    if value < 0x109D2:
                                        if value < 0x109BC:
                                            if value < 0x109A0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x109B7:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(89, UInt8(0))
                                        if value > 0x109CF:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(89, UInt8(0))
                                    if value > 0x109FF:
                                        if value < 0x10A01:
                                            if value < 0x10A00:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x10A00:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(65, UInt8(0))
                                        if value > 0x10A03:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(65, UInt8(4))
                                    return _UnicodeScriptProperty(89, UInt8(0))
                                return _UnicodeScriptProperty(90, UInt8(0))
                            if value > 0x10A06:
                                if value < 0x10A3F:
                                    if value < 0x10A15:
                                        if value < 0x10A10:
                                            if value < 0x10A0C:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x10A0F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(65, UInt8(4))
                                        if value > 0x10A13:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(65, UInt8(0))
                                    if value > 0x10A17:
                                        if value < 0x10A38:
                                            if value < 0x10A19:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x10A35:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(65, UInt8(0))
                                        if value > 0x10A3A:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(65, UInt8(4))
                                    return _UnicodeScriptProperty(65, UInt8(0))
                                if value > 0x10A3F:
                                    if value < 0x10A60:
                                        if value < 0x10A50:
                                            if value < 0x10A40:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x10A48:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(65, UInt8(0))
                                        if value > 0x10A58:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(65, UInt8(0))
                                    if value > 0x10A7F:
                                        if value < 0x10A80:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0x10A9F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(100, UInt8(0))
                                    return _UnicodeScriptProperty(126, UInt8(0))
                                return _UnicodeScriptProperty(65, UInt8(4))
                            return _UnicodeScriptProperty(65, UInt8(4))
                        return _UnicodeScriptProperty(52, UInt8(0))
                    if value > 0x10AE4:
                        if value < 0x10D8E:
                            if value < 0x10B99:
                                if value < 0x10B39:
                                    if value < 0x10AF2:
                                        if value < 0x10AEB:
                                            if value < 0x10AE5:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x10AE6:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(85, UInt8(4))
                                        if value > 0x10AF1:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(85, UInt8(0))
                                    if value > 0x10AF2:
                                        if value < 0x10B00:
                                            if value < 0x10AF3:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x10AF6:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(85, UInt8(0))
                                        if value > 0x10B35:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(6, UInt8(0))
                                    return _UnicodeScriptProperty(289, UInt8(0))
                                if value > 0x10B3F:
                                    if value < 0x10B60:
                                        if value < 0x10B58:
                                            if value < 0x10B40:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x10B55:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(121, UInt8(0))
                                        if value > 0x10B5F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(121, UInt8(0))
                                    if value > 0x10B72:
                                        if value < 0x10B80:
                                            if value < 0x10B78:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x10B7F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(117, UInt8(0))
                                        if value > 0x10B91:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(118, UInt8(0))
                                    return _UnicodeScriptProperty(117, UInt8(0))
                                return _UnicodeScriptProperty(6, UInt8(0))
                            if value > 0x10B9C:
                                if value < 0x10D00:
                                    if value < 0x10C80:
                                        if value < 0x10C00:
                                            if value < 0x10BA9:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x10BAF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(118, UInt8(0))
                                        if value > 0x10C48:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(108, UInt8(0))
                                    if value > 0x10CB2:
                                        if value < 0x10CFA:
                                            if value < 0x10CC0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x10CF2:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(59, UInt8(0))
                                        if value > 0x10CFF:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(59, UInt8(0))
                                    return _UnicodeScriptProperty(59, UInt8(0))
                                if value > 0x10D23:
                                    if value < 0x10D40:
                                        if value < 0x10D30:
                                            if value < 0x10D24:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x10D27:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(123, UInt8(4))
                                        if value > 0x10D39:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(123, UInt8(0))
                                    if value > 0x10D65:
                                        if value < 0x10D6E:
                                            if value < 0x10D69:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x10D6D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(38, UInt8(4))
                                        if value > 0x10D85:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(38, UInt8(0))
                                    return _UnicodeScriptProperty(38, UInt8(0))
                                return _UnicodeScriptProperty(123, UInt8(0))
                            return _UnicodeScriptProperty(118, UInt8(0))
                        if value > 0x10D8F:
                            if value < 0x10F51:
                                if value < 0x10EC2:
                                    if value < 0x10EAB:
                                        if value < 0x10E80:
                                            if value < 0x10E60:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x10E7E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(3, UInt8(0))
                                        if value > 0x10EA9:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(170, UInt8(0))
                                    if value > 0x10EAC:
                                        if value < 0x10EB0:
                                            if value < 0x10EAD:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x10EAD:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(170, UInt8(0))
                                        if value > 0x10EB1:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(170, UInt8(0))
                                    return _UnicodeScriptProperty(170, UInt8(4))
                                if value > 0x10EC7:
                                    if value < 0x10F00:
                                        if value < 0x10EFA:
                                            if value < 0x10ED0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x10ED8:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(3, UInt8(0))
                                        if value > 0x10EFF:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(3, UInt8(4))
                                    if value > 0x10F27:
                                        if value < 0x10F46:
                                            if value < 0x10F30:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x10F45:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(135, UInt8(0))
                                        if value > 0x10F50:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(135, UInt8(4))
                                    return _UnicodeScriptProperty(136, UInt8(0))
                                return _UnicodeScriptProperty(3, UInt8(0))
                            if value > 0x10F59:
                                if value < 0x11000:
                                    if value < 0x10F86:
                                        if value < 0x10F82:
                                            if value < 0x10F70:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x10F81:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(112, UInt8(0))
                                        if value > 0x10F85:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(112, UInt8(4))
                                    if value > 0x10F89:
                                        if value < 0x10FE0:
                                            if value < 0x10FB0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x10FCB:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(24, UInt8(0))
                                        if value > 0x10FF6:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(36, UInt8(0))
                                    return _UnicodeScriptProperty(112, UInt8(0))
                                if value > 0x11002:
                                    if value < 0x11047:
                                        if value < 0x11038:
                                            if value < 0x11003:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11037:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(15, UInt8(0))
                                        if value > 0x11046:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(15, UInt8(4))
                                    if value > 0x1104D:
                                        if value < 0x11052:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0x1106F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(15, UInt8(0))
                                    return _UnicodeScriptProperty(15, UInt8(0))
                                return _UnicodeScriptProperty(15, UInt8(4))
                            return _UnicodeScriptProperty(135, UInt8(0))
                        return _UnicodeScriptProperty(38, UInt8(0))
                    return _UnicodeScriptProperty(85, UInt8(0))
                if value > 0x11070:
                    if value < 0x11301:
                        if value < 0x111B3:
                            if value < 0x110F0:
                                if value < 0x11083:
                                    if value < 0x11075:
                                        if value < 0x11073:
                                            if value < 0x11071:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11072:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(15, UInt8(0))
                                        if value > 0x11074:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(15, UInt8(4))
                                    if value > 0x11075:
                                        if value < 0x11080:
                                            if value < 0x1107F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1107F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(15, UInt8(4))
                                        if value > 0x11082:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(71, UInt8(4))
                                    return _UnicodeScriptProperty(15, UInt8(0))
                                if value > 0x110AF:
                                    if value < 0x110C2:
                                        if value < 0x110BB:
                                            if value < 0x110B0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x110BA:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(71, UInt8(4))
                                        if value > 0x110C1:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(71, UInt8(0))
                                    if value > 0x110C2:
                                        if value < 0x110D0:
                                            if value < 0x110CD:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x110CD:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(71, UInt8(0))
                                        if value > 0x110E8:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(137, UInt8(0))
                                    return _UnicodeScriptProperty(71, UInt8(4))
                                return _UnicodeScriptProperty(71, UInt8(0))
                            if value > 0x110F9:
                                if value < 0x11147:
                                    if value < 0x11127:
                                        if value < 0x11103:
                                            if value < 0x11100:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11102:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(19, UInt8(4))
                                        if value > 0x11126:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(19, UInt8(0))
                                    if value > 0x11134:
                                        if value < 0x11145:
                                            if value < 0x11136:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11144:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(19, UInt8(0))
                                        if value > 0x11146:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(19, UInt8(4))
                                    return _UnicodeScriptProperty(19, UInt8(4))
                                if value > 0x11147:
                                    if value < 0x11174:
                                        if value < 0x11173:
                                            if value < 0x11150:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11172:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(82, UInt8(0))
                                        if value > 0x11173:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(82, UInt8(4))
                                    if value > 0x11176:
                                        if value < 0x11183:
                                            if value < 0x11180:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11182:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(130, UInt8(4))
                                        if value > 0x111B2:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(130, UInt8(0))
                                    return _UnicodeScriptProperty(82, UInt8(0))
                                return _UnicodeScriptProperty(19, UInt8(0))
                            return _UnicodeScriptProperty(137, UInt8(0))
                        if value > 0x111C0:
                            if value < 0x1123F:
                                if value < 0x111E1:
                                    if value < 0x111CD:
                                        if value < 0x111C9:
                                            if value < 0x111C1:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x111C8:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(130, UInt8(0))
                                        if value > 0x111CC:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(130, UInt8(4))
                                    if value > 0x111CD:
                                        if value < 0x111D0:
                                            if value < 0x111CE:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x111CF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(130, UInt8(4))
                                        if value > 0x111DF:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(130, UInt8(0))
                                    return _UnicodeScriptProperty(130, UInt8(0))
                                if value > 0x111F4:
                                    if value < 0x1122C:
                                        if value < 0x11213:
                                            if value < 0x11200:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11211:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(67, UInt8(0))
                                        if value > 0x1122B:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(67, UInt8(0))
                                    if value > 0x11237:
                                        if value < 0x1123E:
                                            if value < 0x11238:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1123D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(67, UInt8(0))
                                        if value > 0x1123E:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(67, UInt8(4))
                                    return _UnicodeScriptProperty(67, UInt8(4))
                                return _UnicodeScriptProperty(134, UInt8(0))
                            if value > 0x11240:
                                if value < 0x1129F:
                                    if value < 0x11288:
                                        if value < 0x11280:
                                            if value < 0x11241:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11241:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(67, UInt8(4))
                                        if value > 0x11286:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(96, UInt8(0))
                                    if value > 0x11288:
                                        if value < 0x1128F:
                                            if value < 0x1128A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1128D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(96, UInt8(0))
                                        if value > 0x1129D:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(96, UInt8(0))
                                    return _UnicodeScriptProperty(96, UInt8(0))
                                if value > 0x112A9:
                                    if value < 0x112F0:
                                        if value < 0x112DF:
                                            if value < 0x112B0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x112DE:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(133, UInt8(0))
                                        if value > 0x112EA:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(133, UInt8(4))
                                    if value > 0x112F9:
                                        if value < 0x11300:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0x11300:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(44, UInt8(4))
                                    return _UnicodeScriptProperty(133, UInt8(0))
                                return _UnicodeScriptProperty(96, UInt8(0))
                            return _UnicodeScriptProperty(67, UInt8(0))
                        return _UnicodeScriptProperty(130, UInt8(4))
                    if value > 0x11301:
                        if value < 0x11390:
                            if value < 0x1133E:
                                if value < 0x1132A:
                                    if value < 0x11305:
                                        if value < 0x11303:
                                            if value < 0x11302:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11302:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(44, UInt8(4))
                                        if value > 0x11303:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(268, UInt8(4))
                                    if value > 0x1130C:
                                        if value < 0x11313:
                                            if value < 0x1130F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11310:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(44, UInt8(0))
                                        if value > 0x11328:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(44, UInt8(0))
                                    return _UnicodeScriptProperty(44, UInt8(0))
                                if value > 0x11330:
                                    if value < 0x1133B:
                                        if value < 0x11335:
                                            if value < 0x11332:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11333:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(44, UInt8(0))
                                        if value > 0x11339:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(44, UInt8(0))
                                    if value > 0x1133B:
                                        if value < 0x1133D:
                                            if value < 0x1133C:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1133C:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(268, UInt8(4))
                                        if value > 0x1133D:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(44, UInt8(0))
                                    return _UnicodeScriptProperty(268, UInt8(6))
                                return _UnicodeScriptProperty(44, UInt8(0))
                            if value > 0x11344:
                                if value < 0x11362:
                                    if value < 0x11350:
                                        if value < 0x1134B:
                                            if value < 0x11347:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11348:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(44, UInt8(4))
                                        if value > 0x1134D:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(44, UInt8(4))
                                    if value > 0x11350:
                                        if value < 0x1135D:
                                            if value < 0x11357:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11357:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(44, UInt8(4))
                                        if value > 0x11361:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(44, UInt8(0))
                                    return _UnicodeScriptProperty(44, UInt8(0))
                                if value > 0x11363:
                                    if value < 0x11380:
                                        if value < 0x11370:
                                            if value < 0x11366:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1136C:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(44, UInt8(4))
                                        if value > 0x11374:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(44, UInt8(4))
                                    if value > 0x11389:
                                        if value < 0x1138E:
                                            if value < 0x1138B:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1138B:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(162, UInt8(0))
                                        if value > 0x1138E:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(162, UInt8(0))
                                    return _UnicodeScriptProperty(162, UInt8(0))
                                return _UnicodeScriptProperty(44, UInt8(4))
                            return _UnicodeScriptProperty(44, UInt8(4))
                        if value > 0x113B5:
                            if value < 0x11400:
                                if value < 0x113CC:
                                    if value < 0x113C2:
                                        if value < 0x113B8:
                                            if value < 0x113B7:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x113B7:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(162, UInt8(0))
                                        if value > 0x113C0:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(162, UInt8(4))
                                    if value > 0x113C2:
                                        if value < 0x113C7:
                                            if value < 0x113C5:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x113C5:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(162, UInt8(4))
                                        if value > 0x113CA:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(162, UInt8(4))
                                    return _UnicodeScriptProperty(162, UInt8(4))
                                if value > 0x113D0:
                                    if value < 0x113D3:
                                        if value < 0x113D2:
                                            if value < 0x113D1:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x113D1:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(162, UInt8(0))
                                        if value > 0x113D2:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(162, UInt8(4))
                                    if value > 0x113D5:
                                        if value < 0x113E1:
                                            if value < 0x113D7:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x113D8:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(162, UInt8(0))
                                        if value > 0x113E2:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(162, UInt8(4))
                                    return _UnicodeScriptProperty(162, UInt8(0))
                                return _UnicodeScriptProperty(162, UInt8(4))
                            if value > 0x11434:
                                if value < 0x11480:
                                    if value < 0x1145D:
                                        if value < 0x11447:
                                            if value < 0x11435:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11446:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(102, UInt8(4))
                                        if value > 0x1145B:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(102, UInt8(0))
                                    if value > 0x1145D:
                                        if value < 0x1145F:
                                            if value < 0x1145E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1145E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(102, UInt8(4))
                                        if value > 0x11461:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(102, UInt8(0))
                                    return _UnicodeScriptProperty(102, UInt8(0))
                                if value > 0x114AF:
                                    if value < 0x114D0:
                                        if value < 0x114C4:
                                            if value < 0x114B0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x114C3:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(157, UInt8(4))
                                        if value > 0x114C7:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(157, UInt8(0))
                                    if value > 0x114D9:
                                        if value < 0x11580:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0x115AE:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(131, UInt8(0))
                                    return _UnicodeScriptProperty(157, UInt8(0))
                                return _UnicodeScriptProperty(157, UInt8(0))
                            return _UnicodeScriptProperty(102, UInt8(0))
                        return _UnicodeScriptProperty(162, UInt8(0))
                    return _UnicodeScriptProperty(268, UInt8(4))
                return _UnicodeScriptProperty(15, UInt8(4))
            return _UnicodeScriptProperty(165, UInt8(0))
        if value > 0x115B5:
            if value < 0x1D129:
                if value < 0x11F02:
                    if value < 0x11A3B:
                        if value < 0x1190C:
                            if value < 0x116C0:
                                if value < 0x11641:
                                    if value < 0x115DC:
                                        if value < 0x115C1:
                                            if value < 0x115B8:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x115C0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(131, UInt8(4))
                                        if value > 0x115DB:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(131, UInt8(0))
                                    if value > 0x115DD:
                                        if value < 0x11630:
                                            if value < 0x11600:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1162F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(92, UInt8(0))
                                        if value > 0x11640:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(92, UInt8(4))
                                    return _UnicodeScriptProperty(131, UInt8(4))
                                if value > 0x11644:
                                    if value < 0x11680:
                                        if value < 0x11660:
                                            if value < 0x11650:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11659:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(92, UInt8(0))
                                        if value > 0x1166C:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(93, UInt8(0))
                                    if value > 0x116AA:
                                        if value < 0x116B8:
                                            if value < 0x116AB:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x116B7:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(144, UInt8(4))
                                        if value > 0x116B9:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(144, UInt8(0))
                                    return _UnicodeScriptProperty(144, UInt8(0))
                                return _UnicodeScriptProperty(92, UInt8(0))
                            if value > 0x116C9:
                                if value < 0x1182C:
                                    if value < 0x1171D:
                                        if value < 0x11700:
                                            if value < 0x116D0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x116E3:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(97, UInt8(0))
                                        if value > 0x1171A:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(2, UInt8(0))
                                    if value > 0x1172B:
                                        if value < 0x11800:
                                            if value < 0x11730:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11746:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(2, UInt8(0))
                                        if value > 0x1182B:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(31, UInt8(0))
                                    return _UnicodeScriptProperty(2, UInt8(4))
                                if value > 0x1183A:
                                    if value < 0x118FF:
                                        if value < 0x118A0:
                                            if value < 0x1183B:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1183B:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(31, UInt8(0))
                                        if value > 0x118F2:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(166, UInt8(0))
                                    if value > 0x118FF:
                                        if value < 0x11909:
                                            if value < 0x11900:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11906:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(30, UInt8(0))
                                        if value > 0x11909:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(30, UInt8(0))
                                    return _UnicodeScriptProperty(166, UInt8(0))
                                return _UnicodeScriptProperty(31, UInt8(4))
                            return _UnicodeScriptProperty(144, UInt8(0))
                        if value > 0x11913:
                            if value < 0x119A0:
                                if value < 0x1193F:
                                    if value < 0x11930:
                                        if value < 0x11918:
                                            if value < 0x11915:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11916:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(30, UInt8(0))
                                        if value > 0x1192F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(30, UInt8(0))
                                    if value > 0x11935:
                                        if value < 0x1193B:
                                            if value < 0x11937:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11938:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(30, UInt8(4))
                                        if value > 0x1193E:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(30, UInt8(4))
                                    return _UnicodeScriptProperty(30, UInt8(4))
                                if value > 0x1193F:
                                    if value < 0x11942:
                                        if value < 0x11941:
                                            if value < 0x11940:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11940:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(30, UInt8(4))
                                        if value > 0x11941:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(30, UInt8(0))
                                    if value > 0x11943:
                                        if value < 0x11950:
                                            if value < 0x11944:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11946:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(30, UInt8(0))
                                        if value > 0x11959:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(30, UInt8(0))
                                    return _UnicodeScriptProperty(30, UInt8(4))
                                return _UnicodeScriptProperty(30, UInt8(0))
                            if value > 0x119A7:
                                if value < 0x11A00:
                                    if value < 0x119DA:
                                        if value < 0x119D1:
                                            if value < 0x119AA:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x119D0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(99, UInt8(0))
                                        if value > 0x119D7:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(99, UInt8(4))
                                    if value > 0x119E0:
                                        if value < 0x119E4:
                                            if value < 0x119E1:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x119E3:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(99, UInt8(0))
                                        if value > 0x119E4:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(99, UInt8(4))
                                    return _UnicodeScriptProperty(99, UInt8(4))
                                if value > 0x11A00:
                                    if value < 0x11A33:
                                        if value < 0x11A0B:
                                            if value < 0x11A01:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11A0A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(172, UInt8(4))
                                        if value > 0x11A32:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(172, UInt8(0))
                                    if value > 0x11A39:
                                        if value < 0x11A3A:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0x11A3A:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(172, UInt8(0))
                                    return _UnicodeScriptProperty(172, UInt8(4))
                                return _UnicodeScriptProperty(172, UInt8(0))
                            return _UnicodeScriptProperty(99, UInt8(0))
                        return _UnicodeScriptProperty(30, UInt8(0))
                    if value > 0x11A3E:
                        if value < 0x11D08:
                            if value < 0x11BC0:
                                if value < 0x11A8A:
                                    if value < 0x11A50:
                                        if value < 0x11A47:
                                            if value < 0x11A3F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11A46:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(172, UInt8(0))
                                        if value > 0x11A47:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(172, UInt8(4))
                                    if value > 0x11A50:
                                        if value < 0x11A5C:
                                            if value < 0x11A51:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11A5B:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(138, UInt8(4))
                                        if value > 0x11A89:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(138, UInt8(0))
                                    return _UnicodeScriptProperty(138, UInt8(0))
                                if value > 0x11A99:
                                    if value < 0x11AC0:
                                        if value < 0x11AB0:
                                            if value < 0x11A9A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11AA2:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(138, UInt8(0))
                                        if value > 0x11ABF:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(20, UInt8(0))
                                    if value > 0x11AF8:
                                        if value < 0x11B60:
                                            if value < 0x11B00:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11B09:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(29, UInt8(0))
                                        if value > 0x11B67:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(130, UInt8(4))
                                    return _UnicodeScriptProperty(114, UInt8(0))
                                return _UnicodeScriptProperty(138, UInt8(4))
                            if value > 0x11BE1:
                                if value < 0x11C40:
                                    if value < 0x11C0A:
                                        if value < 0x11C00:
                                            if value < 0x11BF0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11BF9:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(140, UInt8(0))
                                        if value > 0x11C08:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(13, UInt8(0))
                                    if value > 0x11C2E:
                                        if value < 0x11C38:
                                            if value < 0x11C2F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11C36:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(13, UInt8(4))
                                        if value > 0x11C3F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(13, UInt8(4))
                                    return _UnicodeScriptProperty(13, UInt8(0))
                                if value > 0x11C45:
                                    if value < 0x11C92:
                                        if value < 0x11C70:
                                            if value < 0x11C50:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11C6C:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(13, UInt8(0))
                                        if value > 0x11C8F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(86, UInt8(0))
                                    if value > 0x11CA7:
                                        if value < 0x11D00:
                                            if value < 0x11CA9:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11CB6:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(86, UInt8(4))
                                        if value > 0x11D06:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(42, UInt8(0))
                                    return _UnicodeScriptProperty(86, UInt8(4))
                                return _UnicodeScriptProperty(13, UInt8(0))
                            return _UnicodeScriptProperty(140, UInt8(0))
                        if value > 0x11D09:
                            if value < 0x11D8A:
                                if value < 0x11D46:
                                    if value < 0x11D3A:
                                        if value < 0x11D31:
                                            if value < 0x11D0B:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11D30:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(42, UInt8(0))
                                        if value > 0x11D36:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(42, UInt8(4))
                                    if value > 0x11D3A:
                                        if value < 0x11D3F:
                                            if value < 0x11D3C:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11D3D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(42, UInt8(4))
                                        if value > 0x11D45:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(42, UInt8(4))
                                    return _UnicodeScriptProperty(42, UInt8(4))
                                if value > 0x11D46:
                                    if value < 0x11D60:
                                        if value < 0x11D50:
                                            if value < 0x11D47:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11D47:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(42, UInt8(4))
                                        if value > 0x11D59:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(42, UInt8(0))
                                    if value > 0x11D65:
                                        if value < 0x11D6A:
                                            if value < 0x11D67:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11D68:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(41, UInt8(0))
                                        if value > 0x11D89:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(41, UInt8(0))
                                    return _UnicodeScriptProperty(41, UInt8(0))
                                return _UnicodeScriptProperty(42, UInt8(0))
                            if value > 0x11D8E:
                                if value < 0x11DE0:
                                    if value < 0x11D98:
                                        if value < 0x11D93:
                                            if value < 0x11D90:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11D91:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(41, UInt8(4))
                                        if value > 0x11D97:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(41, UInt8(4))
                                    if value > 0x11D98:
                                        if value < 0x11DB0:
                                            if value < 0x11DA0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11DA9:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(41, UInt8(0))
                                        if value > 0x11DDB:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(160, UInt8(0))
                                    return _UnicodeScriptProperty(41, UInt8(0))
                                if value > 0x11DE9:
                                    if value < 0x11EF7:
                                        if value < 0x11EF3:
                                            if value < 0x11EE0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11EF2:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(83, UInt8(0))
                                        if value > 0x11EF6:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(83, UInt8(4))
                                    if value > 0x11EF8:
                                        if value < 0x11F00:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0x11F01:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(64, UInt8(4))
                                    return _UnicodeScriptProperty(83, UInt8(0))
                                return _UnicodeScriptProperty(160, UInt8(0))
                            return _UnicodeScriptProperty(41, UInt8(4))
                        return _UnicodeScriptProperty(42, UInt8(0))
                    return _UnicodeScriptProperty(172, UInt8(4))
                if value > 0x11F02:
                    if value < 0x16EA0:
                        if value < 0x13460:
                            if value < 0x11FD3:
                                if value < 0x11F43:
                                    if value < 0x11F12:
                                        if value < 0x11F04:
                                            if value < 0x11F03:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11F03:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(64, UInt8(4))
                                        if value > 0x11F10:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(64, UInt8(0))
                                    if value > 0x11F33:
                                        if value < 0x11F3E:
                                            if value < 0x11F34:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11F3A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(64, UInt8(4))
                                        if value > 0x11F42:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(64, UInt8(4))
                                    return _UnicodeScriptProperty(64, UInt8(0))
                                if value > 0x11F59:
                                    if value < 0x11FC0:
                                        if value < 0x11FB0:
                                            if value < 0x11F5A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11F5A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(64, UInt8(4))
                                        if value > 0x11FB0:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(79, UInt8(0))
                                    if value > 0x11FCF:
                                        if value < 0x11FD2:
                                            if value < 0x11FD0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11FD1:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(268, UInt8(0))
                                        if value > 0x11FD2:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(147, UInt8(0))
                                    return _UnicodeScriptProperty(147, UInt8(0))
                                return _UnicodeScriptProperty(64, UInt8(0))
                            if value > 0x11FD3:
                                if value < 0x12480:
                                    if value < 0x12000:
                                        if value < 0x11FFF:
                                            if value < 0x11FD4:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x11FF1:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(147, UInt8(0))
                                        if value > 0x11FFF:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(147, UInt8(0))
                                    if value > 0x12399:
                                        if value < 0x12470:
                                            if value < 0x12400:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1246E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(169, UInt8(0))
                                        if value > 0x12474:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(169, UInt8(0))
                                    return _UnicodeScriptProperty(169, UInt8(0))
                                if value > 0x12543:
                                    if value < 0x13440:
                                        if value < 0x13000:
                                            if value < 0x12F90:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x12FF2:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(26, UInt8(0))
                                        if value > 0x1343F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(34, UInt8(0))
                                    if value > 0x13440:
                                        if value < 0x13447:
                                            if value < 0x13441:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x13446:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(34, UInt8(0))
                                        if value > 0x13455:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(34, UInt8(4))
                                    return _UnicodeScriptProperty(34, UInt8(4))
                                return _UnicodeScriptProperty(169, UInt8(0))
                            return _UnicodeScriptProperty(268, UInt8(0))
                        if value > 0x143FA:
                            if value < 0x16AF0:
                                if value < 0x16A40:
                                    if value < 0x1611E:
                                        if value < 0x16100:
                                            if value < 0x14400:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x14646:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(55, UInt8(0))
                                        if value > 0x1611D:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(47, UInt8(0))
                                    if value > 0x1612F:
                                        if value < 0x16800:
                                            if value < 0x16130:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x16139:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(47, UInt8(0))
                                        if value > 0x16A38:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(8, UInt8(0))
                                    return _UnicodeScriptProperty(47, UInt8(4))
                                if value > 0x16A5E:
                                    if value < 0x16A70:
                                        if value < 0x16A6E:
                                            if value < 0x16A60:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x16A69:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(94, UInt8(0))
                                        if value > 0x16A6F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(94, UInt8(0))
                                    if value > 0x16ABE:
                                        if value < 0x16AD0:
                                            if value < 0x16AC0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x16AC9:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(158, UInt8(0))
                                        if value > 0x16AED:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(9, UInt8(0))
                                    return _UnicodeScriptProperty(158, UInt8(0))
                                return _UnicodeScriptProperty(94, UInt8(0))
                            if value > 0x16AF4:
                                if value < 0x16B5B:
                                    if value < 0x16B30:
                                        if value < 0x16B00:
                                            if value < 0x16AF5:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x16AF5:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(9, UInt8(0))
                                        if value > 0x16B2F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(56, UInt8(0))
                                    if value > 0x16B36:
                                        if value < 0x16B50:
                                            if value < 0x16B37:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x16B45:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(56, UInt8(0))
                                        if value > 0x16B59:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(56, UInt8(0))
                                    return _UnicodeScriptProperty(56, UInt8(4))
                                if value > 0x16B61:
                                    if value < 0x16D40:
                                        if value < 0x16B7D:
                                            if value < 0x16B63:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x16B77:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(56, UInt8(0))
                                        if value > 0x16B8F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(56, UInt8(0))
                                    if value > 0x16D79:
                                        if value < 0x16E40:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0x16E9A:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(87, UInt8(0))
                                    return _UnicodeScriptProperty(70, UInt8(0))
                                return _UnicodeScriptProperty(56, UInt8(0))
                            return _UnicodeScriptProperty(9, UInt8(4))
                        return _UnicodeScriptProperty(34, UInt8(0))
                    if value > 0x16EB8:
                        if value < 0x1B120:
                            if value < 0x16FF0:
                                if value < 0x16F8F:
                                    if value < 0x16F4F:
                                        if value < 0x16F00:
                                            if value < 0x16EBB:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x16ED3:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(12, UInt8(0))
                                        if value > 0x16F4A:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(120, UInt8(0))
                                    if value > 0x16F4F:
                                        if value < 0x16F51:
                                            if value < 0x16F50:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x16F50:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(120, UInt8(0))
                                        if value > 0x16F87:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(120, UInt8(4))
                                    return _UnicodeScriptProperty(120, UInt8(4))
                                if value > 0x16F92:
                                    if value < 0x16FE1:
                                        if value < 0x16FE0:
                                            if value < 0x16F93:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x16F9F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(120, UInt8(0))
                                        if value > 0x16FE0:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(148, UInt8(0))
                                    if value > 0x16FE1:
                                        if value < 0x16FE4:
                                            if value < 0x16FE2:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x16FE3:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(50, UInt8(0))
                                        if value > 0x16FE4:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(68, UInt8(4))
                                    return _UnicodeScriptProperty(104, UInt8(0))
                                return _UnicodeScriptProperty(120, UInt8(4))
                            if value > 0x16FF1:
                                if value < 0x18D80:
                                    if value < 0x18B00:
                                        if value < 0x17000:
                                            if value < 0x16FF2:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x16FF6:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(50, UInt8(0))
                                        if value > 0x18AFF:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(148, UInt8(0))
                                    if value > 0x18CD5:
                                        if value < 0x18D00:
                                            if value < 0x18CFF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x18CFF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(68, UInt8(0))
                                        if value > 0x18D1E:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(148, UInt8(0))
                                    return _UnicodeScriptProperty(68, UInt8(0))
                                if value > 0x18DF2:
                                    if value < 0x1AFFD:
                                        if value < 0x1AFF5:
                                            if value < 0x1AFF0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1AFF3:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(63, UInt8(0))
                                        if value > 0x1AFFB:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(63, UInt8(0))
                                    if value > 0x1AFFE:
                                        if value < 0x1B001:
                                            if value < 0x1B000:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1B000:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(63, UInt8(0))
                                        if value > 0x1B11F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(54, UInt8(0))
                                    return _UnicodeScriptProperty(63, UInt8(0))
                                return _UnicodeScriptProperty(148, UInt8(0))
                            return _UnicodeScriptProperty(50, UInt8(4))
                        if value > 0x1B122:
                            if value < 0x1BC9F:
                                if value < 0x1BC00:
                                    if value < 0x1B155:
                                        if value < 0x1B150:
                                            if value < 0x1B132:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1B132:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(54, UInt8(0))
                                        if value > 0x1B152:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(54, UInt8(0))
                                    if value > 0x1B155:
                                        if value < 0x1B170:
                                            if value < 0x1B164:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1B167:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(63, UInt8(0))
                                        if value > 0x1B2FB:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(104, UInt8(0))
                                    return _UnicodeScriptProperty(63, UInt8(0))
                                if value > 0x1BC6A:
                                    if value < 0x1BC90:
                                        if value < 0x1BC80:
                                            if value < 0x1BC70:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1BC7C:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(33, UInt8(0))
                                        if value > 0x1BC88:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(33, UInt8(0))
                                    if value > 0x1BC99:
                                        if value < 0x1BC9D:
                                            if value < 0x1BC9C:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1BC9C:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(33, UInt8(0))
                                        if value > 0x1BC9E:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(33, UInt8(4))
                                    return _UnicodeScriptProperty(33, UInt8(0))
                                return _UnicodeScriptProperty(33, UInt8(0))
                            if value > 0x1BC9F:
                                if value < 0x1CF00:
                                    if value < 0x1CD00:
                                        if value < 0x1CC00:
                                            if value < 0x1BCA0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1BCA3:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(263, UInt8(1))
                                        if value > 0x1CCFC:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    if value > 0x1CEB3:
                                        if value < 0x1CEE0:
                                            if value < 0x1CEBA:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1CED0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x1CEF0:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                if value > 0x1CF2D:
                                    if value < 0x1D000:
                                        if value < 0x1CF50:
                                            if value < 0x1CF30:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1CF46:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(173, UInt8(6))
                                        if value > 0x1CFC3:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    if value > 0x1D0F5:
                                        if value < 0x1D100:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0x1D126:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                return _UnicodeScriptProperty(173, UInt8(6))
                            return _UnicodeScriptProperty(33, UInt8(0))
                        return _UnicodeScriptProperty(63, UInt8(0))
                    return _UnicodeScriptProperty(12, UInt8(0))
                return _UnicodeScriptProperty(64, UInt8(0))
            if value > 0x1D164:
                if value < 0x1E8C7:
                    if value < 0x1DA76:
                        if value < 0x1D4A5:
                            if value < 0x1D200:
                                if value < 0x1D17B:
                                    if value < 0x1D16A:
                                        if value < 0x1D167:
                                            if value < 0x1D165:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1D166:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(5))
                                        if value > 0x1D169:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(173, UInt8(6))
                                    if value > 0x1D16C:
                                        if value < 0x1D173:
                                            if value < 0x1D16D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1D172:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(5))
                                        if value > 0x1D17A:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                if value > 0x1D182:
                                    if value < 0x1D18C:
                                        if value < 0x1D185:
                                            if value < 0x1D183:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1D184:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x1D18B:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(173, UInt8(6))
                                    if value > 0x1D1A9:
                                        if value < 0x1D1AE:
                                            if value < 0x1D1AA:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1D1AD:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(173, UInt8(6))
                                        if value > 0x1D1EA:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                return _UnicodeScriptProperty(173, UInt8(6))
                            if value > 0x1D241:
                                if value < 0x1D360:
                                    if value < 0x1D2C0:
                                        if value < 0x1D245:
                                            if value < 0x1D242:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1D244:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(45, UInt8(4))
                                        if value > 0x1D245:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(45, UInt8(0))
                                    if value > 0x1D2D3:
                                        if value < 0x1D300:
                                            if value < 0x1D2E0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1D2F3:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x1D356:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                if value > 0x1D371:
                                    if value < 0x1D456:
                                        if value < 0x1D400:
                                            if value < 0x1D372:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1D378:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x1D454:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    if value > 0x1D49C:
                                        if value < 0x1D4A2:
                                            if value < 0x1D49E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1D49F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x1D4A2:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                return _UnicodeScriptProperty(273, UInt8(1))
                            return _UnicodeScriptProperty(45, UInt8(0))
                        if value > 0x1D4A6:
                            if value < 0x1D546:
                                if value < 0x1D507:
                                    if value < 0x1D4BB:
                                        if value < 0x1D4AE:
                                            if value < 0x1D4A9:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1D4AC:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x1D4B9:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    if value > 0x1D4BB:
                                        if value < 0x1D4C5:
                                            if value < 0x1D4BD:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1D4C3:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x1D505:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                if value > 0x1D50A:
                                    if value < 0x1D51E:
                                        if value < 0x1D516:
                                            if value < 0x1D50D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1D514:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x1D51C:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    if value > 0x1D539:
                                        if value < 0x1D540:
                                            if value < 0x1D53B:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1D53E:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x1D544:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                return _UnicodeScriptProperty(174, UInt8(1))
                            if value > 0x1D546:
                                if value < 0x1DA00:
                                    if value < 0x1D6A8:
                                        if value < 0x1D552:
                                            if value < 0x1D54A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1D550:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x1D6A5:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    if value > 0x1D7CB:
                                        if value < 0x1D800:
                                            if value < 0x1D7CE:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1D7FF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x1D9FF:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(128, UInt8(0))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                if value > 0x1DA36:
                                    if value < 0x1DA6D:
                                        if value < 0x1DA3B:
                                            if value < 0x1DA37:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1DA3A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(128, UInt8(0))
                                        if value > 0x1DA6C:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(128, UInt8(4))
                                    if value > 0x1DA74:
                                        if value < 0x1DA75:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0x1DA75:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(128, UInt8(4))
                                    return _UnicodeScriptProperty(128, UInt8(0))
                                return _UnicodeScriptProperty(128, UInt8(4))
                            return _UnicodeScriptProperty(174, UInt8(1))
                        return _UnicodeScriptProperty(174, UInt8(1))
                    if value > 0x1DA83:
                        if value < 0x1E2FF:
                            if value < 0x1E030:
                                if value < 0x1DF25:
                                    if value < 0x1DA9B:
                                        if value < 0x1DA85:
                                            if value < 0x1DA84:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1DA84:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(128, UInt8(4))
                                        if value > 0x1DA8B:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(128, UInt8(0))
                                    if value > 0x1DA9F:
                                        if value < 0x1DF00:
                                            if value < 0x1DAA1:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1DAAF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(128, UInt8(4))
                                        if value > 0x1DF1E:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(74, UInt8(0))
                                    return _UnicodeScriptProperty(128, UInt8(4))
                                if value > 0x1DF2A:
                                    if value < 0x1E01B:
                                        if value < 0x1E008:
                                            if value < 0x1E000:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1E006:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(40, UInt8(4))
                                        if value > 0x1E018:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(40, UInt8(4))
                                    if value > 0x1E021:
                                        if value < 0x1E026:
                                            if value < 0x1E023:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1E024:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(40, UInt8(4))
                                        if value > 0x1E02A:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(40, UInt8(4))
                                    return _UnicodeScriptProperty(40, UInt8(4))
                                return _UnicodeScriptProperty(74, UInt8(0))
                            if value > 0x1E06D:
                                if value < 0x1E14E:
                                    if value < 0x1E130:
                                        if value < 0x1E100:
                                            if value < 0x1E08F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1E08F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(28, UInt8(4))
                                        if value > 0x1E12C:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(57, UInt8(0))
                                    if value > 0x1E136:
                                        if value < 0x1E140:
                                            if value < 0x1E137:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1E13D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(57, UInt8(0))
                                        if value > 0x1E149:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(57, UInt8(0))
                                    return _UnicodeScriptProperty(57, UInt8(4))
                                if value > 0x1E14F:
                                    if value < 0x1E2C0:
                                        if value < 0x1E2AE:
                                            if value < 0x1E290:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1E2AD:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(161, UInt8(0))
                                        if value > 0x1E2AE:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(161, UInt8(4))
                                    if value > 0x1E2EB:
                                        if value < 0x1E2F0:
                                            if value < 0x1E2EC:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1E2EF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(167, UInt8(4))
                                        if value > 0x1E2F9:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(167, UInt8(0))
                                    return _UnicodeScriptProperty(167, UInt8(0))
                                return _UnicodeScriptProperty(57, UInt8(0))
                            return _UnicodeScriptProperty(28, UInt8(0))
                        if value > 0x1E2FF:
                            if value < 0x1E6E6:
                                if value < 0x1E5F0:
                                    if value < 0x1E4F0:
                                        if value < 0x1E4EC:
                                            if value < 0x1E4D0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1E4EB:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(98, UInt8(0))
                                        if value > 0x1E4EF:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(98, UInt8(4))
                                    if value > 0x1E4F9:
                                        if value < 0x1E5EE:
                                            if value < 0x1E5D0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1E5ED:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(107, UInt8(0))
                                        if value > 0x1E5EF:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(107, UInt8(4))
                                    return _UnicodeScriptProperty(98, UInt8(0))
                                if value > 0x1E5FA:
                                    if value < 0x1E6E0:
                                        if value < 0x1E6C0:
                                            if value < 0x1E5FF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1E5FF:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(107, UInt8(0))
                                        if value > 0x1E6DE:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(150, UInt8(0))
                                    if value > 0x1E6E2:
                                        if value < 0x1E6E4:
                                            if value < 0x1E6E3:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1E6E3:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(150, UInt8(4))
                                        if value > 0x1E6E5:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(150, UInt8(0))
                                    return _UnicodeScriptProperty(150, UInt8(0))
                                return _UnicodeScriptProperty(107, UInt8(0))
                            if value > 0x1E6E6:
                                if value < 0x1E7E0:
                                    if value < 0x1E6F0:
                                        if value < 0x1E6EE:
                                            if value < 0x1E6E7:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1E6ED:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(150, UInt8(0))
                                        if value > 0x1E6EF:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(150, UInt8(4))
                                    if value > 0x1E6F4:
                                        if value < 0x1E6FE:
                                            if value < 0x1E6F5:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1E6F5:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(150, UInt8(4))
                                        if value > 0x1E6FF:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(150, UInt8(0))
                                    return _UnicodeScriptProperty(150, UInt8(0))
                                if value > 0x1E7E6:
                                    if value < 0x1E7F0:
                                        if value < 0x1E7ED:
                                            if value < 0x1E7E8:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1E7EB:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(37, UInt8(0))
                                        if value > 0x1E7EE:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(37, UInt8(0))
                                    if value > 0x1E7FE:
                                        if value < 0x1E800:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0x1E8C4:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(88, UInt8(0))
                                    return _UnicodeScriptProperty(37, UInt8(0))
                                return _UnicodeScriptProperty(37, UInt8(0))
                            return _UnicodeScriptProperty(150, UInt8(4))
                        return _UnicodeScriptProperty(167, UInt8(0))
                    return _UnicodeScriptProperty(128, UInt8(0))
                if value > 0x1E8CF:
                    if value < 0x1F0C1:
                        if value < 0x1EE54:
                            if value < 0x1EE24:
                                if value < 0x1E95E:
                                    if value < 0x1E944:
                                        if value < 0x1E900:
                                            if value < 0x1E8D0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1E8D6:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(88, UInt8(4))
                                        if value > 0x1E943:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(0, UInt8(0))
                                    if value > 0x1E94A:
                                        if value < 0x1E950:
                                            if value < 0x1E94B:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1E94B:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(0, UInt8(0))
                                        if value > 0x1E959:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(0, UInt8(0))
                                    return _UnicodeScriptProperty(0, UInt8(4))
                                if value > 0x1E95F:
                                    if value < 0x1EE00:
                                        if value < 0x1ED01:
                                            if value < 0x1EC71:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1ECB4:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x1ED3D:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    if value > 0x1EE03:
                                        if value < 0x1EE21:
                                            if value < 0x1EE05:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1EE1F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(3, UInt8(0))
                                        if value > 0x1EE22:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(3, UInt8(0))
                                    return _UnicodeScriptProperty(3, UInt8(0))
                                return _UnicodeScriptProperty(0, UInt8(0))
                            if value > 0x1EE24:
                                if value < 0x1EE42:
                                    if value < 0x1EE34:
                                        if value < 0x1EE29:
                                            if value < 0x1EE27:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1EE27:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(3, UInt8(0))
                                        if value > 0x1EE32:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(3, UInt8(0))
                                    if value > 0x1EE37:
                                        if value < 0x1EE3B:
                                            if value < 0x1EE39:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1EE39:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(3, UInt8(0))
                                        if value > 0x1EE3B:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(3, UInt8(0))
                                    return _UnicodeScriptProperty(3, UInt8(0))
                                if value > 0x1EE42:
                                    if value < 0x1EE4B:
                                        if value < 0x1EE49:
                                            if value < 0x1EE47:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1EE47:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(3, UInt8(0))
                                        if value > 0x1EE49:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(3, UInt8(0))
                                    if value > 0x1EE4B:
                                        if value < 0x1EE51:
                                            if value < 0x1EE4D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1EE4F:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(3, UInt8(0))
                                        if value > 0x1EE52:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(3, UInt8(0))
                                    return _UnicodeScriptProperty(3, UInt8(0))
                                return _UnicodeScriptProperty(3, UInt8(0))
                            return _UnicodeScriptProperty(3, UInt8(0))
                        if value > 0x1EE54:
                            if value < 0x1EE7E:
                                if value < 0x1EE61:
                                    if value < 0x1EE5B:
                                        if value < 0x1EE59:
                                            if value < 0x1EE57:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1EE57:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(3, UInt8(0))
                                        if value > 0x1EE59:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(3, UInt8(0))
                                    if value > 0x1EE5B:
                                        if value < 0x1EE5F:
                                            if value < 0x1EE5D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1EE5D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(3, UInt8(0))
                                        if value > 0x1EE5F:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(3, UInt8(0))
                                    return _UnicodeScriptProperty(3, UInt8(0))
                                if value > 0x1EE62:
                                    if value < 0x1EE6C:
                                        if value < 0x1EE67:
                                            if value < 0x1EE64:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1EE64:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(3, UInt8(0))
                                        if value > 0x1EE6A:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(3, UInt8(0))
                                    if value > 0x1EE72:
                                        if value < 0x1EE79:
                                            if value < 0x1EE74:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1EE77:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(3, UInt8(0))
                                        if value > 0x1EE7C:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(3, UInt8(0))
                                    return _UnicodeScriptProperty(3, UInt8(0))
                                return _UnicodeScriptProperty(3, UInt8(0))
                            if value > 0x1EE7E:
                                if value < 0x1EEF0:
                                    if value < 0x1EEA1:
                                        if value < 0x1EE8B:
                                            if value < 0x1EE80:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1EE89:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(3, UInt8(0))
                                        if value > 0x1EE9B:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(3, UInt8(0))
                                    if value > 0x1EEA3:
                                        if value < 0x1EEAB:
                                            if value < 0x1EEA5:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1EEA9:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(3, UInt8(0))
                                        if value > 0x1EEBB:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(3, UInt8(0))
                                    return _UnicodeScriptProperty(3, UInt8(0))
                                if value > 0x1EEF1:
                                    if value < 0x1F0A0:
                                        if value < 0x1F030:
                                            if value < 0x1F000:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1F02B:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x1F093:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    if value > 0x1F0AE:
                                        if value < 0x1F0B1:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0x1F0BF:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                return _UnicodeScriptProperty(3, UInt8(0))
                            return _UnicodeScriptProperty(3, UInt8(0))
                        return _UnicodeScriptProperty(3, UInt8(0))
                    if value > 0x1F0CF:
                        if value < 0x1F8D0:
                            if value < 0x1F6F0:
                                if value < 0x1F210:
                                    if value < 0x1F1E6:
                                        if value < 0x1F100:
                                            if value < 0x1F0D1:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1F0F5:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x1F1AD:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    if value > 0x1F1FF:
                                        if value < 0x1F201:
                                            if value < 0x1F200:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1F200:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(54, UInt8(0))
                                        if value > 0x1F202:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                if value > 0x1F23B:
                                    if value < 0x1F260:
                                        if value < 0x1F250:
                                            if value < 0x1F240:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1F248:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x1F251:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(273, UInt8(1))
                                    if value > 0x1F265:
                                        if value < 0x1F6DC:
                                            if value < 0x1F300:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1F6D8:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x1F6EC:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                return _UnicodeScriptProperty(174, UInt8(1))
                            if value > 0x1F6FC:
                                if value < 0x1F850:
                                    if value < 0x1F7F0:
                                        if value < 0x1F7E0:
                                            if value < 0x1F700:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1F7D9:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x1F7EB:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    if value > 0x1F7F0:
                                        if value < 0x1F810:
                                            if value < 0x1F800:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1F80B:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x1F847:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                if value > 0x1F859:
                                    if value < 0x1F8B0:
                                        if value < 0x1F890:
                                            if value < 0x1F860:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1F887:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x1F8AD:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    if value > 0x1F8BB:
                                        if value < 0x1F8C0:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0x1F8C1:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                return _UnicodeScriptProperty(174, UInt8(1))
                            return _UnicodeScriptProperty(174, UInt8(1))
                        if value > 0x1F8D8:
                            if value < 0x20000:
                                if value < 0x1FAC8:
                                    if value < 0x1FA70:
                                        if value < 0x1FA60:
                                            if value < 0x1F900:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1FA57:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x1FA6D:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    if value > 0x1FA7C:
                                        if value < 0x1FA8E:
                                            if value < 0x1FA80:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1FA8A:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x1FAC6:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                if value > 0x1FAC8:
                                    if value < 0x1FAEF:
                                        if value < 0x1FADF:
                                            if value < 0x1FACD:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1FADC:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x1FAEA:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    if value > 0x1FAF8:
                                        if value < 0x1FB94:
                                            if value < 0x1FB00:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x1FB92:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(174, UInt8(1))
                                        if value > 0x1FBFA:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                return _UnicodeScriptProperty(174, UInt8(1))
                            if value > 0x2A6DF:
                                if value < 0x30000:
                                    if value < 0x2CEB0:
                                        if value < 0x2B820:
                                            if value < 0x2A700:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x2B81D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(50, UInt8(0))
                                        if value > 0x2CEAD:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(50, UInt8(0))
                                    if value > 0x2EBE0:
                                        if value < 0x2F800:
                                            if value < 0x2EBF0:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x2EE5D:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(50, UInt8(0))
                                        if value > 0x2FA1D:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(50, UInt8(0))
                                    return _UnicodeScriptProperty(50, UInt8(0))
                                if value > 0x3134A:
                                    if value < 0xE0020:
                                        if value < 0xE0001:
                                            if value < 0x31350:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            if value > 0x33479:
                                                return _UnicodeScriptProperty(
                                                    175, UInt8(0)
                                                )
                                            return _UnicodeScriptProperty(50, UInt8(0))
                                        if value > 0xE0001:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(174, UInt8(1))
                                    if value > 0xE007F:
                                        if value < 0xE0100:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        if value > 0xE01EF:
                                            return _UnicodeScriptProperty(175, UInt8(0))
                                        return _UnicodeScriptProperty(173, UInt8(6))
                                    return _UnicodeScriptProperty(174, UInt8(1))
                                return _UnicodeScriptProperty(50, UInt8(0))
                            return _UnicodeScriptProperty(50, UInt8(0))
                        return _UnicodeScriptProperty(174, UInt8(1))
                    return _UnicodeScriptProperty(174, UInt8(1))
                return _UnicodeScriptProperty(88, UInt8(0))
            return _UnicodeScriptProperty(174, UInt8(1))
        return _UnicodeScriptProperty(131, UInt8(4))
    return _UnicodeScriptProperty(174, UInt8(1))


def _unicode_bracket_property(value: Int) -> _UnicodeBracketProperty:
    if value < 0 or value > 0x10FFFF:
        return _UnicodeBracketProperty(0)
    if value < 0x2991:
        if value < 0x2770:
            if value < 0x208D:
                if value < 0xF3C:
                    if value < 0x7B:
                        if value < 0x5B:
                            if value < 0x29:
                                if value < 0x28:
                                    return _UnicodeBracketProperty(0)
                                if value > 0x28:
                                    return _UnicodeBracketProperty(0)
                                return _UnicodeBracketProperty(0x140000A5)
                            if value > 0x29:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x148000A2)
                        if value > 0x5B:
                            if value < 0x5D:
                                return _UnicodeBracketProperty(0)
                            if value > 0x5D:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x2E80016E)
                        return _UnicodeBracketProperty(0x2D800175)
                    if value > 0x7B:
                        if value < 0xF3A:
                            if value < 0x7D:
                                return _UnicodeBracketProperty(0)
                            if value > 0x7D:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x3E8001EE)
                        if value > 0xF3A:
                            if value < 0xF3B:
                                return _UnicodeBracketProperty(0)
                            if value > 0xF3B:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x79D803CEA)
                        return _UnicodeBracketProperty(0x79D003CED)
                    return _UnicodeBracketProperty(0x3D8001F5)
                if value > 0xF3C:
                    if value < 0x2045:
                        if value < 0x169B:
                            if value < 0xF3D:
                                return _UnicodeBracketProperty(0)
                            if value > 0xF3D:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x79E803CF2)
                        if value > 0x169B:
                            if value < 0x169C:
                                return _UnicodeBracketProperty(0)
                            if value > 0x169C:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0xB4E005A6E)
                        return _UnicodeBracketProperty(0xB4D805A71)
                    if value > 0x2045:
                        if value < 0x207D:
                            if value < 0x2046:
                                return _UnicodeBracketProperty(0)
                            if value > 0x2046:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x1023008116)
                        if value > 0x207D:
                            if value < 0x207E:
                                return _UnicodeBracketProperty(0)
                            if value > 0x207E:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x103F0081F6)
                        return _UnicodeBracketProperty(0x103E8081F9)
                    return _UnicodeBracketProperty(0x1022808119)
                return _UnicodeBracketProperty(0x79E003CF5)
            if value > 0x208D:
                if value < 0x2768:
                    if value < 0x230A:
                        if value < 0x2308:
                            if value < 0x208E:
                                return _UnicodeBracketProperty(0)
                            if value > 0x208E:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x1047008236)
                        if value > 0x2308:
                            if value < 0x2309:
                                return _UnicodeBracketProperty(0)
                            if value > 0x2309:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x1184808C22)
                        return _UnicodeBracketProperty(0x1184008C25)
                    if value > 0x230A:
                        if value < 0x2329:
                            if value < 0x230B:
                                return _UnicodeBracketProperty(0)
                            if value > 0x230B:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x1185808C2A)
                        if value > 0x2329:
                            if value < 0x232A:
                                return _UnicodeBracketProperty(0)
                            if value > 0x232A:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x180480C022)
                        return _UnicodeBracketProperty(0x180400C025)
                    return _UnicodeBracketProperty(0x1185008C2D)
                if value > 0x2768:
                    if value < 0x276C:
                        if value < 0x276A:
                            if value < 0x2769:
                                return _UnicodeBracketProperty(0)
                            if value > 0x2769:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x13B4809DA2)
                        if value > 0x276A:
                            if value < 0x276B:
                                return _UnicodeBracketProperty(0)
                            if value > 0x276B:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x13B5809DAA)
                        return _UnicodeBracketProperty(0x13B5009DAD)
                    if value > 0x276C:
                        if value < 0x276E:
                            if value < 0x276D:
                                return _UnicodeBracketProperty(0)
                            if value > 0x276D:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x13B6809DB2)
                        if value > 0x276E:
                            if value < 0x276F:
                                return _UnicodeBracketProperty(0)
                            if value > 0x276F:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x13B7809DBA)
                        return _UnicodeBracketProperty(0x13B7009DBD)
                    return _UnicodeBracketProperty(0x13B6009DB5)
                return _UnicodeBracketProperty(0x13B4009DA5)
            return _UnicodeBracketProperty(0x1046808239)
        if value > 0x2770:
            if value < 0x27EE:
                if value < 0x27E6:
                    if value < 0x2774:
                        if value < 0x2772:
                            if value < 0x2771:
                                return _UnicodeBracketProperty(0)
                            if value > 0x2771:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x13B8809DC2)
                        if value > 0x2772:
                            if value < 0x2773:
                                return _UnicodeBracketProperty(0)
                            if value > 0x2773:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x13B9809DCA)
                        return _UnicodeBracketProperty(0x13B9009DCD)
                    if value > 0x2774:
                        if value < 0x27C5:
                            if value < 0x2775:
                                return _UnicodeBracketProperty(0)
                            if value > 0x2775:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x13BA809DD2)
                        if value > 0x27C5:
                            if value < 0x27C6:
                                return _UnicodeBracketProperty(0)
                            if value > 0x27C6:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x13E3009F16)
                        return _UnicodeBracketProperty(0x13E2809F19)
                    return _UnicodeBracketProperty(0x13BA009DD5)
                if value > 0x27E6:
                    if value < 0x27EA:
                        if value < 0x27E8:
                            if value < 0x27E7:
                                return _UnicodeBracketProperty(0)
                            if value > 0x27E7:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x13F3809F9A)
                        if value > 0x27E8:
                            if value < 0x27E9:
                                return _UnicodeBracketProperty(0)
                            if value > 0x27E9:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x13F4809FA2)
                        return _UnicodeBracketProperty(0x13F4009FA5)
                    if value > 0x27EA:
                        if value < 0x27EC:
                            if value < 0x27EB:
                                return _UnicodeBracketProperty(0)
                            if value > 0x27EB:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x13F5809FAA)
                        if value > 0x27EC:
                            if value < 0x27ED:
                                return _UnicodeBracketProperty(0)
                            if value > 0x27ED:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x13F6809FB2)
                        return _UnicodeBracketProperty(0x13F6009FB5)
                    return _UnicodeBracketProperty(0x13F5009FAD)
                return _UnicodeBracketProperty(0x13F3009F9D)
            if value > 0x27EE:
                if value < 0x2989:
                    if value < 0x2985:
                        if value < 0x2983:
                            if value < 0x27EF:
                                return _UnicodeBracketProperty(0)
                            if value > 0x27EF:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x13F7809FBA)
                        if value > 0x2983:
                            if value < 0x2984:
                                return _UnicodeBracketProperty(0)
                            if value > 0x2984:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x14C200A60E)
                        return _UnicodeBracketProperty(0x14C180A611)
                    if value > 0x2985:
                        if value < 0x2987:
                            if value < 0x2986:
                                return _UnicodeBracketProperty(0)
                            if value > 0x2986:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x14C300A616)
                        if value > 0x2987:
                            if value < 0x2988:
                                return _UnicodeBracketProperty(0)
                            if value > 0x2988:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x14C400A61E)
                        return _UnicodeBracketProperty(0x14C380A621)
                    return _UnicodeBracketProperty(0x14C280A619)
                if value > 0x2989:
                    if value < 0x298D:
                        if value < 0x298B:
                            if value < 0x298A:
                                return _UnicodeBracketProperty(0)
                            if value > 0x298A:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x14C500A626)
                        if value > 0x298B:
                            if value < 0x298C:
                                return _UnicodeBracketProperty(0)
                            if value > 0x298C:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x14C600A62E)
                        return _UnicodeBracketProperty(0x14C580A631)
                    if value > 0x298D:
                        if value < 0x298F:
                            if value < 0x298E:
                                return _UnicodeBracketProperty(0)
                            if value > 0x298E:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x14C700A63E)
                        if value > 0x298F:
                            if value < 0x2990:
                                return _UnicodeBracketProperty(0)
                            if value > 0x2990:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x14C800A636)
                        return _UnicodeBracketProperty(0x14C780A639)
                    return _UnicodeBracketProperty(0x14C680A641)
                return _UnicodeBracketProperty(0x14C480A629)
            return _UnicodeBracketProperty(0x13F7009FBD)
        return _UnicodeBracketProperty(0x13B8009DC5)
    if value > 0x2991:
        if value < 0x300A:
            if value < 0x2E24:
                if value < 0x29D8:
                    if value < 0x2995:
                        if value < 0x2993:
                            if value < 0x2992:
                                return _UnicodeBracketProperty(0)
                            if value > 0x2992:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x14C900A646)
                        if value > 0x2993:
                            if value < 0x2994:
                                return _UnicodeBracketProperty(0)
                            if value > 0x2994:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x14CA00A64E)
                        return _UnicodeBracketProperty(0x14C980A651)
                    if value > 0x2995:
                        if value < 0x2997:
                            if value < 0x2996:
                                return _UnicodeBracketProperty(0)
                            if value > 0x2996:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x14CB00A656)
                        if value > 0x2997:
                            if value < 0x2998:
                                return _UnicodeBracketProperty(0)
                            if value > 0x2998:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x14CC00A65E)
                        return _UnicodeBracketProperty(0x14CB80A661)
                    return _UnicodeBracketProperty(0x14CA80A659)
                if value > 0x29D8:
                    if value < 0x29FC:
                        if value < 0x29DA:
                            if value < 0x29D9:
                                return _UnicodeBracketProperty(0)
                            if value > 0x29D9:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x14EC80A762)
                        if value > 0x29DA:
                            if value < 0x29DB:
                                return _UnicodeBracketProperty(0)
                            if value > 0x29DB:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x14ED80A76A)
                        return _UnicodeBracketProperty(0x14ED00A76D)
                    if value > 0x29FC:
                        if value < 0x2E22:
                            if value < 0x29FD:
                                return _UnicodeBracketProperty(0)
                            if value > 0x29FD:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x14FE80A7F2)
                        if value > 0x2E22:
                            if value < 0x2E23:
                                return _UnicodeBracketProperty(0)
                            if value > 0x2E23:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x171180B88A)
                        return _UnicodeBracketProperty(0x171100B88D)
                    return _UnicodeBracketProperty(0x14FE00A7F5)
                return _UnicodeBracketProperty(0x14EC00A765)
            if value > 0x2E24:
                if value < 0x2E57:
                    if value < 0x2E28:
                        if value < 0x2E26:
                            if value < 0x2E25:
                                return _UnicodeBracketProperty(0)
                            if value > 0x2E25:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x171280B892)
                        if value > 0x2E26:
                            if value < 0x2E27:
                                return _UnicodeBracketProperty(0)
                            if value > 0x2E27:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x171380B89A)
                        return _UnicodeBracketProperty(0x171300B89D)
                    if value > 0x2E28:
                        if value < 0x2E55:
                            if value < 0x2E29:
                                return _UnicodeBracketProperty(0)
                            if value > 0x2E29:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x171480B8A2)
                        if value > 0x2E55:
                            if value < 0x2E56:
                                return _UnicodeBracketProperty(0)
                            if value > 0x2E56:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x172B00B956)
                        return _UnicodeBracketProperty(0x172A80B959)
                    return _UnicodeBracketProperty(0x171400B8A5)
                if value > 0x2E57:
                    if value < 0x2E5B:
                        if value < 0x2E59:
                            if value < 0x2E58:
                                return _UnicodeBracketProperty(0)
                            if value > 0x2E58:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x172C00B95E)
                        if value > 0x2E59:
                            if value < 0x2E5A:
                                return _UnicodeBracketProperty(0)
                            if value > 0x2E5A:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x172D00B966)
                        return _UnicodeBracketProperty(0x172C80B969)
                    if value > 0x2E5B:
                        if value < 0x3008:
                            if value < 0x2E5C:
                                return _UnicodeBracketProperty(0)
                            if value > 0x2E5C:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x172E00B96E)
                        if value > 0x3008:
                            if value < 0x3009:
                                return _UnicodeBracketProperty(0)
                            if value > 0x3009:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x180480C022)
                        return _UnicodeBracketProperty(0x180400C025)
                    return _UnicodeBracketProperty(0x172D80B971)
                return _UnicodeBracketProperty(0x172B80B961)
            return _UnicodeBracketProperty(0x171200B895)
        if value > 0x300A:
            if value < 0xFE59:
                if value < 0x3014:
                    if value < 0x300E:
                        if value < 0x300C:
                            if value < 0x300B:
                                return _UnicodeBracketProperty(0)
                            if value > 0x300B:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x180580C02A)
                        if value > 0x300C:
                            if value < 0x300D:
                                return _UnicodeBracketProperty(0)
                            if value > 0x300D:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x180680C032)
                        return _UnicodeBracketProperty(0x180600C035)
                    if value > 0x300E:
                        if value < 0x3010:
                            if value < 0x300F:
                                return _UnicodeBracketProperty(0)
                            if value > 0x300F:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x180780C03A)
                        if value > 0x3010:
                            if value < 0x3011:
                                return _UnicodeBracketProperty(0)
                            if value > 0x3011:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x180880C042)
                        return _UnicodeBracketProperty(0x180800C045)
                    return _UnicodeBracketProperty(0x180700C03D)
                if value > 0x3014:
                    if value < 0x3018:
                        if value < 0x3016:
                            if value < 0x3015:
                                return _UnicodeBracketProperty(0)
                            if value > 0x3015:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x180A80C052)
                        if value > 0x3016:
                            if value < 0x3017:
                                return _UnicodeBracketProperty(0)
                            if value > 0x3017:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x180B80C05A)
                        return _UnicodeBracketProperty(0x180B00C05D)
                    if value > 0x3018:
                        if value < 0x301A:
                            if value < 0x3019:
                                return _UnicodeBracketProperty(0)
                            if value > 0x3019:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x180C80C062)
                        if value > 0x301A:
                            if value < 0x301B:
                                return _UnicodeBracketProperty(0)
                            if value > 0x301B:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x180D80C06A)
                        return _UnicodeBracketProperty(0x180D00C06D)
                    return _UnicodeBracketProperty(0x180C00C065)
                return _UnicodeBracketProperty(0x180A00C055)
            if value > 0xFE59:
                if value < 0xFF3B:
                    if value < 0xFE5D:
                        if value < 0xFE5B:
                            if value < 0xFE5A:
                                return _UnicodeBracketProperty(0)
                            if value > 0xFE5A:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x7F2D03F966)
                        if value > 0xFE5B:
                            if value < 0xFE5C:
                                return _UnicodeBracketProperty(0)
                            if value > 0xFE5C:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x7F2E03F96E)
                        return _UnicodeBracketProperty(0x7F2D83F971)
                    if value > 0xFE5D:
                        if value < 0xFF08:
                            if value < 0xFE5E:
                                return _UnicodeBracketProperty(0)
                            if value > 0xFE5E:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x7F2F03F976)
                        if value > 0xFF08:
                            if value < 0xFF09:
                                return _UnicodeBracketProperty(0)
                            if value > 0xFF09:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x7F8483FC22)
                        return _UnicodeBracketProperty(0x7F8403FC25)
                    return _UnicodeBracketProperty(0x7F2E83F979)
                if value > 0xFF3B:
                    if value < 0xFF5F:
                        if value < 0xFF5B:
                            if value < 0xFF3D:
                                return _UnicodeBracketProperty(0)
                            if value > 0xFF3D:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x7F9E83FCEE)
                        if value > 0xFF5B:
                            if value < 0xFF5D:
                                return _UnicodeBracketProperty(0)
                            if value > 0xFF5D:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x7FAE83FD6E)
                        return _UnicodeBracketProperty(0x7FAD83FD75)
                    if value > 0xFF5F:
                        if value < 0xFF62:
                            if value < 0xFF60:
                                return _UnicodeBracketProperty(0)
                            if value > 0xFF60:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x7FB003FD7E)
                        if value > 0xFF62:
                            if value < 0xFF63:
                                return _UnicodeBracketProperty(0)
                            if value > 0xFF63:
                                return _UnicodeBracketProperty(0)
                            return _UnicodeBracketProperty(0x7FB183FD8A)
                        return _UnicodeBracketProperty(0x7FB103FD8D)
                    return _UnicodeBracketProperty(0x7FAF83FD81)
                return _UnicodeBracketProperty(0x7F9D83FCF5)
            return _UnicodeBracketProperty(0x7F2C83F969)
        return _UnicodeBracketProperty(0x180500C02D)
    return _UnicodeBracketProperty(0x14C880A649)
