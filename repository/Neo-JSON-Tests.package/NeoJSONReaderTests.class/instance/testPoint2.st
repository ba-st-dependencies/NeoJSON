tests
testPoint2
	| reader |
	reader := [ :string | 
		(NeoJSONReader on: string readStream) 
			mapAllInstVarsFor: NeoJSONMockPoint;
			nextAs: NeoJSONMockPoint ].
	self assert: (reader value: '{"x":1,"y":2}') equals: (NeoJSONMockPoint x: 1 y: 2). 
	self assert: (reader value: '{}') equals: NeoJSONMockPoint new