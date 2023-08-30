Extension { #name : #CharacterCollection }

{ #category : #'*Neo-JSON-GS64-Base-Extensions' }
CharacterCollection >> neoJsonOn: neoJSONWriter [
	neoJSONWriter writeString: self
]
