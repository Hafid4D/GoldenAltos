//%attributes = {"executedOnServer":true}

// Purpose: Import bill payment lines from legacy PartialPays export JSON.
// Parameters: reads DataJson/partialPays_export.json from the data folder.
// Returns: nothing (truncates and reloads BillPayment).
// created by 4D/PS [2026-june-09]

var $records : Collection
var $file : 4D:C1709.File
var $ePayment : cs:C1710.BillPaymentEntity
var $seq : Integer

TRUNCATE TABLE:C1051([BillPayment:152])

$file:=Folder:C1567(fk data folder:K87:12).file("DataJson/partialPays_export.json")
If ($file.exists)
	$records:=JSON Parse:C1218($file.getText())
	$seq:=0
	For each ($record; $records)
		$seq:=$seq+1
		$ePayment:=ds:C1482.BillPayment.new()
		$ePayment.paymentNumber:=$seq
		$ePayment.moreData:=New object:C1471("legacy"; $record)
		$ePayment.save()
	End for each
End if
