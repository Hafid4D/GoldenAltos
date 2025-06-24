Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	//Mark: entry : Specification
	$entry:=cs:C1710.sfw_definitionEntry.new("specification"; ["qualityAssistance"]; "Specs Control")
	$entry.setDataclass("Specification")
	$entry.setSearchboxField("spec")
	$entry.setDisplayOrder(-500)
	$entry.setIcon("image/entry/spec-control-white-50x50.png")
	
	$entry.setSearchboxField("spec"; "placeholder:Spec#")
	
	$entry.setLBItemsColumn("spec"; "Spec#"; "width:50")
	$entry.setLBItemsColumn("rev"; "Revision"; "width:50")
	$entry.setLBItemsColumn("title"; "Title")
	
	$entry.setLBItemsOrderBy("spec")
	
	$entry.setPanel("panel_specification")
	
	$entry.setPanelPage(1; ""; "Main")
	$entry.setPanelPage(2; ""; "Documents")
	
	
	
	