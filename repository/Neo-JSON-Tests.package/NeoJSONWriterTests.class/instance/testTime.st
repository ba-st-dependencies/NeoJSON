testing
testTime

	| writer |
	writer := [ :object |
	          String streamContents: [ :stream |
		          (NeoJSONWriter on: stream)
			          for: Time
			          customDo: [ :mapping |
				          mapping encoder: [ :time | time print24 ] ];
			          nextPut: object ] ].
	self
		assert:
		(writer value: (Time fromSeconds: 8 + (30 * 60) + (14 * 3600)))
		equals: '"14:30:08"'