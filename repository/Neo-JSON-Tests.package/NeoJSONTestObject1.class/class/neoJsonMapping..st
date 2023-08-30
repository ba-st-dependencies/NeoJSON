examples
neoJsonMapping: mapper
	mapper for: self do: [ :mapping |
		mapping mapInstVars: #(id name).
		(mapping mapInstVar: #timestamp to: 'created-at') valueSchema: DateAndTime.
		(mapping mapInstVar: #points) valueSchema: #ArrayOfPoints.
		(mapping mapInstVar: #bytes) valueSchema: ByteArray ].
	mapper for: DateAndTime customDo: [ :mapping |
		mapping decoder: [ :string | DateAndTime fromString: string ].
		mapping encoder: [ :dateAndTime | dateAndTime printString ] ].
	mapper for: #ArrayOfPoints customDo: [ :mapping |
		mapping listOfElementSchema: NeoJSONMockPoint ].  
	mapper mapAllInstVarsFor: NeoJSONMockPoint.
	mapper for: ByteArray customDo: [ :mapping |
		mapping listOfType: ByteArray ]