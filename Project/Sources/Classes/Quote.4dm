Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	//Mark: entry : Quote
	$entry:=cs:C1710.sfw_definitionEntry.new("quote"; ["customerService"]; "Quotes")
	$entry.setDataclass("Quote")
	$entry.setIcon("image/entry/contract-50x50.png")
	$entry.setSearchboxField("subject")
	$entry.setPanel("panel_quote")
	$entry.setPanelPage(1; "staff-32x32.png"; "Lines")
	$entry.setPanelPage(2; "staff-32x32.png"; "Assumptions and Terms")
	$entry.setPanelPage(3; "staff-32x32.png"; "Optional premilinary text")
	$entry.setPanelPage(4; "staff-32x32.png"; "Preview")
	
	$entry.setLBItemsColumn("subject"; "Subject"; "subject"; "width:300")
	$entry.setLBItemsColumn("code"; "Code"; "code"; "width:100")
	
	$entry.setLBItemsOrderBy("subject")
	
	
	$entry.enableTransaction()