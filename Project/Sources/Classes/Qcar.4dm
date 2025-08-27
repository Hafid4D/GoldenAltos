Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("qcar"; ["qualityAssurance"]; "QCARS")
	$entry.setDataclass("Qcar")
	$entry.setDisplayOrder(-400)
	$entry.setIcon("image/entry/qcar-white-50x50.png")
	
	$entry.setSearchboxField("qcarNumber")
	$entry.setSearchboxField("lot.customer"; "placeholder:customer")
	$entry.setSearchboxField("category")
	$entry.setSearchboxField("lot.lotNumber"; "placeholder:lot")
	$entry.setSearchboxField("lot.poNumber"; "placeholder:po")
	
	$entry.setPanel("panel_qcar")
	$entry.setPanelPage(1; ""; "Main")
	$entry.setPanelPage(2; ""; "8D CA Report")
	
	$entry.setLBItemsColumn("qcarNumber"; "#"; "width:40"; "center")
	$entry.setLBItemsColumn("lot.customer"; "Customer"; "width:200")
	$entry.setLBItemsColumn("category"; "Category"; "width:140")
	$entry.setLBItemsColumn("issuedDate"; "Issued"; "width:70"; "center")
	
	$entry.setValidationRule("verifiedBy"; "entryField_verifiedBy"; "mandatory"; "message:The verifiedBy is mandatory")
	
	$entry.setLBItemsOrderBy("qcarNumber")
	
	$view:=cs:C1710.sfw_definitionView.new("openQcars"; "Open QCARS"; "derivedFrom:main"; $entry)
	$view.setSubset("openQcars")
	$view.setPictoLabel("/RESOURCES/ga/image/picto/open-qcars-16x16.png")
	$entry.setView($view)
	
	$view:=cs:C1710.sfw_definitionView.new("lateQcars"; "Late QCARS"; "derivedFrom:main"; $entry)
	$view.setSubset("lateQcars")
	$view.setPictoLabel("/RESOURCES/ga/image/picto/late-qcars-16x16.png")
	$entry.setView($view)
	
	$view:=cs:C1710.sfw_definitionView.new("verifiedQcars"; "Verified QCARS"; "derivedFrom:main"; $entry)
	$view.setSubset("verifiedQcars")
	$view.setPictoLabel("/RESOURCES/ga/image/picto/verified-qcars-16x16.png")
	$entry.setView($view)
	
	//$entry.setAllowedProfiles("qa")
	
	$filter:=cs:C1710.sfw_definitionFilter.new("filterCustomer")
	$filter.setDefaultTitle("All customers")
	$filter.setFilterByLinkedEntity("Customer"; "UUID_Customer"; ""; "customer")
	$filter.setDynamicTitle("name"; "## customers")
	$entry.addFilter($filter)
	
	
	$entry.enableTransaction()
	
	$entry.setItemAction("Print Report"; "QCARS_print_corrective_report")
	$entry.setItemAction("Print RMA"; "QCARS_print_rma_report")
	
	
Function openQcars()->$qcars : cs:C1710.QcarSelection
	$interval:=This:C1470.getInterval()
	
	If ($interval#Null:C1517)
		$qcars:=ds:C1482.Qcar.query("openDate >= :1 AND openDate <= :2 AND closedDate = :3"; $interval.start; $interval.end; !00-00-00!)
	Else 
		$qcars:=ds:C1482.Qcar.query("closedDate = :1"; !00-00-00!)
	End if 
	
	
Function lateQcars()->$qcars : cs:C1710.QcarSelection
	$interval:=This:C1470.getInterval()
	
	If ($interval#Null:C1517)
		$qcars:=ds:C1482.Qcar.query("targetCloseDate >= :1 AND targetCloseDate <= :2 AND closedDate = :3"; $interval.start; $interval.end; !00-00-00!)
	Else 
		$qcars:=ds:C1482.Qcar.query("targetCloseDate < :1 AND closedDate = :2"; Current date:C33(); !00-00-00!)
	End if 
	
	
Function verifiedQcars()->$qcars : cs:C1710.QcarSelection
	$interval:=This:C1470.getInterval()
	
	If ($interval#Null:C1517)
		$qcars:=ds:C1482.Qcar.query("verifiedDate >= :1 AND verifiedDate<= :2"; $interval.start; $interval.end)
	Else 
		$qcars:=ds:C1482.Qcar.query("verifiedDate # :1"; !00-00-00!)
	End if 
	
	
Function getInterval()->$interval : Object
	$form:=New object:C1471
	
	$form.startDate:=Current date:C33()
	$form.endDate:=Current date:C33()
	$form.interval:=0
	
	MOUSE POSITION:C468($mouseX; $mouseY; $mouseButtons)
	CONVERT COORDINATES:C1365($mouseX; $mouseY; XY Current form:K27:5; XY Main window:K27:8)
	
	$windRef:=Open window:C153($mouseX; $mouseY; $mouseX+270; $mouseY+165; Movable dialog box:K34:7; $title)
	DIALOG:C40("_ga_setDateInterval"; $form)
	CLOSE WINDOW:C154($windRef)
	
	If (ok=1)
		$interval:=New object:C1471(\
			"start"; $form.startDate; \
			"end"; $form.endDate\
			)
	End if 
	
	