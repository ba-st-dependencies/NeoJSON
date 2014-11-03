parsing
readFrom: jsonReader
	| anObject |
	anObject := subjectClass new.
	jsonReader parseMapKeysDo: [ :key |
		(self propertyNamed: key ifAbsent: [self propertyNamed: key asSymbol ifAbsent:[nil] ])
			ifNil: [
				"read, skip & ignore value"
				jsonReader next ]
			ifNotNil: [ :mapping |
				mapping readObject: anObject from: jsonReader ] ].
	^ anObject