//%attributes = {}

// Purpose: Open the Receive Payment dialog for the selected invoice (partial / multi-invoice apply).
// Parameters: uses Form.current_item (selected invoice line).
// Returns: nothing.
// modified by 4D/PS [2026-june-08]

var $invoice : cs:C1710.SalesTransactionEntity
var $form : Object
var $winRef : Integer
var $result : Object
var $eCustomer : cs:C1710.CustomerEntity
var $customerName : Text

$invoice:=Form:C1466.current_item

If ($invoice=Null:C1517)
	cs:C1710.sfw_dialog.me.alert("Select a sales transaction first.")
Else
	// Purpose: Re-sync zero-balance job invoice ST rows via entity method (DataClass call cannot stream entity from SFW).
	// modified by 4D/PS [2026-june-08]
	$invoice:=$invoice.syncJobInvoiceSTAmount()
	
	If (Not:C34($invoice.canReceivePayment()))
		Case of
			: ($invoice.typeCode()#"INV")
				cs:C1710.sfw_dialog.me.alert("Receive Payment is only available for invoice lines.")
			: (Abs:C99($invoice.openBalance)=0)
				cs:C1710.sfw_dialog.me.alert("This invoice has no open balance. Check Amount on the transaction or the linked Job Invoice.")
			Else
				cs:C1710.sfw_dialog.me.alert("Receive Payment is only available for open invoices.")
		End case
	Else
		// Purpose: Resolve customer label from ORDA relation or UUID when relation is not hydrated.
		// modified by 4D/PS [2026-june-08]
		$customerName:=""
		$eCustomer:=$invoice.customer
		If ($eCustomer=Null:C1517) && (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($invoice.UUID_Customer)))
			$eCustomer:=ds:C1482.Customer.get($invoice.UUID_Customer)
		End if
		If ($eCustomer#Null:C1517)
			$customerName:=$eCustomer.name
		End if
		
		$form:=New object:C1471(\
			"seedInvoice"; $invoice; \
			"customerName"; $customerName; \
			"customerUUID"; $invoice.UUID_Customer; \
			"paymentAmount"; Abs:C99($invoice.openBalance); \
			"transactionDate"; Current date:C33(*); \
			"memo"; "Payment for transaction #"+String:C10($invoice.transactionNumber); \
			"invoiceLines"; New collection:C1472(); \
			"totalApplied"; 0; \
			"unapplied"; 0)
		
		$winRef:=Open form window:C675("_ga_receivePayment"; Plain form window:K39:6; Horizontally centered:K39:3; Vertically centered:K39:4)
		SET WINDOW TITLE:C213("Receive Payment"; $winRef)
		DIALOG:C40("_ga_receivePayment"; $form)
		CLOSE WINDOW:C154($winRef)
		
		If (OK=1)
			$result:=$form.dialogResult
			Form:C1466.current_item:=ds:C1482.SalesTransaction.get($invoice.UUID)
			If ($result#Null:C1517)
				cs:C1710.sfw_dialog.me.alert("Payment of "+String:C10($result.totalApplied; "###,###,##0.00")+" recorded.")
			End if
		End if
	End if
End if
