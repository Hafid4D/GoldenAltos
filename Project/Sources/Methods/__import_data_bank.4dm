//%attributes = {"executedOnServer":true}

// Purpose: Import bank accounts from legacy Bank export JSON (AC_number → GLAccount mapping).
// Parameters: reads DataJson/bank_export.json from the data folder.
// Returns: nothing (truncates and reloads Bank).
// created by 4D/PS [2026-june-29]

var $records : Collection
var $file : 4D:C1709.File
var $eBank : cs:C1710.BankEntity
var $eCao : cs:C1710.CAOEntity
var $glAcct : Text
var $emptyUUID : Text

TRUNCATE TABLE:C1051([Bank:158])

$emptyUUID:=16*"00"
$file:=Folder:C1567(fk data folder:K87:12).file("DataJson/bank_export.json")
If ($file.exists)
	$records:=JSON Parse:C1218($file.getText())
	For each ($record; $records)
		$eBank:=ds:C1482.Bank.new()
		If (OB Is defined:C1231($record; "AC_number"))
			$eBank.acNumber:=String:C10($record.AC_number)
		End if
		If (OB Is defined:C1231($record; "Bank"))
			$eBank.bankName:=String:C10($record.Bank)
		End if
		$glAcct:=""
		If (OB Is defined:C1231($record; "GLAccount"))
			$glAcct:=String:C10($record.GLAccount)
			$eBank.glAccount:=$glAcct
		End if
		If (OB Is defined:C1231($record; "Division"))
			$eBank.division:=String:C10($record.Division)
		End if
		If (OB Is defined:C1231($record; "Currency"))
			$eBank.currency:=String:C10($record.Currency)
		End if
		$eBank.UUID_CAO:=$emptyUUID
		// Purpose: Pre-resolve CAO UUID at import so AP check posting does not depend on runtime lookup.
		// modified by 4D/PS [2026-june-29]
		If ($glAcct#"")
			$eCao:=_ga_jeResolveCaoByAcct($glAcct)
			If ($eCao#Null:C1517)
				$eBank.UUID_CAO:=$eCao.UUID
			End if
		End if
		$eBank.save()
	End for each
End if
