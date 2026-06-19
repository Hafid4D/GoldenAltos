//%attributes = {}

// Purpose: Validate dialog input and persist credit application via _ga_applyCreditMemoApply.
// Parameters: uses Form (creditMemoUUID, invoiceLines, memo, invoiceUUIDByNumber, creditAvailable, totalApplied).
// Returns: nothing — closes dialog with ACCEPT when successful.
// created by 4D/PS [2026-june-08]

var $applications : Collection
var $line : Object
var $result : Object
var $memo : Text
var $invoiceUUID : Text
var $txnKey : Text
var $eInv : cs:C1710.SalesTransactionEntity

_ga_applyCreditMemoRecalc()

If (Form:C1466.totalApplied#Null:C1517) && (Form:C1466.creditAvailable#Null:C1517) && (Form:C1466.totalApplied>Form:C1466.creditAvailable)
	cs:C1710.sfw_dialog.me.alert("Applied amount cannot exceed the available credit.")
	return 
End if

$applications:=New collection:C1472()
For each ($line; Form:C1466.invoiceLines)
	If ($line.applyAmount#Null:C1517) && ($line.applyAmount>0)
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

$result:=_ga_applyCreditMemoApply(Form:C1466.creditMemoUUID; $applications; $memo)

If ($result.success)
	Form:C1466.dialogResult:=$result
	ACCEPT:C269
Else
	If ($result.error="")
		$result.error:="Could not apply credit memo."
	End if
	cs:C1710.sfw_dialog.me.alert($result.error)
End if
