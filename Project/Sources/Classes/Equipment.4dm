
Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	//Mark: entry : Equipment
	$entry:=cs:C1710.sfw_definitionEntry.new("equipment"; ["qualityAssurance"]; "Equipments")
	$entry.setDataclass("Equipment")
	$entry.setSearchboxField("assignedID")
	$entry.setDisplayOrder(100)
	$entry.setIcon("image/entry/equipment-white-50x50.png")
	
	$entry.setSearchboxField("assignedID"; "placeholder:ID")
	
	$entry.setPanel("panel_equipment")
	$entry.setPanelPage(1; ""; "Main")
	$entry.setPanelPage(2; ""; "Repair Log")
	$entry.setPanelPage(3; ""; "Documents")
	
	$entry.setLBItemsColumn("assignedID"; "Equipment ID"; "width:125")
	$entry.setLBItemsColumn("serialNumber"; "Serial number"; "width:125")
	$entry.setLBItemsColumn("type.name"; "Equipment Type"; "width:200")
	$entry.setLBItemsOrderBy("assignedID")
	
	$entry.setItemListAction("Export equipments list"; "_ga_exportEquipmentList")
	$entry.setItemListAction("-"; "-")
	$entry.setItemListAction("Print equipments list"; "_ga_printEquipmentList")
	$entry.setItemListAction("-"; "-")
	$entry.setItemListAction("Print Cal Sticker"; "_ga_printCalStickers")
	$entry.setItemListAction("-"; "-")
	$entry.setItemListAction("Print PM Sticker"; "_ga_printPMStickers")
	
	$entry.setItemAction("Print Repair Log Report"; "_ga_printRepairLogReport")
	
	$entry.setItemAction("Print Usage Log EquipTraveler"; "_ga_usageLogReport")
	
	
	
	$entry.enableTransaction()
	
	// MARK: -Filters
	
	$filter:=cs:C1710.sfw_definitionFilter.new("filterEquipmentLocation")
	$filter.setDefaultTitle("All locations")
	$filter.setFilterByLinkedEntity("EquipmentLocation"; "UUID_EquipmentLocation"; ""; "location")
	$filter.setDynamicTitle("name"; "## equipment location")
	$entry.addFilter($filter)
	
	$filter:=cs:C1710.sfw_definitionFilter.new("filterEquipmentType")
	$filter.setDefaultTitle("All types")
	$filter.setFilterByLinkedEntity("ToolType"; "UUID_ToolType"; ""; "type")
	$filter.setDynamicTitle("name"; "## equipment type")
	$entry.addFilter($filter)
	
	$filter:=cs:C1710.sfw_definitionFilter.new("filterEquipmentDivision")
	$filter.setDefaultTitle("All divisions")
	$filter.setFilterByLinkedEntity("Division"; "UUID_Division"; ""; "division")
	$filter.setDynamicTitle("name"; "## equipment division")
	$entry.addFilter($filter)
	
	
	
	// MARK: - Views Definition
	
	// MARK: Equipment out of calibration List
	$view:=cs:C1710.sfw_definitionView.new("equipmentsOutOfCalibration"; "Equipments out of calibration")  //Calibration Overdue
	$view.setLBItemsColumn("assignedID"; "Equipment ID"; "width:125")
	$view.setLBItemsColumn("serialNumber"; "Serial number"; "width:125")
	$view.setLBItemsColumn("type.name"; "Equipment Type"; "width:200")
	$view.setLBItemsOrderBy("assignedID")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:equipment"; "unitN:equipments")
	$view.setSubset("equipmentsOutOfCalibration")
	$entry.setView($view)
	
	// MARK: List of Equipments to be calibrated in X days
	$view:=cs:C1710.sfw_definitionView.new("dueCalibrationEquipments"; "Equipments to be calibrated in X days")
	$view.setLBItemsColumn("assignedID"; "Equipment ID"; "width:125")
	$view.setLBItemsColumn("serialNumber"; "Serial number"; "width:125")
	$view.setLBItemsColumn("type.name"; "Equipment Type"; "width:200")
	$view.setLBItemsOrderBy("assignedID")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:equipment"; "unitN:equipments")
	$view.setSubset("dueCalibrationEquipments")
	$entry.setView($view)
	
	// MARK: List of Equipments to be calibrated in X days Exclude NPU
	$view:=cs:C1710.sfw_definitionView.new("dueCalibrationEquipmentsExculeNPU"; "Equipments to be calibrated in X days exclude NPU")
	$view.setLBItemsColumn("assignedID"; "Equipment ID"; "width:125")
	$view.setLBItemsColumn("serialNumber"; "Serial number"; "width:125")
	$view.setLBItemsColumn("type.name"; "Equipment Type"; "width:200")
	$view.setLBItemsOrderBy("assignedID")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:equipment"; "unitN:equipments")
	$view.setSubset("dueCalibrationEquipmentsExculeNPU")
	$entry.setView($view)
	
	// MARK:  List of equipment not requiring calibration
	$view:=cs:C1710.sfw_definitionView.new("calibrationNotRequired"; "Equipments not requiring calibration")
	$view.setLBItemsColumn("assignedID"; "Equipment ID"; "width:125")
	$view.setLBItemsColumn("serialNumber"; "Serial number"; "width:125")
	$view.setLBItemsColumn("type.name"; "Equipment Type"; "width:200")
	$view.setLBItemsOrderBy("assignedID")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:equipment"; "unitN:equipments")
	$view.setSubset("calibrationNotRequired")
	$entry.setView($view)
	
	
	
	// MARK: Prevent Maintenance equipments within X days
	$view:=cs:C1710.sfw_definitionView.new("pmEquipments"; "Prevent Maintenance within X days")
	$view.setLBItemsColumn("assignedID"; "Equipment ID"; "width:125")
	$view.setLBItemsColumn("serialNumber"; "Serial number"; "width:125")
	$view.setLBItemsColumn("type.name"; "Equipment Type"; "width:200")
	$view.setLBItemsOrderBy("assignedID")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:equipment"; "unitN:equipments")
	$view.setSubset("pmEquipments")
	$entry.setView($view)
	
	
	// MARK: Prevent Maintenance equipments within X days Exlude NPU
	$view:=cs:C1710.sfw_definitionView.new("duePMEquipmentsExcludeNPU"; "Prevent Maintenance within X days exclude NPU")
	$view.setLBItemsColumn("assignedID"; "Equipment ID"; "width:125")
	$view.setLBItemsColumn("serialNumber"; "Serial number"; "width:125")
	$view.setLBItemsColumn("type.name"; "Equipment Type"; "width:200")
	$view.setLBItemsOrderBy("assignedID")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:equipment"; "unitN:equipments")
	$view.setSubset("duePMEquipmentsExcludeNPU")
	$entry.setView($view)
	
	
	// MARK: NPU Equipments list
	$view:=cs:C1710.sfw_definitionView.new("NPUEquipments"; "NPU Equipments")
	$view.setLBItemsColumn("assignedID"; "Equipment ID"; "width:125")
	$view.setLBItemsColumn("serialNumber"; "Serial number"; "width:125")
	$view.setLBItemsColumn("type.name"; "Equipment Type"; "width:200")
	$view.setLBItemsOrderBy("assignedID")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:equipment"; "unitN:equipments")
	$view.setSubset("NPUEquipments")
	$entry.setView($view)
	
	// MARK:  List of equipment down
	$view:=cs:C1710.sfw_definitionView.new("equipmentsDownOrOnHold"; "Equipments down")
	$view.setLBItemsColumn("assignedID"; "Equipment ID"; "width:125")
	$view.setLBItemsColumn("serialNumber"; "Serial number"; "width:125")
	$view.setLBItemsColumn("type.name"; "Equipment Type"; "width:200")
	$view.setLBItemsOrderBy("assignedID")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:equipment"; "unitN:equipments")
	$view.setSubset("equipmentsDownOrOnHold")
	$entry.setView($view)
	
	
	// MARK:  List of equipment Decommissioned
	$view:=cs:C1710.sfw_definitionView.new("decommissionedEquipment"; "Decommissioned Equipments")
	$view.setLBItemsColumn("assignedID"; "Equipment ID"; "width:125")
	$view.setLBItemsColumn("serialNumber"; "Serial number"; "width:125")
	$view.setLBItemsColumn("type.name"; "Equipment Type"; "width:200")
	$view.setLBItemsOrderBy("assignedID")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:equipment"; "unitN:equipments")
	$view.setSubset("decommissionedEquipment")
	$entry.setView($view)
	
	// MARK:  PM Required Equipements
	$view:=cs:C1710.sfw_definitionView.new("PMRequiredEquipments"; "PM Required")
	$view.setLBItemsColumn("assignedID"; "Equipment ID"; "width:125")
	$view.setLBItemsColumn("serialNumber"; "Serial number"; "width:125")
	$view.setLBItemsColumn("type.name"; "Equipment Type"; "width:200")
	$view.setLBItemsOrderBy("assignedID")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:equipment"; "unitN:equipments")
	$view.setSubset("PMRequiredEquipments")
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
	$windRef:=Open window:C153($mouseX; $mouseY; $mouseX+270; $mouseY+165; Movable dialog box:K34:7; "Set date interval")
	DIALOG:C40("_ga_setDateInterval"; $form)
	CLOSE WINDOW:C154($windRef)
	Use (Storage:C1525.cache)
		Storage:C1525.cache.startDate:=$form.startDate
		Storage:C1525.cache.endDate:=$form.endDate
		Storage:C1525.cache.interval:=$form.interval
	End use 
	
	
