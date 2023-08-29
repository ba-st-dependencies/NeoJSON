tests
testAllowNil
	self 
		should: [ 
			(NeoJSONReader on: 'null' readStream)
				mapInstVarsFor: NeoJSONMockPoint;
				nextAs: NeoJSONMockPoint ] 
		raise: NeoJSONParseError.
	self
		assert: ((NeoJSONReader on: 'null' readStream)
						mapInstVarsFor: NeoJSONMockPoint;
						for: NeoJSONMockPoint do: [ :mapping | mapping allowNil ];
						nextAs: NeoJSONMockPoint)
		equals: nil.
	self
		assert: ((NeoJSONReader on: '[ { "x" : 1, "y" : 2 }, null, { "x" : 3, "y" : -1 } ]' readStream)
						mapInstVarsFor: NeoJSONMockPoint;
						for: NeoJSONMockPoint do: [ :mapping | mapping allowNil ];
						for: #ArrayOfPoints customDo: [ :mapping | mapping listOfElementSchema: NeoJSONMockPoint ];
						nextAs: #ArrayOfPoints)
		equals: (Array with: (NeoJSONMockPoint x: 1 y: 2) with: nil with: (NeoJSONMockPoint x: 3 y: -1)).