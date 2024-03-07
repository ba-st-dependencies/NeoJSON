Extension { #name : #Number }

{ #category : #'*Neo-JSON-Extensions' }
Number >> neoJsonOn: neoJSONWriter [
	neoJSONWriter writeFloat: self asFloat
]
