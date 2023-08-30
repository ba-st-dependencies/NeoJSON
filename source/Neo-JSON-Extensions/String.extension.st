Extension { #name : #String }

{ #category : #'*Neo-JSON-Extensions' }
String >> neoJsonOn: neoJSONWriter [
	neoJSONWriter writeString: self
]
