//%attributes = {}

// Purpose: Build the Applications tab listbox rows for the current SalesTransaction panel item.
// Parameters: uses Form.current_item; writes Form.lb_applications.
// Returns: nothing.
// created by 4D/PS [2026-june-08]

var $eST : cs:C1710.SalesTransactionEntity
var $eApp : cs:C1710.PaymentApplicationEntity
var $eSource : cs:C1710.SalesTransactionEntity
var $eInv : cs:C1710.SalesTransactionEntity
var $line : Object
var $typeCode : Text
var $sourceType : Text

Form:C1466.lb_applications:=New collection:C1472()
$eST:=Form:C1466.current_item
If ($eST=Null:C1517)
	return 
End if

$typeCode:=$eST.typeCode()

If ($typeCode="INV")
	For each ($eApp; $eST.invoiceApplications)
		$eSource:=$eApp.payment
		If ($eSource=Null:C1517) && (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($eApp.UUID_Payment)))
			$eSource:=ds:C1482.SalesTransaction.get($eApp.UUID_Payment)
		End if
		$sourceType:=""
		If ($eSource#Null:C1517)
			Case of 
				: ($eSource.typeCode()="PAY")
					$sourceType:="Payment"
				: ($eSource.typeCode()="CM")
					$sourceType:="Credit Memo"
				Else 
					$sourceType:=$eSource.typeCode()
			End case
		End if
		$line:=New object:C1471(\
			"sourceType"; $sourceType; \
			"sourceNumber"; ($eSource#Null:C1517) ? String:C10($eSource.transactionNumber) : ""; \
			"invoiceNumber"; String:C10($eST.transactionNumber); \
			"applicationDate"; ($eSource#Null:C1517) ? $eSource.transactionDate : !00-00-00!; \
			"appliedAmount"; $eApp.appliedAmount)
		Form:C1466.lb_applications.push($line)
	End for each
Else
	If (($typeCode="PAY") || ($typeCode="CM"))
		For each ($eApp; $eST.paymentApplications)
			$eInv:=$eApp.appliedInvoice
			If ($eInv=Null:C1517) && (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($eApp.UUID_Invoice)))
				$eInv:=ds:C1482.SalesTransaction.get($eApp.UUID_Invoice)
			End if
			$line:=New object:C1471(\
				"sourceType"; ($typeCode="PAY") ? "Payment" : "Credit Memo"; \
				"sourceNumber"; String:C10($eST.transactionNumber); \
				"invoiceNumber"; ($eInv#Null:C1517) ? String:C10($eInv.transactionNumber) : ""; \
				"applicationDate"; $eST.transactionDate; \
				"appliedAmount"; $eApp.appliedAmount)
			Form:C1466.lb_applications.push($line)
		End for each
	End if
End if
