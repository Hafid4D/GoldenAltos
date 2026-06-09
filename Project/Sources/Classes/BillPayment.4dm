// Purpose: SFW entry for vendor bill payments (legacy PartialPays / check run).
// created by 4D/PS [2026-june-09]
Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("BillPayment"; ["accounting"]; "Bill Payments"; "BillPayment")
	$entry.setDataclass("BillPayment")
	$entry.setDisplayOrder(-800)
	$entry.setIcon("image/entry/billPayment-white-50x50.png")
	
	$entry.setSearchboxField("paymentNumber")
	
	$entry.setPanel("panel_billPayment"; 1)
	$entry.setPanelPage(1; ""; "Main")
	
	$entry.setLBItemsColumn("paymentNumber"; "Payment #"; "width:80")
	$entry.setLBItemsOrderBy("paymentNumber")
	$entry.setMainViewLabel("All bill payments")
	
	$entry.setItemListAction("Export to Excel"; "_ga_exportBillPaymentSelection")
	$entry.setItemAction("Generate Barcode"; "_ga_openBarCodeForm")
	$entry.setItemListAction("Search by Scanning"; "_ga_searchByBarcodeScanning")
	
	$entry.enableTransaction()
	$entry.activateFavorite()
