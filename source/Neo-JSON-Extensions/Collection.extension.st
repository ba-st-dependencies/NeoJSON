Extension { #name : #Collection }

{ #category : #'*Neo-JSON-Extensions' }
Collection >> neoJsonOn: neoJSONWriter [
	neoJSONWriter writeList: self
]
