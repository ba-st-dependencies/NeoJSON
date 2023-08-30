tests
testPointUsingAsString
	| point |
	point := (NeoJSONReader on: '{"x":"1","y":"2"}' readStream)
		for: NeoJSONMockPoint
			do: [ :mapping | 
					(mapping 
						mapProperty: #x 
						getter: [ :object | object x ] 
						setter: [ :object :value | object setX: value setY: object y ])
						valueSchema: #AsString.
					(mapping
						mapProperty: #y
						getter: [ :object | object y ]
						setter: [ :object :value | object setX: object x setY: value ]) 
						valueSchema: #AsString ];
		for: #AsString
			customDo: [ :mapping | 
					mapping
						encoder: [ :x | x asString ];
						decoder: [ :x | x asNumber ] ];
		nextAs: NeoJSONMockPoint.
	self assert: point equals: (NeoJSONMockPoint x: 1 y: 2)