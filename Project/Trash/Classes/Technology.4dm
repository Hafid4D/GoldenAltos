Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("technology"; "projectManagment"; "Technologies")
	$entry.setDataclass("Technology")
	$entry.setDisplayOrder(-9000)
	$entry.setIcon("image/entry/technology-50x50.png")
	
	$entry.setSearchboxField("code")
	$entry.setSearchboxField("name")
	
	$entry.setPanel("panel_technology"; 1)
	
	$entry.setLBItemsColumn("colorPicto"; ""; "width:20"; "type:picture")
	$entry.setLBItemsColumn("logo"; ""; "width:20"; "type:picture"; "format:"+Char:C90(Scaled to fit prop centered:K6:6))
	
	$entry.setLBItemsColumn("code"; "Code"; "width:50")
	$entry.setLBItemsColumn("name"; "Name"; "width:200")
	
	$entry.setLBItemsOrderBy("code")
	
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:technology"; "unitN:technologies")
	$entry.setValidationRule("code"; "entryField_code"; "mandatory"; "trimSpace"; "capitalize")
	$entry.setValidationRule("name"; "entryField_name"; "mandatory"; "trimSpace"; "capitalize")
	//$entry.setValidationRule("color"; "entryField_color"; "mandatory"; "trimSpace"; "capitalize")
	
	
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	$entry.setItemListPreconfigAction("copyItemsListToPasteboard")
	
	
	
	//Mark:- Function to manage the cache
local Function cacheClear()
	If (Storage:C1525.cache#Null:C1517)
		Use (Storage:C1525.cache)
			Storage:C1525.cache.technology:=Null:C1517
		End use 
	End if 
	
	
local Function cacheLoad()
	
	If (Storage:C1525.cache=Null:C1517)
		Use (Storage:C1525)
			Storage:C1525.cache:=New shared object:C1526
		End use 
	End if 
	If (Storage:C1525.cache.technology=Null:C1517)
		$technologyColl:=This:C1470._loadAsCollection()
		Use (Storage:C1525.cache)
			Storage:C1525.cache.technology:=$technologyColl.copy(ck shared:K85:29; Storage:C1525.cache)
		End use 
	End if 
	
	
local Function cacheGet($uuid : Text)->$technology : Object
	If (Storage:C1525.cache=Null:C1517)
		This:C1470.cacheLoad()
	Else 
		If (Storage:C1525.cache.technology=Null:C1517)
			This:C1470.cacheLoad()
		End if 
	End if 
	$indices:=Storage:C1525.cache.technology.indices("UUID = :1"; $uuid)
	If ($indices.length>0)
		$technology:=Storage:C1525.cache.technology[$indices[0]]
	Else 
		$technology:=New object:C1471
	End if 
	
	
Function trigger()
	If (Application type:C494=4D Local mode:K5:1)
		This:C1470.cacheClear()
	Else 
		EXECUTE ON CLIENT:C651("@"; "sfw_cacheManager"; "clear"; "technology")
	End if 
	
Function _loadAsCollection()->$technologyColl : Collection
	
	$technologyColl:=This:C1470.all().toCollection("UUID, code, name, color").orderBy("name")