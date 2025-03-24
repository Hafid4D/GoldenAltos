Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	//Mark: entry : Customer
	$entry:=cs:C1710.sfw_definitionEntry.new("customer"; ["customerService"]; "Customers")
	$entry.setDataclass("Customer")
	$entry.setDisplayOrder(100)
	$entry.setIcon("image/entry/customers-50x50.png")
	
	$entry.setSearchboxField("name")
	
	$entry.setPanel("panel_customer")
	$entry.setPanelPage(1; "address-32x32.png"; "address")
	
	$entry.setLBItemsColumn("name"; "Name"; "xliff:entry.customer.field.name"; "width:300")
	$entry.setLBItemsColumn("code"; "Code"; "xliff:entry.customer.field.name"; "width:200")
	
	$entry.setLBItemsOrderBy("name")
	