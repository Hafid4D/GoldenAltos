singleton Class constructor
	
	
Function dropDownListSelection($dataClass; $foreignKey; $fieldRedrawer)
	
	$barcodeData:=This:C1470.communicateWithScanner()
	
	If (OK=1)
		$eEntities:=ds:C1482[$dataClass].query("moreData.barcodeData = :1"; $barcodeData)
		
		Case of 
				
			: ($eEntities.length=0)
				cs:C1710.sfw_dialog.me.alert(ds:C1482.sfw_readXliff("Error"; "No Records Found for the Barcode Scanned"))
				
			: ($eEntities.length=1)
				$eEntity:=$eEntities.first()
				$keys:=Split string:C1554($foreignKey; ".")
				Case of 
					: ($keys.length=1)
						Form:C1466.current_item[$foreignKey]:=$eEntity.UUID
						
					: ($keys.length=2)  //Repair_Log case where fixer and reporter are saved as attribute of an object name operators
						Form:C1466.current_item[$keys[0]][$keys[1]]:=$eEntity.UUID
						
					Else 
						
				End case 
				
			: ($eEntities.length>1)
				cs:C1710.sfw_dialog.me.alert(ds:C1482.sfw_readXliff("Error"; "Multiples Records Found for the Barcode Scanned"))
				
			Else 
				
		End case 
		
		$nomFonction:="_activate_save_cancel_button"
		$formule:=Formula from string:C1601("cs.panel_lot.me."+$nomFonction+"()")
		$resultat:=$formule.source
		
		$formule:=Formula from string:C1601("cs.panel_lot.me."+$fieldRedrawer+"()")
		$resultat:=$formule.source
		
	End if 
	
	
Function scanForInputField()
	
	
	
Function UserApprovalByScanning($dataClass)
	
	$barcodeData:=This:C1470.communicateWithScanner()
	
	If (OK=1)
		$eEntities:=ds:C1482[$dataClass].query("moreData.barcodeData = :1"; $barcodeData)
		
		Case of 
				
			: ($eEntities.length=0)
				cs:C1710.sfw_dialog.me.alert(ds:C1482.sfw_readXliff("No User Found for the Barcode Scanned"))
				
			: ($eEntities.length=1)
				$eEntity:=$eEntities.first()
				//todo-> uniformiser
				
				//If (Form.details.isApproved)
				//Form.details.approvedBy:=$eEntity.staffs[0].code  //ds.sfw_User.query("login = :1"; Current user).first().staffs[0].code
				//Form.details.approvalDate:=Current date(*)
				//Else 
				//Form.details.approvedBy:=""
				//Form.details.approvalDate:=Date(!00-00-00!)
				//End if 
				
				
			: ($eEntities.length>1)
				cs:C1710.sfw_dialog.me.alert(ds:C1482.sfw_readXliff("Multiples Users Found for the Barcode Scanned"))
				
			Else 
				
		End case 
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
	
	