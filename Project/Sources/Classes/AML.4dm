
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
	
	
	
	
	
	
	// MARK: - Views Definition
	
	
	// MARK: All  product Suppliers
	$view:=cs:C1710.sfw_definitionView.new("productSuppliers"; "Show Product Suppliers")
	$view.setLBItemsColumn("partData.internalPartNum"; "Internal Part#"; "width:250")
	$view.setLBItemsColumn("vendorPartnum"; "Vendor Part#"; "width:150")
	//$entry.setLBItemsColumn("supplier.name"; "Vendor name"; "width:200")
	$view.setLBItemsOrderBy("partData.internalPartNum")
	$view.setSubset("productSuppliers")
	$entry.setView($view)
	
	// MARK: All  service Suppliers
	$view:=cs:C1710.sfw_definitionView.new("serviceSuppliers"; "Show Service Suppliers")
	$view.setLBItemsColumn("partData.internalPartNum"; "Internal Part#"; "width:250")
	$view.setLBItemsColumn("vendorPartnum"; "Vendor Part#"; "width:150")
	//$entry.setLBItemsColumn("supplier.name"; "Vendor name"; "width:200")
	$view.setLBItemsOrderBy("partData.internalPartNum")
	$view.setSubset("serviceSuppliers")
	$entry.setView($view)
	
	// MARK: All  critical product Suppliers
	$view:=cs:C1710.sfw_definitionView.new("criticalProductSuppliers"; "Show Critical Product Suppliers")
	$view.setLBItemsColumn("partData.internalPartNum"; "Internal Part#"; "width:250")
	$view.setLBItemsColumn("vendorPartnum"; "Vendor Part#"; "width:150")
	//$entry.setLBItemsColumn("supplier.name"; "Vendor name"; "width:200")
	$view.setLBItemsOrderBy("partData.internalPartNum")
	$view.setSubset("criticalProductSuppliers")
	$entry.setView($view)
	
	// MARK: All  critical service Suppliers
	$view:=cs:C1710.sfw_definitionView.new("criticalServicesSuppliers"; "Show Critical Service Suppliers")
	$view.setLBItemsColumn("partData.internalPartNum"; "Internal Part#"; "width:250")
	$view.setLBItemsColumn("vendorPartnum"; "Vendor Part#"; "width:150")
	//$entry.setLBItemsColumn("supplier.name"; "Vendor name"; "width:200")
	$view.setLBItemsOrderBy("partData.internalPartNum")
	$view.setSubset("criticalServiceSuppliers")
	$entry.setView($view)
	
	
	
Function productSuppliers()->$amls : cs:C1710.AMLSelection
	$amls:=ds:C1482.AML.query("service =:1"; False:C215)
	
	
Function serviceSuppliers()->$amls : cs:C1710.AMLSelection
	$amls:=ds:C1482.AML.query("service =:1"; True:C214)
	
	
Function criticalProductSuppliers()->$amls : cs:C1710.AMLSelection
	$amls:=ds:C1482.AML.query("service =:1 & critical =:2"; False:C215; True:C214)
	
	
Function criticalServiceSuppliers()->$amls : cs:C1710.AMLSelection
	$amls:=ds:C1482.AML.query("service =:1 & critical =:2"; True:C214; True:C214)
	
	