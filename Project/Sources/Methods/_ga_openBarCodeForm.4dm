//%attributes = {}
/*


*/




$form:=New object:C1471
If (Form:C1466.lastPanelDisplayed="sfw_panel_user")
	
	$form.barcodeData:=Form:C1466.current_item.UUID
Else 
	
	$form.barcodeData:=Form:C1466.current_item.moreData.barcodeData
	//$form.fieldsNames:=New collection()
	//GET FIELD TITLES([sfw_User]; $fieldTitles; $fieldsNums)
	//ARRAY TO COLLECTION($form.fieldsNames; $fieldTitles)
	
End if 

$winRef:=Open form window:C675("_ga_generateBarCode"; Movable dialog box:K34:7; Horizontally centered:K39:1; Vertically centered:K39:4)
SET WINDOW TITLE:C213("Generate Bar code for "+String:C10(Form:C1466.current_item.fullName); $winRef)
DIALOG:C40("_ga_generateBarCode"; $form)





