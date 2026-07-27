//%attributes = {"executedOnServer":true}

// Purpose: Import AccTransaction legacy JSON into typed JournalEntry headers and JournalEntryLine rows.
// Groups legacy rows by GroupID (one header per group; orphan rows become single-line headers).
// Parameters: reads DataJson/accTransaction_export.json after __import_data_chartOfAccount.
// Returns: nothing (truncates and reloads JournalEntry + JournalEntryLine).
// modified by 4D/PS [2026-june-29]

var $records : Collection
var $file : 4D:C1709.File
var $byGroup : Object
var $groupKeys : Collection
var $groupKey : Text
var $groupLines : Collection
var $record : Object
var $first : Object
var $eEntry : cs:C1710.JournalEntryEntity
var $eLine : cs:C1710.JournalEntryLineEntity
var $mapped : Object
var $caoCache : Object
var $entryNum : Integer
var $lineNum : Integer
var $totalDebit : Real
var $totalCredit : Real
var $transType : Text
var $adjusting : Boolean
var $tableNum : Integer
var $emptyUUID : Text

$emptyUUID:=16*"00"
$caoCache:=New object:C1471
$byGroup:=New object:C1471
$groupKeys:=New collection:C1472()

TRUNCATE TABLE:C1051([JournalEntryLine:157])
TRUNCATE TABLE:C1051([JournalEntry:150])

$file:=Folder:C1567(fk data folder:K87:12).file("DataJson/accTransaction_export.json")
If (Not:C34($file.exists))
	return 
End if 

$records:=JSON Parse:C1218($file.getText())

For each ($record; $records)
	$groupKey:=""
	If (OB Is defined:C1231($record; "GroupID")) && (String:C10($record.GroupID)#"")
		$groupKey:=String:C10($record.GroupID)
	Else 
		If (OB Is defined:C1231($record; "UniqueID"))
			$groupKey:="UID_"+String:C10($record.UniqueID)
		Else 
			$groupKey:="ROW_"+String:C10($groupKeys.length+1)
		End if 
	End if 
	If (Not:C34(OB Is defined:C1231($byGroup; $groupKey)))
		$byGroup[$groupKey]:=New collection:C1472()
		$groupKeys.push($groupKey)
	End if 
	$byGroup[$groupKey].push($record)
End for each 

$entryNum:=0
For each ($groupKey; $groupKeys)
	$groupLines:=$byGroup[$groupKey]
	If ($groupLines.length=0)
		continue
	End if 
	$first:=$groupLines[0]
	$entryNum:=$entryNum+1
	
	$transType:=""
	If (OB Is defined:C1231($first; "TransactionType"))
		$transType:=String:C10($first.TransactionType)
	End if 
	// Purpose: Map legacy TransactionType to mockup labels (inline — no extra import helper).
	// modified by 4D/PS [2026-june-29]
	If ($transType="")
		$transType:="Journal Entry"
	End if 
	$adjusting:=OB Is defined:C1231($first; "AdjustingEntry") ? Bool:C1537($first.AdjustingEntry) : False:C215
	$tableNum:=OB Is defined:C1231($first; "TableNumber") ? Num:C11($first.TableNumber) : 0
	If ($adjusting) || ($tableNum=0)
		$transType:="Journal Entry"
	Else 
		Case of 
			: ($transType="Sale") | ($transType="Invoice")
				$transType:="Invoice"
			: ($transType="CreditMemo")
				$transType:="Credit Note"
			: ($transType="Payment")
				$transType:="Payment"
			: ($transType="Deposit")
				$transType:="Deposit"
			: ($transType="Purchase")
				$transType:="Bill"
			: ($transType="Discount")
				$transType:="Discount"
		End case 
	End if 
	
	$eEntry:=ds:C1482.JournalEntry.new()
	$eEntry.entryNumber:=$entryNum
	$eEntry.journalDate:=_ga_parseLegacyDepositDate($first.TransactionDate)
	$eEntry.transactionType:=$transType
	$eEntry.transactionNum:=""
	If (OB Is defined:C1231($first; "RecordID"))
		$eEntry.transactionNum:=String:C10($first.RecordID)
	End if 
	$eEntry.adjustingEntry:=OB Is defined:C1231($first; "AdjustingEntry") ? Bool:C1537($first.AdjustingEntry) : False:C215
	$eEntry.isSaved:=True:C214
	$eEntry.memo:=""
	If (OB Is defined:C1231($first; "Description"))
		$eEntry.memo:=String:C10($first.Description)
	End if 
	$eEntry.legacyGroupID:=$groupKey
	$eEntry.sourceTableNumber:=OB Is defined:C1231($first; "TableNumber") ? Num:C11($first.TableNumber) : 0
	$eEntry.sourceRecordID:=""
	If (OB Is defined:C1231($first; "RecordID"))
		$eEntry.sourceRecordID:=String:C10($first.RecordID)
	End if 
	$eEntry.totalDebit:=0
	$eEntry.totalCredit:=0
	$eEntry.save()
	
	$lineNum:=0
	$totalDebit:=0
	$totalCredit:=0
	For each ($record; $groupLines)
		$mapped:=_ga_importJeResolveLine($record; $caoCache)
		$lineNum:=$lineNum+1
		$eLine:=ds:C1482.JournalEntryLine.new()
		$eLine.UUID_JournalEntry:=$eEntry.UUID
		$eLine.lineNumber:=$lineNum
		$eLine.UUID_CAO_debit:=String:C10($mapped.UUID_CAO_debit)
		$eLine.UUID_CAO_credit:=String:C10($mapped.UUID_CAO_credit)
		$eLine.debitAccountLabel:=String:C10($mapped.debitAccountLabel)
		$eLine.creditAccountLabel:=String:C10($mapped.creditAccountLabel)
		$eLine.debitAmount:=Num:C11($mapped.debitAmount)
		$eLine.creditAmount:=Num:C11($mapped.creditAmount)
		$eLine.entityName:=String:C10($mapped.entityName)
		$eLine.description:=String:C10($mapped.description)
		$eLine.legacyUniqueID:=String:C10($mapped.legacyUniqueID)
		$eLine.save()
		$totalDebit:=$totalDebit+$eLine.debitAmount
		$totalCredit:=$totalCredit+$eLine.creditAmount
	End for each 
	
	$eEntry.totalDebit:=$totalDebit
	$eEntry.totalCredit:=$totalCredit
	$eEntry.save()
End for each 
