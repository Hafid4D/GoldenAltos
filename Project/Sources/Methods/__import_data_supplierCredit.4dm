//%attributes = {"executedOnServer":true}

// Purpose: Import vendor credits from legacy CM_items export (Tovendor=true).
// Parameters: reads DataJson/CM_items_list_export.json from the data folder.
// Returns: nothing (truncates and reloads SupplierCredit).
// created by 4D/PS [2026-june-09]

var $records : Collection
var $file : 4D:C1709.File
var $eCredit : cs:C1710.SupplierCreditEntity
var $seq : Integer

TRUNCATE TABLE:C1051([SupplierCredit:153])

$file:=Folder:C1567(fk data folder:K87:12).file("DataJson/CM_items_list_export.json")
If ($file.exists)
	$records:=JSON Parse:C1218($file.getText())
	$seq:=0
	For each ($record; $records)
		If (Bool:C1537($record.Tovendor))
			$seq:=$seq+1
			$eCredit:=ds:C1482.SupplierCredit.new()
			$eCredit.creditNumber:=$seq
			$eCredit.moreData:=New object:C1471("legacy"; $record)
			$eCredit.save()
		End if
	End for each
End if
