"
I am NeoJSONObject.
I am an OrderedDictionary.

I behave more like a JavaScript object. I return nil for missing keys. I allow any property to be read or set by using a normal accessor message.

The following are equivalent:

	self foo.
	self at: #foo.

As are the following

	self foo: 1. 
	self at: #foo put: 1.
	
Except that in the first case, self is returned.

I can optionally be used by NeoJSONReader as mapClass (see #mapClass:).

For output, I act just like my superclass (it is thus not necessary to do any conversions).

Example:

	NeoJSONObject fromString: '{""foo"":1,""bar"":-2}'.
	NeoJSONObject new foo: 1; bar: -2.
	{ #x -> 100. #y -> 200 } as: NeoJSONObject.
	(NeoJSONObject new data: (NeoJSONObject new id: #sensor1; value: 37.5)) asString.

I use JSON as my printed representation. To convert me to JSON, use #printString or #asString.

Additionally, I support path access for nested instances of me, using #atPath: and #atPath:put:

The first is special because it returns nil as soon as a key is missing. The second is special because it creates extra levels (instances of me) as needed to follow the path of keys.

	NeoJSONObject new atPath: #(one two three) put: 42; yourself.
	NeoJSONObject new atPath: #(one two three) put: 42; atPath: #(one two three).

The fact that I am an OrderedDictionary means to I maintain the order of keys. This is meant as a convenience feature only as the official JSON specification clearly states ""An object is an unordered set of name/value pairs"".
I work together with NeoJSONArray.
"
Class {
	#name : 'NeoJSONObject',
	#superclass : 'OrderedDictionary',
	#category : 'Neo-JSON-Core',
	#package : 'Neo-JSON-Core'
}

{ #category : 'convenience' }
NeoJSONObject class >> fromStream: readStream [
	"Parse stream as JSON, so that maps become instances of me and lists instances of NeoJSONArray"

	^ (NeoJSONReader on: readStream)
			mapClass: self;
			listClass: NeoJSONArray;
			propertyNamesAsSymbols: true;
			next
]

{ #category : 'convenience' }
NeoJSONObject class >> fromString: string [
	"Parse string as JSON, so that maps become instances of me and lists instances of NeoJSONArray"

	^ self fromStream: string readStream
]

{ #category : 'convenience' }
NeoJSONObject class >> readFrom: readStream [
	"Parse stream as JSON, so that maps become instances of me and lists instances of NeoJSONArray"

	^ self fromStream: readStream
]

{ #category : 'accessing' }
NeoJSONObject >> at: key [
	"I return nil for missing keys.
	My superclass would signal a KeyNotFound."

	^ self at: key ifAbsent: [ nil ]
]

{ #category : 'add' }
NeoJSONObject >> at: key add: object [
	^ self at: key put: object
]

{ #category : 'nested dictionaries' }
NeoJSONObject >> at: firstKey at: secondKey [
	"I return nil for missing keys.
	My superclass would signal a KeyNotFound."

	^ self atPath: { firstKey. secondKey }
]

{ #category : 'nested dictionaries' }
NeoJSONObject >> at: firstKey at: secondKey put: value [
	"Store value under secondKey in nested object under firstKey, create new level when needed"

	^ self atPath: { firstKey. secondKey } put: value
]

{ #category : 'accessing' }
NeoJSONObject >> at: key ifPresent: aPresentBlock ifAbsentPut: anAbsentBlock [
	"Lookup the given key in the receiver. If it is present, answer the
	value of evaluating the first block optionally with the value associated with the key.
	Otherwise store and return the result of evaluating the second block as the new value of the key."

	"Overwritten to patch a bug in the superclass implementation in Pharo 7 and 8.
	This problem was fixed in Pharo 9 where this overwrite is no longer necessary but harmless."

	^ self
		at: key
		ifPresent: aPresentBlock
		ifAbsent: [ self at: key put: anAbsentBlock value ]
]

{ #category : 'accessing' }
NeoJSONObject >> atPath: keyCollection [
	"Use each key in keyCollection recursively, return nil when a key is missing.
	Note how keys can also be indexes to arrays."

	| value |
	value := self.
	keyCollection do: [ :each |
		value := value at: each ifAbsent: [ ^ nil ] ].
	^ value
]

{ #category : 'accessing' }
NeoJSONObject >> atPath: keyCollection add: newValue [
	"Use each key in keyCollection recursively, create new levels when needed.
	Note how keys can also be indexes to arrays.
	This variant will insert/add to arrays."

	| target |
	keyCollection ifEmpty: [ ^ self ].
	target := self.
	keyCollection allButLastDo: [ :each |
		target := target 
			at: each
			ifAbsent: [ target at: each add: target species new ] ].
	^ target at: keyCollection last add: newValue
]

{ #category : 'accessing' }
NeoJSONObject >> atPath: keyCollection put: newValue [
	"Use each key in keyCollection recursively, create new levels when needed.
	Note how keys can also be indexes to arrays."

	| target |
	keyCollection ifEmpty: [ ^ self ].
	target := self.
	keyCollection allButLastDo: [ :each |
		target := target 
			at: each
			ifAbsent: [ target at: each put: target species new ] ].
	^ target at: keyCollection last put: newValue
]

{ #category : 'reflective operations' }
NeoJSONObject >> doesNotUnderstand: message [
	"Overwritten so that 'self foo' becomes 'self at: #foo'
	and 'self foo: 1' becomes 'self at: #foo put: 1' except that self is returned"

	| key |
	key := message selector.
	key isUnary
		ifTrue: [ ^ self at: key ].
	^ (key isKeyword and: [ key numArgs = 1 ])
		ifTrue: [ self at: key allButLast asSymbol put: message arguments first; yourself ]
		ifFalse: [ super doesNotUnderstand: message ]
]

{ #category : 'accessing' }
NeoJSONObject >> findPath: conditionBlock [
	"Find and return the first path to an object in the graph that I represent 
	for which conditionBlock holds. Return nil when not found."

	(conditionBlock value: self) ifTrue: [ ^ #(()) ].
	self keysAndValuesDo: [ :key :value |
		(conditionBlock value: value) ifTrue: [ ^ { key } ].
		(value isCollection and: [ value isString not ]) ifTrue: [
			(value findPath: conditionBlock) ifNotNil: [ :subPath |
				^ { key } , subPath ] ] ].
	^ nil
]

{ #category : 'accessing' }
NeoJSONObject >> findPaths: conditionBlock [
	"Find and return all paths to objects in the graph that I represent 
	for which conditionBlock holds. Return an empty collection when none are found."

	| found |
	found := OrderedCollection new.
	self keysAndValuesDo: [ :key :value |
		(conditionBlock value: value) ifTrue: [ found add: { key } ].
		(value isCollection and: [ value isString not ]) ifTrue: [
			(value findPaths: conditionBlock) do: [ :subPath |
				found add: { key } , subPath ] ] ].
	^ found
]

{ #category : 'accessing' }
NeoJSONObject >> name [
	"Overwritten to make this accessor available as key"

	^ self at: #name
]

{ #category : 'printing' }
NeoJSONObject >> printOn: stream [
	"I use my JSON representation when printing myself"

	[ (NeoJSONWriter on: stream) nextPut: self ]
		on: Error
		do: [ :exception |
			stream
				nextPutAll: ' Error printing JSON: ';
				print: exception ]
]

{ #category : 'accessing' }
NeoJSONObject >> removeAtPath: keyCollection [
	"Use each key in keyCollection recursively and remove the final key.
	Note how keys can also be indexes to arrays."

	| target |
	keyCollection ifEmpty: [ ^ self ].
	target := self.
	keyCollection allButLastDo: [ :each |
		target := target at: each ifAbsent: [ ^ self ] ].
	^ target removeKey: keyCollection last
]

{ #category : 'evaluating' }
NeoJSONObject >> value [
	"Overwritten to make this accessor available as key"

	^ self at: #value
]
