


Case of 
		
	: (Form event code:C388=On Clicked:K2:4)
		
		$form:=New object:C1471
		$form.table:="sfw_User"
		$form.currentItem:=Form:C1466.current_item
		$form.fieldsNames:=New collection:C1472()
		GET FIELD TITLES:C804([sfw_User:16]; $fieldTitles; $fieldsNums)
		ARRAY TO COLLECTION:C1563($form.fieldsNames; $fieldTitles)
		
		$winRef:=Open form window:C675("_ga_generateBarCode"; Movable dialog box:K34:7; Horizontally centered:K39:1; Vertically centered:K39:4)
		SET WINDOW TITLE:C213("Generate Bar code for "+String:C10(Form:C1466.current_item.fullName); $winRef)
		DIALOG:C40("_ga_generateBarCode"; $form)
		
	Else 
		
End case 

