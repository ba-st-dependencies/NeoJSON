Class {
	#name : #NeoJSONMockPoint,
	#superclass : #Object,
	#instVars : [
		'x',
		'y'
	],
	#category : 'Neo-JSON-Tests'
}

{ #category : #'instance creation' }
NeoJSONMockPoint class >> x: xValue y: yValue [

	^ self new
		  setX: xValue setY: yValue;
		  yourself
]

{ #category : #comparing }
NeoJSONMockPoint >> = anObject [

	^ self species = anObject species and: [
		  x = anObject x and: [ y = anObject y ] ]
]

{ #category : #comparing }
NeoJSONMockPoint >> hash [

	^ x hash bitXor: y hash
]

{ #category : #initialization }
NeoJSONMockPoint >> setX: xValue setY: yValue [

	x := xValue.
	y := yValue
]

{ #category : #accessing }
NeoJSONMockPoint >> x [

	^ x
]

{ #category : #accessing }
NeoJSONMockPoint >> y [

	^ y
]
