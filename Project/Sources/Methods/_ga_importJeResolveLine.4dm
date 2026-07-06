// Purpose: Map one legacy AccTransaction JSON row onto typed JournalEntryLine fields.
// Parameters:
// $record : Object — one row from accTransaction_export.json
// $caoCache : Object — GLAC accountNumber → UUID map (mutated when a match is found)
// Returns: Object — line field values for JournalEntryLine persistence
// created by 4D/PS [2026-june-29]

#DECLARE($record : Object; $caoCache : Object) -> $mapped : Object

var $debitGlac : Text
var $creditGlac : Text
var $amount : Real
var $description : Text
var $entityName : Text
var $legacyUniqueID : Text
var $uuidDebit : Text
var $uuidCredit : Text
var $emptyUUID : Text
var $eCao : cs:C1710.CAOEntity

$emptyUUID:=16*"00"
$uuidDebit:=$emptyUUID
$uuidCredit:=$emptyUUID
$debitGlac:=""
$creditGlac:=""
$amount:=0
$description:=""
$entityName:=""
$legacyUniqueID:=""

If (OB Is defined:C1231($record; "DebitAccount"))
	$debitGlac:=String:C10($record.DebitAccount)
End if
If (OB Is defined:C1231($record; "CreditAccount"))
	$creditGlac:=String:C10($record.CreditAccount)
End if
If (OB Is defined:C1231($record; "Amount"))
	$amount:=Num:C11($record.Amount)
End if
If (OB Is defined:C1231($record; "Description"))
	$description:=String:C10($record.Description)
End if
If (OB Is defined:C1231($record; "EntityReference"))
	$entityName:=String:C10($record.EntityReference)
End if
If (OB Is defined:C1231($record; "UniqueID"))
	$legacyUniqueID:=String:C10($record.UniqueID)
End if

If ($debitGlac#"")
	If (OB Is defined:C1231($caoCache; $debitGlac))
		$uuidDebit:=$caoCache[$debitGlac]
	Else
		$eCao:=ds:C1482.CAO.query("accountNumber = :1"; $debitGlac).first()
		If ($eCao#Null:C1517)
			$uuidDebit:=$eCao.UUID
			$caoCache[$debitGlac]:=$uuidDebit
		Else
			$caoCache[$debitGlac]:=$emptyUUID
		End if
	End if
End if

If ($creditGlac#"")
	If (OB Is defined:C1231($caoCache; $creditGlac))
		$uuidCredit:=$caoCache[$creditGlac]
	Else
		$eCao:=ds:C1482.CAO.query("accountNumber = :1"; $creditGlac).first()
		If ($eCao#Null:C1517)
			$uuidCredit:=$eCao.UUID
			$caoCache[$creditGlac]:=$uuidCredit
		Else
			$caoCache[$creditGlac]:=$emptyUUID
		End if
	End if
End if

$mapped:=New object:C1471(\
	"UUID_CAO_debit"; $uuidDebit; \
	"UUID_CAO_credit"; $uuidCredit; \
	"debitAccountLabel"; $debitGlac; \
	"creditAccountLabel"; $creditGlac; \
	"debitAmount"; $amount; \
	"creditAmount"; $amount; \
	"entityName"; $entityName; \
	"description"; $description; \
	"legacyUniqueID"; $legacyUniqueID)
