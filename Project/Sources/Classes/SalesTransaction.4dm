
// Purpose: SFW entry for the Accounts Receivable sub-ledger (GA3-T398 / legacy Receivables).
// created by 4D/PS [2026-june-08]
Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("SalesTransaction"; ["accounting"]; "Received Transactions"; "SalesTransaction")
	$entry.setDataclass("SalesTransaction")
	$entry.setDisplayOrder(-400)
	$entry.setIcon("image/entry/sales-Transaction-50x50.png")
	
	$entry.setSearchboxField("transactionNumber"; "placeholder:transactionNumber")
	$entry.setSearchboxField("customer.name"; "placeholder:customer")
	
	$entry.setPanel("panel_salesTransaction"; 1)
	$entry.setPanelPage(1; ""; "Main")
	
	$entry.setLBItemsColumn("transactionType.name"; "Type"; "width:100")
	$entry.setLBItemsColumn("transactionNumber"; "Num"; "width:60")
	$entry.setLBItemsColumn("transactionDate"; "Date"; "width:80")
	$entry.setLBItemsColumn("customer.name"; "Customer"; "width:200")
	$entry.setLBItemsColumn("Amount"; "Amount"; "width:100")
	$entry.setLBItemsColumn("openBalance"; "Open Balance"; "width:100")
	
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
	
	$entry.enableTransaction()
	$entry.activateFavorite()
	
	
// Purpose: Parse legacy receivable invoice label prefix (CM / PY / blank) into a type code.
// Parameters:
// $invoiceLabel : Text — legacy invoice field (e.g. "CM 12345", "PY 99", "12345")
// Returns: Text — type code (INV, CM, PAY, DEP)
// created by 4D/PS [2026-june-08]
Function mapLegacyTypeCode($invoiceLabel : Text)->$typeCode : Text
	
	$parts:=Split string:C1554($invoiceLabel; " "; sk trim spaces:K86:2)
	Case of
		: ($parts.length=0)
			$typeCode:="INV"
		: ($parts[0]="CM")
			$typeCode:="CM"
		: ($parts[0]="PY")
			$typeCode:="PAY"
		: ($parts[0]="DEP")
			$typeCode:="DEP"
		Else
			$typeCode:="INV"
	End case
	
	
// Purpose: Extract numeric transaction number from a legacy invoice label.
// Parameters:
// $invoiceLabel : Text — legacy invoice field
// Returns: Integer — parsed number, or 0 when not found
// created by 4D/PS [2026-june-08]
Function parseLegacyTransactionNumber($invoiceLabel : Text)->$number : Integer
	
	$parts:=Split string:C1554($invoiceLabel; " "; sk trim spaces:K86:2)
	$last:=$parts[$parts.length-1]
	$number:=Num:C11($last)
	
	
