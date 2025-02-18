Class extends DataClass



local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("holidayType"; "administration"; "Holiday types")
	$entry.setDataclass("HolidayType")
	$entry.setDisplayOrder(-6500)
	$entry.setIcon("image/entry/holidayType-50x50.png")
	$entry.setSearchboxField("code")
	$entry.setSearchboxField("name")
	$entry.setSearchboxField("company.country.name"; "placeholder:countryName")
	
	
	$entry.setPanel("panel_holidayType"; 2)
	$entry.setLBItemsColumn("code"; "Code"; "width:50")
	$entry.setLBItemsColumn("name"; "Name"; "width:200")
	$entry.setLBItemsColumn("company.name"; "Company"; "type:picture"; "width:100"; "orderByFormula:this.company.name")
	
	$entry.setLBItemsOrderBy("code")
	
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:holiday type"; "unitN:holiday types")
	$entry.setValidationRule("code"; "entryField_code"; "mandatory"; "trimSpace"; "capitalize")
	$entry.setValidationRule("name"; "entryField_name"; "mandatory"; "trimSpace"; "capitalize")
	$entry.enableTransaction()
	
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	$entry.setItemListPreconfigAction("copyItemsListToPasteboard")
	$entry.setToolBarGroup("Holidays")
	
local Function cacheLoad()
	
	If (Storage:C1525.cache=Null:C1517)
		Use (Storage:C1525)
			Storage:C1525.cache:=New shared object:C1526
		End use 
	End if 
	If (Storage:C1525.cache.holidayType=Null:C1517)
		$holidayTypeColl:=This:C1470._loadAsCollection()
		Use (Storage:C1525.cache)
			Storage:C1525.cache.holidayType:=$holidayTypeColl.copy(ck shared:K85:29; Storage:C1525.cache)
		End use 
	End if 
	
Function _loadAsCollection()->$roleColl : Collection
	
	$roleColl:=This:C1470.all().toCollection("UUID, code, name").orderBy("code")