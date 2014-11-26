testing
testAsciiOnlyStrings
  | writer |
  writer := [ :object | 
  String
    streamContents: [ :stream | 
      (NeoJSONWriter on: stream)
        asciiOnly: true;
        nextPut: object ] ].
  self
    assert: (writer value: 'élève français')
    equals: '"\u00E9l\u00E8ve fran\u00E7ais"'.
  self assert: (writer value: 'foo') equals: '"foo"'.
  self assert: (writer value: 'Foo BAR') equals: '"Foo BAR"'.
  self assert: (writer value: '') equals: '""'.
  self
    assert:
      (writer
        value:
          (String
            withAll:
              {$".
              $\.
              $/.
              (Character tab).
              (Character cr).
              (Character lf).
              (Character newPage).
              (Character backspace)}))
    equals: '"\"\\/\t\r\n\f\b"'.
  self
    assert: (writer value: 'Я можу їсти скло, і воно мені не зашкодить.')
    equals:
      '"\u042F \u043C\u043E\u0436\u0443 \u0457\u0441\u0442\u0438 \u0441\u043A\u043B\u043E, \u0456 \u0432\u043E\u043D\u043E \u043C\u0435\u043D\u0456 \u043D\u0435 \u0437\u0430\u0448\u043A\u043E\u0434\u0438\u0442\u044C."'.
  self assert: (writer value: '𣎏') equals: '"\uD84C\uDF8F"'