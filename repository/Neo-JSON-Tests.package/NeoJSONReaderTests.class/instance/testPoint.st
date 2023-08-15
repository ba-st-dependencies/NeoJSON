testing
testPoint
	| reader |
	reader := [ :string | 
		(NeoJSONReader on: string readStream) nextAs: NeoJSONMockPoint ].
	self should: [ reader value: '{"x":1,"y":2}' ] raise: NeoJSONMappingNotFound