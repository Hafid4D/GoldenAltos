//%attributes = {}

// Purpose: Receive Payment action — delegates to SalesTransaction.applyReceivePayment (full open balance on current invoice).
// Parameters: uses Form.current_item (selected invoice line).
// Returns: nothing.
// modified by 4D/PS [2026-june-17]

var $invoice : cs:C1710.SalesTransactionEntity
var $paymentAmount : Real
var $applications : Collection
var $result : Object

$invoice:=Form:C1466.current_item

If ($invoice=Null:C1517)
	cs:C1710.sfw_dialog.me.alert("Select a sales transaction first.")
Else
	If (Not:C34($invoice.canReceivePayment()))
		cs:C1710.sfw_dialog.me.alert("Receive Payment is only available for open invoices.")
	Else
		$paymentAmount:=Abs:C99($invoice.openBalance)
		$applications:=New collection:C1472(New object:C1471("UUID_Invoice"; $invoice.UUID; "appliedAmount"; $paymentAmount))
		$result:=ds:C1482.SalesTransaction.applyReceivePayment($invoice.UUID_Customer; $paymentAmount; $applications; "Payment for transaction #"+String:C10($invoice.transactionNumber); Current date:C33(*))
		If ($result.success)
			Form:C1466.current_item:=ds:C1482.SalesTransaction.get($invoice.UUID)
			cs:C1710.sfw_dialog.me.alert("Payment of "+String:C10($result.totalApplied; "###,###,##0.00")+" recorded.")
		Else
			cs:C1710.sfw_dialog.me.alert($result.error)
		End if
	End if
End if
