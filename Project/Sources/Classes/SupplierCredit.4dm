// Purpose: SFW entry for vendor credits (legacy CM_items with Tovendor).
// created by 4D/PS [2026-june-09]
Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("SupplierCredit"; ["accounting"]; "Supplier Credits"; "SupplierCredit")
	$entry.setDataclass("SupplierCredit")
	$entry.setDisplayOrder(-900)
	$entry.setIcon("image/entry/supplierCredit-white-50x50.png")
	
	$entry.setSearchboxField("creditNumber")
	
	$entry.setPanel("panel_supplierCredit"; 1)
	$entry.setPanelPage(1; ""; "Main")
	
	$entry.setLBItemsColumn("creditNumber"; "Credit #"; "width:80")
	$entry.setLBItemsOrderBy("creditNumber")
	$entry.setMainViewLabel("All supplier credits")
	
	$entry.setItemListAction("Export to Excel"; "_ga_exportSupplierCreditSelection")
	$entry.setItemAction("Generate Barcode"; "_ga_openBarCodeForm")
	$entry.setItemListAction("Search by Scanning"; "_ga_searchByBarcodeScanning")
	
	$entry.enableTransaction()
	$entry.activateFavorite()
