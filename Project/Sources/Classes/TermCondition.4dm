Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	$entry:=cs:C1710.sfw_definitionEntry.new("termCondition"; "salesAndQuotes"; "Terms")
	$entry.setDataclass("TermCondition")
	$entry.setIcon("image/entry/termCondition-50x50.png")
	$entry.setDisplayOrder(-2000)
	
	$entry.setSearchboxField("code")
	
	$entry.setPanel("panel_termCondition")
	
	$entry.setLBItemsColumn("code"; "Code"; "width:150")
	$entry.setLBItemsColumn("value"; "value")
	
	$entry.setLBItemsOrderBy("code")
	$entry.setLBItemsOrderBy("value")
	
	$entry.setLBItemsCounter("###0###0##0^1;;"; "unit1:term"; "unitN:terms")
	
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	$entry.setItemListPreconfigAction("copyItemsListToPasteboard")