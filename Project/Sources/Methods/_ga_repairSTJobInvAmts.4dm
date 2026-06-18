//%attributes = {}

// Purpose: Patch Amount/openBalance on SalesTransaction rows built from JobInvoice when import left zeros.
// Uses the same amount resolution as __import_stBuildFromSources (total + charge components).
// Returns: nothing — shows an alert with the number of rows updated.
// created by 4D/PS [2026-june-08]

var $eST : cs:C1710.SalesTransactionEntity
var $eRefreshed : cs:C1710.SalesTransactionEntity
var $updated : Integer

$updated:=0

For each ($eST; ds:C1482.SalesTransaction.all())
	If ($eST.memo#Null:C1517) && (Position:C15("Job invoice "; $eST.memo)=1) && ($eST.openBalance=0) && ($eST.Amount=0)
		$eRefreshed:=ds:C1482.SalesTransaction.syncJobInvoiceSTAmount($eST)
		If (($eRefreshed.openBalance#0) || ($eRefreshed.Amount#0))
			$updated:=$updated+1
		End if
	End if
End for each

ALERT:C41(String:C10($updated)+" job invoice sales transaction(s) updated with amounts.")
