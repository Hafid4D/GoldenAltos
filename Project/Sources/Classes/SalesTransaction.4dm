
// Purpose: SFW entry for the Accounts Receivable sub-ledger (GA3-T398 / legacy Receivables).
// created by 4D/PS [2026-june-08]
Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	// Purpose: Entry label aligned with Zoho GA3-T398 naming (Sales Transactions).
	// modified by 4D/PS [2026-june-08]
	$entry:=cs:C1710.sfw_definitionEntry.new("SalesTransaction"; ["accounting"]; "Sales Transactions"; "SalesTransaction")
	$entry.setDataclass("SalesTransaction")
	$entry.setDisplayOrder(-400)
	$entry.setIcon("image/entry/sales-Transaction-50x50.png")
	
	$entry.setSearchboxField("transactionNumber"; "placeholder:transactionNumber")
	$entry.setSearchboxField("customer.name"; "placeholder:customer")
	
	$entry.setPanel("panel_salesTransaction"; 1)
	$entry.setPanelPage(1; ""; "Main")
	
	$entry.setLBItemsColumn("transactionNumber"; "Num"; "width:60")
	$entry.setLBItemsColumn("transactionType.name"; "Type"; "width:100")
	$entry.setLBItemsColumn("transactionDate"; "Date"; "width:80")
	$entry.setLBItemsColumn("Amount"; "Amount"; "width:100")
	
	$entry.setLBItemsOrderBy("transactionNumber")
	$entry.setMainViewLabel("All sales transactions")
	
	// Purpose: Method names kept within the 4D 31-character limit.
	// modified by 4D/PS [2026-june-08]
	$entry.setItemListAction("Export to Excel"; "_ga_exportSalesTransactionSelec")
	$entry.setItemListAction("Print selection"; "_ga_printSalesTransSel")
	$entry.setItemListAction("-"; "-")
	$entry.setItemListAction("View Receivables Report"; "_ga_viewReceivablesReport")
	$entry.setItemListAction("Print Receivables Report"; "_ga_printReceivablesReport")
	$entry.setItemListAction("View Receivables Aging Report"; "_ga_viewReceivablesAging")
	$entry.setItemListAction("Print Receivables Aging Report"; "_ga_printReceivablesAging")
	
	$entry.setItemAction("Receive Payement"; "_ga_receivePayement")
	$entry.setItemAction("Generate Barcode"; "_ga_openBarCodeForm")
	$entry.setItemListAction("Search by Scanning"; "_ga_searchByBarcodeScanning")
	
	$entry.setValidationRule("Amount"; "entryField_amount")
	$entry.setValidationRule("memo"; "entryField_memo")
	$entry.setValidationRule("transactionDate"; "entryField_transactionDate")
	$entry.setValidationRule("dueDate"; "entryField_dueDate")
	$entry.setValidationRule("openBalance"; "entryField_openBalance")
	
	$entry.setSubset("main")
	
	$entry.enableTransaction()
	$entry.activateFavorite()
	
	
Function main()->$transactions : cs:C1710.SalesTransactionSelection
	$transactions:=ds:C1482.SalesTransaction.all()
	
	