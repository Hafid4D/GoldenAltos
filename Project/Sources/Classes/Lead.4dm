Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	$entry:=cs:C1710.sfw_definitionEntry.new("lead"; ["salesAndQuotes"]; "Leads")
	$entry.setDataclass("Lead")
	$entry.setDisplayOrder(-500)
	$entry.setIcon("image/entry/lead-50x50.png")
	
	$entry.setSearchboxField("leadCode")
	$entry.setSearchboxField("customerName")
	$entry.setPanel("panel_lead")
	
	
	
	$entry.setLBItemsColumn("leadCode"; "Lead ID"; "width:50")
	$entry.setLBItemsColumn("customerName"; "Customer"; "subject"; "width:300")
	$entry.setLBItemsColumn("amountText"; "Amount"; "width:80"; "left"; "headerCenter")
	
	$entry.setValidationRule("UUID_Staff"; ""; "UUIDNotNull"; "message:The staff must be defined")
	$entry.setValidationRule("UUID_Customer"; ""; "UUIDNotNull"; "message:The customer must be defined")
	$entry.setValidationRule("dateCreation"; "entryField_dateCreation"; "mandatory")
	$entry.setValidationRule("UUID_ServiceType"; ""; "UUIDNotNull"; "message:The service must be defined")
	//$entry.setValidationRule("currentStageID"; "entryField_dateCreation"; "mandatory")
	
	$entry.setLBItemsOrderBy("leadCode")
	
	
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:lead"; "unitN:leads")
	$entry.setMainViewLabel("All leads")
	$entry.enableTransaction()
	
	
	$entry.setItemListAction("Export Leads - CSV"; "lead_export_csv")
	
	
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	
	
	//Mark:- Filters
	
	//customers
	$filter:=cs:C1710.sfw_definitionFilter.new("filterCustomer")
	$filter.setDefaultTitle("All customers")
	$filter.setFilterByLinkedEntity("Customer"; "UUID_Customer"; "uuidCustomer"; "customer")
	$filter.setDynamicTitle("name"; "## customers")
	$filter.setOrderForItems("name")
	$entry.addFilter($filter)
	
	//service types
	$filter:=cs:C1710.sfw_definitionFilter.new("filterServiceType")
	$filter.setDefaultTitle("All services")
	$filter.setFilterByLinkedEntity("ServiceType"; "UUID_ServiceType"; "uuidService"; "serviceType")
	$filter.setDynamicTitle("name"; "## services")
	$filter.setOrderForItems("name")
	$entry.addFilter($filter)
	
	
	//stages
	$filter:=cs:C1710.sfw_definitionFilter.new("filterCurrentStage")
	$filter.setDefaultTitle("All stages")
	$filter.setFilterByIDInTable("LeadStage"; "stageID"; "currentStageID")
	$filter.setDynamicTitle("name"; "## statuses")
	$entry.addFilter($filter)
	
	//priorities
	$filter:=cs:C1710.sfw_definitionFilter.new("filterCurrentPriority")
	$filter.setDefaultTitle("All priorities")
	$filter.setFilterByIDInTable("LeadPriority"; "levelID"; "priorityLevelID")
	$filter.setDynamicTitle("name"; "## priorities")
	$entry.addFilter($filter)
	