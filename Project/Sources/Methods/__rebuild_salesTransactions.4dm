//%attributes = {}

// Purpose: Admin/designer utility — re-sync SalesTransaction rows from Invoice and JobInvoice only.
// Executed manually on the server; does not reseed TransactionType/TransactionStatus.
// Returns: nothing.
// modified by 4D/PS [2026-june-09]

var $count : Integer

If (ds:C1482.TransactionType.all().length=0) | (ds:C1482.TransactionStatus.all().length=0)
	ALERT:C41("TransactionType/TransactionStatus are empty."+Char:C90(13)+\
	"Run __import_data_salesTransaction before rebuilding.")
Else
	$count:=__import_stBuildFromSources
	ALERT:C41("Sales transactions rebuilt: "+String:C10($count)+" record(s).")
End if
