*Neo-JSON-GS64-Base-Extensions
closeTo: num precision: aPrecision
 	"Tell whether the receiver and arguments are close from each."

	^ self = num asFloat or: [ (self - num) abs <= aPrecision ]