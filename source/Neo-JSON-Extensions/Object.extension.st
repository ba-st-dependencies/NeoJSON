Extension { #name : #Object }

{ #category : #'*Neo-JSON-Extensions' }
Object >> neoJsonOn: neoJSONWriter [
	neoJSONWriter writeObject: self
]
