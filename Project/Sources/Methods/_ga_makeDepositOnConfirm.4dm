//%attributes = {}

// Purpose: Validate Make Deposit dialog and persist via _ga_makeDepositApply.
// created by 4D/PS [2026-june-22]

var $paymentUUIDs : Collection
var $line : Object
var $result : Object
var $memo : Text

_ga_makeDepositRecalc()

If (Form:C1466.totalSelected#Null:C1517) && (Form:C1466.totalSelected<=0)
	cs:C1710.sfw_dialog.me.alert("Select at least one payment to deposit.")
	return 
End if

$paymentUUIDs:=New collection:C1472()
For each ($line; Form:C1466.paymentLines)
	If ($line.include#Null:C1517) && ($line.include#0)
		If (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($line.UUID_Payment)))
			$paymentUUIDs.push($line.UUID_Payment)
		End if
	End if
End for each

$memo:=Form:C1466.memo
If ($memo=Null:C1517)
	$memo:=""
End if

If (Form:C1466.depositDate=Null:C1517) || (Form:C1466.depositDate=!00-00-00!)
	Form:C1466.depositDate:=Current date:C33(*)
End if

$result:=_ga_makeDepositApply($paymentUUIDs; Form:C1466.bankAccountUUID; $memo; Form:C1466.depositDate)

If ($result.success)
	Form:C1466.dialogResult:=$result
	ACCEPT:C269
Else
	If ($result.error="")
		$result.error:="Could not save deposit."
	End if
	cs:C1710.sfw_dialog.me.alert($result.error)
End if
