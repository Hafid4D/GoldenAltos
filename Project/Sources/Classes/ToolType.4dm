Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("toolType"; ["housekeeping"]; "Tool Type")
	$entry.setDataclass("ToolType")
	$entry.setDisplayOrder(-100)
	$entry.setIcon("image/entry/tools-white-50x50.png")
	
	$entry.setSearchboxField("type")
	$entry.setSearchboxField("name")
	
	$entry.setPanel("panel_tools")
	$entry.setPanelPage(1; ""; "Main")
	
	
	$entry.setLBItemsColumn("type"; "Tool Type"; "width:100")
	$entry.setLBItemsColumn("name"; "Name"; "width:250")
	$entry.setLBItemsColumn("date"; "Date"; "width:100")
	
	$entry.setLBItemsOrderBy("name")
	$entry.enableTransaction()
	
	