Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	//Mark: entry : Customer
	$entry:=cs:C1710.sfw_definitionEntry.new("customer"; ["customerService"]; "Customers")
	$entry.setDataclass("Customer")
	$entry.setDisplayOrder(100)
	$entry.setIcon("image/entry/customers-50x50.png")
	
	$entry.setSearchboxField("name")
	
	$entry.setPanel("panel_customer")
	$entry.setPanelPage(1; "staff-32x32.png"; "Main")
	$entry.setPanelPage(2; "staff-32x32.png"; "POs")
	$entry.setPanelPage(3; "staff-32x32.png"; "Jobs")
	$entry.setPanelPage(4; "staff-32x32.png"; "Planning")
	$entry.setPanelPage(5; "staff-32x32.png"; "CFM Receiving")
	$entry.setPanelPage(6; "staff-32x32.png"; "Invoices")
	$entry.setPanelPage(7; "staff-32x32.png"; "Timeline")
	
	$entry.setLBItemsColumn("name"; "Name"; "xliff:entry.customer.field.name"; "width:300")
	$entry.setLBItemsColumn("code"; "Code"; "xliff:entry.customer.field.name"; "width:200")
	
	$entry.setLBItemsOrderBy("name")
	
	
	