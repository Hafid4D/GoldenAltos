Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("assumption"; "salesAndQuotes"; "Assumptions")
	$entry.setDataclass("Assumption")
	$entry.setIcon("image/entry/assumption-50x50.png")
	$entry.setDisplayOrder(-1000)
	
	$entry.setSearchboxField("code")
	
	$entry.setPanel("panel_assumption")
	
	$entry.setLBItemsColumn("code"; "Code"; "width:50")
	$entry.setLBItemsColumn("value"; "value")
	
	$entry.setLBItemsOrderBy("code")
	$entry.setLBItemsOrderBy("value")
	
	$entry.setLBItemsCounter("###0###0##0^1;;"; "unit1:assumption"; "unitN:assumptions")
	
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	$entry.setItemListPreconfigAction("copyItemsListToPasteboard")
	