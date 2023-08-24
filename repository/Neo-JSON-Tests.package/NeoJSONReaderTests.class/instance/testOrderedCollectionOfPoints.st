testing
testOrderedCollectionOfPoints

	| reader |
	reader := [ :string |
	          (NeoJSONReader on: string readStream)
		          for: NeoJSONMockPoint
		          do: [ :mapping | mapping mapInstVars: #( x y ) ];
		          for: #OrderedCollectionOfPoints customDo: [ :mapping |
			          mapping
				          listOfType: OrderedCollection
				          andElementSchema: NeoJSONMockPoint ];
		          nextAs: #OrderedCollectionOfPoints ].
	self
		assert: (reader value: '[ { "x":1, "y":2 }, { "x":-1, "y":-2 } ]')
		equals: {
				(NeoJSONMockPoint x: 1 y: 2).
				(NeoJSONMockPoint x: -1 y: -2) } asOrderedCollection.
	self assert: (reader value: '[ ]') equals: OrderedCollection new.
	self
		assert: (reader value: '[ { } ]')
		equals: (OrderedCollection with: NeoJSONMockPoint new)