Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("purchaseOrders"; ["customerService"]; "Purchase Orders"; "Purchase Order")
	$entry.setDataclass("PurchaseOrder")
	$entry.setDisplayOrder(-100)
	$entry.setIcon("image/entry/purchase-orders-white-50x50.png")
	
	$entry.setSearchboxField("poNum")
	
	$entry.setPanel("panel_purchaseOrder")
	$entry.setPanelPage(1; "po-infos-32x32.png"; "Infos")
	$entry.setPanelPage(2; "line-items-32x32.png"; "Line Items")
	$entry.setPanelPage(3; "jobs-32x32.png"; "Jobs")
	$entry.setPanelPage(4; "lots-32x32.png"; "Lots")
	$entry.setPanelPage(5; "invoices-32x32.png"; "Invoices")
	
	$entry.setLBItemsColumn("poNum"; "PO Number"; "width:100")
	$entry.setLBItemsColumn("customer.name"; "Customer Name"; "width:250")
	$entry.setLBItemsColumn("amountBilled"; "Amount Billed"; "width:100"; "format:$##,###,###,##0.00")
	
	$entry.setLBItemsOrderBy("poNumber")
	
	//$entry.setValidationRule("poNumber"; "entryField_poNumber"; "mandatory"; "message:the poNumber is mandatory")
	$entry.setValidationRule("poNumber"; "entryField_poNumber"; "notZero"; "message:the poNumber is mandatory")
	$entry.setValidationRule("poNumber"; "entryField_poNumber"; "unique"; "message:the ident is must be unique")
	
	$entry.setItemAction("Generate Barcode"; "_ga_openBarCodeForm")
	
	$entry.setItemListAction("Search by Scanning"; "_ga_searchByBarcodeScanning")
	
	$entry.enableTransaction()
	