Extension { #name : #Time }

{ #category : #'*Neo-JSON-GS64-Base-Extensions' }
Time >> printHHMMSS [

	^ self asStringUsingFormat: #($: true false)
]
