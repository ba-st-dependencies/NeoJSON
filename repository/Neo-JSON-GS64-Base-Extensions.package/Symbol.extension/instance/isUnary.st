*Neo-JSON-GS64-Base-Extensions
isUnary
	"Answer whether the receiver is an unary message selector."

	"#new isUnary >>> true"
	"#>> isUnary >>> false"
	"#between:and: isUnary >>> false"

	^ self precedence = 1