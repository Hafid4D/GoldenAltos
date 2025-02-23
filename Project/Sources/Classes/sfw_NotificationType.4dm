Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("notificationType"; "administration"; "Notification types")
	$entry.setDataclass("sfw_NotificationType")
	$entry.setDisplayOrder(-1200)
	$entry.setIcon("image/entry/notificationType-50x50.png")
	
	$entry.setSearchboxField("ident")
	$entry.setSearchboxField("label")
	
	$entry.setPanel("panel_notificationType")
	
	$entry.setLBItemsColumn("ident"; "Identifier"; "width:80")
	$entry.setLBItemsColumn("label"; "Label"; "width:100")
	$entry.setLBItemsColumn("description"; "Description"; "width:200")
	$entry.setLBItemsOrderBy("ident")
	
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:email template"; "unitN:email templates")
	$entry.setValidationRule("ident"; "entryField_ident"; "mandatory"; "trimSpace")
	$entry.setValidationRule("label"; "entryField_label"; "mandatory"; "trimSpace"; "capitalize")
	$entry.setValidationRule("description"; "entryField_description"; "trimSpace"; "capitalize")
	
	
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	$entry.setItemListPreconfigAction("copyItemsListToPasteboard")