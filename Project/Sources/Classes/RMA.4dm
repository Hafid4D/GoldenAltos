Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("rma"; ["qualityAssurance"]; "RMA")
	$entry.setDataclass("RMA")
	$entry.setDisplayOrder(-500)
	$entry.setIcon("image/entry/rma-white-50x50.png")
	
	$entry.setSearchboxField("rmaNumber")
	$entry.setSearchField("path:dateReceived"; "tag:receivedYear"; "placeholder:receivedYear"; "date")
	
	$entry.setPanel("panel_rma"; 2)
	$entry.setPanelPage(1; ""; "Main")
	
	
	$entry.setLBItemsColumn("rmaNumber"; "#"; "width:40"; "center")
	$entry.setLBItemsColumn("qcar.customer.name"; "Customer"; "width:200")
	$entry.setLBItemsColumn("invoiceNumber"; "Invoice"; "width:140")
	// Apr 22, 2026 4DFix: "receivedDate" did not match the computed attribute name "dateReceived" in RMAEntity — column was always empty
	$entry.setLBItemsColumn("dateReceived"; "Received"; "width:70"; "center")
	
	$entry.setItemAction("Generate Barcode"; "_ga_openBarCodeForm")
	
	$entry.setItemListAction("Search by Scanning"; "_ga_searchByBarcodeScanning")
	
	$entry.setLBItemsOrderBy("rmaNumber")
	
	$entry.enableTransaction()
	
	
	//Mark: - Filters
	$filter:=cs:C1710.sfw_definitionFilter.new("filterCustomer")
	$filter.setDefaultTitle("All customers")
	$filter.setFilterByLinkedEntity("Customer"; "qcar.customer.UUID"; "customerUUID"; "qcar.customer")
	$filter.setDynamicTitle("name"; "## RMA customers")
	$entry.addFilter($filter)
	
	
	
	////Mark: - Views
	//$view:=cs.sfw_definitionView.new("RmaByYear"; "RMA by Year"; "derivedFrom:main"; $entry)
	//$view.setSubset("RmaByYear")
	//$entry.setView($view)
	
	
	
	//Function RmaByYear()->$rmas : cs.RMASelection
	
	
	//$form:=New object
	//$form.lb_data:=New collection()
	//$data:=ds.RMA.all().extract("dateReceived").map(Formula(_ga_yearOfFormula))
	//For each ($value; $data)
	
	//$form.lb_data.push(New object("value"; $value))
	//End for each 
	//$form.selectedPos:=0
	//$form.selected:=New object("value"; "")
	//$form.title:="Select a Year"
	
	//$form:=EXECUTE ON CLIENT(_ga_callCustomFilter($form))
	////If (OK=1)
	
	//$formula:=Formula(Num(Year of(This.dateReceived))=Num($form.selected.value))
	//$rmas:=ds.RMA.query($formula)
	
	//Else 
	
	//End if 
	
	
	
	
	
	