local Function equipmentsOutOfCalibration()->$equipments : cs:C1710.EquipmentSelection  //Calibration Overdue
	$equipments:=ds:C1482.Equipment.query("nextCalDate<=:1 & calibrationNotRequired=:2 & notAtSite=:3"; Current date:C33(*); False:C215; False:C215)  // Storage.cache.endDate
	
local Function dueCalibrationEquipments()->$equipments : cs:C1710.EquipmentSelection  //List of equip to be calibrated within X days
	Use (Storage:C1525.cache)
		Storage:C1525.cache.startDate:=Current date:C33(*)
	End use 
	This:C1470.setDateInterval(False:C215)
	$equipments:=ds:C1482.Equipment.query("nextCalDate<=:1 & notAtSite=:2"; Storage:C1525.cache.endDate; False:C215)
	
local Function dueCalibrationEquipmentsExculeNPU()->$equipments : cs:C1710.EquipmentSelection  //List of equip to be calibrated within X days exclude NPU 
	Use (Storage:C1525.cache)
		Storage:C1525.cache.startDate:=Current date:C33(*)
	End use 
	This:C1470.setDateInterval(False:C215)
	$equipments:=ds:C1482.Equipment.query("nextCalDate<=:1 & notAtSite=:2 & engg=:3"; Storage:C1525.cache.endDate; False:C215; False:C215)
	
