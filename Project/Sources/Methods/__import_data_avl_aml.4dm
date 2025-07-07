//%attributes = {}


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
		
		//$eSupplier.contactDetails:=$supplier.TransFactorNumerator
		
		$eSupplier.deactivated:=$supplier.Deactivate
		$eSupplier.lastAuditDate:=$supplier.Last_Audit_Date
		$eSupplier.nextAuditDate:=$supplier.Next_Audit_Due
		
		
		$res:=$eSupplier.save()
		If (Not:C34($res.success))
			TRACE:C157
		End if 
		
		
	End for each 
	
End if 




//AML table
var $eAvml : cs:C1710.AMLEntity


$avml_log:=Folder:C1567(fk data folder:K87:12).file("DataJson/avlAml_export.json")

If ($avml_log.exists)
	$avmls:=JSON Parse:C1218($avml_log.getText())
	
	TRUNCATE TABLE:C1051([PartInfo])
	
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
		
		$eAvml.inventoryUnits:=$avml.InventoryUnits
		$eAvml.procurementUnits:=$avml.TransFactorNumerator
		$eAvml.transFactorNumerator:=$avml.TransFactorNumerator
		$eAvml.transFactorDenominator:=$avml.TransFactorDenominator
		$eAvml.minInventoryLevel:=$avml.MinInventoryLevel
		
		//$eAvml.ourPartNum:=$avml.OUR_partnum
		$partNum:=ds:C1482.PartData.query("internalPartNum =:1"; Split string:C1554($avml.OUR_partnum; "\r"; sk trim spaces:K86:2).join("\r"))
		If ($partNum.length>0)
			$eAvml.UUID_PartData:=$partNum[0].UUID
		End if 
		
		$supplier:=ds:C1482.Supplier.query("name =:1"; Split string:C1554($avml.Supplier; "\r"; sk trim spaces:K86:2).join("\r"))
		If ($partNum.length>0)
			$eAvml.UUID_Supplier:=$supplier[0].UUID
		End if 
		
		$res:=$eAvml.save()
		If (Not:C34($res.success))
			TRACE:C157
		End if 
		
		
	End for each 
	
End if 

