Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	$entry:=cs:C1710.sfw_definitionEntry.new("operationProcess"; ["housekeeping"]; "Operation Process"; "Operation Processes")
	$entry.setDataclass("StepTemplateProcess")
	$entry.setDisplayOrder(-100000)
	$entry.setIcon("image/entry/step-template-white-52x52.png")
	
	$entry.setSearchboxField("name")
	
	$entry.setPanel("panel_stepTemplateProcess")
	$entry.setPanelPage(1; ""; "Step Templates")
	
	$entry.setLBItemsColumn("name"; "Name"; "width:300")
	$entry.setLBItemsOrderBy("name")
	$entry.enableTransaction()
