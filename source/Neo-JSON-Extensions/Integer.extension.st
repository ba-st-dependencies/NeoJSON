Extension { #name : #Integer }

{ #category : #'*Neo-JSON-Extensions' }
Integer >> neoJsonOn: neoJSONWriter [
	neoJSONWriter writeInteger: self
]
