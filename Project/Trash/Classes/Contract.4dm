Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("contract"; "projectManagment"; "Contracts")
	$entry.setDataclass("Contract")
	$entry.setIcon("image/entry/contract-50x50.png")
	$entry.setSearchboxField("name")
	$entry.setSearchboxField("customer.name"; "placeholder:customerName")
	$entry.setDisplayOrder(1000)
	$entry.setPanel("panel_contract")
	
	$entry.setLBItemsColumn("contractType.code"; "Type"; "width:55"; "center"; "columnName:contractType")
	$entry.setLBItemsColumn("customer.name"; "Customer name"; "width:150")
	$entry.setLBItemsColumn("name"; "Contract"; "width:150")
	$entry.setLBItemsColumn("dateSigning"; "Signing date"; "width:50"; "type:date")
	$entry.setLBItemsOrderBy("customer.name")
	
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:contract"; "unitN:contracts")
	
	$entry.setValidationRule("name"; "entryField_name"; "mandatory"; "trimSpace"; "capitalize"; "message:The customer must be defined")
	$entry.setValidationRule("UUID_Customer"; ""; "UUIDNotNull"; "message:The customer must be defined")
	$entry.setValidationRule("UUID_ContractType"; ""; "UUIDNotNull"; "message:The contract type must be defined")
	$entry.setValidationRule("UUID_Currency"; ""; "UUIDNotNull"; "message:The currency must be defined")
	
	$entry.enableTransaction()
	
	$entry.activateFavorite()
	
	
	
	$filter:=cs:C1710.sfw_definitionFilter.new("filterCustomer")
	$filter.setDefaultTitle("All customers")
	$filter.setFilterByLinkedEntity("Customer"; "UUID_Customer"; ""; "customer")
	$filter.setDynamicTitle("name"; "## customers")
	$entry.addFilter($filter)
	
	$filter:=cs:C1710.sfw_definitionFilter.new("filterContract")
	$filter.setDefaultTitle("All types of contract")
	$filter.setFilterByLinkedEntity("ContractType"; "UUID_ContractType"; ""; "contractType")
	$filter.setDynamicTitle("name"; "## contract types")
	$entry.addFilter($filter)
	
	$filter:=cs:C1710.sfw_definitionFilter.new("filterCustomerCountry")
	$filter.setDefaultTitle("All customer countries")
	$filter.setFilterByLinkedEntity("sfw_Country"; "customer.UUID_Country"; "uuidCustomerCountry"; "customer.country")
	$filter.setDynamicTitle("name"; "## customer countries")
	$entry.addFilter($filter)