singleton Class constructor
	
	
Function getBarcodeData($dataClass)->$barCodeData : Integer
	
	$barCodeData:=ds:C1482.sfw_Counter.getNextValue($dataClass)
	
Function dropDownListSelection($dataClass; $foreignKey; $fieldRedrawer; $pannelClass)
	
	$barcodeData:=This:C1470.communicateWithScanner()
	
	If (OK=1)
		$eEntities:=ds:C1482[$dataClass].query("moreData.barcodeData = :1"; $barcodeData)
		
		Case of 
				
			: ($eEntities.length=0)
				cs:C1710.sfw_dialog.me.alert(ds:C1482.sfw_readXliff("Error"; "No Records Found for the Barcode Scanned"))
				
			: ($eEntities.length=1)
				// Purpose: Barcode lives on sfw_User; RepairLog FK fields store linked Staff UUID.
				// modified by 4D/PS [2026-june-08]
				If ($dataClass="sfw_User")
					Case of 
						: ($eEntities[0].staffs.length=0)
							cs:C1710.sfw_dialog.me.alert(ds:C1482.sfw_readXliff("Error"; "No Records Found for the Barcode Scanned"))
							
						: ($eEntities[0].staffs.length=1)
							$eEntity:=$eEntities[0].staffs[0]
							Form:C1466.current_item[$foreignKey]:=$eEntity.UUID
							
						: ($eEntities[0].staffs.length>1)
							cs:C1710.sfw_dialog.me.alert(ds:C1482.sfw_readXliff("Error"; "Multiples Records Found for the Barcode Scanned"))
							
						Else 
							
					End case 
				Else 
					$eEntity:=$eEntities.first()
					Form:C1466.current_item[$foreignKey]:=$eEntity.UUID
				End if 
				
			: ($eEntities.length>1)
				cs:C1710.sfw_dialog.me.alert(ds:C1482.sfw_readXliff("Error"; "Multiples Records Found for the Barcode Scanned"))
				
			Else 
				
		End case 
		
		$nomFonction:="_activate_save_cancel_button"
		$formule:=Formula from string:C1601("cs."+$pannelClass+".me."+$nomFonction+"()")
		$resultat:=$formule.source
		
		$formule:=Formula from string:C1601("cs."+$pannelClass+".me."+$fieldRedrawer+"()")
		$resultat:=$formule.source
		
	End if 
	
	
Function scanForInputField()
	
	
Function UserApprovalByScanning($object)  //$type)
	
	// Purpose: Restore isApproved to its pre-click value when scan fails or is cancelled.
	// The checkbox toggles the bound boolean before this handler runs; UI follows the value.
	// Parameters: $object : Object — record with isApproved, approvedBy, approvalDate
	// modified by 4D/PS [2026-june-08]
	$previousIsApproved:=Not:C34($object.isApproved)
	$scanOk:=False:C215
	
	$barcodeData:=This:C1470.communicateWithScanner()
	
	If (OK=1)
		// Purpose: Resolve badge on sfw_User, then use linked Staff for approvedBy code.
		// modified by 4D/PS [2026-june-08]
		$eEntities:=ds:C1482.sfw_User.query("moreData.barcodeData = :1"; $barcodeData)
		
		Case of 
				
			: ($eEntities.length=0)
				cs:C1710.sfw_dialog.me.alert(ds:C1482.sfw_readXliff("Scan Error"; "No User Found for the Barcode Scanned"))
				
			: ($eEntities.length=1)
				Case of 
					: ($eEntities[0].staffs.length=0)
						cs:C1710.sfw_dialog.me.alert(ds:C1482.sfw_readXliff("Scan Error"; "No User Found for the Barcode Scanned"))
						
					: ($eEntities[0].staffs.length=1)
						
						$eEntity:=$eEntities[0].staffs[0]
						$scanOk:=True:C214
						
						If ($object.isApproved)
							$object.approvedBy:=$eEntity.code
							$object.approvalDate:=Current date:C33(*)
						Else 
							$object.approvedBy:=""
							$object.approvalDate:=Date:C102(!00-00-00!)
						End if 
						
					: ($eEntities[0].staffs.length>1)
						cs:C1710.sfw_dialog.me.alert(ds:C1482.sfw_readXliff("Scan Error"; "Multiples Users Found for the Barcode Scanned"))
						
					Else 
						
				End case 
				
			: ($eEntities.length>1)
				cs:C1710.sfw_dialog.me.alert(ds:C1482.sfw_readXliff("Multiples Users Found for the Barcode Scanned"))
				
			Else 
				
		End case 
		
		If (Not:C34($scanOk))
			$object.isApproved:=$previousIsApproved
		End if 
		
	Else 
		
		$object.isApproved:=$previousIsApproved
		
	End if 
	
	
Function communicateWithScanner()->$barcodeData : Text
	
	$winRef:=Open form window:C675("_ga_scanInterface"; Movable dialog box:K34:7; Horizontally centered:K39:1; Vertically centered:K39:4)
	
	$form:=New object:C1471
	$form.barcodeData:=""
	$form.winRef:=$winRef
	SET WINDOW TITLE:C213("Scan the bar code"; $winRef)
	DIALOG:C40("_ga_scanInterface"; $form)
	CLOSE WINDOW:C154($winRef)
	$barcodeData:=(OK=1) ? $form.barcodeData : ""
	
	
	