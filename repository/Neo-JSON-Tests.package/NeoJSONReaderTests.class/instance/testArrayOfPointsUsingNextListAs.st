tests
testArrayOfPointsUsingNextListAs
	| reader |
	reader := [ :string | 
		(NeoJSONReader on: string readStream) 
			mapInstVarsFor: NeoJSONMockPoint;
			nextListAs: NeoJSONMockPoint ].
	self assert: (reader value: '[ { "x":1, "y":2 }, { "y":-2, "x":-1 } ]') equals: (Array with: (NeoJSONMockPoint x: 1 y: 2) with: (NeoJSONMockPoint x: -1 y: -2)) . 
	self assert: (reader value: '[ ]') equals: #().
	self assert: (reader value: '[ { } ]') equals: (Array with: NeoJSONMockPoint new) 