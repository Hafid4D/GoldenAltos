Class extends DataClass



local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	var $pageListbox : cs:C1710.sfw_definitionPageListbox
	
	$entry:=cs:C1710.sfw_definitionEntry.new("contractType"; "administration"; "Contract types")
	$entry.setDataclass("ContractType")
	$entry.setDisplayOrder(-2000)
	$entry.setIcon("image/entry/contractType-50x50.png")
	$entry.setSearchboxField("code")
	$entry.setSearchboxField("name")
	
	$entry.setPanel("panel_contractType"; 1)
	
	$pageListbox:=cs:C1710.sfw_definitionPageListbox.new("lb_contracts")
	$pageListbox.setDatasource("Form.current_item.contracts")
	$pageListbox.addColumn("This.name"; "width:300"; "headerLabel:Contract name")
	$pageListbox.addColumn("This.customer.name"; "width:200"; "headerLabel:Customer")
	$pageListbox.addColumn("This.sowDays"; "width:70"; "headerLabel:Sow (Days)"; "formatNum:###,###,##0.0;;")
	$pageListbox.addColumn("This.budget"; "headerLabel:Budget"; "formatNum:###,###,##0.00;;")
	$pageListbox.addPredefinedAction("openInWindow"; "projectManagment"; "contract")
	$pageListbox.addPredefinedAction("openAProjection"; "projectManagment"; "contract")
	$pageListbox.addPredefinedAction("splitLine")
	//$pageListbox.addSpecificAction("contractAction"; "That's a test action"; Formula(cs.sfw_dialog.me.alert("Hello")); Formula(Random%2=0); "needAnEntity")
	$pageListbox.addPredefinedAction("export")
	$entry.setPanelDynamicPage(1; "contract-32x32.png"; "Contracts"; $pageListbox)
	
	//$pageListbox:=cs.sfw_definitionPageListbox.new("lb_staff")
	//$pageListbox.setDatasource("Form.current_item.contracts")
	//$pageListbox.addColumn("This.name"; "width:300"; "headerLabel:Contract name")
	//$entry.setPanelDynamicPage(2; "staff-32x32.png"; "Contracts2"; $pageListbox)
	
	
	$entry.setLBItemsColumn("colorPicture"; ""; "type:picture"; "width:15"; "orderByFormula:this.name")
	$entry.setLBItemsColumn("code"; "Code"; "width:100")
	$entry.setLBItemsColumn("name"; "Name"; "width:200")
	$entry.setLBItemsOrderBy("code")
	
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:contract type"; "unitN:contract types")
	$entry.setValidationRule("code"; "entryField_code"; "mandatory"; "trimSpace"; "uppercase")
	$entry.setValidationRule("name"; "entryField_name"; "mandatory"; "trimSpace"; "capitalize")
	
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	$entry.setItemListPreconfigAction("copyItemsListToPasteboard")
	$entry.setToolBarGroup("ServicesGroup"; "Services"; "sfw/entry/FW-50x50.png")
	
	//Mark:- Function to manage the cache
local Function cacheClear()
	If (Storage:C1525.cache#Null:C1517)
		Use (Storage:C1525.cache)
			Storage:C1525.cache.contractType:=Null:C1517
		End use 
	End if 
	
	
local Function cacheLoad()
	
	If (Storage:C1525.cache=Null:C1517)
		Use (Storage:C1525)
			Storage:C1525.cache:=New shared object:C1526
		End use 
	End if 
	If (Storage:C1525.cache.contractType=Null:C1517)
		$contractTypeColl:=This:C1470._loadAsCollection()
		Use (Storage:C1525.cache)
			Storage:C1525.cache.contractType:=$contractTypeColl.copy(ck shared:K85:29; Storage:C1525.cache)
		End use 
	End if 
	
	
local Function cacheGet($uuid : Text)->$contractType : Object
	If (Storage:C1525.cache=Null:C1517)
		This:C1470.cacheLoad()
	Else 
		If (Storage:C1525.cache.sfw_country=Null:C1517)
			This:C1470.cacheLoad()
		End if 
	End if 
	
	$indices:=Storage:C1525.cache.contractType.indices("UUID = :1"; $uuid)
	If ($indices.length>0)
		$contractType:=Storage:C1525.cache.contractType[$indices[0]]
	Else 
		$contractType:=New object:C1471
	End if 
	
	
Function trigger()
	If (Application type:C494=4D Local mode:K5:1)
		This:C1470.cacheClear()
	Else 
		EXECUTE ON CLIENT:C651("@"; "sfw_cacheManager"; "clear"; "ContractType")
	End if 
	
Function _loadAsCollection()->$contractTypeColl : Collection
	
	$contractTypeColl:=This:C1470.all().toCollection("UUID, code, name").orderBy("name")