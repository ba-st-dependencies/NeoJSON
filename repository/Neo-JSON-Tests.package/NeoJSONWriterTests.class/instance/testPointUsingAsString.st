tests
testPointUsingAsString
  | output |
  output := String
    streamContents: [ :out | 
      (NeoJSONWriter on: out)
        for: NeoJSONMockPoint
          do: [ :mapping | 
              (mapping
                mapProperty: #'x'
                getter: [ :object | object x ]
                setter: [ :object :value | object setX: value setY: object y ])
                valueSchema: #'AsString'.
              (mapping
                mapProperty: #'y'
                getter: [ :object | object y ]
                setter: [ :object :value | object setX: object x setY: value ])
                valueSchema: #'AsString' ];
        for: #'AsString'
          customDo: [ :mapping | 
              mapping
                encoder: [ :x | x asString ];
                decoder: [ :x | x asNumber ] ];
        nextPut: (NeoJSONMockPoint x: 1 y: 2) ].
  self
    assert: (output = '{"x":"1","y":"2"}' or: [ output = '{"y":"2","x":"1"}' ])