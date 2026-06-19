//%attributes = {}

// Purpose: Open the Apply Credit Memo dialog for the selected CM line (partial / multi-invoice apply).
// Parameters: uses Form.current_item (selected credit memo line).
// Returns: nothing.
// created by 4D/PS [2026-june-08]

var $creditMemo : cs:C1710.SalesTransactionEntity
var $form : Object
var $winRef : Integer
var $result : Object
var $eCustomer : cs:C1710.CustomerEntity
var $customerName : Text

$creditMemo:=Form:C1466.current_item

If ($creditMemo=Null:C1517)
	cs:C1710.sfw_dialog.me.alert("Select a sales transaction first.")
Else
	If (Not:C34($creditMemo.canApplyCreditMemo()))
		Case of
			: ($creditMemo.typeCode()#"CM")
				cs:C1710.sfw_dialog.me.alert("Apply Credit Memo is only available for credit memo lines.")
			: (Abs:C99($creditMemo.openBalance)=0)
				cs:C1710.sfw_dialog.me.alert("This credit memo has no unapplied credit.")
			Else
				cs:C1710.sfw_dialog.me.alert("Apply Credit Memo is only available for open credit memos.")
		End case
	Else
		$customerName:=""
		$eCustomer:=$creditMemo.customer
		If ($eCustomer=Null:C1517) && (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($creditMemo.UUID_Customer)))
			$eCustomer:=ds:C1482.Customer.get($creditMemo.UUID_Customer)
		End if
		If ($eCustomer#Null:C1517)
			$customerName:=$eCustomer.name
		End if
		
		$form:=New object:C1471(\
			"seedCreditMemo"; $creditMemo; \
			"creditMemoUUID"; $creditMemo.UUID; \
			"creditMemoNumber"; String:C10($creditMemo.transactionNumber); \
			"customerName"; $customerName; \
			"customerUUID"; $creditMemo.UUID_Customer; \
			"creditAvailable"; Abs:C99($creditMemo.openBalance); \
			"memo"; "Credit applied from transaction #"+String:C10($creditMemo.transactionNumber); \
			"invoiceLines"; New collection:C1472(); \
			"totalApplied"; 0; \
			"remainingCredit"; 0)
		
		$winRef:=Open form window:C675("_ga_applyCreditMemo"; Plain form window:K39:6; Horizontally centered:K39:3; Vertically centered:K39:4)
		SET WINDOW TITLE:C213("Apply Credit Memo"; $winRef)
		DIALOG:C40("_ga_applyCreditMemo"; $form)
		CLOSE WINDOW:C154($winRef)
		
		If (OK=1)
			$result:=$form.dialogResult
			Form:C1466.current_item:=ds:C1482.SalesTransaction.get($creditMemo.UUID)
			If ($result#Null:C1517)
				cs:C1710.sfw_dialog.me.alert("Credit of "+String:C10($result.totalApplied; "###,###,##0.00")+" applied successfully.")
			End if
		End if
	End if
End if
