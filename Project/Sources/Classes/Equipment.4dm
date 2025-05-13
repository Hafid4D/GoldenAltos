
Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	//Mark: entry : Contact
	$entry:=cs:C1710.sfw_definitionEntry.new("equipment"; ["qualityAssistance"]; "Equipments")
	$entry.setDataclass("Equipment")
	$entry.setDisplayOrder(100)
	$entry.setIcon("image/entry/equipment-white-50x50.png")
	
	
	