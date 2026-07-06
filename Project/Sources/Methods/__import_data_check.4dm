//%attributes = {"executedOnServer":true}

// Purpose: Import checks from legacy Check_Register export JSON into typed catalog fields.
// Parameters: reads DataJson/check_register_export.json from the data folder.
// Returns: nothing (truncates and reloads Check).
// modified by 4D/PS [2026-june-29]

var $records : Collection
var $file : 4D:C1709.File
var $eCheck : cs:C1710.CheckEntity
var $emptyUUID : Text

TRUNCATE TABLE:C1051([Check:151])

$emptyUUID:=16*"00"
$file:=Folder:C1567(fk data folder:K87:12).file("DataJson/check_register_export.json")
If ($file.exists)
	// Purpose: Skip automatic GL posting while bulk-importing legacy checks (GL comes from journalEntry import).
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
	For each ($record; $records)
		$eCheck:=ds:C1482.Check.new()
		$eCheck.checkNumber:=Num:C11($record.Check_Num)
		$eCheck.checkDateStmp:=_ga_legacyDateToStmp($record.Check_Date)
		If (OB Is defined:C1231($record; "Check_To"))
			$eCheck.payee:=String:C10($record.Check_To)
		End if
		If (OB Is defined:C1231($record; "Amt"))
			$eCheck.amount:=Num:C11($record.Amt)
		End if
		If (OB Is defined:C1231($record; "Memo"))
			$eCheck.memo:=String:C10($record.Memo)
		End if
		If (OB Is defined:C1231($record; "Currency"))
			$eCheck.currency:=String:C10($record.Currency)
		End if
		If (OB Is defined:C1231($record; "AC_Num"))
			$eCheck.acNumber:=String:C10($record.AC_Num)
		End if
		$eCheck.bankGlAccount:=""
		$eCheck.UUID_CAO_bank:=$emptyUUID
		$eCheck.bankAccountLabel:=""
		_ga_enrichCheckBank($eCheck)
		$eCheck.save()
	End for each
	
	Use (Storage:C1525.cache)
		Storage:C1525.cache.skipJePosting:=False:C215
	End use 
End if
