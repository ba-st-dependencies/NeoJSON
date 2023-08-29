tests
testPoint1

	| reader |
	reader := [ :string |
	          (NeoJSONReader on: string readStream)
		          for: NeoJSONMockPoint do: [ :mapping |
			          mapping
				          mapProperty: 'x'
				          getter: [ :point | point x ]
				          setter: [ :point :value |
					          point setX: value setY: point y ].
			          mapping
				          mapProperty: 'y'
				          getter: [ :point | point y ]
				          setter: [ :point :value |
					          point setX: point x setY: value ] ];
		          nextAs: NeoJSONMockPoint ].
	self
		assert: (reader value: '{"x":1,"y":2}')
		equals: (NeoJSONMockPoint x: 1 y: 2).
	self assert: (reader value: '{}') equals: NeoJSONMockPoint new