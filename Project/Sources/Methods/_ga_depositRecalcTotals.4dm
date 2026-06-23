//%attributes = {}

// Purpose: Recompute deposit panel totals (selected payments, other funds, grand total, net to bank).
// created by 4D/PS [2026-june-22]

var $line : Object
var $paymentsTotal : Real
var $otherFundsTotal : Real
var $grossTotal : Real
var $cashBack : Real
var $netToBank : Real

$paymentsTotal:=0
If (Form:C1466.depositPaymentLines#Null:C1517)
	For each ($line; Form:C1466.depositPaymentLines)
		If ($line.include#Null:C1517) && ($line.include#0) && ($line.amount#Null:C1517)
			$paymentsTotal:=$paymentsTotal+$line.amount
		End if
	End for each
End if

$otherFundsTotal:=0
If (Form:C1466.depositOtherFundLines#Null:C1517)
	For each ($line; Form:C1466.depositOtherFundLines)
		If ($line.amount#Null:C1517) && ($line.amount>0)
			$otherFundsTotal:=$otherFundsTotal+$line.amount
		End if
	End for each
End if

$grossTotal:=$paymentsTotal+$otherFundsTotal
$cashBack:=0
If (Form:C1466.current_item#Null:C1517)
	$cashBack:=Form:C1466.current_item.cashBackAmount
End if
If ($cashBack=Null:C1517)
	$cashBack:=0
End if
$netToBank:=$grossTotal-$cashBack
If ($netToBank<0)
	$netToBank:=0
End if

Form:C1466.depositSelectedPaymentsTotal:=$paymentsTotal
Form:C1466.depositOtherFundsTotal:=$otherFundsTotal
Form:C1466.depositGrandTotal:=$grossTotal
Form:C1466.depositNetToBank:=$netToBank
Form:C1466.depositSelectedPaymentsTotal:=Form:C1466.depositSelectedPaymentsTotal
Form:C1466.depositOtherFundsTotal:=Form:C1466.depositOtherFundsTotal
Form:C1466.depositGrandTotal:=Form:C1466.depositGrandTotal
Form:C1466.depositNetToBank:=Form:C1466.depositNetToBank
