testing
testAsciiOnlyStrings

	| objects |
	objects := { 'foo'. 'Foo BAR'. ''. '	\\'''. 'élève en Français' }.
	self assert: (self writeReadAsciiOnly: objects) equals: objects