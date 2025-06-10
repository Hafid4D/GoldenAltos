Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	$entry:=cs:C1710.sfw_definitionEntry.new("jobs"; ["customerService"]; "Jobs"; "Job")
	$entry.setDataclass("Job")
	$entry.setDisplayOrder(-200)
	$entry.setIcon("image/entry/jobs-white-50x50.png")
	
	$entry.setSearchboxField("jobNumber")
	
	$entry.setPanel("panel_job"; 1)
	$entry.setPanelPage(1; "po-infos-32x32.png"; "Main")
	$entry.setPanelPage(2; "po-lines-32x32.png"; "PO Lines")
	$entry.setPanelPage(3; "lots-32x32.png"; "Lots")
	
	
	$entry.setLBItemsColumn("jobNumber"; "Job #"; "width:100")
	$entry.setLBItemsColumn("division"; "Division"; "width:250")
	$entry.setLBItemsColumn("dateCreated"; "Created"; "width:100")
	
	$entry.setLBItemsOrderBy("jobNumber")
	
	// MARK: -Views
	$view:=cs:C1710.sfw_definitionView.new("archivedJobs"; "Archived Jobs"; "derivedFrom:main"; $entry)
	$view.setSubset("archivedJobs")
	$view.setPictoLabel("/RESOURCES/ga/image/picto/archived-16x16.png")
	$entry.setView($view)
	
	$view:=cs:C1710.sfw_definitionView.new("shippedJobs"; "Shipped Jobs"; "derivedFrom:main"; $entry)
	$view.setSubset("shippedJobs")
	$view.setPictoLabel("/RESOURCES/ga/image/picto/shipped-16x16.png")
	$entry.setView($view)
	
	$entry.enableTransaction()
	
Function archivedJobs()->$jobs : cs:C1710.JobSelection
	$jobs:=ds:C1482.Job.query("archived = :1"; True:C214)
	
	
Function shippedJobs()->$jobs : cs:C1710.JobSelection
	$jobs:=ds:C1482.Job.query("shipped = :1"; True:C214)
	
	