//%attributes = {}




var $eAvml : cs:C1710.AVMLEntity


$avml_log:=Folder:C1567(fk data folder:K87:12).file("DataJson/avlAml_export.json")

If ($avml_log.exists)
	$avmls:=JSON Parse:C1218($avml_log.getText())
	
	TRUNCATE TABLE:C1051([AVML:46])
	
	For each ($avml; $avmls)
		
		$eAvml:=ds:C1482.AVML.new()
		
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
		$eAvml.partID:=$avml.OUR_partnum
		$eAvml.inventoryUnits:=$avml.InventoryUnits
		$eAvml.procurementUnits:=$avml.TransFactorNumerator
		$eAvml.transFactorNumerator:=$avml.TransFactorNumerator
		$eAvml.transFactorDenominator:=$avml.TransFactorDenominator
		$eAvml.minInventoryLevel:=$avml.MinInventoryLevel
		
		
		$res:=$eAvml.save()
		If (Not:C34($res.success))
			TRACE:C157
		End if 
		
		
	End for each 
	
End if 

