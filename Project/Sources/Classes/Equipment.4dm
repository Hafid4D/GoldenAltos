
Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	//Mark: entry : Contact
	$entry:=cs:C1710.sfw_definitionEntry.new("equipment"; ["qualityAssistance"]; "Equipments")
	$entry.setDataclass("Equipment")
	$entry.setSearchboxField("assignedID")
	$entry.setDisplayOrder(100)
	$entry.setIcon("image/entry/equipment-white-50x50.png")
	
	$entry.setSearchboxField("assignedID"; "placeholder:ID")
	
	$entry.setPanel("panel_equipment")
	$entry.setPanelPage(1; ""; "Main")
	$entry.setPanelPage(2; ""; "Repair Log")
	
	$entry.setLBItemsColumn("assignedID"; "assigned ID"; "width:200")
	$entry.setLBItemsColumn("serialNumber"; "Serial number"; "width:100")
	$entry.setLBItemsOrderBy("assignedID")
	
	$entry.setItemListAction("Export equipments list"; "_ga_exportEquipmentList")
	$entry.setItemListAction("-"; "-")
	$entry.setItemListAction("Print equipments list"; "_ga_printEquipmentList")
	$entry.setItemListAction("-"; "-")
	$entry.setItemListAction("Print Cal Sticker"; "_ga_printCalStickers")
	$entry.setItemListAction("-"; "-")
	$entry.setItemListAction("Print PM Sticker"; "_ga_printPMStickers")
	
	$entry.setItemAction("Print Repair Log Report"; "_ga_printRepairLogReport")
	$entry.setItemAction("Print Usage Log Report"; "_ga_usageLogReport")
	
	
	$entry.enableTransaction()
	
	// MARK: -Filters
	
	$filter:=cs:C1710.sfw_definitionFilter.new("filterEquipmentLocation")
	$filter.setDefaultTitle("All locations")
	$filter.setFilterByIDInTable("EquipmentLocation"; "locationID"; "locationID")
	$filter.setDynamicTitle("name"; "## equipment location")
	$entry.addFilter($filter)
	
	$filter:=cs:C1710.sfw_definitionFilter.new("filterEquipmentType")
	$filter.setDefaultTitle("All types")
	$filter.setFilterByLinkedEntity("ToolType"; "UUID_ToolType"; ""; "type")
	$filter.setDynamicTitle("name"; "## equipment type")
	$entry.addFilter($filter)
	
	$filter:=cs:C1710.sfw_definitionFilter.new("filterEquipmentDivision")
	$filter.setDefaultTitle("All divisions")
	$filter.setFilterByIDInTable("Division"; "divisionID"; "divisionID")
	$filter.setDynamicTitle("name"; "## equipment division")
	$entry.addFilter($filter)
	
	
	
	
	// MARK: - Views Definition
	
	// MARK: Equipment out of calibration List
	$view:=cs:C1710.sfw_definitionView.new("equipmentsOutOfCalibration"; "Equipments out of calibration")
	$view.setLBItemsColumn("assignedID"; "assigned ID")
	$view.setLBItemsColumn("serialNumber"; "Serial number"; "width:200")
	$view.setLBItemsOrderBy("assignedID")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:equipment"; "unitN:equipments")
	$view.setSubset("equipmentsOutOfCalibration")
	$entry.setView($view)
	
	// MARK: Prevent Maintenance List
	$view:=cs:C1710.sfw_definitionView.new("pmEquipments"; "Prevent Maintenance equipments")
	$view.setLBItemsColumn("assignedID"; "assigned ID")
	$view.setLBItemsColumn("serialNumber"; "Serial number"; "width:200")
	$view.setLBItemsOrderBy("assignedID")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:equipment"; "unitN:equipments")
	$view.setSubset("pmEquipments")
	$entry.setView($view)
	
	// MARK: Due calibration List
	$view:=cs:C1710.sfw_definitionView.new("dueCalibrationEquipments"; "Due calibration equipments")
	$view.setLBItemsColumn("assignedID"; "assigned ID")
	$view.setLBItemsColumn("serialNumber"; "Serial number"; "width:200")
	$view.setLBItemsOrderBy("assignedID")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:equipment"; "unitN:equipments")
	$view.setSubset("dueCalibrationEquipments")
	$entry.setView($view)
	
	// MARK: Due Prevent Maintenance List
	$view:=cs:C1710.sfw_definitionView.new("duePMEquipments"; "Due Prevent Maintenance equipments")
	$view.setLBItemsColumn("assignedID"; "assigned ID")
	$view.setLBItemsColumn("serialNumber"; "Serial number"; "width:200")
	$view.setLBItemsOrderBy("assignedID")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:equipment"; "unitN:equipments")
	$view.setSubset("duePMEquipments")
	$entry.setView($view)
	
	// MARK:  List of equipment down
	$view:=cs:C1710.sfw_definitionView.new("equipmentsDownOrOnHold"; "Equipments down")
	$view.setLBItemsColumn("assignedID"; "assigned ID")
	$view.setLBItemsColumn("serialNumber"; "Serial number"; "width:200")
	$view.setLBItemsOrderBy("assignedID")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:equipment"; "unitN:equipments")
	$view.setSubset("equipmentsDownOrOnHold")
	$entry.setView($view)
	
	
