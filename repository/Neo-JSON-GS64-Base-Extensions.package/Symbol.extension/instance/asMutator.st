*Neo-JSON-GS64-Base-Extensions
asMutator

	(self notEmpty and: [ self last == $: ]) ifTrue: [ ^ self ].
	^ (self asString copyWith: $:) asSymbol