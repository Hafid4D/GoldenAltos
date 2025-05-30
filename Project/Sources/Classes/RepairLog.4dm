Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	//Mark: entry : Contact
	$entry:=cs:C1710.sfw_definitionEntry.new("repairLog"; ["qualityAssistance"]; "Repair Logs")
	$entry.setDataclass("RepairLog")
	$entry.setSearchboxField("systemID")
	$entry.setDisplayOrder(100)
	$entry.setIcon("image/entry/repairLog-50x50.png")
	
	$entry.setSearchboxField("systemID"; "placeholder:ID")
	
	$entry.setPanel("panel_repairLog")
	$entry.setPanelPage(1; ""; "Main")
	//$entry.setPanelPage(2; ""; "Repair Log")
	
	$entry.setLBItemsColumn("systemID"; "system ID"; "width:200")
	$entry.setLBItemsColumn("reportID"; "report ID"; "width:100")
	$entry.setLBItemsOrderBy("systemID")
	
	
	
	