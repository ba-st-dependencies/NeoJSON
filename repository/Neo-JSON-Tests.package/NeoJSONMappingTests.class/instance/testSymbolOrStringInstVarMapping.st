tests
testSymbolOrStringInstVarMapping

	| data out1 out2 result1 result2 |
	data := Array
		        with: (NeoJSONMockPoint x: 1 y: 2)
		        with: (NeoJSONMockPoint x: 3 y: 4).
	out1 := String streamContents: [ :out |
		        (NeoJSONWriter on: out)
			        for: NeoJSONMockPoint
			        do: [ :mapping | mapping mapInstVars: #( x y ) ];
			        nextPut: data ].
	result1 := (NeoJSONReader on: out1 readStream)
		           for: NeoJSONMockPoint
		           do: [ :mapping | mapping mapInstVars: #( x y ) ];
		           nextListAs: NeoJSONMockPoint.
	self assert: result1 equals: data.
	out2 := String streamContents: [ :out |
		        (NeoJSONWriter on: out)
			        for: NeoJSONMockPoint
			        do: [ :mapping | mapping mapInstVars: #( 'x' 'y' ) ];
			        nextPut: data ].
	result2 := (NeoJSONReader on: out1 readStream)
		           for: NeoJSONMockPoint
		           do: [ :mapping | mapping mapInstVars: #( 'x' 'y' ) ];
		           nextListAs: NeoJSONMockPoint.
	self assert: result2 equals: data