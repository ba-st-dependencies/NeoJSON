*Neo-JSON-GS64-Base-Extensions
allButLastDo: block

	1 to: self size - 1 do:
		[:index | block value: (self at: index)]