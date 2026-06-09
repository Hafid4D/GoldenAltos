//%attributes = {}

// Purpose: Admin/designer utility — re-sync SalesTransaction rows from Invoice and JobInvoice only.
// Executed manually on the server; not part of the regular user workflow.
// Does not seed reference data; production migration uses __import_data_salesTransaction via __import_data.
// Returns: nothing.
// modified by 4D/PS [2026-june-08]

var $count : Integer

// Purpose: Reference tables must exist before rebuilding AR lines (seeded during production migration).
// Technical message is acceptable — this method is run by admin/designer only.
// modified by 4D/PS [2026-june-08]
If (ds:C1482.TransactionType.all().length=0) | (ds:C1482.TransactionStatus.all().length=0)
	ALERT:C41("TransactionType/TransactionStatus are empty."+Char:C90(13)+\
	"Run __import_data_salesTransaction before rebuilding.")
Else
	$count:=ds:C1482.SalesTransaction.rebuildFromSources()
	ALERT:C41("Sales transactions rebuilt: "+String:C10($count)+" record(s).")
End if
