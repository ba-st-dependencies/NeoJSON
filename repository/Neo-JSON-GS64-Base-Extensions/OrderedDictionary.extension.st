Extension { #name : #OrderedDictionary }

{ #category : #'*Neo-JSON-GS64-Base-Extensions' }
OrderedDictionary >> neoJsonOn: neoJSONWriter [
	neoJSONWriter writeMap: self
]
