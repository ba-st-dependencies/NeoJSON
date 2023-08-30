comparing
= anObject

	^ self species = anObject species and: [
		  origin = anObject origin and: [ corner = anObject corner ] ]