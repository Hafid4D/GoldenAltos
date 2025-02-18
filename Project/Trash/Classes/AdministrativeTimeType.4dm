Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("administrativeTimeType"; "time"; "Admin Time types")
	$entry.setDataclass("AdministrativeTimeType")
	$entry.setIcon("image/entry/admiTimeType-50x50.png")
	$entry.setSearchboxField("code")
	$entry.setSearchboxField("name")
	$entry.setPanel("panel_administrativeTimeType")
	
	$entry.setPanelPage(1; "-24x24.png")
	$entry.setLBItemsColumn("code"; "Code"; "width:50")
	$entry.setLBItemsColumn("name"; "Name"; "width:200")
	$entry.setLBItemsOrderBy("code")
	
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:aministrative time type"; "unitN:administrative Time types")
	$entry.setValidationRule("code"; "entryField_code"; "mandatory"; "trimSpace"; "uppercase")
	$entry.setValidationRule("name"; "entryField_name"; "mandatory"; "trimSpace"; "capitalize")
	
	$entry.enableTransaction()
	
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	$entry.setItemListPreconfigAction("copyItemsListToPasteboard")
	
	$entry.setDisplayOrder(-1000)
	//$entry.setAllowedProfiles("admin")
	//$entry.setToolBarGroup("Task Parameters"; "Tasks P."; "sfw/entry/TParam-50x50.png")
	
	
	
	//Mark:- Function to manage the cache
local Function cacheClear()
	If (Storage:C1525.cache#Null:C1517)
		Use (Storage:C1525.cache)
			Storage:C1525.cache.customerTimeType:=Null:C1517
		End use 
	End if 
	
	
local Function cacheLoad()
	
	If (Storage:C1525.cache=Null:C1517)
		Use (Storage:C1525)
			Storage:C1525.cache:=New shared object:C1526
		End use 
	End if 
	If (Storage:C1525.cache.customerTimeType=Null:C1517)
		$customerTimeTypeColl:=This:C1470._loadAsCollection()
		Use (Storage:C1525.cache)
			Storage:C1525.cache.customerTimeType:=$customerTimeTypeColl.copy(ck shared:K85:29; Storage:C1525.cache)
		End use 
	End if 
	
	
local Function cacheGet($uuid : Text)->$customerTimeType : Object
	If (Storage:C1525.cache=Null:C1517)
		This:C1470.cacheLoad()
	Else 
		If (Storage:C1525.cache.customerTimeType=Null:C1517)
			This:C1470.cacheLoad()
		End if 
	End if 
	$indices:=Storage:C1525.cache.customerTimeType.indices("UUID = :1"; $uuid)
	If ($indices.length>0)
		$customerTimeType:=Storage:C1525.cache.customerTimeType[$indices[0]]
	Else 
		$customerTimeType:=New object:C1471
	End if 
	
	
Function trigger()
	If (Application type:C494=4D Local mode:K5:1)
		This:C1470.cacheClear()
	Else 
		EXECUTE ON CLIENT:C651("@"; "sfw_cacheManager"; "clear"; "CustomerTimeType")
	End if 
	
Function _loadAsCollection()->$customerTimeTypeColl : Collection
	
	$customerTimeTypeColl:=This:C1470.all().toCollection("UUID, code, name").orderBy("name")