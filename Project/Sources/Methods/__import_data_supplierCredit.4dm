//%attributes = {"executedOnServer":true}

// Purpose: Import vendor credits from legacy CM_items export (Tovendor=true) into typed catalog fields.
// Parameters: reads DataJson/CM_items_list_export.json from the data folder.
// Returns: nothing (truncates and reloads SupplierCredit).
// modified by 4D/PS [2026-june-29]

var $records : Collection
var $file : 4D:C1709.File
var $eCredit : cs:C1710.SupplierCreditEntity
var $seq : Integer
var $emptyUUID : Text

TRUNCATE TABLE:C1051([SupplierCredit:153])

$emptyUUID:=16*"00"
$file:=Folder:C1567(fk data folder:K87:12).file("DataJson/CM_items_list_export.json")
If ($file.exists)
	// Purpose: Skip automatic GL posting while bulk-importing legacy vendor credits.
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
		If (Bool:C1537($record.Tovendor))
			$seq:=$seq+1
			$eCredit:=ds:C1482.SupplierCredit.new()
			If (OB Is defined:C1231($record; "CMnum"))
				$eCredit.creditNumber:=Num:C11($record.CMnum)
			Else 
				$eCredit.creditNumber:=$seq
			End if
			If (OB Is defined:C1231($record; "Amt"))
				$eCredit.amount:=Abs:C99(Num:C11($record.Amt))
			End if
			If (OB Is defined:C1231($record; "Invoice"))
				$eCredit.billSeqNumber:=Num:C11($record.Invoice)
			End if
			$eCredit.creditDateStmp:=_ga_legacyDateToStmp($record.CM_date)
			If (OB Is defined:C1231($record; "Customer"))
				$eCredit.vendorName:=String:C10($record.Customer)
			End if
			$eCredit.UUID_BuyingOrderLine:=$emptyUUID
			$eCredit.save()
		End if
	End for each
	
	Use (Storage:C1525.cache)
		Storage:C1525.cache.skipJePosting:=False:C215
	End use 
End if
