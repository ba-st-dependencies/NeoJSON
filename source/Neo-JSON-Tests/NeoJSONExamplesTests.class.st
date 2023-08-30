"
NeoJSONExamplesTests runs a couple of examples as tests
"
Class {
	#name : #NeoJSONExamplesTests,
	#superclass : #TestCase,
	#category : 'Neo-JSON-Tests'
}

{ #category : #tests }
NeoJSONExamplesTests >> testPoints [
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
]

{ #category : #tests }
NeoJSONExamplesTests >> testRectanglePoints [

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
]

{ #category : #tests }
NeoJSONExamplesTests >> testRectanglePointsWithNils [
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
]
