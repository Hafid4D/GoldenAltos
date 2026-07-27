//%attributes = {}

// Purpose: Convert a legacy deposit JSON date value to a 4D Date (ISO text, Date, or numeric day offset).
// Parameters: $value : Variant — legacy DepositDate / Deposit_Date field
// Returns: Date — !00-00-00! when conversion fails
// created by 4D/PS [2026-june-29]

#DECLARE($value : Variant) -> $date : Date

$date:=!00-00-00!
If ($value=Null:C1517) || (Undefined:C82($value))
	return $date
End if
Case of
	: (Value type:C1509($value)=Is date:K8:7)
		$date:=$value
	: (Value type:C1509($value)=Is text:K8:3)
		If ($value#"")
			If (Position:C15("T"; $value)>0)
				$value:=Substring:C12($value; 1; 10)
			End if
			$date:=Date:C102($value)
		End if
	: ((Value type:C1509($value)=Is real:K8:5) | (Value type:C1509($value)=Is longint:K8:6))
		If (Num:C11($value)#0)
			$date:=!00-00-00!+Num:C11($value)
		End if
End case

return $date
