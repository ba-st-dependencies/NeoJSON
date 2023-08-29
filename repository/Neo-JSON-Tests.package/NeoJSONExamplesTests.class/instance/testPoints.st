tests
testPoints
	| points json result |
	
	points := Array with: (NeoJSONMockPoint x: 1 y: 2) with: (NeoJSONMockPoint x: 3 y: 4) with: (NeoJSONMockPoint x: 5 y: 6).
	
	json := String streamContents: [ :out |
		(NeoJSONWriter on: out)
			prettyPrint: true;
			mapInstVarsFor: NeoJSONMockPoint;
			nextPut: points ].
		
	result := (NeoJSONReader on: json readStream)
		mapInstVarsFor: NeoJSONMockPoint;
		for: #ListOfPoints customDo: [ :mapping |
			mapping listOfElementSchema: NeoJSONMockPoint ];
		nextAs: #ListOfPoints.
	
	self assert: result equals: points.
			
	result := (NeoJSONReader on: json readStream)
		mapInstVarsFor: NeoJSONMockPoint;
		nextListAs: NeoJSONMockPoint.
	
	self assert: result equals: points.
		
	result := (NeoJSONReader on: json readStream)
		mapInstVarsFor: NeoJSONMockPoint;
		for: #OrderedCollectionOfPoints customDo: [ :mapping |
			mapping listOfType: OrderedCollection andElementSchema: NeoJSONMockPoint ];
		nextAs: #OrderedCollectionOfPoints.
	
	self assert: result equals: points asOrderedCollection.