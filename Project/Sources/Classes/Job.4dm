Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("jobs"; ["customerService"]; "Jobs")
	$entry.setDataclass("Job")
	$entry.setDisplayOrder(-200)
	$entry.setIcon("image/entry/jobs-50x50.png")
	
	$entry.setSearchboxField("jobNumber")
	
	
	$entry.setPanel("panel_job"; 1)
	$entry.setPanelPage(1; "po-infos-32x32.png"; "Main")
	$entry.setPanelPage(2; "po-lines-32x32.png"; "PO Lines")
	$entry.setPanelPage(3; "lots-32x32.png"; "Lots")
	
	
	$entry.setLBItemsColumn("jobNumber"; "Job #"; "width:100")
	$entry.setLBItemsColumn("division"; "Division"; "width:250")
	$entry.setLBItemsColumn("dateCreated"; "Created"; "width:100")
	
	$entry.setLBItemsOrderBy("jobNumber")
	