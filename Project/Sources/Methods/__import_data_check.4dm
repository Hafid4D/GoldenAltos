//%attributes = {"executedOnServer":true}

// Purpose: Import checks from legacy Check_Register export JSON.
// Parameters: reads DataJson/check_register_export.json from the data folder.
// Returns: nothing (truncates and reloads Check).
// created by 4D/PS [2026-june-09]

var $records : Collection
var $file : 4D:C1709.File
var $eCheck : cs:C1710.CheckEntity

TRUNCATE TABLE:C1051([Check:151])

$file:=Folder:C1567(fk data folder:K87:12).file("DataJson/check_register_export.json")
If ($file.exists)
	$records:=JSON Parse:C1218($file.getText())
	For each ($record; $records)
		$eCheck:=ds:C1482.Check.new()
		$eCheck.checkNumber:=Num:C11($record.Check_Num)
		$eCheck.moreData:=New object:C1471("legacy"; $record)
		$eCheck.save()
	End for each
End if
