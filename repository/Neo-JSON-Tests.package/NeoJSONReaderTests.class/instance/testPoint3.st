testing
testPoint3
	| reader |
	reader := [ :string | 
		(NeoJSONReader on: string readStream) 
			for: NeoJSONMockPoint do: [ :mapping |
				mapping mapInstVars: #(x y) ];
			nextAs: NeoJSONMockPoint ].
	self assert: (reader value: '{"x":1,"y":2}') equals: (NeoJSONMockPoint x: 1 y: 2). 
	self assert: (reader value: '{}') equals: NeoJSONMockPoint new