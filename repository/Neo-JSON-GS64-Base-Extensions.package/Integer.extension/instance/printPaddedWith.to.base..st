*Neo-JSON-GS64-Base-Extensions
printPaddedWith: aCharacter to: anInteger base: aRadix

	(aCharacter = $0 and: [ aRadix = 16 ]) ifFalse: [
		Error signal: 'Unsupported padding parameters' ].
	^ (self asHexStringWithLength: anInteger) asUppercase