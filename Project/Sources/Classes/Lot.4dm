Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("lots"; ["customerService"]; "Lots"; "Lot")
	$entry.setDataclass("Lot")
	$entry.setDisplayOrder(-300)
	$entry.setIcon("image/entry/lots-50x50.png")
	
	$entry.setSearchboxField("lotNumber")
	
	
	$entry.setPanel("panel_lot")
	$entry.setPanelPage(1; "po-infos-32x32.png"; "Main")
	$entry.setPanelPage(2; "lot-steps-32x32.png"; "Lot Steps")
	$entry.setPanelPage(3; "inventories-32x32.png"; "Inventories")
	
	
	$entry.setLBItemsColumn("lotNumber"; "Lot #"; "width:100")
	$entry.setLBItemsColumn("device"; "Device"; "width:200")
	$entry.setLBItemsColumn("dateIn"; "Date IN"; "width:75"; "center")
	$entry.setLBItemsColumn("dateOut"; "Date OUT"; "width:75"; "center")
	
	$entry.setLBItemsOrderBy("lotNumber")
	