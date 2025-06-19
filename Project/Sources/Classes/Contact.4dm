

Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	//Mark: entry : Contact
	$entry:=cs:C1710.sfw_definitionEntry.new("contact"; ["customerService"; "salesAndQuotes"]; "Contacts")
	$entry.setDataclass("Contact")
	$entry.setDisplayOrder(-700)
	$entry.setIcon("image/entry/contact-white-50x50.png")
	
	$entry.setSearchboxField("customer.name"; "placeholder:customerName")
	
	$entry.setPanelPage(1; "staff-32x32.png"; "Main")
	$entry.setPanel("panel_contact")
	$entry.setLBItemsColumn("customer.name"; "Customer name"; "width:200")
	$entry.setLBItemsColumn("title"; "Title"; "width:200")
	$entry.setLBItemsOrderBy("customer.name")
	
	$entry.enableTransaction()
	
	$entry.activateFavorite()
	
	$filter:=cs:C1710.sfw_definitionFilter.new("filterCustomer")
	$filter.setDefaultTitle("All customers")
	$filter.setFilterByLinkedEntity("Customer"; "UUID_Customer"; ""; "customer")
	$filter.setDynamicTitle("name"; "## customers")
	$entry.addFilter($filter)
	
	$entry.activateEvent("ContactEvent"; "UUID_Contact")
	$entry.setAttributesToTrackInModificationEvent("firstName"; "lastName"; "code"; "title")
	$entry.setEventOptions("CreateModifyEventIfNoTrackingAttribute")
	
	