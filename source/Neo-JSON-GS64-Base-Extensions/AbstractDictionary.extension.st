Extension { #name : #AbstractDictionary }

{ #category : #'*Neo-JSON-GS64-Base-Extensions' }
AbstractDictionary >> neoJsonOn: neoJSONWriter [
	neoJSONWriter writeMap: self
]
