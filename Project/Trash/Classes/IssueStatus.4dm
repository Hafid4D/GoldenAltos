Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("issueStatus"; "issue"; "Issue status")
	$entry.setDataclass("IssueStatus")
	$entry.setDisplayOrder(-2000)
	$entry.setIcon("image/entry/issueStatus-50x50.png")
	$entry.setSearchboxField("code")
	$entry.setSearchboxField("name")
	$entry.setPanel("panel_issueStatus")
	
	$entry.setPanelPage(1; "-24x24.png")
	$entry.setLBItemsColumn("colorPicto"; ""; "width:20"; "type:picture")
	$entry.setLBItemsColumn("code"; "Code"; "width:50")
	$entry.setLBItemsColumn("name"; "Name"; "width:200")
	$entry.setLBItemsOrderBy("code")
	
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:service type"; "unitN:service types")
	$entry.setValidationRule("code"; "entryField_code"; "mandatory"; "trimSpace"; "uppercase")
	$entry.setValidationRule("name"; "entryField_name"; "mandatory"; "trimSpace"; "capitalize")
	
	$entry.setAddable()
	
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	$entry.setItemListPreconfigAction("copyItemsListToPasteboard")
	
	$entry.enableTransaction()
	$entry.setToolBarGroup("Issue Parameters")