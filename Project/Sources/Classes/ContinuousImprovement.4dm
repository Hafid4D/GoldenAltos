Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	//Mark: entry : Contact
	$entry:=cs:C1710.sfw_definitionEntry.new("continuousImprovement"; ["qualityAssistance"]; "CIP")
	$entry.setDataclass("ContinuousImprovement")
	$entry.setSearchboxField("item")
	$entry.setDisplayOrder(-400)
	$entry.setIcon("image/entry/cip-white-50x50.png")
	
	$entry.setSearchboxField("item"; "placeholder:ID")
	
	$entry.setPanel("panel_continuousImprovement")
	$entry.setPanelPage(1; ""; "Main")
	
	$entry.setLBItemsColumn("item"; "Item#"; "width:125")
	$entry.setLBItemsColumn("interestedParty"; "Interested Party"; "width:125")
	$entry.setLBItemsColumn("procedureType"; "Procedure "; "width:200")
	$entry.setLBItemsOrderBy("item")
	
	
	