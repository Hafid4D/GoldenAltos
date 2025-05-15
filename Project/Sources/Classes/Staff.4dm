Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("staff"; "housekeeping"; "Staff")
	$entry.setDataclass("Staff")
	$entry.setDisplayOrder(-300)
	$entry.setIcon("image/entry/staffs-white-50x50.png")
	
	$entry.setSearchboxField("firstName")
	$entry.setSearchboxField("lastName")
	
	
	$entry.setPanel("panel_staff")
	$entry.setPanelPage(1; ""; "Certifications Assignment")
	
	
	$entry.setLBItemsColumn("civility"; "Civility"; "width:50")
	$entry.setLBItemsColumn("firstName"; "First Name"; "width:200")
	$entry.setLBItemsColumn("lastName"; "Last Name"; "width:200")
	
	$entry.setLBItemsOrderBy("firstName")
	
	$entry.enableTransaction()
	