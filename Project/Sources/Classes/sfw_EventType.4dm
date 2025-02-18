Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("eventType"; "administration"; "Event types")
	$entry.setDataclass("sfw_EventType")
	$entry.setDisplayOrder(-6500)
	$entry.setIcon("image/entry/eventType-50x50.png")
	$entry.setSearchboxField("ident")
	$entry.setSearchboxField("label")
	
	$entry.setPanel("sfw_panel_eventType"; 2)
	$entry.setLBItemsColumn("ident"; "Identifier"; "width:100")
	$entry.setLBItemsColumn("label"; "Label")
	$entry.setLBItemsOrderBy("ident")
	
	
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:event type"; "unitN:event types")
	$entry.setValidationRule("ident"; "entryField_ident"; "mandatory"; "trimSpace"; "capitalize")
	$entry.setValidationRule("label"; "entryField_label"; "mandatory"; "trimSpace"; "capitalize")
	
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	$entry.setItemListPreconfigAction("copyItemsListToPasteboard")
	
	$entry.activateFavorite(False:C215)