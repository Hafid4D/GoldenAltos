Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("training"; "training"; "Trainings")
	$entry.setDataclass("Training")
	$entry.setDisplayOrder(-1000)
	$entry.setIcon("image/entry/training-50x50.png")
	$entry.setSearchboxField("code")
	$entry.setSearchboxField("name")
	$entry.setPanel("panel_training"; 1)
	
	$entry.setLBItemsColumn("code"; "Code"; "width:70"; "center"; "headerCenter")
	$entry.setLBItemsColumn("name"; "Name"; "width:200"; "headerLeft")
	$entry.setLBItemsOrderBy("code")
	
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:training"; "unitN:trainings")
	$entry.setValidationRule("code"; "entryField_code"; "mandatory"; "trimSpace"; "uppercase"; "unique"; "message:The code must be unique")
	$entry.setValidationRule("name"; "entryField_name"; "mandatory"; "trimSpace"; "capitalize")
	
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	$entry.setItemListPreconfigAction("copyItemsListToPasteboard")
	
	$entry.enableTransaction()