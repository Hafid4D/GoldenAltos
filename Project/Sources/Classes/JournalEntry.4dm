// Purpose: SFW entry for the general ledger journal (legacy AccTransaction groups + manual adjusting entries).
// created by 4D/PS [2026-june-29]
Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("JournalEntry"; ["accounting"]; "Journal Entries"; "JournalEntry")
	$entry.setDataclass("JournalEntry")
	$entry.setDisplayOrder(-600)
	$entry.setIcon("image/entry/journalEntry-white-50x50.png")
	
	$entry.setSearchboxField("entryNumber")
	$entry.setSearchboxField("transactionType")
	$entry.setSearchboxField("transactionNum")
	
	$entry.setPanel("panel_journalEntry"; 1)
	$entry.setPanelPage(1; ""; "Main")
	
	// Purpose: List columns aligned with client mockup (trans type, accounts, amounts).
	// modified by 4D/PS [2026-june-29]
	$entry.setLBItemsColumn("entryNumber"; "#"; "width:40")
	$entry.setLBItemsColumn("transactionType"; "Trans Type"; "width:100")
	$entry.setLBItemsColumn("transactionNum"; "Num"; "width:60")
	$entry.setLBItemsColumn("listDebitAccount"; "Debit Acc"; "width:120")
	$entry.setLBItemsColumn("listCreditAccount"; "Credit Acc"; "width:120")
	$entry.setLBItemsColumn("totalDebit"; "Debit"; "width:80")
	$entry.setLBItemsColumn("totalCredit"; "Credit"; "width:80")
	$entry.setLBItemsOrderBy("entryNumber")
	$entry.setMainViewLabel("All journal entries")
	
	$entry.setItemListAction("Export to Excel"; "_ga_exportJournalEntrySelection")
	$entry.setItemAction("Generate Barcode"; "_ga_openBarCodeForm")
	$entry.setItemListAction("Search by Scanning"; "_ga_searchByBarcodeScanning")
	
	$entry.enableTransaction()
	$entry.activateFavorite()

// Purpose: Return the next available entryNumber for a new journal header.
// Returns: Integer
// created by 4D/PS [2026-june-29]
Function nextEntryNumber()->$num : Integer
	var $max : Integer
	
	$max:=This:C1470.all().extract("entryNumber").max()
	$num:=($max=Null:C1517) ? 1 : $max+1

// Purpose: Delegate to _ga_jePostAutoLine — single-line system posting with CAO balance update.
// Parameters: $opts : Object — see _ga_jePostAutoLine
// Returns: Object — { success, entryUUID, error }
// created by 4D/PS [2026-june-26]
Function postAutoLine($opts : Object)->$result : Object
	$result:=_ga_jePostAutoLine($opts)
