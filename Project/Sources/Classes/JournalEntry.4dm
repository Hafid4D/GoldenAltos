// Purpose: SFW entry for manual GL journal lines (legacy AccTransaction).
// created by 4D/PS [2026-june-09]
Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("JournalEntry"; ["accounting"]; "Journal Entries"; "JournalEntry")
	$entry.setDataclass("JournalEntry")
	$entry.setDisplayOrder(-600)
	$entry.setIcon("image/entry/journalEntry-white-50x50.png")
	
	$entry.setSearchboxField("entryNumber")
	
	$entry.setPanel("panel_journalEntry"; 1)
	$entry.setPanelPage(1; ""; "Main")
	
	$entry.setLBItemsColumn("entryNumber"; "Entry #"; "width:80")
	$entry.setLBItemsOrderBy("entryNumber")
	$entry.setMainViewLabel("All journal entries")
	
	$entry.setItemListAction("Export to Excel"; "_ga_exportJournalEntrySelection")
	$entry.setItemAction("Generate Barcode"; "_ga_openBarCodeForm")
	$entry.setItemListAction("Search by Scanning"; "_ga_searchByBarcodeScanning")
	
	$entry.enableTransaction()
	$entry.activateFavorite()
