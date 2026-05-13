Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	// Purpose: Entry labels use CAR / Corrective Action Report wording instead of QCARS (technical dataclass remains Qcar).
	// modified by 4D/PS [2026-may-12]
	$entry:=cs:C1710.sfw_definitionEntry.new("qcar"; ["qualityAssurance"]; "CAR")
	$entry.setDataclass("Qcar")
	$entry.setDisplayOrder(-400)
	$entry.setIcon("image/entry/qcar-white-50x50.png")
	
	$entry.setSearchboxField("qcarNumber")
	$entry.setSearchboxField("customer.name"; "placeholder:customer")
	$entry.setSearchboxField("category")
	$entry.setSearchboxField("lot.lotNumber"; "placeholder:lot")
	$entry.setSearchboxField("lot.poNumber"; "placeholder:po")
	
	$entry.setPanel("panel_qcar")
	$entry.setPanelPage(1; ""; "Main")
	$entry.setPanelPage(2; ""; "8D CA Report")
	$entry.setPanelPage(3; ""; "Objective Evidence")
	
	$entry.setLBItemsColumn("qcarNumber"; "#"; "width:40"; "center")
	$entry.setLBItemsColumn("customer.name"; "Customer"; "width:200")
	$entry.setLBItemsColumn("category"; "Category"; "width:140")
	$entry.setLBItemsColumn("issuedDate"; "Issued"; "width:70"; "center")
	
	$entry.setLBItemsOrderBy("qcarNumber")
	
	$view:=cs:C1710.sfw_definitionView.new("openQcars"; "Open CARs"; "derivedFrom:main"; $entry)
	$view.setSubset("openQcars")
	$view.setPictoLabel("/RESOURCES/ga/image/picto/open-qcars-16x16.png")
	$entry.setView($view)
	
	$view:=cs:C1710.sfw_definitionView.new("lateQcars"; "Late CARs"; "derivedFrom:main"; $entry)
	$view.setSubset("lateQcars")
	$view.setPictoLabel("/RESOURCES/ga/image/picto/late-qcars-16x16.png")
	$entry.setView($view)
	
	$view:=cs:C1710.sfw_definitionView.new("verifiedQcars"; "Verified CARs"; "derivedFrom:main"; $entry)
	$view.setSubset("verifiedQcars")
	$view.setPictoLabel("/RESOURCES/ga/image/picto/verified-qcars-16x16.png")
	$entry.setView($view)
	
	//$entry.setAllowedProfiles(qm)
	
	$entry.enableTransaction()
	
	// Purpose: Action labels reflect CAR wording; method identifiers unchanged for compatibility.
	// modified by 4D/PS [2026-may-12]
	$entry.setItemAction("Print corrective action report"; "QCARS_print_corrective_report")
	$entry.setItemAction("Print RMA report"; "QCARS_print_rma_report")
	
	$entry.setItemAction("Generate Barcode"; "_ga_openBarCodeForm")
	
	$entry.setItemListAction("Search by Scanning"; "_ga_searchByBarcodeScanning")
	
	
Function openQcars()->$qcars : cs:C1710.QcarSelection
	$qcars:=ds:C1482.Qcar.query("closedDate = :1"; !00-00-00!)
	
	
Function lateQcars()->$qcars : cs:C1710.QcarSelection
	$qcars:=ds:C1482.Qcar.query("targetCloseDate < :1 AND closedDate = :2"; Current date:C33(); !00-00-00!)
	
	
Function verifiedQcars()->$qcars : cs:C1710.QcarSelection
	$qcars:=ds:C1482.Qcar.query("verifiedDate # :1"; !00-00-00!)
	