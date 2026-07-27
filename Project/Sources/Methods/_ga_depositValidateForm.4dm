//%attributes = {}

// Purpose: Validate deposit panel state before SFW create (called from Deposit_beforeSave).
// Returns: Object — { valid : Boolean, error : Text }
// created by 4D/PS [2026-june-22]

-> $result : Object

var $line : Object
var $hasPayment : Boolean
var $hasOtherFund : Boolean

$result:=New object:C1471("valid"; True:C214; "error"; "")

If (Form:C1466.situation.mode#"add")
	$result.valid:=False:C215
	$result.error:="Deposits cannot be modified after they are saved."
	return $result
End if

If (Form:C1466.current_item=Null:C1517)
	$result.valid:=False:C215
	$result.error:="No deposit to save."
	return $result
End if

If (cs:C1710.sfw_string.me.isAnEmptyUUID(Form:C1466.current_item.UUID_CAO_bank))
	$result.valid:=False:C215
	$result.error:="Select a bank account for the deposit."
	return $result
End if

// Purpose: Reject non-Bank CAO accounts on the deposit header (mockup — bank accounts live in CAO type Bank).
// modified by 4D/PS [2026-june-29]
If (Not:C34(ds:C1482.CAO.get(String:C10(Form:C1466.current_item.UUID_CAO_bank)).isBankType()))
	$result.valid:=False:C215
	$result.error:="The selected account is not a bank account. Choose a CAO account of type Bank."
	return $result
End if

$hasPayment:=False:C215
If (Form:C1466.depositPaymentLines#Null:C1517)
	For each ($line; Form:C1466.depositPaymentLines)
		If ($line.include#Null:C1517) && ($line.include#0)
			$hasPayment:=True:C214
		End if
	End for each
End if

$hasOtherFund:=False:C215
If (Form:C1466.depositOtherFundLines#Null:C1517)
	For each ($line; Form:C1466.depositOtherFundLines)
		If ($line.amount#Null:C1517) && ($line.amount>0)
			$hasOtherFund:=True:C214
		End if
	End for each
End if

If (Not:C34($hasPayment)) && (Not:C34($hasOtherFund))
	$result.valid:=False:C215
	$result.error:="Select at least one payment or add an other-funds line."
	return $result
End if

If (Form:C1466.current_item.cashBackAmount>0) && (cs:C1710.sfw_string.me.isAnEmptyUUID(String:C10(Form:C1466.current_item.UUID_CAO_cashBack)))
	$result.valid:=False:C215
	$result.error:="Select an account for cash back."
	return $result
End if

_ga_depositRecalcTotals()
If (Form:C1466.depositGrandTotal#Null:C1517) && (Form:C1466.current_item.cashBackAmount>Form:C1466.depositGrandTotal)
	$result.valid:=False:C215
	$result.error:="Cash back amount cannot exceed the deposit total."
	return $result
End if
