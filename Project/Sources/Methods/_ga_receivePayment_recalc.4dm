//%attributes = {}

// Purpose: Recompute total applied and unapplied amounts on the Receive Payment dialog.
// Parameters: uses Form (invoiceLines, paymentAmount).
// Returns: nothing.
// created by 4D/PS [2026-june-08]

var $line : Object
var $totalApplied : Real
var $paymentAmount : Real

$totalApplied:=0
For each ($line; Form:C1466.invoiceLines)
	If ($line.applyAmount#Null:C1517) && ($line.applyAmount>0)
		$totalApplied:=$totalApplied+$line.applyAmount
	End if 
End for each 

$paymentAmount:=(Form:C1466.paymentAmount=Null:C1517) ? 0 : Form:C1466.paymentAmount
Form:C1466.totalApplied:=$totalApplied
Form:C1466.unapplied:=Choose:C955($paymentAmount>$totalApplied; $paymentAmount-$totalApplied; 0)
