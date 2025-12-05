

Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	//Mark: entry : Contact
	$entry:=cs:C1710.sfw_definitionEntry.new("JobInvoice"; ["customerService"]; "Invoices")
	$entry.setDataclass("JobInvoice")
	$entry.setDisplayOrder(-800)
	$entry.setIcon("image/entry/invoice-white-50x50.png")
	
	$entry.setSearchField("attribute:invoiceNumber"; "tag:InvoiceNumber")
	$entry.setSearchField("path:job.customer"; "tag:Customer"; "popupPart:Job"; "placeholder:customerName")
	$entry.setSearchField("path:job.jobNumber"; "tag:Job"; "placeholder:jobNumer")
	$entry.setSearchField("path:job.poNumber"; "tag:PO"; "placeholder:poNumber"; "onlyWithTag")
	
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
	
	
	
	// MARK: -Filters
	
	//$filter:=cs.sfw_definitionFilter.new("filterCustomerInvoices")
	//$filter.setDefaultTitle("All Customers")
	//$filter.setFilterByLinkedEntity("Customer"; "UUID_Job"; ""; "")
	//$filter.setDynamicTitle("name"; "## AML  supplier")
	//$entry.addFilter($filter)
	
	//$filter:=cs.sfw_definitionFilter.new("filterJob")
	//$filter.setDefaultTitle("All Jobs")
	//$filter.setFilterByLinkedEntity("Job"; "UUID_Job"; ""; "jobNumber")
	//$filter.setDynamicTitle("internalPartNum"; "## AML  ParNumber")
	//$filter.setOrderForItems("internalPartNum")
	//$filter.setAttributeLabelForItem("internalPartNum")
	//$entry.addFilter($filter)
	
	
	// MARK: -Views
	$view:=cs:C1710.sfw_definitionView.new("postedInvoices"; "Posted Invoices")  //; "derivedFrom:main"; $entry)
	$view.setSubset("postedInvoices")
	$view.setPictoLabel("/RESOURCES/ga/image/picto/archived-16x16.png")
	$view.setLBItemsColumn("invoiceNumber"; "Invoice#"; "width:100")
	$view.setLBItemsColumn("job.jobNumber"; "Job#"; "width:100")
	$view.setLBItemsColumn("job.customer"; "customer"; "width:100")
	$view.setLBItemsColumn("invoiceDate"; "Invoice Date"; "width:100")
	$view.setLBItemsOrderBy("invoiceNumber")
	$entry.setView($view)
	
	$view:=cs:C1710.sfw_definitionView.new("allReadyToInvoice"; "All ready to invoice")  //; "derivedFrom:main"; $entry)
	$view.setSubset("allReadyToInvoice")
	$view.setPictoLabel("/RESOURCES/ga/image/picto/archived-16x16.png")
	$view.setLBItemsColumn("invoiceNumber"; "Invoice#"; "width:100")
	$view.setLBItemsColumn("job.jobNumber"; "Job#"; "width:100")
	$view.setLBItemsColumn("job.customer"; "customer"; "width:100")
	$view.setLBItemsColumn("invoiceDate"; "Invoice Date"; "width:100")
	$view.setLBItemsOrderBy("invoiceNumber")
	$entry.setView($view)
	
	$view:=cs:C1710.sfw_definitionView.new("lineItemJobInvoices"; "Ready to invoice - Line-Item Jobs")  //; "derivedFrom:main"; $entry)
	$view.setSubset("lineItemJobInvoices")
	$view.setPictoLabel("/RESOURCES/ga/image/picto/archived-16x16.png")
	$view.setLBItemsColumn("invoiceNumber"; "Invoice#"; "width:100")
	$view.setLBItemsColumn("job.jobNumber"; "Job#"; "width:100")
	$view.setLBItemsColumn("job.customer"; "customer"; "width:100")
	$view.setLBItemsColumn("invoiceDate"; "Invoice Date"; "width:100")
	$view.setLBItemsOrderBy("invoiceNumber")
	$entry.setView($view)
	
	$view:=cs:C1710.sfw_definitionView.new("travelerBasedJobInvoices"; "Ready to invoice - Traveler-based Jobs")  //; "derivedFrom:main"; $entry)
	$view.setSubset("travelerBasedJobInvoices")
	$view.setPictoLabel("/RESOURCES/ga/image/picto/archived-16x16.png")
	$view.setLBItemsColumn("invoiceNumber"; "Invoice#"; "width:100")
	$view.setLBItemsColumn("job.jobNumber"; "Job#"; "width:100")
	$view.setLBItemsColumn("job.customer"; "customer"; "width:100")
	$view.setLBItemsColumn("invoiceDate"; "Invoice Date"; "width:100")
	$view.setLBItemsOrderBy("invoiceNumber")
	$entry.setView($view)
	
	
	
Function postedInvoices()->$invoices : cs:C1710.JobInvoiceSelection
	//cs.Util.me.setDateInterval(False)
	$invoices:=ds:C1482.JobInvoice.query("job.postToPO =:1 & job.archived =:2"; True:C214; False:C215)
	
Function allReadyToInvoice()->$invoices : cs:C1710.JobInvoiceSelection
	//cs.Util.me.setDateInterval(False)
	$invoices:=ds:C1482.JobInvoice.query("job.postToPO =:1 & job.archived =:2 & job.shipped =:3"; False:C215; False:C215; True:C214)
	
Function lineItemJobInvoices()->$invoices : cs:C1710.JobInvoiceSelection
	//cs.Util.me.setDateInterval(False)
	$invoices:=ds:C1482.JobInvoice.query("job.postToPO =:1 & job.archived =:2 & job.shipped =:3 & job.lineItem =:4"; False:C215; False:C215; True:C214; True:C214)
	
Function travelerBasedJobInvoices()->$invoices : cs:C1710.JobInvoiceSelection
	//cs.Util.me.setDateInterval(False)
	$invoices:=ds:C1482.JobInvoice.query("job.postToPO =:1 & job.archived =:2 & job.shipped =:3 & job.lineItem =:4"; False:C215; False:C215; True:C214; False:C215)
	
	