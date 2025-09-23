

Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	//Mark: entry : Contact
	$entry:=cs:C1710.sfw_definitionEntry.new("contact"; ["customerService"; "salesAndQuotes"]; "Contacts")
	$entry.setDataclass("Contact")
	$entry.setDisplayOrder(-700)
	$entry.setIcon("image/entry/contact-white-50x50.png")
	
	$entry.setSearchboxField("companyName"; "placeholder:companyName")
	
	$entry.setPanelPage(1; "staff-32x32.png"; "Main")
	$entry.setPanel("panel_contact")
	$entry.setLBItemsColumn("fullName"; "Full Name"; "width:200")
	$entry.setLBItemsColumn("companyName"; "Company name"; "width:200")
	//$entry.setLBItemsColumn("title"; "Title"; "width:100")
	$entry.setLBItemsOrderBy("companyName")
	
	$entry.enableTransaction()
	
	$entry.activateFavorite()
	
	
	// MARK: - Views Definition
	
	
	// MARK: Suppliers contact
	$view:=cs:C1710.sfw_definitionView.new("suppliersContacts"; "Suppliers Contacts")
	$view.setLBItemsColumn("companyName"; "Company name"; "width:200")
	$view.setLBItemsColumn("title"; "Title"; "width:100")
	$view.setLBItemsOrderBy("companyName")
	$view.setSubset("suppliersContacts")
	$entry.setView($view)
	
	// MARK: Customers contact
	$view:=cs:C1710.sfw_definitionView.new("customersContacts"; "Customers Contacts")
	$view.setLBItemsColumn("companyName"; "Company name"; "width:200")
	$view.setLBItemsColumn("title"; "Title"; "width:100")
	$view.setLBItemsOrderBy("companyName")
	$view.setSubset("customersContacts")
	$entry.setView($view)
	
	
Function suppliersContacts()->$contacts : cs:C1710.ContactSelection
	var $suppliersUUIDs : Collection:=New collection:C1472()
	$suppliersUUIDs:=ds:C1482.Supplier.all().toCollection().extract("UUID")  //$formula:=Formula(This.supplier#Null)
	$contacts:=ds:C1482.Contact.query("UUID_Company IN :1"; $suppliersUUIDs)
	
Function customersContacts()->$contacts : cs:C1710.ContactSelection
	var $customersUUIDs : Collection:=New collection:C1472()
	$customersUUIDs:=ds:C1482.Customer.all().toCollection().extract("UUID")  //$formula:=Formula(This.customer#Null)
	$contacts:=ds:C1482.Contact.query("UUID_Company IN :1"; $customersUUIDs)
	
	
local Function cacheLoad()
	
	If (Storage:C1525.cache=Null:C1517)
		Use (Storage:C1525)
			Storage:C1525.cache:=New shared object:C1526
		End use 
	End if 
	If (Storage:C1525.cache.companyTypes=Null:C1517)
		$companyTypes:=This:C1470._loadAsCollection()
		Use (Storage:C1525.cache)
			Storage:C1525.cache.companyTypes:=$companyTypes.copy(ck shared:K85:29; Storage:C1525.cache)
		End use 
	End if 
	
	
local Function _loadAsCollection()->$companyTypes : Collection
	$companyTypes:=New collection:C1472("Supplier"; "Customer")
	