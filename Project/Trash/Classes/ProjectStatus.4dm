Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("projectStatus"; "administration"; "Project status")
	$entry.setDataclass("ProjectStatus")
	$entry.setDisplayOrder(-7200)
	$entry.setIcon("image/entry/projectStatus-50x50.png")
	
	$entry.setSearchboxField("statusID")
	$entry.setSearchboxField("name")
	
	$entry.setPanel("panel_ProjectStatus"; 1)
	$pageListbox:=cs:C1710.sfw_definitionPageListbox.new("lb_projects")
	$pageListbox.setDatasource("Form.current_item.projects")
	$pageListbox.addColumn("This.name"; "width:300"; "headerLabel:Contract name")
	$pageListbox.addColumn("This.customer.name"; "width:200"; "headerLabel:Customer")
	$pageListbox.addColumn("This.company.name"; "width:200"; "headerLabel:Company")
	$pageListbox.addPredefinedAction("openInWindow"; "projectManagment"; "project")
	$pageListbox.addPredefinedAction("openAProjection"; "projectManagment"; "project")
	$pageListbox.addPredefinedAction("splitLine")
	$pageListbox.addSpecificAction("contractAction"; "That's a test action"; Formula:C1597(cs:C1710.sfw_dialog.me.alert("Hello")); Formula:C1597(Random:C100%2=0); "needAnEntity")
	$pageListbox.addPredefinedAction("export")
	$entry.setPanelDynamicPage(1; "project-32x32.png"; "Projects"; $pageListbox)
	
	$entry.setLBItemsColumn("colorPicto"; ""; "width:20"; "type:picture")
	$entry.setLBItemsColumn("statusID"; ""; "width:50")
	$entry.setLBItemsColumn("code"; "Code"; "width:50")
	$entry.setLBItemsColumn("name"; "Name"; "width:200")
	
	$entry.setLBItemsOrderBy("statusID")
	
	
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:project status"; "unitN:project status")
	$entry.setValidationRule("statusID"; "entryField_statusID"; "mandatory")
	$entry.setValidationRule("code"; "entryField_code"; "mandatory"; "trimSpace"; "capitalize")
	$entry.setValidationRule("name"; "entryField_name"; "mandatory"; "trimSpace"; "capitalize")
	//$entry.setValidationRule("color"; "entryField_color"; "mandatory"; "trimSpace"; "capitalize")
	//$entry.enableTransaction()
	
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	$entry.setItemListPreconfigAction("copyItemsListToPasteboard")
	
	
	//Mark:- Function to manage the cache
local Function cacheClear()
	If (Storage:C1525.cache#Null:C1517)
		Use (Storage:C1525.cache)
			Storage:C1525.cache.projectStatus:=Null:C1517
		End use 
	End if 
	
	
local Function cacheLoad()
	
	If (Storage:C1525.cache=Null:C1517)
		Use (Storage:C1525)
			Storage:C1525.cache:=New shared object:C1526
		End use 
	End if 
	If (Storage:C1525.cache.projectStatus=Null:C1517)
		$projectStatusColl:=This:C1470._loadAsCollection()
		Use (Storage:C1525.cache)
			Storage:C1525.cache.projectStatus:=$projectStatusColl.copy(ck shared:K85:29; Storage:C1525.cache)
		End use 
	End if 
	
	
local Function cacheGet($uuid : Text)->$projectStatus : Object
	If (Storage:C1525.cache=Null:C1517)
		This:C1470.cacheLoad()
	Else 
		If (Storage:C1525.cache.projectStatus=Null:C1517)
			This:C1470.cacheLoad()
		End if 
	End if 
	$indices:=Storage:C1525.cache.projectStatus.indices("UUID = :1"; $uuid)
	If ($indices.length>0)
		$projectStatus:=Storage:C1525.cache.projectStatus[$indices[0]]
	Else 
		$projectStatus:=New object:C1471
	End if 
	
	
Function trigger()
	If (Application type:C494=4D Local mode:K5:1)
		This:C1470.cacheClear()
	Else 
		EXECUTE ON CLIENT:C651("@"; "sfw_cacheManager"; "clear"; "ProjectStatus")
	End if 
	
Function _loadAsCollection()->$projectStatusColl : Collection
	var $file : 4D:C1709.File
	var $img : Picture
	$projectStatusColl:=This:C1470.all().toCollection("UUID, statusID, code, name, color").orderBy("statusID")