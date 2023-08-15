testing
testArrayOfPoints

	| reader |
	reader := [ :string |
	          (NeoJSONReader on: string readStream)
		          for: NeoJSONMockPoint
		          do: [ :mapping | mapping mapInstVars: #( x y ) ];
		          for: #ArrayOfPoints
		          customDo: [ :mapping |
			          mapping listOfElementSchema: NeoJSONMockPoint ];
		          nextAs: #ArrayOfPoints ].
	self
		assert: (reader value: '[ { "x":1, "y":2 }, { "x":-1, "y":-2 } ]')
		equals: {
				(NeoJSONMockPoint x: 1 y: 2).
				(NeoJSONMockPoint x: -1 y: -2) }.
	self assert: (reader value: '[ ]') equals: #(  ).
	self
		assert: (reader value: '[ { } ]')
		equals: { NeoJSONMockPoint new }