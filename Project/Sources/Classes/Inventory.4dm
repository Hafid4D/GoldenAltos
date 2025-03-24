Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("inventories"; ["customerService"]; "Inventories"; "Inventory")
	$entry.setDataclass("Inventory")
	$entry.setDisplayOrder(-400)
	$entry.setIcon("image/entry/inventories-50x50.png")
	
	$entry.setSearchboxField("stockNum")
	
	
	$entry.setPanel("panel_inventory"; 1)
	$entry.setPanelPage(1; "po-infos-32x32.png"; "Infos")
	$entry.setPanelPage(2; "inventory-pulls-32x32.png"; "Inventory Pulls")
	
	
	$entry.setLBItemsColumn("stockNum"; "Stock #"; "width:100")
	$entry.setLBItemsColumn("vendor"; "Vendor"; "width:180")
	$entry.setLBItemsColumn("classification"; "Classification"; "width:80")
	$entry.setLBItemsColumn("dateIn"; "Date In"; "width:80")
	
	$entry.setLBItemsOrderBy("stockNum")
	