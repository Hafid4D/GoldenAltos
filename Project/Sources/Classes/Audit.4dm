Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	//Mark: entry : Equipment
	$entry:=cs:C1710.sfw_definitionEntry.new("Audit"; ["qualityAssurance"]; "Audits")
	$entry.setDataclass("Audit")
	$entry.setDisplayOrder(-900)
	$entry.setIcon("image/entry/audit-50x50.png")
	
	$entry.setSearchboxField("book")
	
	$entry.setPanel("panel_audit")
	$entry.setPanelPage(1; ""; "Main")
	
	$entry.setLBItemsColumn("book"; "Operational Areas"; "width:150")
	$entry.setLBItemsOrderBy("book")

