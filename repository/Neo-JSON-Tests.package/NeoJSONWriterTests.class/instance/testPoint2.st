tests
testPoint2
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(NeoJSONWriter on: stream) 
				mapAllInstVarsFor: NeoJSONMockPoint;
				nextPut: object ] ].
	self assert: (writer value: (NeoJSONMockPoint x: 1 y: 2)) equals: '{"x":1,"y":2}'.
	self assert: (writer value: NeoJSONMockPoint new) equals: '{}'