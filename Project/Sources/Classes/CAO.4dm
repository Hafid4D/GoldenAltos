

Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	//Mark: entry : CAO
	$entry:=cs:C1710.sfw_definitionEntry.new("CAO"; ["customerService"]; "CAOs"; "CAO")
	$entry.setDataclass("CAO")
	$entry.setDisplayOrder(-900)
	$entry.setIcon("image/entry/charOfAccount-white-50x50.png")
	
	$entry.setSearchboxField("name")
	
	$entry.setPanel("panel_CAO"; 1)
	$entry.setPanelPage(1; ""; "Main")
	
	//$entry.setLBItemsColumn("dateCreated"; "Created"; "width:100")
	$entry.setLBItemsColumn("name"; "Name"; "width:150")
	$entry.setLBItemsColumn("type.name"; "Type"; "width:150")
	$entry.setLBItemsColumn("typeDetail.name"; "Type Detail"; "width:100")
	$entry.setLBItemsColumn("balance"; "Balance"; "width:50")
	
	$entry.setLBItemsOrderBy("name")
	$entry.setMainViewLabel("All Chart of Account")
	
	$entry.setItemListAction("Print Chart Of Account List"; "_ga_printCAOSelection")
	$entry.setItemListAction("Export Chart Of Account List"; "_ga_exportCAOSelection")
	
	$entry.enableTransaction()
	
	$entry.activateFavorite()