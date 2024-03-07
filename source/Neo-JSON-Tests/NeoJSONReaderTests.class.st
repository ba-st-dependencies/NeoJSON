"
I am NeoJSONReaderTests, a test suite for NeoJSONReader.
"
Class {
	#name : #NeoJSONReaderTests,
	#superclass : #TestCase,
	#category : 'Neo-JSON-Tests'
}

{ #category : #tests }
NeoJSONReaderTests >> testAllowNil [
	self 
		should: [ 
			(NeoJSONReader on: 'null' readStream)
				mapInstVarsFor: NeoJSONMockPoint;
				nextAs: NeoJSONMockPoint ] 
		raise: NeoJSONParseError.
	self
		assert: ((NeoJSONReader on: 'null' readStream)
						mapInstVarsFor: NeoJSONMockPoint;
						for: NeoJSONMockPoint do: [ :mapping | mapping allowNil ];
						nextAs: NeoJSONMockPoint)
		equals: nil.
	self
		assert: ((NeoJSONReader on: '[ { "x" : 1, "y" : 2 }, null, { "x" : 3, "y" : -1 } ]' readStream)
						mapInstVarsFor: NeoJSONMockPoint;
						for: NeoJSONMockPoint do: [ :mapping | mapping allowNil ];
						for: #ArrayOfPoints customDo: [ :mapping | mapping listOfElementSchema: NeoJSONMockPoint ];
						nextAs: #ArrayOfPoints)
		equals: (Array with: (NeoJSONMockPoint x: 1 y: 2) with: nil with: (NeoJSONMockPoint x: 3 y: -1)).
]

{ #category : #tests }
NeoJSONReaderTests >> testArrayOfPoints [

	| reader |
	reader := [ :string |
	          (NeoJSONReader on: string readStream)
		          for: NeoJSONMockPoint
		          do: [ :mapping | mapping mapInstVars: #( x y ) ];
		          for: #ArrayOfPoints
		          customDo: [ :mapping |
			          mapping listOfElementSchema: NeoJSONMockPoint ];
		          nextAs: #ArrayOfPoints ].
	self
		assert: (reader value: '[ { "x":1, "y":2 }, { "x":-1, "y":-2 } ]')
		equals: {
				(NeoJSONMockPoint x: 1 y: 2).
				(NeoJSONMockPoint x: -1 y: -2) }.
	self assert: (reader value: '[ ]') equals: #(  ).
	self
		assert: (reader value: '[ { } ]')
		equals: { NeoJSONMockPoint new }
]

{ #category : #tests }
NeoJSONReaderTests >> testArrayOfPointsUsingNextListAs [
	| reader |
	reader := [ :string | 
		(NeoJSONReader on: string readStream) 
			mapInstVarsFor: NeoJSONMockPoint;
			nextListAs: NeoJSONMockPoint ].
	self assert: (reader value: '[ { "x":1, "y":2 }, { "y":-2, "x":-1 } ]') equals: (Array with: (NeoJSONMockPoint x: 1 y: 2) with: (NeoJSONMockPoint x: -1 y: -2)) . 
	self assert: (reader value: '[ ]') equals: #().
	self assert: (reader value: '[ { } ]') equals: (Array with: NeoJSONMockPoint new) 
]

{ #category : #testing }
NeoJSONReaderTests >> testAssociation [
	| reader |
	reader := [ :string | 
		(NeoJSONReader on: string readStream) 
			for: Association do: [ :mapping |
				mapping mapAccessors: #(key value) ]; 
			nextAs: Association ].
	self assert: (reader value: '{"key":"foo","value":42}') equals: 'foo' -> 42. 
	self assert: (reader value: '{}') equals: Association new
]

{ #category : #testing }
NeoJSONReaderTests >> testBooleans [
	self assert: (NeoJSONReader on: 'true' readStream) next equals: true.
	self assert: (NeoJSONReader on: 'false' readStream) next equals: false.
	self should: [ (NeoJSONReader on: 'tru' readStream) next ] raise: NeoJSONParseError.
	self should: [ (NeoJSONReader on: 'falsE' readStream) next ] raise: NeoJSONParseError.
]

{ #category : #testing }
NeoJSONReaderTests >> testByteArray [
	| reader |
	reader := [ :string | 
		(NeoJSONReader on: string readStream) 
			for: ByteArray customDo: [ :mapping |
				mapping listOfType: ByteArray ];
			nextAs: ByteArray ].
	self assert: (reader value: '[ 1, 2, 3 ]') equals: #[1 2 3].
	self assert: (reader value: '[ ]') equals: ByteArray new
]

{ #category : #testing }
NeoJSONReaderTests >> testDate [

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
]

{ #category : #testing }
NeoJSONReaderTests >> testDateAndTime [ 
	| reader |
	reader := [ :input | 
		(NeoJSONReader on: input readStream) 
			for: DateAndTime customDo: [ :mapping |
				mapping decoder: [ :string | DateAndTime fromString: string ] ];
			nextAs: DateAndTime ].
	self 
		assert: (reader value: ' "2012-02-14T16:40:18+01:00" ') 
		equals: (DateAndTime year: 2012 month: 2 day: 14 hour: 16 minute: 40 second: 18 offset: (Duration days: 0 hours: 1 minutes: 0 seconds: 0))
]

{ #category : #testing }
NeoJSONReaderTests >> testFloats [
	| reader |
	reader := [ :string |
		(NeoJSONReader on: string readStream) next ].
	self assert: ((reader value: '123.0') closeTo: 123.0).
	self assert: ((reader value: '-123.0') closeTo: -123.0).
	self assert: ((reader value: '123.0e0') closeTo: 123.0).
	self assert: ((reader value: '123e6') closeTo: 123e6).
	self assert: ((reader value: '123e+6') closeTo: 123e6).
	self assert: ((reader value: '123e-6') closeTo: 123e-6).
	self assert: ((reader value: '123E6') closeTo: 123e6).
	self assert: ((reader value: '123E+6') closeTo: 123e6).
	self assert: ((reader value: '123E-6') closeTo: 123e-6).
	self assert: ((reader value: '-123e6') closeTo: -123e6).
	self assert: ((reader value: '-123e-6') closeTo: -123e-6).
	self assert: ((reader value: '-123E6') closeTo: -123e6).
	self assert: ((reader value: '-123E-6') closeTo: -123e-6).
	self assert: ((reader value: '3.14159') closeTo: Float pi).
	self assert: ((reader value: '0.123e6') closeTo: 0.123e6).
	self assert: ((reader value: '0.123e-6') closeTo: 0.123e-6).
	self assert: ((reader value: '-0.123E6') closeTo: -0.123e6).
	self assert: ((reader value: '-0.123E-6') closeTo: -0.123e-6).

]

{ #category : #testing }
NeoJSONReaderTests >> testIntegers [
	| reader |
	reader := [ :string |
		(NeoJSONReader on: string readStream) next ].
	self assert: (reader value: '123') equals: 123.
	self assert: (reader value: '00123') equals: 123.
	self assert: (reader value: '-123') equals: -123.
	self assert: (reader value: '-0123') equals: -123.
	self assert: (reader value: '0') equals: 0.
	self assert: (reader value: '-0') equals: 0.
	self assert: (reader value: '00') equals: 0.
	self assert: (reader value: ' 123	') equals: 123.
	self should: [ reader value: '+1' ] raise: NeoJSONParseError.
	self should: [ reader value: ' - ' ] raise: NeoJSONParseError.

]

{ #category : #testing }
NeoJSONReaderTests >> testLists [
	| reader |
	reader := [ :string |
		(NeoJSONReader on: string readStream) next ].
	self assert: (reader value: '[1,2,3]') equals: #(1 2 3).
	self assert: (reader value: '[]') equals: #().
	self assert: (reader value: ' [ 1 , 2 , 3 ] ') equals: #(1 2 3).
	self assert: (reader value: ' [ ] ') equals: #().
	self should: [ reader value: '[1,]' ] raise: NeoJSONParseError. 
	self should: [ reader value: '[' ] raise: NeoJSONParseError.
	self should: [ reader value: ']' ] raise: NeoJSONParseError.
	self should: [ reader value: '[}' ] raise: NeoJSONParseError
]

{ #category : #testing }
NeoJSONReaderTests >> testMaps [
	| reader |
	reader := [ :string |
		(NeoJSONReader on: string readStream) next ].
	self assert: (reader value: '{"x":1,"y":2}') equals: (Dictionary newFromPairs: #( 'x' 1 'y' 2)).
	self assert: (reader value: '{}') equals: Dictionary new.
	self assert: (reader value: ' { "x" : 1 , "y" : 2 } ' ) equals: (Dictionary newFromPairs: #( 'x' 1 'y' 2)).
	self assert: (reader value: ' { } ') equals: Dictionary new.
	self should: [ reader value: '{"foo":}' ] raise: NeoJSONParseError. 
	self should: [ reader value: '{"foo":9,}' ] raise: NeoJSONParseError. 
	self should: [ reader value: '{9:true,}' ] raise: NeoJSONParseError. 
	self should: [ reader value: '{' ] raise: NeoJSONParseError.
	self should: [ reader value: '}' ] raise: NeoJSONParseError.
	self should: [ reader value: '{]' ] raise: NeoJSONParseError
]

{ #category : #testing }
NeoJSONReaderTests >> testNextStringAsHex [
	| string |
	string := (NeoJSONReader on: '"466F6F2062617221"' readStream)
		for: #StringAsHex
			customDo: [ :mapping | 
					mapping
						encoder: [ :x | x asByteArray asHexString asUppercase ];
						decoder: [ :x | (ByteArray readHexFrom: x) utf8Decoded ] ];
		nextAs: #StringAsHex.
	self assert: string equals: 'Foo bar!'
]

{ #category : #testing }
NeoJSONReaderTests >> testNonBMPCharacterDecoding [
	"Characters not in the Basic Multilingual Plane are encoded as a UTF-16 surrogate pair"

	| string object |
	string := 16r1D11E asCharacter asString. "MUSICAL SYMBOL G CLEF"
	object := (NeoJSONReader fromString: '"\uD834\uDD1E"').
	self assert: object equals: string.
	
	"UTF-16 surrogate pairs might be invalid, make sure an error is raised"
	self should: [ NeoJSONReader fromString: '"\udbff\ue000"' ] raise: NeoJSONParseError
]

{ #category : #testing }
NeoJSONReaderTests >> testNull [
	self assert: (NeoJSONReader on: 'null' readStream) next equals: nil.
	self assert: (NeoJSONReader on: '	null ' readStream) next equals: nil.
	self should: [ (NeoJSONReader on: '	nil ' readStream) next ] raise: NeoJSONParseError.
]

{ #category : #testing }
NeoJSONReaderTests >> testOrderedCollection [
	| json list |
	json := '[ 1, 2, 3 ]'.
	list := (NeoJSONReader on: json readStream) 
		listClass: OrderedCollection;
		next.
	self 
		assert: list 
		equals: (OrderedCollection with: 1 with: 2 with: 3).
	self 
		assert: list class 
		equals: OrderedCollection
]

{ #category : #tests }
NeoJSONReaderTests >> testOrderedCollectionOfPoints [

	| reader |
	reader := [ :string |
	          (NeoJSONReader on: string readStream)
		          for: NeoJSONMockPoint
		          do: [ :mapping | mapping mapInstVars: #( x y ) ];
		          for: #OrderedCollectionOfPoints customDo: [ :mapping |
			          mapping
				          listOfType: OrderedCollection
				          andElementSchema: NeoJSONMockPoint ];
		          nextAs: #OrderedCollectionOfPoints ].
	self
		assert: (reader value: '[ { "x":1, "y":2 }, { "x":-1, "y":-2 } ]')
		equals: {
				(NeoJSONMockPoint x: 1 y: 2).
				(NeoJSONMockPoint x: -1 y: -2) } asOrderedCollection.
	self assert: (reader value: '[ ]') equals: OrderedCollection new.
	self
		assert: (reader value: '[ { } ]')
		equals: (OrderedCollection with: NeoJSONMockPoint new)
]

{ #category : #testing }
NeoJSONReaderTests >> testParseErrors [
	self should: [ NeoJSONReader fromString: 'zero' ] raise: NeoJSONParseError.
	self should: [ NeoJSONReader fromString: '#' ] raise: NeoJSONParseError.
	self should: [ NeoJSONReader fromString: '@' ] raise: NeoJSONParseError.
	
	self should: [ (NeoJSONReader on: '[1,2,3]true' readStream) next; failIfNotAtEnd ] raise: NeoJSONParseError.
	self should: [ (NeoJSONReader on: '{"foo":1}"extra"' readStream) next; failIfNotAtEnd ] raise: NeoJSONParseError.
	self should: [ (NeoJSONReader on: '[]"extra"' readStream) next; failIfNotAtEnd ] raise: NeoJSONParseError.
]

{ #category : #tests }
NeoJSONReaderTests >> testPoint [
	| reader |
	reader := [ :string | 
		(NeoJSONReader on: string readStream) nextAs: NeoJSONMockPoint ].
	self should: [ reader value: '{"x":1,"y":2}' ] raise: NeoJSONMappingNotFound
]

{ #category : #tests }
NeoJSONReaderTests >> testPoint1 [

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
]

{ #category : #tests }
NeoJSONReaderTests >> testPoint2 [
	| reader |
	reader := [ :string | 
		(NeoJSONReader on: string readStream) 
			mapAllInstVarsFor: NeoJSONMockPoint;
			nextAs: NeoJSONMockPoint ].
	self assert: (reader value: '{"x":1,"y":2}') equals: (NeoJSONMockPoint x: 1 y: 2). 
	self assert: (reader value: '{}') equals: NeoJSONMockPoint new
]

{ #category : #tests }
NeoJSONReaderTests >> testPoint3 [
	| reader |
	reader := [ :string | 
		(NeoJSONReader on: string readStream) 
			for: NeoJSONMockPoint do: [ :mapping |
				mapping mapInstVars: #(x y) ];
			nextAs: NeoJSONMockPoint ].
	self assert: (reader value: '{"x":1,"y":2}') equals: (NeoJSONMockPoint x: 1 y: 2). 
	self assert: (reader value: '{}') equals: NeoJSONMockPoint new
]

{ #category : #tests }
NeoJSONReaderTests >> testPointUsingAsString [
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
]

{ #category : #testing }
NeoJSONReaderTests >> testPropertyNamesAsSymbols [
	| json map |
	json := '{ "x" : true, "y" : false, "key-1" : 1 }'.
	map := (NeoJSONReader on: json readStream) 
		propertyNamesAsSymbols: true; 
		next.
	self 
		assert: map 
		equals: (Dictionary new at: #x put: true; at: #y put: false; at: #'key-1' put: 1; yourself).
	self assert: (map keys allSatisfy: [ :each | each isSymbol ])
]

{ #category : #testing }
NeoJSONReaderTests >> testSmallDictionary [

	| json map smallDictionaryClass |
	json := '{ "x" : true, "y" : false, "key-1" : 1 }'.
	smallDictionaryClass := LanguagePlatform current
		                        globalNamed: #SmallDictionary
		                        ifAbsent: [ Dictionary ].
	map := (NeoJSONReader on: json readStream)
		       mapClass: smallDictionaryClass;
		       next.
	self assert: map equals: (smallDictionaryClass new
			 at: 'x' put: true;
			 at: 'y' put: false;
			 at: 'key-1' put: 1;
			 yourself).
	self assert: map class equals: smallDictionaryClass
]

{ #category : #testing }
NeoJSONReaderTests >> testStrings [
	| reader |
	reader := [ :string |
		(NeoJSONReader on: string readStream) next ].
	self assert: (reader value: '"foo"') equals: 'foo'.
	self assert: (reader value: '""') equals: ''.
	self assert: (reader value: '"Foo BAR"') equals: 'Foo BAR'.
	self assert: (reader value: '" foo "') equals: ' foo '.
	self assert: (reader value: '"\u00E9l\u00E8ve en Fran\u00E7ais"') equals: 'élève en Français'.
	self 
		assert: (reader value: '"\"\\\/\t\r\n\f\b"') 
		equals: (String withAll: ( OrderedCollection new 
			add: $";
			add: $\; 
			add: $/;
			add: Character tab;
			add: Character cr;
			add: Character lf;
			add: Character newPage; 
			add: Character backspace;
			yourself )).
	self should: [ reader value: '"open' ] raise: NeoJSONParseError.
	self should: [ reader value: '"\uAA"' ] raise: NeoJSONParseError.
	self should: [ reader value: '"\uZZ"' ] raise: NeoJSONParseError.
	self should: [ reader value: '"\x"' ] raise: NeoJSONParseError.
	self should: [ reader value: ' " ' ] raise: NeoJSONParseError.

]

{ #category : #testing }
NeoJSONReaderTests >> testSymbol [
	| reader |
	reader := [ :input | 
		(NeoJSONReader on: input readStream) 
			for: Symbol customDo: [ :mapping |
				mapping decoder: [ :string | string asSymbol ] ];
			nextAs: Symbol ].
	self assert: (reader value: ' "foo" ') equals: #foo.
	self assert: (reader value: ' "FOO-1" ') equals: #'FOO-1'
]

{ #category : #testing }
NeoJSONReaderTests >> testTime [

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
]
