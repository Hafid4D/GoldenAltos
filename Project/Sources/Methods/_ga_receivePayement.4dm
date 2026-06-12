//%attributes = {}

// Purpose: Receive Payment action — reduces invoice open balance and creates a PAY SalesTransaction line.
// Parameters: uses Form.current_item (selected invoice line).
// Returns: nothing.
// created by 4D/PS [2026-june-08]

var $invoice : cs:C1710.SalesTransactionEntity
var $paymentAmount : Real
var $ePayment : cs:C1710.SalesTransactionEntity
var $eType : cs:C1710.TransactionTypeEntity
var $maxNum : Integer

$invoice:=Form:C1466.current_item

If ($invoice=Null:C1517)
	cs:C1710.sfw_dialog.me.alert("Select a sales transaction first.")
Else
	If (Not:C34($invoice.canReceivePayment()))
		cs:C1710.sfw_dialog.me.alert("Receive Payment is only available for open invoices.")
	Else
		$paymentAmount:=Abs:C99($invoice.openBalance)
		// Purpose: Apply full open balance for now; partial payment UI will follow in a dedicated dialog.
		// modified by 4D/PS [2026-june-08]
		$maxNum:=ds:C1482.SalesTransaction.all().extract("transactionNumber").max()
		$ePayment:=ds:C1482.SalesTransaction.new()
		$ePayment.transactionNumber:=($maxNum=Null:C1517) ? 1 : $maxNum+1
		$ePayment.UUID_Customer:=$invoice.UUID_Customer
		$eType:=ds:C1482.TransactionType.query("code = :1"; "PAY").first()
		If ($eType#Null:C1517)
			$ePayment.UUID_TransactionType:=$eType.UUID
		End if
		$ePayment.transactionDate:=Current date:C33(*)
		$ePayment.Amount:=-$paymentAmount
		$ePayment.openBalance:=0
		$ePayment.memo:="Payment for transaction #"+String:C10($invoice.transactionNumber)
		$ePayment.refreshStatus()
		$ePayment.save()
		
		$invoice.openBalance:=0
		$invoice.refreshStatus()
		$invoice.save()
		
		Form:C1466.current_item:=ds:C1482.SalesTransaction.get($invoice.UUID)
		cs:C1710.sfw_dialog.me.alert("Payment of "+String:C10($paymentAmount; "|Money")+" recorded.")
	End if
End if
