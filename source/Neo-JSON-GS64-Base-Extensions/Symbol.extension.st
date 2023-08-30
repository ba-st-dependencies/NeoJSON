Extension { #name : #Symbol }

{ #category : #'*Neo-JSON-GS64-Base-Extensions' }
Symbol >> asMutator [

	(self notEmpty and: [ self last == $: ]) ifTrue: [ ^ self ].
	^ (self asString copyWith: $:) asSymbol
]

{ #category : #'*Neo-JSON-GS64-Base-Extensions' }
Symbol >> isUnary [

	^ self precedence = 1
]
