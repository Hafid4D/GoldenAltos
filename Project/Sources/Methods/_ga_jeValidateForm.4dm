//%attributes = {}

// Purpose: Validate journal panel state before SFW create (manual adjusting entries only).
// Returns: Object — { valid : Boolean, error : Text }
// created by 4D/PS [2026-june-29]

-> $result : Object

var $line : Object
var $hasLine : Boolean

$result:=New object:C1471("valid"; True:C214; "error"; "")

If (Form:C1466.situation.mode#"add")
	$result.valid:=False:C215
	$result.error:="Journal entries cannot be modified after they are saved."
	return $result
End if

If (Form:C1466.current_item=Null:C1517)
	$result.valid:=False:C215
	$result.error:="No journal entry to save."
	return $result
End if

$hasLine:=False:C215
If (Form:C1466.journalEntryLines#Null:C1517)
	For each ($line; Form:C1466.journalEntryLines)
		If (Num:C11($line.debitAmount)>0) || (Num:C11($line.creditAmount)>0)
			$hasLine:=True:C214
		End if
	End for each
End if

If (Not:C34($hasLine))
	$result.valid:=False:C215
	$result.error:="Add at least one journal line with an amount."
	return $result
End if

_ga_jeRecalcTotals()
If (Abs:C99(Form:C1466.journalTotalDebit-Form:C1466.journalTotalCredit)>0.005)
	$result.valid:=False:C215
	$result.error:="Total debits must equal total credits."
	return $result
End if

If (Form:C1466.journalTotalDebit<=0)
	$result.valid:=False:C215
	$result.error:="Journal entry total must be greater than zero."
	return $result
End if
