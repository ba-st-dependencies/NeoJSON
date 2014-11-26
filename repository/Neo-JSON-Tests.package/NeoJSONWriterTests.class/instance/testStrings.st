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
    assert: (writer value: 'Я можу їсти скло, і воно мені не зашкодить.')
    equals: '"Я можу їсти скло, і воно мені не зашкодить."'.
  self assert: (writer value: '𣎏') equals: '"𣎏"'