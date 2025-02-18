Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("role"; "administration"; "Roles")
	$entry.setDataclass("Role")
	$entry.setDisplayOrder(-2000)
	$entry.setIcon("image/entry/role-50x50.png")
	$entry.setSearchboxField("code")
	$entry.setSearchboxField("name")
	
	$entry.setPanel("panel_role"; 1)
	
	$pageListbox:=cs:C1710.sfw_definitionPageListbox.new("lb_staff")
	$pageListbox.setDatasource("Form.current_item.skills.staff")
	$pageListbox.addColumn("This.fullName"; "width:300"; "headerLabel:Staff")
	$entry.setPanelDynamicPage(1; "staff-32x32.png"; "Staff"; $pageListbox)
	
	
	$entry.setLBItemsColumn("code"; "Code"; "width:100")
	$entry.setLBItemsColumn("name"; "Name"; "width:200")
	$entry.setLBItemsOrderBy("name")
	
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:role"; "unitN:roles")
	$entry.setValidationRule("code"; "entryField_code"; "mandatory"; "trimSpace"; "uppercase")
	$entry.setValidationRule("name"; "entryField_name"; "mandatory"; "trimSpace"; "capitalize")
	
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	$entry.setItemListPreconfigAction("copyItemsListToPasteboard")
	
	$entry.setToolBarGroup("ServicesGroup")
	
	
	//Mark:- Function to manage the cache
local Function cacheClear()
	If (Storage:C1525.cache#Null:C1517)
		Use (Storage:C1525.cache)
			Storage:C1525.cache.role:=Null:C1517
		End use 
	End if 
	
	
local Function cacheLoad()
	
	If (Storage:C1525.cache=Null:C1517)
		Use (Storage:C1525)
			Storage:C1525.cache:=New shared object:C1526
		End use 
	End if 
	If (Storage:C1525.cache.role=Null:C1517)
		$roleColl:=This:C1470._loadAsCollection()
		Use (Storage:C1525.cache)
			Storage:C1525.cache.role:=$roleColl.copy(ck shared:K85:29; Storage:C1525.cache)
		End use 
	End if 
	
	
local Function cacheGet($uuid : Text)->$role : Object
	If (Storage:C1525.cache=Null:C1517)
		This:C1470.cacheLoad()
	Else 
		If (Storage:C1525.cache.role=Null:C1517)
			This:C1470.cacheLoad()
		End if 
	End if 
	$indices:=Storage:C1525.cache.role.indices("UUID = :1"; $uuid)
	If ($indices.length>0)
		$role:=Storage:C1525.cache.role[$indices[0]]
	Else 
		$role:=New object:C1471
	End if 
	
	
Function trigger()
	If (Application type:C494=4D Local mode:K5:1)
		This:C1470.cacheClear()
	Else 
		EXECUTE ON CLIENT:C651("@"; "sfw_cacheManager"; "clear"; "Role")
	End if 
	
Function _loadAsCollection()->$roleColl : Collection
	
	$roleColl:=This:C1470.all().toCollection("UUID, code, name").orderBy("name")