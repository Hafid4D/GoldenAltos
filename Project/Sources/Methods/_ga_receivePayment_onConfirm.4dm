//%attributes = {}

// Purpose: Validate dialog input and persist payment via _ga_applyReceivePayment.
// Parameters: uses Form (customerUUID, paymentAmount, invoiceLines, memo, transactionDate, invoiceUUIDByNumber).
// Returns: nothing — closes dialog with ACCEPT when successful.
// modified by 4D/PS [2026-june-08]

var $applications : Collection
var $line : Object
var $result : Object
var $memo : Text
var $invoiceUUID : Text
var $txnKey : Text
var $eInv : cs:C1710.SalesTransactionEntity

_ga_receivePayment_recalc()

$applications:=New collection:C1472()
For each ($line; Form:C1466.invoiceLines)
	If ($line.applyAmount#Null:C1517) && ($line.applyAmount>0)
		// Purpose: Listbox edits may drop unbound properties — resolve invoice UUID from backup map or query.
		// modified by 4D/PS [2026-june-08]
		$invoiceUUID:=$line.UUID_Invoice
		If (cs:C1710.sfw_string.me.isAnEmptyUUID($invoiceUUID))
			$txnKey:=String:C10($line.transactionNumber)
			If (Form:C1466.invoiceUUIDByNumber#Null:C1517) && (Form:C1466.invoiceUUIDByNumber[$txnKey]#Null:C1517)
				$invoiceUUID:=Form:C1466.invoiceUUIDByNumber[$txnKey]
			End if
		End if
		If (cs:C1710.sfw_string.me.isAnEmptyUUID($invoiceUUID))
			$eInv:=ds:C1482.SalesTransaction.query("UUID_Customer = :1 AND transactionNumber = :2"; Form:C1466.customerUUID; $line.transactionNumber).first()
			If ($eInv#Null:C1517)
				$invoiceUUID:=$eInv.UUID
			End if
		End if
		If (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($invoiceUUID)))
			$applications.push(New object:C1471("UUID_Invoice"; $invoiceUUID; "appliedAmount"; $line.applyAmount))
		End if
	End if
End for each

$memo:=Form:C1466.memo
If ($memo=Null:C1517)
	$memo:=""
End if

If (Form:C1466.transactionDate=Null:C1517) || (Form:C1466.transactionDate=!00-00-00!)
	Form:C1466.transactionDate:=Current date:C33(*)
End if

$result:=_ga_applyReceivePayment(\
	Form:C1466.customerUUID; \
	Form:C1466.paymentAmount; \
	$applications; \
	$memo; \
	Form:C1466.transactionDate)

If ($result.success)
	Form:C1466.dialogResult:=$result
	// Purpose: Use ACCEPT:C269 (project standard); C68 is CREATE RECORD, not ACCEPT.
	// modified by 4D/PS [2026-june-08]
	ACCEPT:C269
Else
	If ($result.error="")
		$result.error:="Could not save payment."
	End if
	cs:C1710.sfw_dialog.me.alert($result.error)
End if
