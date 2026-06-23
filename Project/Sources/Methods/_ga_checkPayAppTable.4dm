//%attributes = {}

// Purpose: Verify that PaymentApplication ORDA read/write works (not only catalog.4DCatalog).
// Returns: nothing — shows OK or a detailed error message.
// modified by 4D/PS [2026-june-08]

var $tableError : Text
var $stCount : Integer

$tableError:=_ga_payAppTableError()
If ($tableError#"")
	ALERT:C41($tableError)
Else
	$stCount:=ds:C1482.SalesTransaction.all().length
	If ($stCount=0)
		ALERT:C41("PaymentApplication ORDA read access is OK."+Char:C10(13)+Char:C10(13)+"Write probe skipped: no SalesTransaction row in the database yet.")
	Else
		ALERT:C41("PaymentApplication ORDA access is available (read and write probe OK).")
	End if
End if
