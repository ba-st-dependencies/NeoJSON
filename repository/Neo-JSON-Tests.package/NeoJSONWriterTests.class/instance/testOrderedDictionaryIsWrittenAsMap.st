testing
testOrderedDictionaryIsWrittenAsMap

	| writer |
	writer := [ :dict |
	          String streamContents: [ :stream |
		          (NeoJSONWriter on: stream) nextPut: dict ] ].
	self
		assert: (writer value: (OrderedDictionary new
					  at: #a put: 1;
					  at: #b put: 2;
					  yourself))
		equals: '{"a":1,"b":2}'.
	self assert: (writer value: OrderedDictionary new) equals: '{}'