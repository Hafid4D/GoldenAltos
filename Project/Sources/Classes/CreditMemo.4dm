
Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	//Mark: entry : CreditMemo
	$entry:=cs:C1710.sfw_definitionEntry.new("CreditMemo"; ["accounting"]; "CreditMemos"; "CreditMemo")
	$entry.setDataclass("CreditMemo")
	$entry.setDisplayOrder(-300)
	$entry.setIcon("image/entry/creditMemo-white-50x50.png")
	
	$entry.setSearchboxField("cmNum")
	
	$entry.setPanel("panel_CreditMemo"; 1)
	$entry.setPanelPage(1; ""; "Main")
	
	$entry.setLBItemsColumn("cmNum"; "Credit Memo #"; "width:50")
	$entry.setLBItemsColumn("customer.name"; "Customer"; "width:200")
	$entry.setLBItemsColumn("description"; "Description"; "width:100")
	$entry.setLBItemsColumn("cmTotal"; "Total"; "width:100")
	
	$entry.setLBItemsOrderBy("cmNum")
	$entry.setMainViewLabel("All Credit Memos")
	
	$entry.setItemListAction("Print Credit Note"; "_ga_printCreditNote")
	
	$entry.enableTransaction()
	
	$entry.activateFavorite()