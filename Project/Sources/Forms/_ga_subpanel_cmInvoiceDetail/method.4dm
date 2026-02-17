var $file : 4D:C1709.File

$inModification:=sfw_checkIsInModification
$setActivation:=False:C215
$rebuildDisplayedLB:=False:C215

/*
If (Form#Null) && (Form.communicationTypes=Null)
$file:=Folder(fk resources folder).file("sfw/communication/communicationTypes.json")
If ($file.exists)
$json:=$file.getText()
Form.communicationTypes:=JSON Parse($json)
For each ($type; Form.communicationTypes)
$file:=Folder(fk resources folder).file("sfw/communication/"+$type.icon)
$blob:=$file.getContent()
BLOB TO PICTURE($blob; $pict; ".png")
$type.displayedIcon:=$pict
End for each 

End if 
End if 
*/

Case of 
	: (FORM Event:C1606.code=On Load:K2:1)
		
		$setActivation:=True:C214
		$rebuildDisplayedLB:=True:C214
		OBJECT GET SUBFORM CONTAINER SIZE:C1148($widthSubform; $heightSubform)
		
		
		OBJECT GET COORDINATES:C663(*; "lb_invoices"; $lb_left; $lb_top; $lb_right; $lb_bottom)
		//OBJECT GET COORDINATES(*; "bActions"; $ba_left; $ba_top; $ba_right; $ba_bottom)
		OBJECT GET COORDINATES:C663(*; "header_bkgd"; $hb_left; $hb_top; $hb_right; $hb_bottom)
		//OBJECT GET COORDINATES(*; "communication_bkgd"; $cb_left; $cb_top; $cb_right; $cb_bottom)
		
		//$widthBa:=$ba_right-$ba_left
		
		OBJECT SET COORDINATES:C1248(*; "lb_invoices"; $lb_left; $lb_top; $widthSubform; $lb_bottom)
		//OBJECT SET COORDINATES(*; "bActions"; $widthSubform-$widthBa; $ba_top; $widthSubform-9; $ba_bottom)
		OBJECT SET COORDINATES:C1248(*; "header_bkgd"; $hb_left; $hb_top; $widthSubform; $hb_bottom)
		//OBJECT SET COORDINATES(*; "communication_bkgd"; $cb_left; $cb_top; $widthSubform; $cb_bottom)
		
		
		
	: (FORM Event:C1606.code=On Bound Variable Change:K2:52)
		$setActivation:=True:C214
		$rebuildDisplayedLB:=True:C214
		
		//: (FORM Event.code=On Data Change)
		
		//Case of 
		//: (FORM Event.columnName="col_contact")
		//Form.communications[Form.communicationMeanPosition-1].contact:=Form.communicationMean.contact
		//: (FORM Event.columnName="col_comment")
		//Form.communications[Form.communicationMeanPosition-1].comment:=Form.communicationMean.comment
		//End case 
		//CALL FORM(Current form window; "sfw_main_draw_button")
		
		
	: (FORM Event:C1606.code=On Clicked:K2:4) && (FORM Event:C1606.objectName="bActions")
		
		$refMenus:=New collection:C1472
		$mainMenu:=Create menu:C408
		$refMenus.push($mainMenu)
		
		APPEND MENU ITEM:C411($mainMenu; "Print invoices"; *)
		SET MENU ITEM PARAMETER:C1004($mainMenu; -1; "--print")
		If (sfw_checkIsInModification)=False:C215
			DISABLE MENU ITEM:C150($mainMenu; -1)
		End if 
		
		//APPEND MENU ITEM($mainMenu; "Delete a communication means"; *)
		//SET MENU ITEM PARAMETER($mainMenu; -1; "--delete")
		//If (sfw_checkIsInModification)=False
		//DISABLE MENU ITEM($mainMenu; -1)
		//Else 
		//If (Form.communicationMean=Null)
		//DISABLE MENU ITEM($mainMenu; -1)
		//End if 
		//End if 
		
		//APPEND MENU ITEM($mainMenu; "modify a communication means"; *)
		//SET MENU ITEM PARAMETER($mainMenu; -1; "--update")
		
		//If (sfw_checkIsInModification)=False
		//DISABLE MENU ITEM($mainMenu; -1)
		//Else 
		//If (Form.communicationMean=Null)
		//DISABLE MENU ITEM($mainMenu; -1)
		//End if 
		//End if 
		
		OBJECT GET COORDINATES:C663(*; "bActions"; $g; $h; $d; $b)
		CONVERT COORDINATES:C1365($g; $b; XY Current form:K27:5; XY Current window:K27:6)
		$choose:=Dynamic pop up menu:C1006($mainMenu; ""; $g; $b)
		For each ($refMenu; $refMenus)
			RELEASE MENU:C978($refMenu)
		End for each 
		
/*
Case of 
: ($choose="")
: ($choose="--delete")
Form.communications.remove(Form.communicationMeanPosition-1)
$rebuildDisplayedLB:=True
CALL FORM(Current form window; "sfw_main_draw_button")
: ($choose="--add")
		
$form:=New object()
		
$winRef:=Open form window("_ga_subpanelCommunicationSingle"; Controller form window; Horizontally centered; Vertically centered)
DIALOG("_ga_subpanelCommunicationSingle"; $form)
CLOSE WINDOW($winRef)
		
If (OK=1)
Form.communications.push($form.com)
End if 
		
$rebuildDisplayedLB:=True
CALL FORM(Current form window; "sfw_main_draw_button")
		
: ($choose="--update")
		
If ($inModification) && (Form.communicationMeanPosition>0)  //(FORM Event.columnName="col_type") && 
$form:=New object
		
$form.com:=OB Copy(Form.communications[Form.communicationMeanPosition-1])
		
$winRef:=Open form window("_ga_subpanelCommunicationSingle"; Plain form window; Horizontally centered; Vertically centered)
DIALOG("_ga_subpanelCommunicationSingle"; $form)
		
If (OK=1)
Form.communications[Form.communicationMeanPosition-1]:=$form.com
End if 
		
$rebuildDisplayedLB:=True
		
CALL FORM(Current form window; "sfw_main_draw_button")
		
End if 
		
		
End case 
*/
		
		
End case 


If ($rebuildDisplayedLB)
	
	If (Form:C1466#Null:C1517)
		
		cs:C1710.panel_cmItem.me.invoiceDetails()
		
		cs:C1710.Util_DynamicListBox.me.deleteAllColumns("lb_invoices")
		
		$colSettings:=Form:C1466.data.colSettings
		cs:C1710.Util_DynamicListBox.me.insertColumns("lb_invoices"; $colSettings)
		
		Form:C1466.lb_invoices:=New collection:C1472
		
		Form:C1466.lb_invoices:=Form:C1466.data.invoices
		
	End if 
	
End if 