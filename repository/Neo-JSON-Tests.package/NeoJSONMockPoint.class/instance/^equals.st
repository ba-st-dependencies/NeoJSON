comparing
= anObject

	^ self species = anObject species and: [
		  x = anObject x and: [ y = anObject y ] ]