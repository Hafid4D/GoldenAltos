Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("planificationSlotStatus"; "administration"; "Planification slot status")
	$entry.setDataclass("PlanificationSlotStatus")
	$entry.setDisplayOrder(-2000)
	$entry.setIcon("image/entry/planificationSlotStatus-50x50.png")
	$entry.setSearchboxField("code")
	$entry.setSearchboxField("name")
	$entry.setPanel("panel_planificationSlotStatus"; 1)
	
	$entry.setLBItemsColumn("colorPicture"; ""; "type:picture"; "width:15"; "orderByFormula:this.name")
	$entry.setLBItemsColumn("code"; "Code"; "width:50"; "center"; "headerCenter")
	$entry.setLBItemsColumn("name"; "Name"; "width:200"; "headerLeft")
	$entry.setLBItemsOrderBy("code")
	
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:planficifation slot status"; "unitN:planficifation slot status")
	$entry.setValidationRule("code"; "entryField_code"; "mandatory"; "trimSpace"; "uppercase"; "unique"; "message:The code must be unique")
	$entry.setValidationRule("name"; "entryField_name"; "mandatory"; "trimSpace"; "capitalize")
	
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	$entry.setItemListPreconfigAction("copyItemsListToPasteboard")
	
	$entry.setToolBarGroup("planificationSettings"; "Planif."; "image/entry/planificationSettings-50x50.png")
	
	//Mark:- Function to manage the cache
local Function cacheClear()
	If (Storage:C1525.cache#Null:C1517)
		Use (Storage:C1525.cache)
			Storage:C1525.cache.planificationSlotStatus:=Null:C1517
		End use 
	End if 
	
	
local Function cacheLoad()
	
	If (Storage:C1525.cache=Null:C1517)
		Use (Storage:C1525)
			Storage:C1525.cache:=New shared object:C1526
		End use 
	End if 
	If (Storage:C1525.cache.planificationSlotStatus=Null:C1517)
		$planificationSlotStatusColl:=This:C1470._loadAsCollection()
		Use (Storage:C1525.cache)
			Storage:C1525.cache.planificationSlotStatus:=$planificationSlotStatusColl.copy(ck shared:K85:29; Storage:C1525.cache)
		End use 
	End if 
	
	
local Function cacheGet($uuid : Text)->$planificationSlotStatus : Object
	If (Storage:C1525.cache=Null:C1517)
		This:C1470.cacheLoad()
	Else 
		If (Storage:C1525.cache.sfw_country=Null:C1517)
			This:C1470.cacheLoad()
		End if 
	End if 
	
	$indices:=Storage:C1525.cache.planificationSlotStatus.indices("UUID = :1"; $uuid)
	If ($indices.length>0)
		$planificationSlotStatus:=Storage:C1525.cache.planificationSlotStatus[$indices[0]]
	Else 
		$planificationSlotStatus:=New object:C1471
	End if 
	
	
Function trigger()
	If (Application type:C494=4D Local mode:K5:1)
		This:C1470.cacheClear()
	Else 
		EXECUTE ON CLIENT:C651("@"; "sfw_cacheManager"; "clear"; "planificationSlotStatus")
	End if 
	
Function _loadAsCollection()->$planificationSlotStatusColl : Collection
	
	$planificationSlotStatusColl:=This:C1470.all().toCollection("UUID, code, name, color").orderBy("name")