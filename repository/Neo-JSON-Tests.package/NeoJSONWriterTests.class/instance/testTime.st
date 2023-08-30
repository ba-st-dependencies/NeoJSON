testing
testTime

	| time writer |
	time := Time fromSeconds: 8 + (30 * 60) + (14 * 3600).
	writer := [ :object |
	          String streamContents: [ :stream |
		          (NeoJSONWriter on: stream)
			          for: time class
			          customDo: [ :mapping |
				          mapping encoder: [ :aTime | aTime printHHMMSS ] ];
			          nextPut: object ] ].
	self assert: (writer value: time) equals: '"14:30:08"'