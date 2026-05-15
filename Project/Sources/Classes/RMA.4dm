Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("rma"; ["qualityAssurance"]; "RMA")
	$entry.setDataclass("RMA")
	$entry.setDisplayOrder(-500)
	$entry.setIcon("image/entry/rma-white-50x50.png")
	
	$entry.setSearchboxField("rmaNumber")
	
	
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
	
	
	
	//Mark: -Views
	$view:=cs:C1710.sfw_definitionView.new("RmaByYear"; "RMA by Year"; "derivedFrom:main"; $entry)
	$view.setSubset("RmaByYear")
	$entry.setView($view)
	
	
Function RmaByYear()->$rmas : cs:C1710.RMASelection
	
	
	$form:=New object:C1471
	$form.lb_data:=New collection:C1472()
	$data:=ds:C1482.RMA.all().extract("dateReceived").map(Formula:C1597(_ga_yearOfFormula))
	For each ($value; $data)
		
		$form.lb_data.push(New object:C1471("value"; $value))
	End for each 
	$form.selectedPos:=0
	$form.selected:=New object:C1471("value"; "")
	$form.title:="Select a Year"
	
	MOUSE POSITION:C468($mouseX; $mouseY; $mouseButtons)
	CONVERT COORDINATES:C1365($mouseX; $mouseY; XY Current form:K27:5; XY Main window:K27:8)
	If ($pushUp)
		$mouseY:=$mouseY-190
		$mouseX:=$mouseX-100
	End if 
	
	$windRef:=Open window:C153($mouseX; $mouseY; $mouseX+270; $mouseY+165; Movable dialog box:K34:7; "Set date interval")
	
	DIALOG:C40("_ga_customFilter"; $form)
	
	//If (OK=1)
	
	$formula:=Formula:C1597(Num:C11(Year of:C25(This:C1470.dateReceived))=Num:C11($form.selected.value))
	$rmas:=ds:C1482.RMA.query($formula)
	
	//Else 
	
	//End if 
	
	
	
	
	
	