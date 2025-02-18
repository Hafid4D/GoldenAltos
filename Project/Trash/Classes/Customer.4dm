Class extends DataClass


//Test github commit on a personnal Mac
local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("customer"; "projectManagment"; "Customer")
	$entry.setDataclass("Customer")
	$entry.setIcon("image/entry/customersBuilding-50x50.png")
	$entry.setSearchboxField("name")
	$entry.setSearchboxField("completeName")
	$entry.setDisplayOrder(2000)
	$entry.setPanel("panel_customer")
	
	$entry.setPanelPage(1; "project-32x32.png"; "projects")
	$entry.setPanelPage(2; "address-32x32.png"; "address")
	$entry.setPanelPage(3; "staff-32x32.png"; "contact")
	
	
	//$entry.setLBItemsColumn("country.flag"; " "; "type:picture"; "width:30"; "orderByFormula:this.country.iso_code_2")
	$entry.setLBItemsColumn("country.iso_code_2"; " "; "type:flag"; "width:30"; "orderByFormula:this.country.iso_code_2")
	$entry.setLBItemsColumn("name"; "Name"; "width:200")
	$entry.setLBItemsColumn("nbProjects"; "Projects"; "width:75"; "type:num"; "format:##0;;-"; "center"; "headerCenter")
	$entry.setLBItemsColumn("nbContracts"; "Contracts"; "width:75"; "type:num"; "format:##0;;-"; "center"; "headerCenter")
	$entry.setLBItemsOrderBy("name")
	
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:customer"; "unitN:customers")
	
	$entry.setValidationRule("name"; "entryField_name"; "mandatory"; "trimSpace")
	$entry.setValidationRule("name"; "entryField_completeName"; "mandatory"; "trimSpace")
	$entry.setValidationRule("UUID_Country"; ""; "UUIDNotNull"; "message:The country must be defined")
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	$entry.setItemListPreconfigAction("copyItemsListToPasteboard")
	
	$entry.enableTransaction()
	
	$entry.activateFavorite()
	$entry.activateComment()
	
	
	
local Function cacheClear()
	If (Storage:C1525.cache#Null:C1517)
		Use (Storage:C1525.cache)
			Storage:C1525.cache.customer:=Null:C1517
		End use 
	End if 
	
	
local Function cacheLoad()
	
	If (Storage:C1525.cache=Null:C1517)
		Use (Storage:C1525)
			Storage:C1525.cache:=New shared object:C1526
		End use 
	End if 
	If (Storage:C1525.cache.customer=Null:C1517)
		$customerCall:=This:C1470._loadAsCollection()
		Use (Storage:C1525.cache)
			Storage:C1525.cache.customer:=$customerCall.copy(ck shared:K85:29; Storage:C1525.cache)
		End use 
	End if 
	
	
local Function cacheGet($uuid : Text)->$customer : Object
	If (Storage:C1525.cache=Null:C1517)
		This:C1470.cacheLoad()
	Else 
		If (Storage:C1525.cache.sfw_country=Null:C1517)
			This:C1470.cacheLoad()
		End if 
	End if 
	$indices:=Storage:C1525.cache.customer.indices("UUID = :1"; $uuid)
	If ($indices.length>0)
		$customer:=Storage:C1525.cache.customer[$indices[0]]
	Else 
		$customer:=New object:C1471
	End if 
	
	
Function trigger()
	If (Application type:C494=4D Local mode:K5:1)
		This:C1470.cacheClear()
	Else 
		EXECUTE ON CLIENT:C651("@"; "sfw_cacheManager"; "clear"; "Customer")
	End if 
	
Function _loadAsCollection()->$customerCall : Collection
	
	$customerCall:=This:C1470.all().toCollection("UUID, name, country.iso_code_2").orderBy("name")