local Function calibrationNotRequired()->$equipments : cs:C1710.EquipmentSelection
	$equipments:=ds:C1482.Equipment.query("calibrationNotRequired=:1"; True:C214)
	
	
	
local Function PMRequiredEquipments()->$equipments : cs:C1710.EquipmentSelection  //PM Required Equipments
	$equipments:=ds:C1482.Equipment.query("nextPMDate<=:1 & nextPMDate#:2 & notAtSite=:3"; Current date:C33(*); !00-00-00!; False:C215)  // Storage.cache.endDate
	
local Function pmEquipments()->$equipments : cs:C1710.EquipmentSelection  //Prevent Maintenance equipments within X days
	Use (Storage:C1525.cache)
		Storage:C1525.cache.startDate:=Current date:C33(*)
	End use 
	This:C1470.setDateInterval(False:C215)
	$equipments:=ds:C1482.Equipment.query("nextPMDate<=:1 & nextPMDate#:2 & notAtSite=:3"; Storage:C1525.cache.endDate; !00-00-00!; False:C215)
	
local Function duePMEquipmentsExcludeNPU()->$equipments : cs:C1710.EquipmentSelection  //Prevent Maintenance equipments within X days exclude NPU
	Use (Storage:C1525.cache)
		Storage:C1525.cache.startDate:=Current date:C33(*)
	End use 
	This:C1470.setDateInterval(False:C215)
	$equipments:=ds:C1482.Equipment.query("nextPMDate<=:1 & nextPMDate#:2 & notAtSite=:3 & engg=:4"; Storage:C1525.cache.endDate; !00-00-00!; False:C215; False:C215)
	
	
	
local Function NPUEquipments()->$equipments : cs:C1710.EquipmentSelection  //NPU List
	$equipments:=ds:C1482.Equipment.query("notAtSite=:1 & engg=:2"; False:C215; True:C214)
	
local Function equipmentsDownOrOnHold()->$equipments : cs:C1710.EquipmentSelection
	$equipments:=ds:C1482.Equipment.query("down=:1"; True:C214)
	
local Function decommissionedEquipment()->$equipments : cs:C1710.EquipmentSelection
	$equipments:=ds:C1482.Equipment.query("decommissioned=:1"; True:C214)
	
	
	
	