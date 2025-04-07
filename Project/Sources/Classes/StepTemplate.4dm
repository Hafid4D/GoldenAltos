Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	$entry:=cs:C1710.sfw_definitionEntry.new("stepTemplate"; ["housekeeping"]; "Step Template"; "Step Templates")
	$entry.setDataclass("StepTemplate")
	$entry.setDisplayOrder(100)
	$entry.setIcon("image/entry/step-template-52x52.png")
	
	$entry.setSearchboxField("name")
	
	$entry.setPanel("panel_stepTemplate")
	$entry.setPanelPage(1; "po-infos-32x32.png"; "Main")
	$entry.setPanelPage(2; "po-infos-32x32.png"; "Main 2")
	
	$entry.setLBItemsColumn("name"; "Step Template Name"; "width:100")
	
	$entry.setLBItemsOrderBy("name")