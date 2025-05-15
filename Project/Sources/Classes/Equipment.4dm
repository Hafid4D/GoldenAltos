
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
	
	$entry.setLBItemsColumn("assignedID"; "assigned ID"; "width:200")
	$entry.setLBItemsColumn("serialNumber"; "Serial number"; "width:100")
	$entry.setLBItemsOrderBy("assignedID")
	
	
	// MARK: -Filters
	
	$filter:=cs:C1710.sfw_definitionFilter.new("filterEquipmentLocation")
	$filter.setDefaultTitle("All locations")
	$filter.setFilterByIDInTable("EquipmentLocation"; "locationID"; "locationID")
	$filter.setDynamicTitle("name"; "## equipment location")
	$entry.addFilter($filter)
	
	$filter:=cs:C1710.sfw_definitionFilter.new("filterEquipmentType")
	$filter.setDefaultTitle("All types")
	$filter.setFilterByIDInTable("EquipmentType"; "typeID"; "typeID")
	$filter.setDynamicTitle("name"; "## equipment type")
	$entry.addFilter($filter)
	
	$filter:=cs:C1710.sfw_definitionFilter.new("filterEquipmentDivision")
	$filter.setDefaultTitle("All divisions")
	$filter.setFilterByIDInTable("Division"; "divisionID"; "divisionID")
	$filter.setDynamicTitle("name"; "## equipment division")
	$entry.addFilter($filter)
	
	
	// MARK: - Views Definition
	
	// MARK: Equipment out of calibration List
	$view:=cs:C1710.sfw_definitionView.new("equipmentOutOfCalibration"; "Equipment out of calibration")
	$view.setLBItemsColumn("assignedID"; "assigned ID")
	$view.setLBItemsColumn("serialNumber"; "Serial number"; "width:200")
	$view.setLBItemsOrderBy("assignedID")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:equipment"; "unitN:equipments")
	$view.setSubset("equipmentOutOfCalibration")
	$entry.setView($view)
	
	// MARK: Prevent Maintenance List
	$view:=cs:C1710.sfw_definitionView.new("pmEquipmentList"; "Prevent Maintenance List")
	$view.setLBItemsColumn("assignedID"; "assigned ID")
	$view.setLBItemsColumn("serialNumber"; "Serial number"; "width:200")
	$view.setLBItemsOrderBy("assignedID")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:equipment"; "unitN:equipments")
	$view.setSubset("pmEquipmentList")
	$entry.setView($view)
	
	// MARK: Due calibration List
	$view:=cs:C1710.sfw_definitionView.new("dueCalibratioList"; "Due calibration List")
	$view.setLBItemsColumn("assignedID"; "assigned ID")
	$view.setLBItemsColumn("serialNumber"; "Serial number"; "width:200")
	$view.setLBItemsOrderBy("assignedID")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:equipment"; "unitN:equipments")
	$view.setSubset("dueCalibratioList")
	$entry.setView($view)
	
	// MARK: Due Prevent Maintenance List
	$view:=cs:C1710.sfw_definitionView.new("duePMEquipmentList"; "Due Prevent Maintenance List")
	$view.setLBItemsColumn("assignedID"; "assigned ID")
	$view.setLBItemsColumn("serialNumber"; "Serial number"; "width:200")
	$view.setLBItemsOrderBy("assignedID")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:equipment"; "unitN:equipments")
	$view.setSubset("duePMEquipmentList")
	$entry.setView($view)
	
	
Function equipmentOutOfCalibration()->$equipments : cs:C1710.EquipmentSelection
	
	$equipments:=ds:C1482.Equipment.query("nextCalDate<=:1 & calibrationNotRequired=:2 & notAtSite=:3"; Current date:C33(*); False:C215; False:C215)
	
	
Function pmEquipmentList()->$equipments : cs:C1710.EquipmentSelection
	
	$equipments:=ds:C1482.Equipment.query("nextPMDate<=:1 & nextPMDate#:2 & notAtSite=:3"; Current date:C33(*); !00-00-00!; False:C215)
	
	
Function dueCalibratioList()->$equipments : cs:C1710.EquipmentSelection
	
	$equipments:=ds:C1482.Equipment.query("nextCalDate<=:1 & notAtSite=:2 & engg=:3"; Current date:C33(*); False:C215; False:C215)
	
	
Function duePMEquipmentList()->$equipments : cs:C1710.EquipmentSelection
	
	$equipments:=ds:C1482.Equipment.query("nextPMDate<=:1 & nextPMDate#:2 & notAtSite=:3 & engg=:4"; Current date:C33(*); !00-00-00!; False:C215; False:C215)
	
	
	
	