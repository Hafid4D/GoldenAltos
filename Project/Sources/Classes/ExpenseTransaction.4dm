// Purpose: SFW entry for vendor expense sub-ledger (legacy BUY_ITEMS expenses).
// created by 4D/PS [2026-june-09]
Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("ExpenseTransaction"; ["accounting"]; "Expense Transactions"; "ExpenseTransaction")
	$entry.setDataclass("ExpenseTransaction")
	$entry.setDisplayOrder(-1000)
	$entry.setIcon("image/entry/expenseTransaction-white-50x50.png")
	
	$entry.setSearchboxField("expenseNumber")
	
	$entry.setPanel("panel_expenseTransaction"; 1)
	$entry.setPanelPage(1; ""; "Main")
	
	$entry.setLBItemsColumn("expenseNumber"; "Expense #"; "width:80")
	$entry.setLBItemsOrderBy("expenseNumber")
	$entry.setMainViewLabel("All expense transactions")
	
	$entry.setItemListAction("Export to Excel"; "_ga_exportExpenseTransactionSelection")
	$entry.setItemAction("Generate Barcode"; "_ga_openBarCodeForm")
	$entry.setItemListAction("Search by Scanning"; "_ga_searchByBarcodeScanning")
	
	$entry.enableTransaction()
	$entry.activateFavorite()
