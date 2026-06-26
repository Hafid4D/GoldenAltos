//%attributes = {}

// Purpose: Coerce a typed catalog field value to Text for deposit print/export output.
// Parameters: $value : Variant — raw field value (Text, Number, Date, Null, …)
// Returns: Text — empty string when null/undefined
// modified by 4D/PS [2026-june-23]
// created by 4D/PS [2026-june-23]

#DECLARE($value : Variant) -> $text : Text

$text:=""
If ($value=Null:C1517) || (Undefined:C82($value))
	return $text
End if
Case of
	: (Value type:C1509($value)=Is text:K8:3)
		$text:=$value
	: (Value type:C1509($value)=Is date:K8:7)
		If ($value#!00-00-00!)
			$text:=String:C10($value)
		End if
	: ((Value type:C1509($value)=Is real:K8:5) | (Value type:C1509($value)=Is longint:K8:6))
		$text:=String:C10($value)
	: (Value type:C1509($value)=Is object:K8:27)
		$text:=""
	: (Value type:C1509($value)=Is boolean:K8:9)
		$text:=Choose:C955($value; "True"; "False")
	: (Value type:C1509($value)=Is collection:K8:32)
		$text:=""
	Else
		// Purpose: Return empty for unsupported types instead of String() which may raise #54.
		// modified by 4D/PS [2026-june-23]
		$text:=""
End case

return $text
