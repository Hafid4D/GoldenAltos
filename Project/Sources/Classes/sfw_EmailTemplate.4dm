Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("emailTemplate"; "administration"; "Email templates")
	$entry.setDataclass("sfw_EmailTemplate")
	$entry.setDisplayOrder(-1500)
	$entry.setIcon("image/entry/emailTemplate-50x50.png")
	
	$entry.setSearchboxField("ident")
	$entry.setSearchboxField("name")
	
	$entry.setPanel("panel_emailTemplate")
	$entry.setPanelPage(1; "description-32x32.png"; "Exemples")
	
	$entry.setLBItemsColumn("ident"; "Identifier"; "width:80")
	$entry.setLBItemsColumn("name"; "Name"; "width:200")
	$entry.setLBItemsColumn("subject"; "Subject"; "width:200")
	
	$entry.setLBItemsOrderBy("ident")
	
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:email template"; "unitN:email templates")
	$entry.setValidationRule("ident"; "entryField_ident"; "mandatory"; "trimSpace")
	$entry.setValidationRule("name"; "entryField_name"; "mandatory"; "trimSpace"; "capitalize")
	$entry.setValidationRule("subject"; "entryField_subject"; "mandatory"; "trimSpace"; "capitalize")
	
	
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	$entry.setItemListPreconfigAction("copyItemsListToPasteboard")
	