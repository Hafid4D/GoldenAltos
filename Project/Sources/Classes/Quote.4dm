Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	//Mark: entry : Quote
	$entry:=cs:C1710.sfw_definitionEntry.new("quote"; ["customerService"]; "Quotes")
	$entry.setDataclass("Quote")
	$entry.setIcon("image/entry/contract-50x50.png")
	$entry.setSearchboxField("subject")
	$entry.setPanel("panel_quote")
	$entry.setPanelPage(1; "address-32x32.png"; "Info")
	
	$entry.setLBItemsColumn("subject"; "Subject"; "subject"; "width:300")
	$entry.setLBItemsColumn("code"; "Code"; "code"; "width:100")
	
	$entry.setLBItemsOrderBy("subject")