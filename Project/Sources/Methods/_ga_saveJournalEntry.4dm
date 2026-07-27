//%attributes = {}

// Purpose: Persist a manual adjusting journal (JournalEntry header + JournalEntryLine rows).
// Parameters:
// $entryUUID : Text — pre-assigned JournalEntry UUID from the SFW panel
// $entryNumber : Integer — journal number
// $journalDate : Date — journal date
// $memo : Text — header memo
// $lines : Collection — UI rows with UUID_CAO_debit/credit, amounts, description, entityName
// Returns: Object — { success : Boolean, entryUUID : Text, error : Text }
// created by 4D/PS [2026-june-29]

#DECLARE(\
$entryUUID : Text; \
$entryNumber : Integer; \
$journalDate : Date; \
$memo : Text; \
$lines : Collection) -> $result : Object

var $eEntry : cs:C1710.JournalEntryEntity
var $eLine : cs:C1710.JournalEntryLineEntity
var $line : Object
var $lineNum : Integer
var $totalDebit : Real
var $totalCredit : Real
var $eCaoDebit : cs:C1710.CAOEntity
var $eCaoCredit : cs:C1710.CAOEntity
var $res : Object
var $ownTransaction : Boolean

$result:=New object:C1471("success"; False:C215; "entryUUID"; ""; "error"; "")

If ($journalDate=Null:C1517) || ($journalDate=!00-00-00!)
	$journalDate:=Current date:C33(*)
End if

$totalDebit:=0
$totalCredit:=0
For each ($line; $lines)
	$totalDebit:=$totalDebit+Num:C11($line.debitAmount)
	$totalCredit:=$totalCredit+Num:C11($line.creditAmount)
End for each

If (Abs:C99($totalDebit-$totalCredit)>0.005) || ($totalDebit<=0)
	$result.error:="Total debits must equal total credits and be greater than zero."
	return $result
End if

$ownTransaction:=False
If (Transaction level:C961=0)
	ds:C1482.startTransaction()
	$ownTransaction:=True
Else
	ds:C1482.startTransaction()
	$ownTransaction:=True
End if

$eEntry:=ds:C1482.JournalEntry.get($entryUUID)
If ($eEntry=Null:C1517)
	$eEntry:=ds:C1482.JournalEntry.new()
	$eEntry.UUID:=$entryUUID
End if

$eEntry.entryNumber:=$entryNumber
$eEntry.journalDate:=$journalDate
$eEntry.transactionType:="Journal Entry"
$eEntry.transactionNum:=""
$eEntry.adjustingEntry:=True:C214
$eEntry.isSaved:=True:C214
$eEntry.memo:=$memo
$eEntry.legacyGroupID:=""
$eEntry.sourceTableNumber:=0
$eEntry.sourceRecordID:=""
$eEntry.totalDebit:=$totalDebit
$eEntry.totalCredit:=$totalCredit

$res:=$eEntry.save()
If (Not:C34($res.success))
	If ($ownTransaction)
		ds:C1482.cancelTransaction()
	End if
	$result.error:=$res.statusText
	return $result
End if

// Purpose: Reverse existing manual-entry lines before replace (Phase 2 balance updates).
// modified by 4D/PS [2026-june-26]
For each ($eLine; ds:C1482.JournalEntryLine.query("UUID_JournalEntry = :1"; $eEntry.UUID))
	If (Num:C11($eLine.debitAmount)>0)
		$eCaoCredit:=ds:C1482.CAO.get(String:C10($eLine.UUID_CAO_credit))
		$eCaoDebit:=ds:C1482.CAO.get(String:C10($eLine.UUID_CAO_debit))
		If ($eCaoCredit#Null:C1517)
			$eCaoCredit.applyPostingDelta("credit"; -Num:C11($eLine.creditAmount))
		End if
		If ($eCaoDebit#Null:C1517)
			$eCaoDebit.applyPostingDelta("debit"; -Num:C11($eLine.debitAmount))
		End if
	End if
	$eLine.drop()
End for each

$lineNum:=0
For each ($line; $lines)
	If ((Num:C11($line.debitAmount)<=0) && (Num:C11($line.creditAmount)<=0))
		continue
	End if
	If (cs:C1710.sfw_string.me.isAnEmptyUUID(String:C10($line.UUID_CAO_debit))) || (cs:C1710.sfw_string.me.isAnEmptyUUID(String:C10($line.UUID_CAO_credit)))
		If ($ownTransaction)
			ds:C1482.cancelTransaction()
		End if
		$result.error:="Each journal line requires debit and credit accounts."
		return $result
	End if
	$lineNum:=$lineNum+1
	$eLine:=ds:C1482.JournalEntryLine.new()
	$eLine.UUID_JournalEntry:=$eEntry.UUID
	$eLine.lineNumber:=$lineNum
	$eLine.UUID_CAO_debit:=String:C10($line.UUID_CAO_debit)
	$eLine.UUID_CAO_credit:=String:C10($line.UUID_CAO_credit)
	$eLine.debitAmount:=Num:C11($line.debitAmount)
	$eLine.creditAmount:=Num:C11($line.creditAmount)
	$eLine.debitAccountLabel:=""
	$eLine.creditAccountLabel:=""
	$eLine.entityName:=""
	$eLine.description:=""
	$eLine.legacyUniqueID:=""
	If ($line.debitAccountName#Null:C1517)
		$eLine.debitAccountLabel:=String:C10($line.debitAccountName)
	Else
		$eCaoDebit:=ds:C1482.CAO.get($eLine.UUID_CAO_debit)
		If ($eCaoDebit#Null:C1517)
			$eLine.debitAccountLabel:=$eCaoDebit.displayLabel()
		End if
	End if
	If ($line.creditAccountName#Null:C1517)
		$eLine.creditAccountLabel:=String:C10($line.creditAccountName)
	Else
		$eCaoCredit:=ds:C1482.CAO.get($eLine.UUID_CAO_credit)
		If ($eCaoCredit#Null:C1517)
			$eLine.creditAccountLabel:=$eCaoCredit.displayLabel()
		End if
	End if
	If ($line.entityName#Null:C1517)
		$eLine.entityName:=String:C10($line.entityName)
	End if
	If ($line.description#Null:C1517)
		$eLine.description:=String:C10($line.description)
	End if
	$res:=$eLine.save()
	If (Not:C34($res.success))
		If ($ownTransaction)
			ds:C1482.cancelTransaction()
		End if
		$result.error:=$res.statusText
		return $result
	End if
	// Purpose: Apply manual adjusting entry to CAO balances (Phase 2).
	// modified by 4D/PS [2026-june-26]
	$eCaoCredit:=ds:C1482.CAO.get($eLine.UUID_CAO_credit)
	$eCaoDebit:=ds:C1482.CAO.get($eLine.UUID_CAO_debit)
	If ($eCaoCredit#Null:C1517)
		$eCaoCredit.applyPostingDelta("credit"; Num:C11($eLine.creditAmount))
	End if
	If ($eCaoDebit#Null:C1517)
		$eCaoDebit.applyPostingDelta("debit"; Num:C11($eLine.debitAmount))
	End if
End for each

If ($ownTransaction)
	ds:C1482.validateTransaction()
End if

$result.success:=True:C214
$result.entryUUID:=$eEntry.UUID
