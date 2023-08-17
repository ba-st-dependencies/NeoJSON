testing
testTime

	| reader |
	reader := [ :input |
	          (NeoJSONReader on: input readStream)
		          for: Time
		          customDo: [ :mapping |
			          mapping decoder: [ :string | Time fromString: string ] ];
		          nextAs: Time ].
	self
		assert: (reader value: ' "14:30:08" ')
		equals: (Time fromSeconds: 8 + (30 * 60) + (14 * 3600))