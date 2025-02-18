Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("department"; "teamManagment"; "Departments")
	$entry.setDataclass("Department")
	$entry.setIcon("image/entry/department-50x50.png")
	$entry.setSearchboxField("name")
	
	$entry.setPanel("panel_department")
	$entry.setPanelPage(1; "staff-32x32.png")
	
	$entry.setLBItemsColumn("code"; "Code"; "width:40")
	$entry.setLBItemsColumn("name"; "Name"; "width:200")
	$entry.setLBItemsColumn("nbStaff"; "Nb staff"; "width:70"; "center"; "headerCenter")
	$entry.setLBItemsColumn("company.country.iso_code_2"; " "; "type:flag"; "width:30"; "orderByFormula:this.company.country.iso_code_2")
	$entry.setLBItemsColumn("company.name"; "Name"; "width:200")
	$entry.setLBItemsOrderBy("name")
	
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:department"; "unitN:departments")
	
	
	$entry.setValidationRule("code"; "entryField_code"; "mandatory"; "trimSpace")
	$entry.setValidationRule("name"; "entryField_name"; "mandatory"; "trimSpace"; "capitalize")
	$entry.setValidationRule("UUID_Company"; ""; "UUIDNotNull"; "message:The company must be defined")
	$entry.setValidationRule("UUID_Manager"; ""; "UUIDNotNull"; "message:The manager must be defined")
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	$entry.setItemListPreconfigAction("copyItemsListToPasteboard")
	