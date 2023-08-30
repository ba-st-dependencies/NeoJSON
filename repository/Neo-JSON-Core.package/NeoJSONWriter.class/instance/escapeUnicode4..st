private
escapeUnicode4: codePoint

	writeStream
		nextPutAll: '\u';
		nextPutAll: (codePoint asHexStringPaddedTo: 4)