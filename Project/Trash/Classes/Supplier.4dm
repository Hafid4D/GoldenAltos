Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	//Mark: entry : Equipment
	$entry:=cs:C1710.sfw_definitionEntry.new("AVL"; ["qualityAssistance"]; "AVL")
	$entry.setDataclass("Supplier")
	$entry.setSearchboxField("partData.internalPartNum")
	$entry.setDisplayOrder(-700)
	$entry.setIcon("image/entry/avl-white-50x50.png")
	
	$entry.setSearchboxField("name"; "placeholder:Supplier name")
	
	$entry.setPanel("panel_supplier")
	$entry.setPanelPage(1; ""; "Main")
	
	$entry.setLBItemsColumn("name"; "Supplier Name"; "width:250")
	$entry.setLBItemsColumn("approvedByQA?\"Approved\":\"Not Approved\""; "QA Approval"; "width:150"; "orderByFormula:this.approvedByQA")
	$entry.setLBItemsOrderBy("name")
	