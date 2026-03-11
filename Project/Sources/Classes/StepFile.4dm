Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	$entry:=cs:C1710.sfw_definitionEntry.new("stepFile"; ["housekeeping"]; "Step File"; "Step Files")
	$entry.setDataclass("StepFile")
	$entry.setDisplayOrder(100)
	$entry.setIcon("image/entry/stepFile-52x52.png")
	
	$entry.setSearchboxField("name")
	
	$entry.setPanel("panel_stepFile")
	$entry.setPanelPage(1; ""; "Steps")
	
	$entry.setLBItemsColumn("customer.name"; "Customer"; "width:170")
	$entry.setLBItemsColumn("name"; "Step File Name"; "width:190")
	$entry.setLBItemsColumn("creationDate"; "Creation date"; "type:date"; "width:50"; "center")
	
	
	$entry.setLBItemsOrderBy("creationDate"; True:C214)
	
	$entry.enableTransaction()
	
	// MARK: -Filters
	
	$filter:=cs:C1710.sfw_definitionFilter.new("filterCustomer")
	$filter.setDefaultTitle("All customers")
	$filter.setFilterByLinkedEntity("Customer"; "UUID_Customer"; ""; "customer")
	$filter.setDynamicTitle("name"; "## Customer")
	$entry.addFilter($filter)
	
	