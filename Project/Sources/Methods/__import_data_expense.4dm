//%attributes = {"executedOnServer":true}

// Purpose: Import internal expense lines from legacy BUY_ITEMS export JSON (Internal=true only).
// Parameters: reads DataJson/expenseTransaction_export.json from the data folder.
// Returns: nothing (truncates and reloads ExpenseTransaction).
// modified by 4D/PS [2026-june-29]

var $records : Collection
var $file : 4D:C1709.File
var $eExpense : cs:C1710.ExpenseTransactionEntity
var $seq : Integer

TRUNCATE TABLE:C1051([ExpenseTransaction:154])

$file:=Folder:C1567(fk data folder:K87:12).file("DataJson/expenseTransaction_export.json")
If ($file.exists)
	// Purpose: Skip automatic GL posting while bulk-importing legacy expenses.
	// modified by 4D/PS [2026-june-29]
	If (Storage:C1525.cache=Null:C1517)
		Use (Storage:C1525)
			Storage:C1525.cache:=New shared object:C1526
		End use 
	End if 
	Use (Storage:C1525.cache)
		Storage:C1525.cache.skipJePosting:=True:C214
	End use 
	
	$records:=JSON Parse:C1218($file.getText())
	$seq:=0
	For each ($record; $records)
		If (Not:C34(Bool:C1537($record.Internal)))
			continue
		End if
		$seq:=$seq+1
		$eExpense:=ds:C1482.ExpenseTransaction.new()
		If (OB Is defined:C1231($record; "Seq_Number"))
			$eExpense.expenseNumber:=Num:C11($record.Seq_Number)
		Else 
			$eExpense.expenseNumber:=$seq
		End if
		If (OB Is defined:C1231($record; "Description"))
			$eExpense.description:=String:C10($record.Description)
		End if
		If (OB Is defined:C1231($record; "QTY"))
			$eExpense.qty:=Num:C11($record.QTY)
		End if
		If (OB Is defined:C1231($record; "Unit_Price"))
			$eExpense.unitPrice:=Num:C11($record.Unit_Price)
		End if
		If (OB Is defined:C1231($record; "Line_total"))
			$eExpense.lineTotal:=Num:C11($record.Line_total)
		End if
		If (OB Is defined:C1231($record; "Freight"))
			$eExpense.freight:=Num:C11($record.Freight)
		End if
		If (OB Is defined:C1231($record; "Discount"))
			$eExpense.discount:=Num:C11($record.Discount)
		End if
		If (OB Is defined:C1231($record; "Glac"))
			$eExpense.glAccount:=String:C10($record.Glac)
		End if
		If (OB Is defined:C1231($record; "Check_num"))
			$eExpense.checkNumber:=Num:C11($record.Check_num)
		End if
		If (OB Is defined:C1231($record; "Vendor"))
			$eExpense.vendorName:=String:C10($record.Vendor)
		End if
		$eExpense.orderStmp:=_ga_legacyDateToStmp($record.Order_Date)
		$eExpense.paidStmp:=_ga_legacyDateToStmp($record.Paid_date)
		$eExpense.save()
	End for each
	
	Use (Storage:C1525.cache)
		Storage:C1525.cache.skipJePosting:=False:C215
	End use 
End if
