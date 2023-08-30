tests
testRectanglePoints

	| rectangle rectangleJson result |
	rectangle := NeoJSONMockRectangle 
		             origin: (NeoJSONMockPoint x: 3 y: 4)
		             extent: (NeoJSONMockPoint x: 5 y: 6).

	rectangleJson := String streamContents: [ :stream |
		                 (NeoJSONWriter on: stream)
			                 prettyPrint: true;
			                 mapInstVarsFor: NeoJSONMockPoint;
			                 mapInstVarsFor: NeoJSONMockRectangle;
			                 nextPut: rectangle ].

	result := (NeoJSONReader on: rectangleJson readStream)
		          mapInstVarsFor: NeoJSONMockPoint;
		          for: NeoJSONMockRectangle do: [ :mapping |
			          (mapping mapInstVar: #origin) valueSchema:
					          NeoJSONMockPoint.
			          (mapping mapInstVar: #corner) valueSchema:
					          NeoJSONMockPoint ];
		          nextAs: NeoJSONMockRectangle.

	self assert: result equals: rectangle.

	result := (NeoJSONReader on: rectangleJson readStream)
		          mapInstVarsFor: NeoJSONMockPoint;
		          for: NeoJSONMockRectangle do: [ :mapping |
			          mapping mapInstVars do: [ :each |
					          each valueSchema: NeoJSONMockPoint ] ];
		          nextAs: NeoJSONMockRectangle.

	self assert: result equals: rectangle