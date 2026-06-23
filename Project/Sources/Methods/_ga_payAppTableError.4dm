//%attributes = {}

// Purpose: Verify PaymentApplication ORDA access (read + write with valid SalesTransaction FK keys).
// Returns: Text — error message, or "" when the dataclass is ready
// modified by 4D/PS [2026-june-08]

#DECLARE -> $error : Text

var $eApp : cs:C1710.PaymentApplicationEntity
var $ePay : cs:C1710.SalesTransactionEntity
var $eInv : cs:C1710.SalesTransactionEntity
var $info : Object
var $sel : cs:C1710.PaymentApplicationSelection

$error:=""

// Purpose: Read probe — confirms table 156 exists and ORDA mapping is active.
// modified by 4D/PS [2026-june-08]
$sel:=ds:C1482.PaymentApplication.all()

// Purpose: Write probe requires real SalesTransaction UUIDs (FK relations payment / appliedInvoice).
// modified by 4D/PS [2026-june-08]
$ePay:=ds:C1482.SalesTransaction.all().first()
If ($ePay=Null:C1517)
	// Table exists and is readable; no SalesTransaction row available for a write probe.
	return $error
End if

$eInv:=ds:C1482.SalesTransaction.query("UUID # :1"; $ePay.UUID).first()
If ($eInv=Null:C1517)
	$eInv:=$ePay
End if

$eApp:=ds:C1482.PaymentApplication.new()
$eApp.UUID_Payment:=$ePay.UUID
$eApp.UUID_Invoice:=$eInv.UUID
$eApp.appliedAmount:=0.01
$info:=$eApp.save()
If ($info.success)
	$eApp.drop()
Else
	If ($info.statusText#"")
		$error:=$info.statusText
	Else
		$error:="PaymentApplication save failed (no statusText). Check Structure > Update database structure for table PaymentApplication (id 156)."
	End if
End if
