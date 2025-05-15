
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
	
	
	// MARK: - Views Definition
	
	$view:=cs:C1710.sfw_definitionView.new("equipmentOutOfCalibration"; "Equipment out of calibration")
	$view.setDisplayType("hierarchicalEntries")
	$view.setPictoLabel("/RESOURCES/sfw/image/picto/hierarchical.png")
	//$view.addEntryMainLevel("nameInWizard"; "assignedID"; "displayOnlyIfChildren"; "displayCount"; "style:bold"; "color:navy"; "collapsed"; "orderBy:assignedID")
	//$view.addEntryLevel("nameInWizard"; "project"; "linkToFollow:projects"; "orderBy:name")
	$entry.setView($view)
	