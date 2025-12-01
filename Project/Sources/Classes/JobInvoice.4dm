

Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	//Mark: entry : Contact
	$entry:=cs:C1710.sfw_definitionEntry.new("JobInvoice"; ["customerService"]; "Invoices")
	$entry.setDataclass("JobInvoice")
	$entry.setDisplayOrder(-800)
	$entry.setIcon("image/entry/invoice-white-50x50.png")
	
	$entry.setSearchboxField("invoiceNumber")
	$entry.setSearchboxField("invoiceNumber"; "placeholder:invoiceNumber")
	
	$entry.setPanel("panel_jobInvoice")
	$entry.setPanelPage(1; ""; "Main")
	$entry.setPanelPage(2; ""; "Lot Qty Amt Based"; "disabled:Form.current_item.job.lineItem=True")
	$entry.setPanelPage(3; ""; "PO Items Based")
	$entry.setPanelPage(4; ""; "Order Item"; "disabled:Form.current_item.job.lineItem=False")
	
	$entry.setLBItemsColumn("invoiceNumber"; "Invoice#"; "width:100")
	$entry.setLBItemsColumn("job.jobNumber"; "Job#"; "width:100")
	$entry.setLBItemsColumn("job.customer"; "customer"; "width:100")
	$entry.setLBItemsColumn("invoiceDate"; "Invoice Date"; "width:100")
	
	$entry.setLBItemsOrderBy("invoiceNumber")
	$entry.setMainViewLabel("All Invoices")
	
	$entry.enableTransaction()
	
	$entry.activateFavorite()
	