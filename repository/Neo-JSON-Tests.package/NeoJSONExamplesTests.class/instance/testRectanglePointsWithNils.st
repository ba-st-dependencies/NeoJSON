tests
testRectanglePointsWithNils
	self
		assert: 
			(String streamContents: [ :stream | 
				(NeoJSONWriter on: stream)
					for: NeoJSONMockPoint do: [ :mapping | mapping mapAllInstVars ];
					for: NeoJSONMockRectangle do: [ :mapping | 
						(mapping mapInstVar: #origin) valueSchema: NeoJSONMockPoint.
						(mapping mapInstVar: #corner) valueSchema: NeoJSONMockPoint ];
					nextPut: NeoJSONMockRectangle new ])
		equals: '{}'.
	self
		assert:
			(String streamContents: [ :stream | 
				(NeoJSONWriter on: stream)
					for: NeoJSONMockPoint do: [ :mapping | mapping mapAllInstVars ];
					for: NeoJSONMockRectangle	do: [ :mapping | 
						(mapping mapInstVar: #origin) valueSchema: NeoJSONMockPoint.
						(mapping mapInstVar: #corner) valueSchema: NeoJSONMockPoint ];
					writeNil: true;
					nextPut: NeoJSONMockRectangle new ])
		equals: '{"origin":null,"corner":null}'.