testing
testAsciiOnlyStrings

	| writer |
	writer := [ :object |
	          String streamContents: [ :stream |
		          (NeoJSONWriter on: stream)
			          asciiOnly: true;
			          nextPut: object ] ].
	self
		assert: (writer value: 'élève français')
		equals: '"\u00e9l\u00e8ve fran\u00e7ais"'.
	self assert: (writer value: 'foo') equals: '"foo"'.
	self assert: (writer value: 'Foo BAR') equals: '"Foo BAR"'.
	self assert: (writer value: '') equals: '""'.
	self
		assert: (writer value: (String withAll: {
						  $".
						  $\.
						  $/.
						  Character tab.
						  Character cr.
						  Character lf.
						  Character newPage.
						  Character backspace }))
		equals: '"\"\\/\t\r\n\f\b"'