"
I am NeoJSONWriterTests, a test suite for NeoJSONWriter.
"
Class {
	#name : #NeoJSONWriterTests,
	#superclass : #TestCase,
	#category : 'Neo-JSON-Tests'
}

{ #category : #testing }
NeoJSONWriterTests >> testAsciiOnlyStrings [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(NeoJSONWriter on: stream) 
				asciiOnly: true;
				nextPut: object ] ].
	self assert: (writer value: 'élève français') equals: '"\u00E9l\u00E8ve fran\u00E7ais"'.
	self assert: (writer value: 'foo') equals: '"foo"'.
	self assert: (writer value: 'Foo BAR') equals: '"Foo BAR"'.
	self assert: (writer value: '') equals: '""'.
	self
		assert: (writer value: (String withAll: ( OrderedCollection new 
			add: $";
			add: $\; 
			add: $/;
			add: Character tab;
			add: Character cr;
			add: Character lf;
			add: Character newPage; 
			add: Character backspace;
			yourself )))
		equals: '"\"\\/\t\r\n\f\b"'


]

{ #category : #testing }
NeoJSONWriterTests >> testAssociation [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(NeoJSONWriter on: stream) 
				for: Association do: [ :mapping |
					mapping mapAccessors: #(key value) ]; 
				nextPut: object ] ].
	self assert: (writer value: 'foo' -> 42) equals: '{"key":"foo","value":42}'.
	self assert: (writer value: Association new) equals: '{}'
]

{ #category : #testing }
NeoJSONWriterTests >> testBooleans [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(NeoJSONWriter on: stream) nextPut: object ] ].
	self assert: (writer value: true) equals: 'true'.
	self assert: (writer value: false) equals: 'false'.
]

{ #category : #testing }
NeoJSONWriterTests >> testByteArray [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(NeoJSONWriter on: stream) nextPut: object ] ].
	self assert: (writer value: #[1 2 3]) equals: '[1,2,3]'.
	self assert: (writer value: #[]) equals: '[]'

]

{ #category : #testing }
NeoJSONWriterTests >> testDate [
	| date writer |
	date := Date newDay: 8 month: 'June' year: 2012.
	writer := [ :object | 
		String streamContents: [ :stream |
			(NeoJSONWriter on: stream) 
				for: date class customDo: [ :mapping |
					mapping encoder: [ :aDate | aDate yyyymmdd ] ];
				nextPut: object ] ].
	self assert: (writer value: date) equals: '"2012-06-08"'
]

{ #category : #testing }
NeoJSONWriterTests >> testDateAndTime [

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
]

{ #category : #testing }
NeoJSONWriterTests >> testFloatPrinter [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(NeoJSONWriter on: stream) 
				floatPrinter: NeoJSONFloatPrinter new;
				nextPut: object ] ].
	self assert: (writer value: 123.0) equals: '123'.
	self assert: (writer value: -123.0) equals: '-123'.
	self assert: (writer value: 0.0) equals: '0'.
	self assert: (writer value: 1.50) equals: '1.5'.
	self assert: (writer value: -1.25) equals: '-1.25'.
	self assert: (writer value: Float pi) equals: '3.14159'.
	self assert: (writer value: 9.10938356e-31) equals: '9.10938e-31'.
	self assert: (writer value: 5.9724e24) equals: '5.9724e24'.
	self assert: (writer value: 1234567890.1234567890) equals: '1.23457e9'.
	self assert: (writer value: (1/3) asFloat) equals: '0.33333'.
]

{ #category : #testing }
NeoJSONWriterTests >> testFloats [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(NeoJSONWriter on: stream) nextPut: object ] ].
	self assert: (writer value: 123.0) equals: '123.0'.
	self assert: (writer value: -123.0) equals: '-123.0'.
	self assert: (writer value: 0.0) equals: '0.0'.
]

{ #category : #testing }
NeoJSONWriterTests >> testIntegers [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(NeoJSONWriter on: stream) nextPut: object ] ].
	self assert: (writer value: 123) equals: '123'.
	self assert: (writer value: -123) equals: '-123'.
	self assert: (writer value: 0) equals: '0'.
]