local Function cacheLoad()
	
	If (Storage:C1525.cache=Null:C1517)
		Use (Storage:C1525)
			Storage:C1525.cache:=New shared object:C1526
		End use 
	End if 
	If (Storage:C1525.cache.startDate=Null:C1517)
		Use (Storage:C1525.cache)
			Storage:C1525.cache.startDate:=Current date:C33()
		End use 
	End if 
	If (Storage:C1525.cache.endDate=Null:C1517)
		Use (Storage:C1525.cache)
			Storage:C1525.cache.endDate:=Current date:C33()
		End use 
	End if 
	If (Undefined:C82(Storage:C1525.cache.interval))
		Use (Storage:C1525.cache)
			Storage:C1525.cache.interval:="0"
		End use 
	End if 
	
	
local Function setDateInterval($pushUp; $title)
	This:C1470.cacheLoad()
	
	$form:=New object:C1471
	$form.startDate:=Storage:C1525.cache.startDate
	$form.endDate:=Storage:C1525.cache.endDate
	$form.interval:=Storage:C1525.cache.interval
	MOUSE POSITION:C468($mouseX; $mouseY; $mouseButtons)
	CONVERT COORDINATES:C1365($mouseX; $mouseY; XY Current form:K27:5; XY Main window:K27:8)
	If ($pushUp)
		$mouseY:=$mouseY-190
		$mouseX:=$mouseX-100
	End if 
	$form.pushUp:=$pushUp
	$windRef:=Open window:C153($mouseX; $mouseY; $mouseX+270; $mouseY+165; Movable dialog box:K34:7; $title)
	DIALOG:C40("_ga_setDateInterval"; $form)
	CLOSE WINDOW:C154($windRef)
	Use (Storage:C1525.cache)
		Storage:C1525.cache.startDate:=$form.startDate
		Storage:C1525.cache.endDate:=$form.endDate
		Storage:C1525.cache.interval:=$form.interval
	End use 
	
	
Function equipmentsOutOfCalibration()->$equipments : cs:C1710.EquipmentSelection
	$title:="Set date interval"
	This:C1470.setDateInterval(False:C215; $title)
	$equipments:=ds:C1482.Equipment.query("nextCalDate<=:1 & calibrationNotRequired=:2 & notAtSite=:3"; Storage:C1525.cache.endDate; False:C215; False:C215)
	
	
Function pmEquipments()->$equipments : cs:C1710.EquipmentSelection
	$title:="Set date interval"
	This:C1470.setDateInterval(False:C215; $title)
	$equipments:=ds:C1482.Equipment.query("nextPMDate<=:1 & nextPMDate#:2 & notAtSite=:3"; Storage:C1525.cache.endDate; !00-00-00!; False:C215)
	
	
Function dueCalibrationEquipments()->$equipments : cs:C1710.EquipmentSelection
	$title:="Set date interval"
	This:C1470.setDateInterval(False:C215; $title)
	$equipments:=ds:C1482.Equipment.query("nextCalDate<=:1 & notAtSite=:2 & engg=:3"; Storage:C1525.cache.endDate; False:C215; False:C215)
	
	
Function duePMEquipments()->$equipments : cs:C1710.EquipmentSelection
	$title:="Set date interval"
	This:C1470.setDateInterval(False:C215; $title)
	$equipments:=ds:C1482.Equipment.query("nextPMDate<=:1 & nextPMDate#:2 & notAtSite=:3 & engg=:4"; Storage:C1525.cache.endDate; !00-00-00!; False:C215; False:C215)
	
	
Function equipmentsDownOrOnHold()->$equipments : cs:C1710.EquipmentSelection
	
	$equipments:=ds:C1482.Equipment.query("down=:1"; True:C214)
	
	
	
	