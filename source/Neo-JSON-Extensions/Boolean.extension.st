Extension { #name : #Boolean }

{ #category : #'*Neo-JSON-Extensions' }
Boolean >> neoJsonOn: neoJSONWriter [
	neoJSONWriter writeBoolean: self
]