{ #category : #testing }
NeoJSONWriterTests >> testLists [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(NeoJSONWriter on: stream) nextPut: object ] ].
	self assert: (writer value: #(1 2 3)) equals: '[1,2,3]'.
	self assert: (writer value: #()) equals: '[]'.

]

{ #category : #testing }
NeoJSONWriterTests >> testListsExtra [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(NeoJSONWriter on: stream) nextPut: object ] ].
	#( OrderedCollection LinkedList ByteArray IntegerArray SortedCollection ) do: [ :each |
		LanguagePlatform current
				 globalNamed: each
				 ifPresent: [ :collectionClass |
			self assert: (writer value: (collectionClass withAll: #(1 2 3))) equals: '[1,2,3]'.
			self assert: (writer value: collectionClass new) equals: '[]' ] ifAbsent: [ ]]

]

{ #category : #testing }
NeoJSONWriterTests >> testMapKeysMustBeStrings [
	self should: [ NeoJSONWriter toString: { 1->#a } asDictionary ] raise: Error.
	self should: [ NeoJSONWriter toString: { true->#a } asDictionary ] raise: Error.
	self should: [ NeoJSONWriter toString: { nil->#a } asDictionary ] raise: Error.
	self should: [ NeoJSONWriter toString: { #()->#a } asDictionary ] raise: Error.
	self should: [ NeoJSONWriter toString: { Dictionary new->#a } asDictionary ] raise: Error.
	self should: [ NeoJSONWriter toString: { Float pi->#a } asDictionary ] raise: Error.
]

{ #category : #testing }
NeoJSONWriterTests >> testMaps [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(NeoJSONWriter on: stream) nextPut: object ] ].
	self assert: ((writer value: (Dictionary newFromPairs: #( 'x' 1 'y' 2))) includesSubstring: '"x":1').
	self assert: ((writer value: (Dictionary newFromPairs: #( 'x' 1 'y' 2))) includesSubstring: '"y":2').
	self assert: (writer value: Dictionary new) equals: '{}'.

]

{ #category : #testing }
NeoJSONWriterTests >> testMapsExtra [
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

]

{ #category : #testing }
NeoJSONWriterTests >> testNextPutStringAsHex [
	| output |
	output := String
		streamContents: [ :out | 
			(NeoJSONWriter on: out)
				for: #StringAsHex
					customDo: [ :mapping | 
							mapping
								encoder: [ :x | x asByteArray asHexString asUppercase ];
								decoder: [ :x | (ByteArray readHexFrom: x) asString ] ];
				nextPut: 'Foo bar!' as: #StringAsHex ].
	self assert: output equals: '"466F6F2062617221"'
]

{ #category : #testing }
NeoJSONWriterTests >> testNonBMPCharacterEncoding [
	"Characters not in the Basic Multilingual Plane are encoded as a UTF-16 surrogate pair"

	| string json |
	string := 16r1D11E asCharacter asString. "MUSICAL SYMBOL G CLEF"
	json := String streamContents: [ :out |
		(NeoJSONWriter on: out) asciiOnly: true; nextPut: string ].
	self assert: json equals: '"\uD834\uDD1E"'
]

{ #category : #testing }
NeoJSONWriterTests >> testNull [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(NeoJSONWriter on: stream) nextPut: object ] ].
	self assert: (writer value: nil) equals: 'null'
]

{ #category : #tests }
NeoJSONWriterTests >> testPoint [

	| writer |
	writer := [ :object |
	          String streamContents: [ :stream |
		          (NeoJSONWriter on: stream) nextPut: object ] ].
	self
		should: [ writer value: (NeoJSONMockPoint x: 1 y: 2) ]
		raise: NeoJSONMappingNotFound
]

{ #category : #tests }
NeoJSONWriterTests >> testPoint1 [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(NeoJSONWriter on: stream) 
				for: NeoJSONMockPoint do: [ :mapping |
					mapping mapProperty: 'x' getter: [ :point | point x ] setter: [ :point :value | point x: value ].
					mapping mapProperty: 'y' getter: [ :point | point y ] setter: [ :point :value | point y: value ]. ];
				nextPut: object ] ].
	self assert: (writer value: (NeoJSONMockPoint x: 1 y: 2)) equals: '{"x":1,"y":2}'.
	self assert: (writer value: NeoJSONMockPoint new) equals: '{}'
]

{ #category : #tests }
NeoJSONWriterTests >> testPoint2 [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(NeoJSONWriter on: stream) 
				mapAllInstVarsFor: NeoJSONMockPoint;
				nextPut: object ] ].
	self assert: (writer value: (NeoJSONMockPoint x: 1 y: 2)) equals: '{"x":1,"y":2}'.
	self assert: (writer value: NeoJSONMockPoint new) equals: '{}'
]

{ #category : #tests }
NeoJSONWriterTests >> testPoint3 [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(NeoJSONWriter on: stream) 
				for: NeoJSONMockPoint do: [ :mapping |
					mapping mapInstVars: #(x y) ];
				nextPut: object ] ].
	self assert: (writer value: (NeoJSONMockPoint x: 1 y: 2)) equals: '{"x":1,"y":2}'.
	self assert: (writer value: NeoJSONMockPoint new) equals: '{}'
]

{ #category : #tests }
NeoJSONWriterTests >> testPointUsingAsString [
  | output |
  output := String
    streamContents: [ :out | 
      (NeoJSONWriter on: out)
        for: NeoJSONMockPoint
          do: [ :mapping | 
              (mapping
                mapProperty: #'x'
                getter: [ :object | object x ]
                setter: [ :object :value | object setX: value setY: object y ])
                valueSchema: #'AsString'.
              (mapping
                mapProperty: #'y'
                getter: [ :object | object y ]
                setter: [ :object :value | object setX: object x setY: value ])
                valueSchema: #'AsString' ];
        for: #'AsString'
          customDo: [ :mapping | 
              mapping
                encoder: [ :x | x asString ];
                decoder: [ :x | x asNumber ] ];
        nextPut: (NeoJSONMockPoint x: 1 y: 2) ].
  self
    assert: (output = '{"x":"1","y":"2"}' or: [ output = '{"y":"2","x":"1"}' ])
]

{ #category : #tests }
NeoJSONWriterTests >> testPointWriteNil [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(NeoJSONWriter on: stream) 
				writeNil: true;
				mapAllInstVarsFor: NeoJSONMockPoint;
				nextPut: object ] ].
	self assert: (writer value: (NeoJSONMockPoint x: 1 y: 2)) equals: '{"x":1,"y":2}'.
	self assert: (writer value: NeoJSONMockPoint new) equals: '{"x":null,"y":null}'
]

{ #category : #testing }
NeoJSONWriterTests >> testPreservePropertyOrder [
	| writer testObject |
	(testObject := NeoJSONTestObject2 new)
		id: 123;
		width: 100;
		height: 50;
		data: 'test'.
	writer := [ :object | 
		String streamContents: [ :stream |
			(NeoJSONWriter on: stream) 
				for: NeoJSONTestObject2 do: [ :mapping | mapping mapInstVars: #(id width height data) ];
				nextPut: object ] ].
	self assert: (writer value: testObject) equals: '{"id":123,"width":100,"height":50,"data":"test"}'.
	writer := [ :object | 
		String streamContents: [ :stream |
			(NeoJSONWriter on: stream) 
				for: NeoJSONTestObject2 do: [ :mapping | mapping mapInstVars: #(width height data id) ];
				nextPut: object ] ].
	self assert: (writer value: testObject) equals: '{"width":100,"height":50,"data":"test","id":123}'.
	writer := [ :object | 
		String streamContents: [ :stream |
			(NeoJSONWriter on: stream) 
				for: NeoJSONTestObject2 do: [ :mapping | mapping mapInstVars: #(data id height width) ];
				nextPut: object ] ].
	self assert: (writer value: testObject) equals: '{"data":"test","id":123,"height":50,"width":100}'.

]

{ #category : #testing }
NeoJSONWriterTests >> testStrings [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(NeoJSONWriter on: stream) nextPut: object ] ].
	self assert: (writer value: 'foo') equals: '"foo"'.
	self assert: (writer value: 'Foo BAR') equals: '"Foo BAR"'.
	self assert: (writer value: '') equals: '""'.
	self
		assert: (writer value: (String withAll: ( OrderedCollection new 
			add: $";
			add: $\; 
			add: $/;
			add: Character tab;
			add: Character cr;
			add: Character lf;
			add: Character newPage; 
			add: Character backspace;
			yourself )))
		equals: '"\"\\/\t\r\n\f\b"'



]

{ #category : #testing }
NeoJSONWriterTests >> testSymbol [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(NeoJSONWriter on: stream) nextPut: object ] ].
	self assert: (writer value: #foo) equals: '"foo"'.
	self assert: (writer value: #'FOO-1') equals: '"FOO-1"'

]

{ #category : #testing }
NeoJSONWriterTests >> testTime [

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
]
