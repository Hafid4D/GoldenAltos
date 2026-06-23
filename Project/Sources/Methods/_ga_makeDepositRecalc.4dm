//%attributes = {}

// Purpose: Recompute selected deposit total on the Make Deposit dialog.
// created by 4D/PS [2026-june-22]

var $line : Object
var $totalSelected : Real

$totalSelected:=0
For each ($line; Form:C1466.paymentLines)
	If ($line.include#Null:C1517) && ($line.include#0) && ($line.amount#Null:C1517)
		$totalSelected:=$totalSelected+$line.amount
	End if
End for each

Form:C1466.totalSelected:=$totalSelected
