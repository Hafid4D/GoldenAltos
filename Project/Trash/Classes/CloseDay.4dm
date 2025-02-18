Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("closeDay"; "administration"; "Closing days")
	$entry.setDataclass("CloseDay")
	$entry.setDisplayOrder(-6500)
	$entry.setIcon("image/entry/closeDay-50x50.png")
	$entry.setSearchboxField("label")
	$entry.setSearchboxField("dateOff")
	$entry.setSearchboxField("company.country.name"; "placeholder:countryName")
	
	
	$entry.setPanel("panel_closeDay"; 2)
	$entry.setLBItemsColumn("dateOff"; "Date off"; "type:date"; "format:"+String:C10(Internal date short:K1:7))
	$entry.setLBItemsColumn("label"; "Label"; "width:200")
	$entry.setLBItemsColumn("company.name"; "Company"; "type:picture"; "width:100"; "orderByFormula:this.company.name")
	
	$entry.setLBItemsOrderBy("dateOff DESC, label")
	
	
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:closing day"; "unitN:closing days")
	$entry.setValidationRule("Label"; "entryField_label"; "mandatory"; "trimSpace"; "capitalize")
	$entry.enableTransaction()
	
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	$entry.setItemListPreconfigAction("copyItemsListToPasteboard")
	$entry.setToolBarGroup("Holidays")
	