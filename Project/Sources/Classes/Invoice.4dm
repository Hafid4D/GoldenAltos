

Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	//Mark: entry : Contact
	$entry:=cs:C1710.sfw_definitionEntry.new("invoice"; ["customerService"]; "Invoices")
	$entry.setDataclass("Invoice")
	$entry.setDisplayOrder(-800)
	$entry.setIcon("image/entry/invoice-white-50x50.png")
	
	$entry.setSearchboxField("fullName")
	$entry.setSearchboxField("companyName"; "placeholder:companyName")
	
	$entry.setPanelPage(1; "staff-32x32.png"; "Main")
	$entry.setPanel("panel_contact")
	$entry.setLBItemsColumn("fullName"; "Full Name"; "width:200")
	$entry.setLBItemsColumn("companyName"; "Company name"; "width:200")
	//$entry.setLBItemsColumn("title"; "Title"; "width:100")
	$entry.setLBItemsOrderBy("companyName")
	$entry.setMainViewLabel("All contacts")
	
	$entry.enableTransaction()
	
	$entry.activateFavorite()
	