//%attributes = {"executedOnServer":true}

// Purpose: Import journal lines from legacy AccTransaction export JSON.
// Parameters: reads DataJson/accTransaction_export.json from the data folder.
// Returns: nothing (truncates and reloads JournalEntry).
// created by 4D/PS [2026-june-09]

var $records : Collection
var $file : 4D:C1709.File
var $eEntry : cs:C1710.JournalEntryEntity
var $seq : Integer

TRUNCATE TABLE:C1051([JournalEntry:150])

$file:=Folder:C1567(fk data folder:K87:12).file("DataJson/accTransaction_export.json")
If ($file.exists)
	$records:=JSON Parse:C1218($file.getText())
	$seq:=0
	For each ($record; $records)
		$seq:=$seq+1
		$eEntry:=ds:C1482.JournalEntry.new()
		$eEntry.entryNumber:=$seq
		$eEntry.moreData:=New object:C1471("legacy"; $record)
		$eEntry.save()
	End for each
End if
