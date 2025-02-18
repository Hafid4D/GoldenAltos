Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("keyDateTypes"; "administration"; "KeyDate")
	$entry.setDataclass("KeyDateType")
	$entry.setDisplayOrder(-7200)
	$entry.setIcon("image/entry/keydateType-50x50.png")
	
	$entry.setSearchboxField("code")
	$entry.setSearchboxField("name")
	$entry.setPanel("panel_keyDateType"; 2)
	$entry.setLBItemsColumn("colorPicto"; ""; "width:20"; "type:picture")
	$entry.setLBItemsColumn("code"; "Code"; "width:50")
	$entry.setLBItemsColumn("name"; "Name"; "width:200")
	
	$entry.setLBItemsOrderBy("name")
	
	
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:project status"; "unitN:project status")
	//$entry.setValidationRule("statusID"; "entryField_statusID"; "mandatory")
	$entry.setValidationRule("code"; "entryField_code"; "mandatory"; "trimSpace"; "uppercase"; "message:Code is mandatory")
	$entry.setValidationRule("code"; "entryField_code"; "unique"; "message:Code must be unique")
	$entry.setValidationRule("name"; "entryField_name"; "mandatory"; "trimSpace"; "message:Name is mandatory")
	//$entry.setValidationRule("color"; "entryField_color"; "mandatory"; "trimSpace"; "capitalize")
	//$entry.enableTransaction()
	
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	$entry.setItemListPreconfigAction("copyItemsListToPasteboard")
	
	
	//Mark:- Function to manage the cache
local Function cacheClear()
	If (Storage:C1525.cache#Null:C1517)
		Use (Storage:C1525.cache)
			Storage:C1525.cache.keyDateTypes:=Null:C1517
		End use 
	End if 
	
	
local Function cacheLoad()
	
	If (Storage:C1525.cache=Null:C1517)
		Use (Storage:C1525)
			Storage:C1525.cache:=New shared object:C1526
		End use 
	End if 
	If (Storage:C1525.cache.keyDateTypes=Null:C1517)
		$keyDateTypesColl:=This:C1470._loadAsCollection()
		Use (Storage:C1525.cache)
			Storage:C1525.cache.keyDateTypes:=$keyDateTypesColl.copy(ck shared:K85:29; Storage:C1525.cache)
		End use 
	End if 
	
	
local Function cacheGet($uuid : Text)->$keyDateTypes : Object
	If (Storage:C1525.cache=Null:C1517)
		This:C1470.cacheLoad()
	Else 
		If (Storage:C1525.cache.keyDateTypes=Null:C1517)
			This:C1470.cacheLoad()
		End if 
	End if 
	$indices:=Storage:C1525.cache.keyDateTypes.indices("UUID = :1"; $uuid)
	If ($indices.length>0)
		$keyDateTypes:=Storage:C1525.cache.keyDateTypes[$indices[0]]
	Else 
		$keyDateTypes:=New object:C1471
	End if 
	
	
Function trigger()
	If (Application type:C494=4D Local mode:K5:1)
		This:C1470.cacheClear()
	Else 
		EXECUTE ON CLIENT:C651("@"; "sfw_cacheManager"; "clear"; "KeyDateType")
	End if 
	
Function _loadAsCollection()->$keyDateTypesColl : Collection
	var $file : 4D:C1709.File
	var $img : Picture
	$keyDateTypesColl:=This:C1470.all().toCollection("UUID, code, name, color").orderBy("name")