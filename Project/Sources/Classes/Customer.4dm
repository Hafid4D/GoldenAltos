Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	//Mark: entry : Customer
	$entry:=cs:C1710.sfw_definitionEntry.new("customer"; ["customerService"]; "Customers")
	$entry.setDataclass("Customer")
	$entry.setDisplayOrder(100)
	$entry.setIcon("image/entry/customers-white-50x50.png")
	
	$entry.setSearchboxField("name")
	
	$entry.setPanel("panel_customer")
	$entry.setPanelPage(1; "staff-32x32.png"; "Main"+String:C10(Count))
	$entry.setPanelPage(2; "staff-32x32.png"; "POs")
	$entry.setPanelPage(3; "staff-32x32.png"; "Jobs")
	$entry.setPanelPage(4; "staff-32x32.png"; "Planning")
	$entry.setPanelPage(5; "staff-32x32.png"; "CFM Receiving")
	$entry.setPanelPage(6; "staff-32x32.png"; "Invoices")
	//$entry.setPanelPage(7; "staff-32x32.png"; "Timeline")
	
	$entry.setLBItemsColumn("name"; "Name"; "xliff:entry.customer.field.name"; "width:300")
	$entry.setLBItemsColumn("code"; "Code"; "xliff:entry.customer.field.name"; "width:200")
	
	$entry.setLBItemsOrderBy("name")
	
	$entry.activateEvent("CustomerEvent"; "UUID_Customer")
	$entry.setAttributesToTrackInModificationEvent("IDT_status"; "name"; "IDT_carrier"; "accountNumber"; "code"; "resaleLicenseNumber")
	$entry.setEventOptions("dontCreateModifyEventIfNoTrackingAttribute")
	
	
	// MARK: -Filters
	$filter:=cs:C1710.sfw_definitionFilter.new("filterCustomerStatus")
	$filter.setDefaultTitle("All status")
	$filter.setFilterByIDInTable("CustomerStatus"; "statusID"; "IDT_status")
	$filter.setDynamicTitle("name"; "## customer status")
	$entry.addFilter($filter)
	
local Function cacheLoad()
	
	If (Storage:C1525.cache=Null:C1517)
		Use (Storage:C1525)
			Storage:C1525.cache:=New shared object:C1526
		End use 
	End if 
	If (Storage:C1525.cache.customers=Null:C1517)
		$customers:=This:C1470._loadAsCollection()
		Use (Storage:C1525.cache)
			Storage:C1525.cache.customers:=$customers.copy(ck shared:K85:29; Storage:C1525.cache)
		End use 
	End if 
	
	
Function _loadAsCollection()->$customers : Collection
	$customers:=This:C1470.all().toCollection("UUID,name").orderBy("name")
	