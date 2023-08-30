testing
testMapsExtra
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(NeoJSONWriter on: stream) nextPut: object ] ].
	self assert: (writer value: (IdentityDictionary newFromPairs: #( 'x' 1))) equals: '{"x":1}'.
	self assert: (writer value: IdentityDictionary new) equals: '{}'.
	#( SmallDictionary OrderedDictionary OrderedIdentityDictionary ) do: [ :each |
		LanguagePlatform current
				 globalNamed: each
				 ifPresent:  [	:dictionaryClass |
			self assert: (writer value: (dictionaryClass new at: 'x' put: 1; at: 'y' put: 2; yourself)) equals: '{"x":1,"y":2}'.
			self assert: (writer value: dictionaryClass new) equals: '{}'] ifAbsent: [ ] ]
