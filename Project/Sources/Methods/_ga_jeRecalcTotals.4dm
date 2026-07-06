//%attributes = {}

// Purpose: Recalculate journal line totals on Form from journalEntryLines collection.
// Returns: nothing (updates Form.journalTotalDebit / Form.journalTotalCredit)
// created by 4D/PS [2026-june-29]

var $line : Object
var $totalDebit : Real
var $totalCredit : Real

$totalDebit:=0
$totalCredit:=0

If (Form:C1466.journalEntryLines#Null:C1517)
	For each ($line; Form:C1466.journalEntryLines)
		If ($line.debitAmount#Null:C1517)
			$totalDebit:=$totalDebit+Num:C11($line.debitAmount)
		End if
		If ($line.creditAmount#Null:C1517)
			$totalCredit:=$totalCredit+Num:C11($line.creditAmount)
		End if
	End for each
End if

Form:C1466.journalTotalDebit:=$totalDebit
Form:C1466.journalTotalCredit:=$totalCredit

If (Form:C1466.current_item#Null:C1517)
	Form:C1466.current_item.totalDebit:=$totalDebit
	Form:C1466.current_item.totalCredit:=$totalCredit
End if
