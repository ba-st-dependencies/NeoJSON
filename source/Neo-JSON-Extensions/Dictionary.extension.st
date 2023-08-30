Extension { #name : #Dictionary }

{ #category : #'*Neo-JSON-Extensions' }
Dictionary >> neoJsonOn: neoJSONWriter [
	neoJSONWriter writeMap: self
]
