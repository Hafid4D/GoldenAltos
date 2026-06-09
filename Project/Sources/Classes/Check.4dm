// Purpose: SFW entry for check register (legacy Check_Register).
// created by 4D/PS [2026-june-09]
Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("Check"; ["accounting"]; "Checks"; "Check")
	$entry.setDataclass("Check")
	$entry.setDisplayOrder(-700)
	$entry.setIcon("image/entry/check-white-50x50.png")
	
	$entry.setSearchboxField("checkNumber")
	
	$entry.setPanel("panel_check"; 1)
	$entry.setPanelPage(1; ""; "Main")
	
	$entry.setLBItemsColumn("checkNumber"; "Check #"; "width:80")
	$entry.setLBItemsOrderBy("checkNumber")
	$entry.setMainViewLabel("All checks")
	
	$entry.setItemListAction("Export to Excel"; "_ga_exportCheckSelection")
	$entry.setItemAction("Generate Barcode"; "_ga_openBarCodeForm")
	$entry.setItemListAction("Search by Scanning"; "_ga_searchByBarcodeScanning")
	
	$entry.enableTransaction()
	$entry.activateFavorite()
