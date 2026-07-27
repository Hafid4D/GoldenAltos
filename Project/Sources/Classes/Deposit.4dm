// Purpose: SFW entry for customer deposit slips (legacy Deposits / Deposit_Items).
// created by 4D/PS [2026-june-22]
Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("Deposit"; ["accounting"]; "Deposits"; "Deposit")
	$entry.setDataclass("Deposit")
	$entry.setDisplayOrder(-500)
	$entry.setIcon("image/entry/deposit-white-50x50.png")
	
	$entry.setSearchboxField("depositNumber")
	
	$entry.setPanel("panel_deposit"; 1)
	$entry.setPanelPage(1; ""; "Main")
	
	$entry.setLBItemsColumn("depositNumber"; "Deposit #"; "width:60")
	// Purpose: List columns bind to typed catalog fields (not moreData helpers).
	// modified by 4D/PS [2026-june-29]
	$entry.setLBItemsColumn("depositDate"; "Date"; "width:80")
	$entry.setLBItemsColumn("bankAccountName"; "Account"; "width:120")
	$entry.setLBItemsColumn("total"; "Total"; "width:80")
	$entry.setLBItemsOrderBy("depositNumber")
	$entry.setMainViewLabel("All deposits")
	
	$entry.setItemListAction("Export to Excel"; "_ga_exportDepositSelection")
	$entry.setItemAction("Print Deposit Receipt"; "_ga_printDepositReceipt")
	$entry.setItemAction("Generate Barcode"; "_ga_openBarCodeForm")
	$entry.setItemListAction("Search by Scanning"; "_ga_searchByBarcodeScanning")
	
	$entry.enableTransaction()
	$entry.activateFavorite()


// Purpose: Return the next available depositNumber for a new deposit slip.
// Returns: Integer
// created by 4D/PS [2026-june-22]
Function nextDepositNumber()->$num : Integer
	var $max : Integer
	
	$max:=This:C1470.all().extract("depositNumber").max()
	$num:=($max=Null:C1517) ? 1 : $max+1
