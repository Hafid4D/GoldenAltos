// Purpose: Entity helpers for JournalEntry header (typed GL fields + barcode in moreData).
// modified by 4D/PS [2026-june-29]
Class extends Entity

local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=String:C10(This:C1470.entryNumber)

// Purpose: Ensure moreData is a valid object (barcode scanner payload only).
// modified by 4D/PS [2026-june-29]
Function _ensureMoreData()
	If (Value type:C1509(This:C1470.moreData)#Is object:K8:27)
		This:C1470.moreData:=New object:C1471
	End if

local Function get journalDate()->$date : Date
	$date:=This:C1470.stmpJournalDate=0 ? !00-00-00! : cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpJournalDate; True:C214)

local Function set journalDate($date : Date)
	This:C1470.stmpJournalDate:=$date=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build($date)

// Purpose: List column — debit account label from the first journal line.
// Returns: Text
// modified by 4D/PS [2026-june-29]
local Function get listDebitAccount()->$label : Text
	var $eLine : cs:C1710.JournalEntryLineEntity
	
	$label:=""
	$eLine:=This:C1470.journalEntryLines.orderBy("lineNumber").first()
	If ($eLine#Null:C1517)
		$label:=$eLine.debitAccountLabel
		If ($label="") && ($eLine.debitAccount#Null:C1517)
			$label:=$eLine.debitAccount.displayLabel()
		End if
	End if

// Purpose: List column — credit account label from the first journal line.
// Returns: Text
// modified by 4D/PS [2026-june-29]
local Function get listCreditAccount()->$label : Text
	var $eLine : cs:C1710.JournalEntryLineEntity
	
	$label:=""
	$eLine:=This:C1470.journalEntryLines.orderBy("lineNumber").first()
	If ($eLine#Null:C1517)
		$label:=$eLine.creditAccountLabel
		If ($label="") && ($eLine.creditAccount#Null:C1517)
			$label:=$eLine.creditAccount.displayLabel()
		End if
	End if

// Purpose: Return True when this journal is still being created (manual adjusting entry).
// Returns: Boolean
// modified by 4D/PS [2026-june-29]
Function isDraft()->$draft : Boolean
	$draft:=Not:C34(Bool:C1537(This:C1470.isSaved))

local Function itemReload()
	cs:C1710.panel_journalEntry.me.loadPanelData()

local Function loadAfterCreation()
	If (Form:C1466.situation.mode="add")
		This:C1470._initOnCreation()
	End if
	This:C1470._ensureMoreData()
	This:C1470.moreData.barcodeData:=String:C10(cs:C1710.Util_ScannerManager.me.getBarcodeData(Form:C1466.sfw.entry.dataclass); "0000000000")

// Purpose: Default header values for a new manual adjusting journal entry.
// modified by 4D/PS [2026-june-29]
Function _initOnCreation()
	If (This:C1470.entryNumber=0)
		This:C1470.entryNumber:=ds:C1482.JournalEntry.nextEntryNumber()
	End if
	This:C1470.isSaved:=False:C215
	This:C1470.adjustingEntry:=True:C214
	If (This:C1470.journalDate=!00-00-00!)
		This:C1470.journalDate:=Current date:C33(*)
	End if
	If (This:C1470.transactionType=Null:C1517) || (This:C1470.transactionType="")
		This:C1470.transactionType:="Journal Entry"
	End if
	If (This:C1470.memo=Null:C1517)
		This:C1470.memo:=""
	End if
	If (This:C1470.transactionNum=Null:C1517)
		This:C1470.transactionNum:=""
	End if
	This:C1470.totalDebit:=0
	This:C1470.totalCredit:=0

local Function beforeSave()
	// Purpose: Manual journals persist via JournalEntry_create — system-generated rows are read-only.
	// modified by 4D/PS [2026-june-29]
