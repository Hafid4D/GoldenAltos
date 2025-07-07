
Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	//Mark: entry : Equipment
	$entry:=cs:C1710.sfw_definitionEntry.new("AML"; ["qualityAssistance"]; "AML")
	$entry.setDataclass("AML")
	$entry.setSearchboxField("partData.internalPartNum")
	$entry.setDisplayOrder(-600)
	$entry.setIcon("image/entry/aml-white-50x50.png")
	
	$entry.setSearchboxField("partData.internalPartNum"; "placeholder:Internal Part#")
	
	$entry.setPanel("panel_AML")
	$entry.setPanelPage(1; ""; "Main")
	
	$entry.setLBItemsColumn("partData.internalPartNum"; "Internal Part#"; "width:250")
	$entry.setLBItemsColumn("vendorPartnum"; "Vendor Part#"; "width:150")
	//$entry.setLBItemsColumn("supplier.name"; "Vendor name"; "width:200")
	$entry.setLBItemsOrderBy("partData.internalPartNum")
	