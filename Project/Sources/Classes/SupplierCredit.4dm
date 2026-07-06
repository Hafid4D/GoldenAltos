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
	// Purpose: Show typed vendor credit columns in the entry list (legacy CM_items fields).
	// modified by 4D/PS [2026-june-29]
	$entry.setLBItemsColumn("vendorName"; "Vendor"; "width:180")
	$entry.setLBItemsColumn("billSeqNumber"; "Bill #"; "width:70")
	$entry.setLBItemsColumn("amount"; "Amount"; "width:80")
	$entry.setLBItemsOrderBy("creditNumber")
	$entry.setMainViewLabel("All supplier credits")
	
	// Purpose: Use export method name within 4D 31-character method limit.
	// modified by 4D/PS [2026-june-09]
	$entry.setItemListAction("Export to Excel"; "_ga_exportSuppCreditSelection")
	$entry.setItemAction("Generate Barcode"; "_ga_openBarCodeForm")
	$entry.setItemListAction("Search by Scanning"; "_ga_searchByBarcodeScanning")
	
	$entry.enableTransaction()
	$entry.activateFavorite()
