parsing
parseCharacterHex
  | value |
  value := self parseCharacterHexDigit.
  3 timesRepeat: [ value := (value << 4) + self parseCharacterHexDigit ].
  (value >= 16rD800 and: [ value <= 16rDFFF ])
    ifTrue: [ 
      | leadingBits trailingBits |
      "UTF-16 surrogate pair handling see NeoJSONWriter>>escapeCharacter:"
      leadingBits := value - 16rD800 << 10.
      trailingBits := self parseTrailingSurrogateHex - 16rDC00 bitAnd: 16r3FF.
      value := leadingBits + trailingBits.
      value := value + 16r010000 ].
  ^ Character codePoint: value