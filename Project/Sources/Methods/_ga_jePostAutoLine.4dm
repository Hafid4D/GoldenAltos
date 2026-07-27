//%attributes = {}

// Purpose: Create or update a single-line system journal entry and update CAO balances (legacy AccountingTransaction).
// Parameters — $opts : Object with:
//   transactionType : Text — e.g. Payment, Deposit, Sale
//   sourceTableNumber : Integer — GA table number of source document
//   sourceRecordID : Text — source row identifier (UUID or legacy id)
//   creditCaoUUID : Text — credit-side CAO UUID (legacy FromAccount)
//   debitCaoUUID : Text — debit-side CAO UUID (legacy ToAccount)
//   amount : Real — posted amount (positive)
//   journalDate : Date — transaction date
//   memo : Text — header memo
//   entityName : Text — optional entity label
//   description : Text — line description
//   groupID : Text — optional legacy group id
//   transactionNum : Text — optional document number label
// Returns: Object — { success : Boolean, entryUUID : Text, error : Text }
// created by 4D/PS [2026-june-26]

#DECLARE($opts : Object) -> $result : Object

var $eEntry : cs:C1710.JournalEntryEntity
var $eLine : cs:C1710.JournalEntryLineEntity
var $eCredit : cs:C1710.CAOEntity
var $eDebit : cs:C1710.CAOEntity
var $amount : Real
var $oldAmount : Real
var $oldCreditUUID : Text
var $oldDebitUUID : Text
var $res : Object
var $transType : Text
var $sourceTable : Integer
var $sourceID : Text

$result:=New object:C1471("success"; False:C215; "entryUUID"; ""; "error"; "")

$transType:=String:C10($opts.transactionType)
$sourceTable:=Num:C11($opts.sourceTableNumber)
$sourceID:=String:C10($opts.sourceRecordID)
$amount:=Num:C11($opts.amount)

If ($transType="") || ($sourceID="") || ($amount<=0)
	$result.error:="Invalid journal posting options."
	return $result
End if

If (cs:C1710.sfw_string.me.isAnEmptyUUID(String:C10($opts.creditCaoUUID))) || (cs:C1710.sfw_string.me.isAnEmptyUUID(String:C10($opts.debitCaoUUID)))
	$result.error:="Debit and credit accounts are required for posting."
	return $result
End if

$eCredit:=ds:C1482.CAO.get(String:C10($opts.creditCaoUUID))
$eDebit:=ds:C1482.CAO.get(String:C10($opts.debitCaoUUID))
If ($eCredit=Null:C1517) || ($eDebit=Null:C1517)
	$result.error:="Chart of accounts entry not found for posting."
	return $result
End if

$eEntry:=ds:C1482.JournalEntry.query(\
	"transactionType = :1 AND sourceTableNumber = :2 AND sourceRecordID = :3 AND adjustingEntry = :4"; \
	$transType; $sourceTable; $sourceID; False:C215).first()

$oldAmount:=0
$oldCreditUUID:=""
$oldDebitUUID:=""
If ($eEntry#Null:C1517)
	$eLine:=ds:C1482.JournalEntryLine.query("UUID_JournalEntry = :1"; $eEntry.UUID).orderBy("lineNumber").first()
	If ($eLine#Null:C1517)
		$oldAmount:=Num:C11($eLine.debitAmount)
		$oldCreditUUID:=String:C10($eLine.UUID_CAO_credit)
		$oldDebitUUID:=String:C10($eLine.UUID_CAO_debit)
	End if
End if

// Purpose: Reverse prior balance deltas before applying the updated posting (legacy upsert behavior).
// modified by 4D/PS [2026-june-26]
If ($oldAmount>0)
	If (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($oldCreditUUID)))
		$eCredit:=ds:C1482.CAO.get($oldCreditUUID)
		If ($eCredit#Null:C1517)
			$eCredit.applyPostingDelta("credit"; -$oldAmount)
		End if
	End if
	If (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($oldDebitUUID)))
		$eDebit:=ds:C1482.CAO.get($oldDebitUUID)
		If ($eDebit#Null:C1517)
			$eDebit.applyPostingDelta("debit"; -$oldAmount)
		End if
	End if
	$eCredit:=ds:C1482.CAO.get(String:C10($opts.creditCaoUUID))
	$eDebit:=ds:C1482.CAO.get(String:C10($opts.debitCaoUUID))
End if

If ($eEntry=Null:C1517)
	$eEntry:=ds:C1482.JournalEntry.new()
	$eEntry.entryNumber:=ds:C1482.JournalEntry.nextEntryNumber()
End if

If ($opts.journalDate#Null:C1517) && ($opts.journalDate#!00-00-00!)
	$eEntry.journalDate:=$opts.journalDate
Else
	If ($eEntry.journalDate=Null:C1517) || ($eEntry.stmpJournalDate=0)
		$eEntry.journalDate:=Current date:C33(*)
	End if
End if

$eEntry.transactionType:=$transType
$eEntry.adjustingEntry:=False:C215
$eEntry.isSaved:=True:C214
$eEntry.memo:=String:C10($opts.memo)
$eEntry.totalDebit:=$amount
$eEntry.totalCredit:=$amount
$eEntry.sourceTableNumber:=$sourceTable
$eEntry.sourceRecordID:=$sourceID
If ($opts.groupID#Null:C1517)
	$eEntry.legacyGroupID:=String:C10($opts.groupID)
End if
If ($opts.transactionNum#Null:C1517)
	$eEntry.transactionNum:=String:C10($opts.transactionNum)
End if

$res:=$eEntry.save()
If (Not:C34($res.success))
	$result.error:=$res.statusText
	return $result
End if

For each ($eLine; ds:C1482.JournalEntryLine.query("UUID_JournalEntry = :1"; $eEntry.UUID))
	$eLine.drop()
End for each

$eLine:=ds:C1482.JournalEntryLine.new()
$eLine.UUID_JournalEntry:=$eEntry.UUID
$eLine.lineNumber:=1
$eLine.UUID_CAO_credit:=String:C10($opts.creditCaoUUID)
$eLine.UUID_CAO_debit:=String:C10($opts.debitCaoUUID)
$eLine.debitAmount:=$amount
$eLine.creditAmount:=$amount
$eLine.debitAccountLabel:=$eDebit.displayLabel()
$eLine.creditAccountLabel:=$eCredit.displayLabel()
$eLine.entityName:=""
$eLine.description:=""
If ($opts.entityName#Null:C1517)
	$eLine.entityName:=String:C10($opts.entityName)
End if
If ($opts.description#Null:C1517)
	$eLine.description:=String:C10($opts.description)
End if

$res:=$eLine.save()
If (Not:C34($res.success))
	$result.error:=$res.statusText
	return $result
End if

$eCredit.applyPostingDelta("credit"; $amount)
$eDebit.applyPostingDelta("debit"; $amount)

$result.success:=True:C214
$result.entryUUID:=$eEntry.UUID
