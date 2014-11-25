testing
testStrings
  | writer |
  writer := [ :object | String streamContents: [ :stream | (NeoJSONWriter on: stream) nextPut: object ] ].
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
    assert:
      (writer value: 'Я можу їсти скло, і воно мені не зашкодить.' asUnicodeString)
    equals: '"Я можу їсти скло, і воно мені не зашкодить."'.	"Unicode16"
  self assert: (writer value: '𣎏' asUnicodeString) equals: '"𣎏"'	"Unicode32"