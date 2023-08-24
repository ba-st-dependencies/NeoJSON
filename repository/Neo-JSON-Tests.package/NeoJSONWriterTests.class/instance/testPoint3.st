testing
testPoint3
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(NeoJSONWriter on: stream) 
				for: NeoJSONMockPoint do: [ :mapping |
					mapping mapInstVars: #(x y) ];
				nextPut: object ] ].
	self assert: (writer value: (NeoJSONMockPoint x: 1 y: 2)) equals: '{"x":1,"y":2}'.
	self assert: (writer value: NeoJSONMockPoint new) equals: '{}'