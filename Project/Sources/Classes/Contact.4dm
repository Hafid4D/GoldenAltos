

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
	$entry.setLBItemsColumn("companyName"; "Company name"; "width:200")
	$entry.setLBItemsColumn("title"; "Title"; "width:100")
	//$entry.setLBItemsColumn("companyType.name"; "Company Type"; "width:100")
	$entry.setLBItemsOrderBy("companyName")
	
	$entry.enableTransaction()
	
	$entry.activateFavorite()
	
	//$filter:=cs.sfw_definitionFilter.new("filterCustomer")
	//$filter.setDefaultTitle("All customers")
	//$filter.setFilterByLinkedEntity("Customer"; "UUID_Customer"; ""; "customer")
	//$filter.setDynamicTitle("name"; "## customers")
	//$entry.addFilter($filter)
	
	//$filter:=cs.sfw_definitionFilter.new("filterSupplier")
	//$filter.setDefaultTitle("All suppliers")
	//$filter.setFilterByLinkedEntity("Supplier"; "UUID_Supplier"; ""; "supplier")
	//$filter.setDynamicTitle("name"; "## suppliers")
	//$entry.addFilter($filter)
	
	//$filter:=cs.sfw_definitionFilter.new("filterCompanyType")
	//$filter.setDefaultTitle("All Company types")
	//$filter.setFilterByLinkedEntity("CompanyType"; "UUID_CompanyType"; ""; "companyType")
	//$filter.setDynamicTitle("name"; "## companyType")
	//$entry.addFilter($filter)
	
	$entry.activateEvent("ContactEvent"; "UUID_Contact")
	$entry.setAttributesToTrackInModificationEvent("firstName"; "lastName"; "code"; "title")
	$entry.setEventOptions("CreateModifyEventIfNoTrackingAttribute")
	
	
	
	
	
	
	// MARK: - Views Definition
	
	
	// MARK: Suppliers contact
	$view:=cs:C1710.sfw_definitionView.new("suppliersContacts"; "Suppliers Contacts")
	$view.setLBItemsColumn("companyName"; "Company name"; "width:200")
	$view.setLBItemsColumn("title"; "Title"; "width:100")
	//$view.setLBItemsColumn("companyType.name"; "Company Type"; "width:100")
	$view.setLBItemsOrderBy("companyName")
	$view.setSubset("suppliersContacts")
	$entry.setView($view)
	
	// MARK: Customers contact
	$view:=cs:C1710.sfw_definitionView.new("customersContacts"; "Customers Contacts")
	$view.setLBItemsColumn("companyName"; "Company name"; "width:200")
	$view.setLBItemsColumn("title"; "Title"; "width:100")
	//$view.setLBItemsColumn("companyType.name"; "Company Type"; "width:100")
	$view.setLBItemsOrderBy("companyName")
	$view.setSubset("customersContacts")
	$entry.setView($view)
	
	
Function suppliersContacts()->$contacts : cs:C1710.Contact
	$formula:=Formula:C1597(This:C1470.supplier#Null:C1517)
	$contacts:=ds:C1482.Contact.query(":1"; $formula)
	
Function customersContacts()->$contacts : cs:C1710.Contact
	$formula:=Formula:C1597(This:C1470.customer#Null:C1517)
	$contacts:=ds:C1482.Contact.query(":1"; $formula)
	
	
	
	