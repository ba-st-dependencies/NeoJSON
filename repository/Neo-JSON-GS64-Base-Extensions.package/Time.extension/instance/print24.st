*Neo-JSON-GS64-Base-Extensions
print24

	^ String
		  new: 8
		  streamContents: [ :aStream | self print24: true on: aStream ]