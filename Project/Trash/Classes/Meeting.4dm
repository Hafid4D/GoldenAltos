Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("meeting"; "time"; "Meetings")
	$entry.setDataclass("Meeting")
	$entry.setDisplayOrder(400)
	$entry.setIcon("image/entry/meeting-50x50.png")
	
	$entry.setSearchboxField("code")
	$entry.setSearchboxField("name")
	
	$entry.setPanel("panel_meeting"; 1)
	$entry.setPanelPage(1; "ability-24x24.png"; "Attendees")
	$entry.setLBItemsColumn("code"; "Code"; "width:50")
	$entry.setLBItemsColumn("name"; "Name"; "width:230")
	$entry.setLBItemsColumn("dateStart"; "Date"; "type:date"; "width:80")
	$entry.setLBItemsColumn("timeStartText"; "Time"; "type:time"; "width:50")
	$entry.setLBItemsColumn("durationWork"; "Duration"; "width:50")
	
	$entry.setLBItemsOrderBy("stmpStart desc")
	
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:technology"; "unitN:technologies")
	$entry.setValidationRule("code"; "entryField_code"; "mandatory"; "trimSpace"; "uppercase")
	$entry.setValidationRule("name"; "entryField_name"; "mandatory"; "trimSpace")
	$entry.setValidationRule("dateStart"; "entryField_dateStart"; "mandatory")
	
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	$entry.setItemListPreconfigAction("copyItemsListToPasteboard")
	$entry.setAddable()
	$entry.enableTransaction()