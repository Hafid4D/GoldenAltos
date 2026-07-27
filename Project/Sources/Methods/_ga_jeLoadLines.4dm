//%attributes = {}

// Purpose: Load saved JournalEntryLine rows into panel listbox collection for view/edit mode.
// Parameters:
// $eEntry : cs.JournalEntryEntity — journal header
// Returns: Collection — UI line rows
// created by 4D/PS [2026-june-29]

#DECLARE($eEntry : cs:C1710.JournalEntryEntity) -> $lines : Collection

var $eLine : cs:C1710.JournalEntryLineEntity
var $line : Object

$lines:=New collection:C1472()

For each ($eLine; ds:C1482.JournalEntryLine.query("UUID_JournalEntry = :1"; $eEntry.UUID).orderBy("lineNumber"))
	$line:=New object:C1471(\
		"lineNumber"; $eLine.lineNumber; \
		"UUID_CAO_debit"; $eLine.UUID_CAO_debit; \
		"UUID_CAO_credit"; $eLine.UUID_CAO_credit; \
		"debitAccountName"; $eLine.debitAccountLabel; \
		"creditAccountName"; $eLine.creditAccountLabel; \
		"debitAmount"; $eLine.debitAmount; \
		"creditAmount"; $eLine.creditAmount; \
		"entityName"; $eLine.entityName; \
		"description"; $eLine.description)
	If ($line.debitAccountName="") && ($eLine.debitAccount#Null:C1517)
		$line.debitAccountName:=$eLine.debitAccount.displayLabel()
	End if
	If ($line.creditAccountName="") && ($eLine.creditAccount#Null:C1517)
		$line.creditAccountName:=$eLine.creditAccount.displayLabel()
	End if
	$lines.push($line)
End for each
