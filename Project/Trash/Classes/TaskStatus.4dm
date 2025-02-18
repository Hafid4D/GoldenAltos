Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("taskStatus"; "administration"; "Task status")
	$entry.setDataclass("TaskStatus")
	$entry.setDisplayOrder(-7200)
	$entry.setIcon("image/entry/taskStatus-50x50.png")
	
	$entry.setSearchboxField("statusID")
	$entry.setSearchboxField("name")
	$entry.setPanel("panel_taskStatus"; 2)
	$entry.setLBItemsColumn("colorPicto"; ""; "width:20"; "type:picture")
	$entry.setLBItemsColumn("statusID"; ""; "width:50")
	$entry.setLBItemsColumn("code"; "Code"; "width:50")
	$entry.setLBItemsColumn("name"; "Name"; "width:200")
	
	$entry.setLBItemsOrderBy("statusID")
	
	
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:service type"; "unitN:service types")
	$entry.setValidationRule("statusID"; "entryField_statusID"; "mandatory")
	$entry.setValidationRule("code"; "entryField_code"; "mandatory"; "trimSpace"; "uppercase")
	$entry.setValidationRule("name"; "entryField_name"; "mandatory"; "trimSpace"; "capitalize")
	//$entry.setValidationRule("color"; "entryField_color"; "mandatory"; "trimSpace"; "capitalize")
	//$entry.enableTransaction()
	
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	$entry.setItemListPreconfigAction("copyItemsListToPasteboard")
	
	
	$entry.setToolBarGroup("Task Parameters")
	