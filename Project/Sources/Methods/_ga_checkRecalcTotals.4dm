//%attributes = {}

// Purpose: Recompute check panel total from linked bill lines.
// created by 4D/PS [2026-june-29]

var $line : Object
var $total : Real

$total:=0
If (Form:C1466.checkBillLines#Null:C1517)
	For each ($line; Form:C1466.checkBillLines)
		If ($line.amount#Null:C1517)
			$total:=$total+Num:C11($line.amount)
		End if
	End for each
End if

Form:C1466.checkBillsTotal:=$total
Form:C1466.checkBillsTotal:=Form:C1466.checkBillsTotal
