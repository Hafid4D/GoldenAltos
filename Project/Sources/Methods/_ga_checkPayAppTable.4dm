//%attributes = {}

// Purpose: Verify that PaymentApplication exists in the database file (not only in catalog.4DCatalog).
// Returns: nothing — shows OK or instructions to update database structure.
// created by 4D/PS [2026-june-08]

var $eApp : cs:C1710.PaymentApplicationEntity
var $info : Object
var $emptyUUID : Text

$emptyUUID:=16*"00"

Try
	$eApp:=ds:C1482.PaymentApplication.new()
	$eApp.UUID_Payment:=$emptyUUID
	$eApp.UUID_Invoice:=$emptyUUID
	$eApp.appliedAmount:=0.01
	$info:=$eApp.save()
	If ($info.success)
		$eApp.drop()
		ALERT:C41("PaymentApplication table is available in the database.")
	Else
		ALERT:C41("PaymentApplication save failed: "+$info.statusText)
	End if
Catch
	ALERT:C41("PaymentApplication table is missing in the database file."+Char:C10(13)+Char:C10(13)+"In 4D Designer: Structure > Update database structure, accept creating table PaymentApplication (id 156), then run this check again.")
End try
