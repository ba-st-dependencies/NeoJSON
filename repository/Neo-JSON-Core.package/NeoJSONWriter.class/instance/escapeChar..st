private
escapeChar: code
  code = 34
    ifTrue: [ ^ writeStream nextPutAll: '\"' ].
  code = 92
    ifTrue: [ ^ writeStream nextPutAll: '\\' ].
  code = 47
    ifTrue: [ ^ writeStream nextPutAll: '\/' ].
  code = 8
    ifTrue: [ ^ writeStream nextPutAll: '\b' ].
  code = 12
    ifTrue: [ ^ writeStream nextPutAll: '\f' ].
  code = 10
    ifTrue: [ ^ writeStream nextPutAll: '\n' ].
  code = 13
    ifTrue: [ ^ writeStream nextPutAll: '\r' ].
  code = 9
    ifTrue: [ ^ writeStream nextPutAll: '\t' ].
  code > 16rffff
    ifTrue: [ 
      | x leadingSurrogate trailingSurrogate |
      "surrogate pair handling from http://en.wikipedia.org/wiki/UTF-16:
Code points from the other planes (called Supplementary Planes) are encoded in UTF-16 by pairs of 16-bit code units called surrogate pairs, by the following scheme:
    - 0x010000 is subtracted from the code point, leaving a 20-bit number in the range 0..0x0FFFFF.

    - The top ten bits (a number in the range 0..0x03FF) are added to 0xD800 to give the first code unit or high surrogate, which will be in the range 0xD800..0xDBFF.
    - The low ten bits (also in the range 0..0x03FF) are added to 0xDC00 to give the second code unit or low surrogate, which will be in the range 0xDC00..0xDFFF.

(High and low surrogates are also known as 'leading' and 'trailing' surrogates, respectively, analogous to the leading and trailing bytes of UTF-8.[3] Note that 'high' surrogates have lower code-point numbers than 'low' surrogates.)

Since the ranges for the high surrogates, low surrogates, and valid BMP characters are disjoint, searches are simplified: it is not possible for part of one character to match a different part of another character. It also means that UTF-16 is self-synchronizing on 16-bit words: whether a code unit starts a character can be determined without examining earlier code units. UTF-8 shares these advantages, but many earlier multi-byte encoding schemes did not allow unambiguous searching and could only be synchronized by re-parsing from the start of the string. UTF-16 is not self-synchronizing if one byte is lost or if traversal starts at a random byte.

Because the most commonly used characters are all in the Basic Multilingual Plane, handling of surrogate pairs is often not thoroughly tested. This leads to persistent bugs and potential security holes, even in popular and well-reviewed application software (e.g. CVE-2008-2938, CVE-2012-2135)"
      x := code - 16r010000.
      leadingSurrogate := 16rD800 + (x >> 10 bitAnd: 16r3FF).	"top ten bits"
      trailingSurrogate := 16rDC00 + (x bitAnd: 16r3FF).	"bottom ten bits missing end of comment"
      writeStream nextPutAll: '\u'.
      writeStream
        nextPutAll: (leadingSurrogate printPaddedWith: $0 to: 4 base: 16).
      writeStream nextPutAll: '\u'.
      writeStream
        nextPutAll: (trailingSurrogate printPaddedWith: $0 to: 4 base: 16) ]
    ifFalse: [ 
      writeStream nextPutAll: '\u'.
      writeStream nextPutAll: (code printPaddedWith: $0 to: 4 base: 16) ]