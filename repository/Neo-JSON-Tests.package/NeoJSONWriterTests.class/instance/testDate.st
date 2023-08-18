testing
testDate
	| date writer |
	date := Date newDay: 8 month: 'June' year: 2012.
	writer := [ :object | 
		String streamContents: [ :stream |
			(NeoJSONWriter on: stream) 
				for: date class customDo: [ :mapping |
					mapping encoder: [ :aDate | aDate yyyymmdd ] ];
				nextPut: object ] ].
	self assert: (writer value: date) equals: '"2012-06-08"'