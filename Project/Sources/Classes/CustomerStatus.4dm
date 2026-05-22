Class extends DataClass


// Purpose: SFW administration entry for CustomerStatus reference records (Customer P. toolbar group).
// created by 4D/PS [2026-may-19]
local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("customerStatus"; "administration"; "Customer status")
	$entry.setDataclass("CustomerStatus")
	$entry.setIcon("image/entry/customerStatus-50x50.png"; "image/entry/customerStatus-50x50.png")
	$entry.setDisplayOrder(-20000)
	
	$entry.setSearchboxField("levelID")
	$entry.setSearchboxField("code")
	$entry.setSearchboxField("name")
	
	$entry.setPanel("panel_customerStatus")
	
	$entry.setLBItemsColumn("colorPicto"; ""; "width:20"; "type:picture")
	$entry.setLBItemsColumn("levelID"; "ID"; "width:30")
	$entry.setLBItemsColumn("code"; "Code"; "width:80")
	$entry.setLBItemsColumn("name"; "Name"; "width:200")
	
	$entry.setLBItemsOrderBy("levelID")
	$entry.setLBItemsOrderBy("code")
	
	$entry.setValidationRule("levelID"; "entryField_levelID"; "mandatory"; "trimSpace")
	$entry.setValidationRule("code"; "entryField_code"; "mandatory"; "trimSpace"; "uppercase")
	$entry.setValidationRule("name"; "entryField_name"; "mandatory"; "trimSpace"; "capitalize")
	
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	$entry.setItemListPreconfigAction("copyItemsListToPasteboard")
	
	// Purpose: Toolbar group icon must exist under Resources (customers-white-50x50.png is missing).
	// modified by 4D/PS [2026-may-19]
	$entry.setToolBarGroup("CustomerParameters"; "Customer P."; "image/entry/customerParam-50x50.png")
	
	
local Function cacheLoad()
	
	If (Storage:C1525.cache=Null:C1517)
		Use (Storage:C1525)
			Storage:C1525.cache:=New shared object:C1526
		End use 
	End if 
	If (Storage:C1525.cache.customerStatus=Null:C1517)
		$customerStatusColl:=This:C1470._loadAsCollection()
		Use (Storage:C1525.cache)
			Storage:C1525.cache.customerStatus:=$customerStatusColl.copy(ck shared:K85:29; Storage:C1525.cache)
		End use 
	End if 
	
	
Function _loadAsCollection()->$customerStatusColl : Collection
	$customerStatusColl:=This:C1470.all().toCollection("UUID, levelID, code, name, color").orderBy("levelID")
	