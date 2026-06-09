//%attributes = {"executedOnServer":true}

// Purpose: Import expense lines from legacy BUY_ITEMS export JSON.
// Parameters: reads DataJson/expenseTransaction_export.json from the data folder.
// Returns: nothing (truncates and reloads ExpenseTransaction).
// Note: Method name kept <= 31 chars (4D limit); was __import_data_expenseTransaction.
// created by 4D/PS [2026-june-09]

var $records : Collection
var $file : 4D:C1709.File
var $eExpense : cs:C1710.ExpenseTransactionEntity
var $seq : Integer

TRUNCATE TABLE:C1051([ExpenseTransaction:154])

$file:=Folder:C1567(fk data folder:K87:12).file("DataJson/expenseTransaction_export.json")
If ($file.exists)
	$records:=JSON Parse:C1218($file.getText())
	$seq:=0
	For each ($record; $records)
		$seq:=$seq+1
		$eExpense:=ds:C1482.ExpenseTransaction.new()
		$eExpense.expenseNumber:=$seq
		$eExpense.moreData:=New object:C1471("legacy"; $record)
		$eExpense.save()
	End for each
End if
