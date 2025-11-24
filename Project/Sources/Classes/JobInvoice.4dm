

Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	//Mark: entry : Contact
	$entry:=cs:C1710.sfw_definitionEntry.new("JobInvoice"; ["customerService"]; "Invoices")
	$entry.setDataclass("JobInvoice")
	$entry.setDisplayOrder(-800)
	$entry.setIcon("image/entry/invoice-white-50x50.png")
	
	$entry.setSearchboxField("invoiceNumber")
	$entry.setSearchboxField("invoiceNumber"; "placeholder:invoiceNumber")
	
	$entry.setPanelPage(1; "staff-32x32.png"; "Main")
	$entry.setPanel("panel_jobInvoice")
	$entry.setLBItemsColumn("invoiceNumber"; "Invoice#"; "width:100")
	$entry.setLBItemsColumn("job.jobNumber"; "Job#"; "width:100")
	$entry.setLBItemsColumn("job.customer"; "customer"; "width:100")
	$entry.setLBItemsColumn("invoiceDate"; "Invoice Date"; "width:100")
	
	$entry.setLBItemsOrderBy("invoiceNumber")
	$entry.setMainViewLabel("All Invoices")
	
	$entry.enableTransaction()
	
	$entry.activateFavorite()
	