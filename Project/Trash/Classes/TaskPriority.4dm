Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("taskPriority"; "administration"; "Task priorities")
	$entry.setDataclass("TaskPriority")
	$entry.setDisplayOrder(-7500)
	$entry.setIcon("image/entry/priority-50x50.png")
	$entry.setToolbarLabel("T. Priorities")
	$entry.setSearchboxField("name")
	
	$entry.setPanel("panel_taskPriority"; 2)
	$entry.setLBItemsColumn("colorPicto"; ""; "width:20"; "type:picture")
	$entry.setLBItemsColumn("levelID"; "ID"; "width:30")
	$entry.setLBItemsColumn("code"; "Code"; "width:80")
	$entry.setLBItemsColumn("name"; "Name"; "width:200")
	
	$entry.setLBItemsOrderBy("levelID")
	
	
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:service type"; "unitN:service types")
	$entry.setValidationRule("levelID"; "entryField_levelID"; "mandatory"; "trimSpace"; "capitalize")
	$entry.setValidationRule("code"; "entryField_code"; "mandatory"; "trimSpace"; "uppercase")
	$entry.setValidationRule("name"; "entryField_name"; "mandatory"; "trimSpace"; "capitalize")
	//$entry.setValidationRule("color"; "entryField_color"; "mandatory"; "trimSpace"; "capitalize")
	//$entry.enableTransaction()
	
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	$entry.setItemListPreconfigAction("copyItemsListToPasteboard")
	
	$entry.setToolBarGroup("Task Parameters")
	