Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("contact"; "projectManagment"; "Contacts")
	$entry.setDataclass("Contact")
	$entry.setDisplayOrder(1500)
	$entry.setIcon("image/entry/contact-50x50.png")
	
	$entry.setSearchboxField("firstName")
	$entry.setSearchboxField("lastName")
	$entry.setSearchboxField("contactDetails.addresses[].detail.city"; "placeholder:city")
	
	$entry.setPanel("panel_contact"; 2)
	$entry.setPanelPage(2; "address-32x32.png"; "address")
	
	$entry.setLBItemsColumn("firstName"; "First Name"; "xliff:entry.customer.field.firstName"; "headerLeft"; "headerStroke:midnightblue")
	$entry.setLBItemsColumn("lastName"; "Last Name"; "xliff:entry.customer.field.lastName"; "headerLeft"; "headerStroke:midnightblue")
	$entry.setLBItemsColumn("customer.country.flag"; " "; "type:picture"; "width:30"; "orderByFormula:this.customer.country.iso_code_2")
	$entry.setLBItemsColumn("customer.name"; "Customer"; "xliff:entry.customer.field.name"; "width:160"; "headerLeft"; "headerStroke:midnightblue")
	
	
	$entry.setLBItemsOrderBy("firstName")
	$entry.setLBItemsOrderBy("lastName")
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:contact"; "unitN:contacts")
	$entry.setValidationRule("code"; "entryField_code"; "mandatory"; "trimSpace"; "uppercase")
	$entry.setValidationRule("name"; "entryField_name"; "mandatory"; "trimSpace"; "capitalize")
	
	$entry.setAddable()
	
	
	$entry.setValidationRule("firstName"; "entryField_firstName"; "mandatory"; "trimSpace"; "capitalize"; "message:The first name is mandatory")
	$entry.setValidationRule("lastName"; "entryField_lastName"; "mandatory"; "trimSpace"; "capitalize"; "message:The last name is mandatory")
	$entry.setValidationRule("UUID_Customer"; ""; "UUIDNotNull"; "message:The customer must be defined")
	
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	$entry.setItemListPreconfigAction("copyItemsListToPasteboard")
	
	$entry.enableTransaction()
	
	$entry.activateFavorite()
	$entry.activateComment()
	