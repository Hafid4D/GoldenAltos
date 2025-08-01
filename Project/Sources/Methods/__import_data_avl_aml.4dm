//%attributes = {"executedOnServer":true}


var $eContact : cs:C1710.ContactEntity

//PartData
var $ePartData : cs:C1710.PartDataEntity

$partData_log:=Folder:C1567(fk data folder:K87:12).file("DataJson/partData_export.json")

If ($partData_log.exists)
	$partDatas:=JSON Parse:C1218($partData_log.getText())
	
	TRUNCATE TABLE:C1051([PartData:48])
	
	For each ($partData; $partDatas)
		
		$ePartData:=ds:C1482.PartData.new()
		$ePartData.internalPartNum:=$partData.InternalPatnum
		
		$res:=$ePartData.save()
		If (Not:C34($res.success))
			TRACE:C157
		End if 
		
	End for each 
	
End if 


//supplier table
var $eSupplier : cs:C1710.SupplierEntity


$supplier_log:=Folder:C1567(fk data folder:K87:12).file("DataJson/suppliers_export.json")

If ($supplier_log.exists)
	$suppliers:=JSON Parse:C1218($supplier_log.getText())
	
	TRUNCATE TABLE:C1051([Supplier:47])
	
	For each ($supplier; $suppliers)
		
		$eSupplier:=ds:C1482.Supplier.new()
		
		$eSupplier.name:=$supplier.Supplier
		$eSupplier.code:=$supplier.code
		
		//$eSupplier.divisionID:=$supplier.Critical
		$division:=ds:C1482.Division.query("name =:1"; Split string:C1554($supplier.Division; "\r"; sk trim spaces:K86:2).join("\r"))
		
		If ($division.length>0)
			
			$eSupplier.divisionID:=$division[0].divisionID
		Else 
			
			$eSupplier.divisionID:=0
		End if 
		
		$eSupplier.disqualified:=$supplier.Disqualified
		$eSupplier.enteredBy:=$supplier.Entry_by
		$eSupplier.qaComment:=$supplier.QA_Comments
		$eSupplier.approvedByQA:=$supplier.ApprovedByQA
		$eSupplier.approvedByCustomer:=$supplier.ApprovedByCustomer
		$eSupplier.allowedLotProcessing:=$supplier.lot_processing_allowed
		$eSupplier.webService:=$supplier.WebService
		$eSupplier.auditRequired:=$supplier.Audit_Required
		$eSupplier.deactivated:=$supplier.Deactivate
		$eSupplier.lastAuditDate:=$supplier.Last_Audit_Date
		$eSupplier.nextAuditDate:=$supplier.Next_Audit_Due
		
		$eSupplier.contactDetails:=New object:C1471()
		$eSupplier.contactDetails.addresses:=New collection:C1472()
		
		$address:=New object:C1471()
		$address.type:="main"
		$address.detail:=New object:C1471()
		$address.detail.country:="US"
		$address.detail.street_1:=$supplier.Address1
		If (String:C10($supplier.Address2)#"")
			$address.detail.street_2:=$supplier.Address2
		End if 
		$address.detail.postcode:=$supplier.Zip
		$address.detail.iso_code_2:="US"
		$address.detail.city:=$supplier.Address3
		$address.detail.state:=$supplier.State
		$eSupplier.contactDetails.addresses.push($address)
		
		$address:=New object:C1471()
		$address.type:="remit"
		$address.detail:=New object:C1471()
		$address.detail.country:="US"
		$address.detail.street_1:=$supplier.remit_add1
		If (String:C10($supplier.Address2)#"")
			$address.detail.street_2:=$supplier.remit_add2
		End if 
		$address.detail.postcode:=$supplier.remit_zip
		$address.detail.iso_code_2:="US"
		$address.detail.city:=$supplier.remit_add3
		$address.detail.state:=$supplier.remit_st
		$eSupplier.contactDetails.addresses.push($address)
		
		
		//Save the supplier
		$res:=$eSupplier.save()
		If (Not:C34($res.success))
			TRACE:C157
		End if 
		
		
		//Primary contact
		$eContact:=ds:C1482.Contact.new()
		$eContact.UUID_Supplier:=$eSupplier.UUID
		$eContact.companyName:=$supplier.Supplier
		$eContact.firstName:=$supplier.C1_first_name
		$eContact.lastName:=$supplier.C1_last_name
		$eContact.title:="Primary"
		$eContact.UUID_CompanyType:=ds:C1482.CompanyType.query("name =:1"; "Supplier")[0].UUID
		$eContact.contactDetails:=New object:C1471()
		$eContact.contactDetails.addresses:=New collection:C1472()
		
		$eContact.contactDetails.communications:=New collection:C1472()
		
		$comm:=New object:C1471()
		$comm.type:="phone"
		$comm.comment:=""
		$comm.contact:=$supplier.C1_tel
		$eContact.contactDetails.communications.push($comm)
		
		$comm:=New object:C1471()
		$comm.type:="fax"
		$comm.comment:=""
		$comm.contact:=$supplier.C1_fax
		$eContact.contactDetails.communications.push($comm)
		If ($supplier.C1_fax#"")
			
		End if 
		$comm:=New object:C1471()
		$comm.type:="mail"
		$comm.comment:=""
		$comm.contact:=$supplier.C1_Email
		$eContact.contactDetails.communications.push($comm)
		
		$result:=$eContact.save()
		If ($result.success=False:C215)
			TRACE:C157
		End if 
		
		
		//Secondary contact
		$eContact:=ds:C1482.Contact.new()
		$eContact.UUID_Supplier:=$eSupplier.UUID
		$eContact.companyName:=$supplier.Supplier
		$eContact.firstName:=$supplier.C2_first_name
		$eContact.lastName:=$supplier.C2_last_name
		$eContact.title:="Secondary"
		$eContact.UUID_CompanyType:=ds:C1482.CompanyType.query("name =:1"; "Supplier")[0].UUID
		
		$eContact.contactDetails:=New object:C1471()
		$eContact.contactDetails.addresses:=New collection:C1472()
		
		$eContact.contactDetails.communications:=New collection:C1472()
		
		$comm:=New object:C1471()
		$comm.type:="phone"
		$comm.comment:=""
		$comm.contact:=$supplier.C2_tel
		$eContact.contactDetails.communications.push($comm)
		
		$comm:=New object:C1471()
		$comm.type:="fax"
		$comm.comment:=""
		$comm.contact:=$supplier.C2_fax
		$eContact.contactDetails.communications.push($comm)
		
		$comm:=New object:C1471()
		$comm.type:="mail"
		$comm.comment:=""
		$comm.contact:=$supplier.C2_Email
		$eContact.contactDetails.communications.push($comm)
		
		$result:=$eContact.save()
		If ($result.success=False:C215)
			TRACE:C157
		End if 
		
		
	End for each 
	
End if 




//AML table
var $eAvml : cs:C1710.AMLEntity


$avml_log:=Folder:C1567(fk data folder:K87:12).file("DataJson/avlAml_export.json")

If ($avml_log.exists)
	$avmls:=JSON Parse:C1218($avml_log.getText())
	
	TRUNCATE TABLE:C1051([AML:46])
	
	For each ($avml; $avmls)
		
		$eAvml:=ds:C1482.AML.new()
		
		$eAvml.vendorPartnum:=$avml.Vendor_partnum
		$eAvml.UUID_Supplier:=$avml.Vendor_partnum
		$eAvml.critical:=$avml.Critical
		$eAvml.service:=$avml.Service
		$eAvml.serviceType:=$avml.Service_type
		
		//$eAvml.divisionID:=$avml.Division
		$division:=ds:C1482.Division.query("name =:1"; Split string:C1554($avml.Division; "\r"; sk trim spaces:K86:2).join("\r"))
		
		If ($division.length>0)
			
			$eAvml.divisionID:=$division[0].divisionID
		Else 
			
			$eAvml.divisionID:=0
		End if 
		
		$eAvml.enteredBy:=$avml.EnteredBy
		$eAvml.capacity:=$avml.Capacity
		$eAvml.makeInactive:=$avml.MakeInactive
		$eAvml.comment:=$avml.Comments
		
		//$eAvml.inventoryUnits:=$avml.InventoryUnits
		$unit:=ds:C1482.Units.query("name =:1"; Split string:C1554($avml.InventoryUnits; "\r"; sk trim spaces:K86:2).join("\r"))
		
		If ($unit.length>0)
			
			$eAvml.inventoryUnits:=$unit[0].unitID
		Else 
			
			$eAvml.inventoryUnits:=0
		End if 
		
		//$eAvml.procurementUnits:=$avml.ProcurementUnits
		$unit:=ds:C1482.Units.query("name =:1"; Split string:C1554($avml.ProcurementUnits; "\r"; sk trim spaces:K86:2).join("\r"))
		
		If ($unit.length>0)
			
			$eAvml.procurementUnits:=$unit[0].unitID
		Else 
			
			$eAvml.procurementUnits:=0
		End if 
		
		$eAvml.transFactorNumerator:=$avml.TransFactorNumerator
		$eAvml.transFactorDenominator:=$avml.TransFactorDenominator
		$eAvml.minInventoryLevel:=$avml.MinInventoryLevel
		$eAvml.description:=$avml.Description
		
		//$eAvml.ourPartNum:=$avml.OUR_partnum
		$partNum:=ds:C1482.PartData.query("internalPartNum =:1"; Split string:C1554($avml.OUR_partnum; "\r"; sk trim spaces:K86:2).join("\r"))
		If ($partNum.length>0)
			$eAvml.UUID_PartData:=$partNum[0].UUID
		End if 
		
		$supplier:=ds:C1482.Supplier.query("name =:1"; Split string:C1554($avml.Supplier; "\r"; sk trim spaces:K86:2).join("\r"))
		If ($supplier.length>0)
			$eAvml.UUID_Supplier:=$supplier[0].UUID
		Else 
			
		End if 
		
		$res:=$eAvml.save()
		If (Not:C34($res.success))
			TRACE:C157
		End if 
		
		
	End for each 
	
End if 

