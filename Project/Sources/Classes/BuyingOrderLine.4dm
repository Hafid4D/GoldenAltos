// Purpose: SFW entry for vendor AP bills (legacy BUY_ITEMS vendor bill lines).
// created by 4D/PS [2026-june-29]
Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("VendorBill"; ["accounting"]; "Vendor Bills"; "BuyingOrderLine")
	$entry.setDataclass("BuyingOrderLine")
	$entry.setDisplayOrder(-650)
	$entry.setIcon("image/entry/buyingOrders-50x50.png")
	
	$entry.setSearchboxField("seqNumber")
	$entry.setSearchboxField("vendorName"; "placeholder:vendorName")
	
	$entry.setPanel("panel_vendorBill"; 1)
	$entry.setPanelPage(1; ""; "Main")
	
	$entry.setLBItemsColumn("billNumber"; "Bill #"; "width:70")
	// Purpose: List columns bind to typed catalog fields (legacy BUY_ITEMS AP bill lines).
	// modified by 4D/PS [2026-june-29]
	$entry.setLBItemsColumn("vendorName"; "Vendor"; "width:180")
	$entry.setLBItemsColumn("orderDate"; "Bill Date"; "width:80")
	$entry.setLBItemsColumn("glAccount"; "GL"; "width:60")
	$entry.setLBItemsColumn("netBillAmount"; "Amount"; "width:80")
	$entry.setLBItemsColumn("checkNumber"; "Check #"; "width:70")
	$entry.setLBItemsOrderBy("seqNumber")
	$entry.setMainViewLabel("All vendor bills")
	
	$entry.setItemListAction("Export to Excel"; "_ga_exportVendorBillSelection")
	
	$entry.enableTransaction()
	$entry.activateFavorite()
