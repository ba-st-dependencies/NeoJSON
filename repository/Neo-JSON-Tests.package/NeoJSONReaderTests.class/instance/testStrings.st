testing
testStrings
  | reader |
  reader := [ :string | (NeoJSONReader on: string readStream) next ].
  self assert: (reader value: '"foo"') equals: 'foo'.
  self assert: (reader value: '""') equals: ''.
  self assert: (reader value: '"Foo BAR"') equals: 'Foo BAR'.
  self
    assert: (reader value: '"\u00E9l\u00E8ve en Fran\u00E7ais"')
    equals: 'élève en Français'.
  self
    assert:
      (reader
        value:
          '"\u042F \u043C\u043E\u0436\u0443 \u0457\u0441\u0442\u0438 \u0441\u043A\u043B\u043E, \u0456 \u0432\u043E\u043D\u043E \u043C\u0435\u043D\u0456 \u043D\u0435 \u0437\u0430\u0448\u043A\u043E\u0434\u0438\u0442\u044C."')
    equals: 'Я можу їсти скло, і воно мені не зашкодить.'.
  self assert: (reader value: '"\u2338F"') equals: '𣎏'.
  self
    assert: (reader value: '"\"\\\/\t\r\n\f\b"')
    equals:
      (String
        withAll:
          {$".
          $\.
          $/.
          (Character tab).
          (Character cr).
          (Character lf).
          (Character newPage).
          (Character backspace)}).
  self
    assert: (reader value: '"\"\\\/\t\r\n\f\b"')
    equals:
      (String
        withAll:
          {$".
          $\.
          $/.
          (Character tab).
          (Character cr).
          (Character lf).
          (Character newPage).
          (Character backspace)}).
  self should: [ reader value: '"open' ] raise: NeoJSONParseError.
  self should: [ reader value: '"\uAA"' ] raise: NeoJSONParseError.
  self should: [ reader value: '"\uZZ"' ] raise: NeoJSONParseError.
  self should: [ reader value: '"\x"' ] raise: NeoJSONParseError.
  self should: [ reader value: ' " ' ] raise: NeoJSONParseError