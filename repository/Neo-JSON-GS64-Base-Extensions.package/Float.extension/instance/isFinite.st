*Neo-JSON-GS64-Base-Extensions
isFinite
	"simple, byte-order independent test for rejecting Not-a-Number and (Negative)Infinity"

	^(self - self) = 0.0