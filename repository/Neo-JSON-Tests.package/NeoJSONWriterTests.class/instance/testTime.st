testing
testTime

	| time writer |
	time := Time fromSeconds: 8 + (30 * 60) + (14 * 3600).
	writer := [ :object |
	          String streamContents: [ :stream |
		          (NeoJSONWriter on: stream)
			          for: time species
			          customDo: [ :mapping |
				          mapping encoder: [ :aTime | aTime print24 ] ];
			          nextPut: object ] ].
	self assert: (writer value: time) equals: '"14:30:08"'