testing
testDateAndTime

	| dateAndTime writer |
	dateAndTime := DateAndTime
		               year: 2012
		               month: 2
		               day: 14
		               hour: 16
		               minute: 40
		               second: 18
		               offset: (Duration
				                days: 0
				                hours: 1
				                minutes: 0
				                seconds: 0).
	writer := [ :object |
	          String streamContents: [ :stream |
		          (NeoJSONWriter on: stream)
			          for: dateAndTime class customDo: [ :mapping |
				          mapping encoder: [ :aDateAndTime |
						          aDateAndTime printString ] ];
			          nextPut: object ] ].
	self
		assert: ((writer value: dateAndTime)
		beginsWith: '"2012-02-14T16:40:18').
	self
		assert: ((writer value: dateAndTime)
		endsWith: '+01:00"')