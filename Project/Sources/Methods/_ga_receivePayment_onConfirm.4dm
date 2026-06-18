//%attributes = {}

// Purpose: Validate dialog input and persist payment via SalesTransaction.applyReceivePayment.
// Parameters: uses Form (customerUUID, paymentAmount, invoiceLines, memo, transactionDate).
// Returns: nothing — closes dialog with ACCEPT when successful.
// created by 4D/PS [2026-june-08]

var $applications : Collection
var $line : Object
var $result : Object
var $memo : Text

_ga_receivePayment_recalc()

$applications:=New collection:C1472()
For each ($line; Form:C1466.invoiceLines)
	If ($line.applyAmount#Null:C1517) && ($line.applyAmount>0)
		$applications.push(New object:C1471(\
			"UUID_Invoice"; $line.UUID_Invoice; \
			"appliedAmount"; $line.applyAmount))
	End if 
End for each 

$memo:=Form:C1466.memo
If ($memo=Null:C1517)
	$memo:=""
End if

$result:=ds:C1482.SalesTransaction.applyReceivePayment(\
	Form:C1466.customerUUID; \
	Form:C1466.paymentAmount; \
	$applications; \
	$memo; \
	Form:C1466.transactionDate)

If ($result.success)
	Form:C1466.dialogResult:=$result
	ACCEPT:C68
Else 
	cs:C1710.sfw_dialog.me.alert($result.error)
End if 
