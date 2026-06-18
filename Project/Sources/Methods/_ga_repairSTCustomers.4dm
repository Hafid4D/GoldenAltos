//%attributes = {}

// Purpose: Patch UUID_Customer on existing SalesTransaction rows without truncating the table.
// Uses the same customer resolution as __import_stBuildFromSources (PO, customerId, job name).
// Returns: nothing — shows an alert with the number of rows updated.
// created by 4D/PS [2026-june-08]

var $eInvoice : cs:C1710.InvoiceEntity
var $eJobInvoice : cs:C1710.JobInvoiceEntity
var $eST : cs:C1710.SalesTransactionEntity
var $parts : Collection
var $num : Integer
var $customerUUID : Text
var $updated : Integer
var $sts : cs:C1710.SalesTransactionSelection
var $res : Object

$updated:=0

For each ($eInvoice; ds:C1482.Invoice.all())
	$customerUUID:=ds:C1482.SalesTransaction.resolveCustomerUUIDFromInvoice($eInvoice)
	If (cs:C1710.sfw_string.me.isAnEmptyUUID($customerUUID))
		continue
	End if
	$parts:=Split string:C1554($eInvoice.invoice; " "; sk trim spaces:K86:2)
	$num:=Num:C11($parts[$parts.length-1])
	If ($num=0)
		continue
	End if
	$sts:=ds:C1482.SalesTransaction.query("transactionNumber = :1"; $num)
	For each ($eST; $sts)
		If (cs:C1710.sfw_string.me.isAnEmptyUUID($eST.UUID_Customer))
			$eST.UUID_Customer:=$customerUUID
			$res:=$eST.save()
			If ($res.success)
				$updated:=$updated+1
			End if
		End if
	End for each
End for each

For each ($eJobInvoice; ds:C1482.JobInvoice.all())
	$customerUUID:=ds:C1482.SalesTransaction.resolveCustomerUUIDFromJobInvoice($eJobInvoice)
	If (cs:C1710.sfw_string.me.isAnEmptyUUID($customerUUID))
		continue
	End if
	$sts:=ds:C1482.SalesTransaction.query("memo = :1"; "Job invoice "+$eJobInvoice.invoiceNumber)
	For each ($eST; $sts)
		If (cs:C1710.sfw_string.me.isAnEmptyUUID($eST.UUID_Customer))
			$eST.UUID_Customer:=$customerUUID
			$res:=$eST.save()
			If ($res.success)
				$updated:=$updated+1
			End if
		End if
	End for each
End for each

ALERT:C41(String:C10($updated)+" sales transaction(s) updated with a customer.")
