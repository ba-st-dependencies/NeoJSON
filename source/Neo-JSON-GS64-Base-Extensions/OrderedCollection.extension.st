Extension { #name : #OrderedCollection }

{ #category : #'*Neo-JSON-GS64-Base-Extensions' }
OrderedCollection >> insert: object before: index [
	^ self add: object beforeIndex: index

]

{ #category : #'*Neo-JSON-GS64-Base-Extensions' }
OrderedCollection >> removeAt: index [

  ^ self removeAtIndex: index

]
