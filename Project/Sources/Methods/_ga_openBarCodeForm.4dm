//%attributes = {}
/*


*/


$form:=New object:C1471
If (Form:C1466.current_item.moreData#Null:C1517)
	If (OB Is defined:C1231(Form:C1466.current_item.moreData; "barcodeData"))
		$form.barcodeData:=Form:C1466.current_item.moreData.barcodeData
		
		$winRef:=Open form window:C675("_ga_generateBarCode"; Movable dialog box:K34:7; Horizontally centered:K39:1; Vertically centered:K39:4)
		SET WINDOW TITLE:C213("Generate Bar code "; $winRef)  //for "+String(Form.current_item.fullName)
		DIALOG:C40("_ga_generateBarCode"; $form)
		
	Else 
		ALERT:C41("Not data for the barcode")
	End if 
Else 
	ALERT:C41("Not data for the barcode")
End if 


//If (Form.lastPanelDisplayed="sfw_panel_user")
//$form.barcodeData:=Form.current_item.UUID
//Else 
//$form.barcodeData:=Form.current_item.moreData.barcodeData
//End if 

//$form.fieldsNames:=New collection()
//GET FIELD TITLES([sfw_User]; $fieldTitles; $fieldsNums)
//ARRAY TO COLLECTION($form.fieldsNames; $fieldTitles)








