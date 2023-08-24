testing
testDate

	| reader |
	reader := [ :input |
	          (NeoJSONReader on: input readStream)
		          for: Date customDo: [ :mapping |
			          mapping decoder: [ :string |
					          | dateSubstrings |
					          dateSubstrings := (string substrings: $- asString)
						                            asOrderedCollection.
					          Date
						          newDay: dateSubstrings removeLast asNumber
						          monthNumber: dateSubstrings removeLast asNumber
						          year: dateSubstrings removeLast asNumber ] ];
		          nextAs: Date ].
	self
		assert: (reader value: ' "2012-06-08" ')
		equals: (Date newDay: 8 month: 'June' year: 2012)