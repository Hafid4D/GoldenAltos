//%attributes = {}

// Purpose: Recompute total applied and remaining credit on the Apply Credit Memo dialog.
// Parameters: uses Form (invoiceLines, creditAvailable).
// Returns: nothing.
// created by 4D/PS [2026-june-08]

var $line : Object
var $totalApplied : Real
var $creditAvailable : Real

$totalApplied:=0
For each ($line; Form:C1466.invoiceLines)
	If ($line.applyAmount#Null:C1517) && ($line.applyAmount>0)
		$totalApplied:=$totalApplied+$line.applyAmount
	End if 
End for each 

$creditAvailable:=(Form:C1466.creditAvailable=Null:C1517) ? 0 : Form:C1466.creditAvailable
Form:C1466.totalApplied:=$totalApplied
Form:C1466.remainingCredit:=Choose:C955($creditAvailable>$totalApplied; $creditAvailable-$totalApplied; 0)
