Class {
	#name : #NeoJSONMockRectangle,
	#superclass : #Object,
	#instVars : [
		'origin',
		'corner'
	],
	#category : 'Neo-JSON-Tests'
}

{ #category : #'instance creation' }
NeoJSONMockRectangle class >> origin: aPoint extent: anotherPoint [

	^ self new initializeOrigin: aPoint extent: anotherPoint
]

{ #category : #comparing }
NeoJSONMockRectangle >> = anObject [

	^ self species = anObject species and: [
		  origin = anObject origin and: [ corner = anObject corner ] ]
]

{ #category : #accessing }
NeoJSONMockRectangle >> corner [
	^ corner
]

{ #category : #comparing }
NeoJSONMockRectangle >> hash [

	^ origin hash bitXor: corner hash
]

{ #category : #initialization }
NeoJSONMockRectangle >> initializeOrigin: aPoint extent: anotherPoint [

	origin := aPoint.
	corner := anotherPoint
]

{ #category : #accessing }
NeoJSONMockRectangle >> origin [
	^ origin
]
