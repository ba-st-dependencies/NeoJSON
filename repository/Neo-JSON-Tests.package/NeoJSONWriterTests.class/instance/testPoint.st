tests
testPoint

	| writer |
	writer := [ :object |
	          String streamContents: [ :stream |
		          (NeoJSONWriter on: stream) nextPut: object ] ].
	self
		should: [ writer value: (NeoJSONMockPoint x: 1 y: 2) ]
		raise: NeoJSONMappingNotFound