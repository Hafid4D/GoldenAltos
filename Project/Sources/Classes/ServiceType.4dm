Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	$entry:=cs:C1710.sfw_definitionEntry.new("serviceType"; "administration"; "Service types")
	$entry.setDataclass("ServiceType")
	$entry.setIcon("image/entry/serviceType-50x50-W.png"; "image/entry/serviceType-50x50-B.png")
	$entry.setDisplayOrder(-33000)
	
	$entry.setSearchboxField("code")
	$entry.setSearchboxField("name")
	
	$entry.setPanel("panel_serviceType")
	
	$entry.setLBItemsColumn("colorPicto"; ""; "width:20"; "type:picture")
	$entry.setLBItemsColumn("code"; "Code"; "width:80")
	$entry.setLBItemsColumn("name"; "Name"; "width:200")
	
	$entry.setLBItemsOrderBy("code")
	$entry.setLBItemsOrderBy("name")
	
	$entry.setLBItemsCounter("###0###0##0^1;;"; "unit1:type"; "unitN:types")
	
	$entry.setValidationRule("code"; "entryField_code"; "mandatory"; "trimSpace"; "uppercase")
	$entry.setValidationRule("name"; "entryField_name"; "mandatory"; "trimSpace"; "capitalize")
	
	
	
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	
	$entry.setToolBarGroup("leadParameters")
	
	//Mark:- Function to manage the cache
local Function cacheClear()
	If (Storage:C1525.cache#Null:C1517)
		Use (Storage:C1525.cache)
			Storage:C1525.cache.serviceType:=Null:C1517
		End use 
	End if 
	
	
local Function cacheLoad()
	
	If (Storage:C1525.cache=Null:C1517)
		Use (Storage:C1525)
			Storage:C1525.cache:=New shared object:C1526
		End use 
	End if 
	If (Storage:C1525.cache.serviceType=Null:C1517)
		$serviceTypeColl:=This:C1470._loadAsCollection()
		Use (Storage:C1525.cache)
			Storage:C1525.cache.serviceType:=$serviceTypeColl.copy(ck shared:K85:29; Storage:C1525.cache)
		End use 
	End if 
	
	
local Function cacheGet($uuid : Text)->$serviceType : Object
	If (Storage:C1525.cache=Null:C1517)
		This:C1470.cacheLoad()
	Else 
		If (Storage:C1525.cache.serviceType=Null:C1517)
			This:C1470.cacheLoad()
		End if 
	End if 
	$indices:=Storage:C1525.cache.serviceType.indices("UUID = :1"; $uuid)
	If ($indices.length>0)
		$serviceType:=Storage:C1525.cache.serviceType[$indices[0]]
	Else 
		$serviceType:=New object:C1471
	End if 
	
	
Function trigger()
	If (Application type:C494=4D Local mode:K5:1)
		This:C1470.cacheClear()
	Else 
		EXECUTE ON CLIENT:C651("@"; "sfw_cacheManager"; "clear"; "ServiceType")
	End if 
	
Function _loadAsCollection()->$projectStatusColl : Collection
	var $file : 4D:C1709.File
	var $img : Picture
	$projectStatusColl:=This:C1470.all().toCollection("UUID, code, name, color").orderBy("code")