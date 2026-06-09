// Purpose: SFW entry for customer deposit slips (legacy Deposits / Deposit_Items).
// created by 4D/PS [2026-june-09]
Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("Deposit"; ["accounting"]; "Deposits"; "Deposit")
	$entry.setDataclass("Deposit")
	$entry.setDisplayOrder(-500)
	$entry.setIcon("image/entry/deposit-white-50x50.png")
	
	$entry.setSearchboxField("depositNumber")
	
	$entry.setPanel("panel_deposit"; 1)
	$entry.setPanelPage(1; ""; "Main")
	
	$entry.setLBItemsColumn("depositNumber"; "Deposit #"; "width:80")
	$entry.setLBItemsOrderBy("depositNumber")
	$entry.setMainViewLabel("All deposits")
	
	$entry.setItemListAction("Export to Excel"; "_ga_exportDepositSelection")
	$entry.setItemAction("Generate Barcode"; "_ga_openBarCodeForm")
	$entry.setItemListAction("Search by Scanning"; "_ga_searchByBarcodeScanning")
	
	$entry.enableTransaction()
	$entry.activateFavorite()
