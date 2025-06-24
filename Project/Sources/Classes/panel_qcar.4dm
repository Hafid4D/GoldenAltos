singleton Class constructor
	//It's a singleton class
	
Function _activate_save_cancel_button()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	
Function formMethod()
	//This function manages the main logic for updating and refreshing the form
	Form:C1466.sfw.panelFormMethod()  //The main body of the form method and basic sfw functionalities 
	If (Form:C1466.sfw.updateOfPanelNeeded())  //The current item is changed or reloaded, so it's necessary ti refresh 
	End if 
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())  //a page is displayed so it's time to load the sources of data to display
		Case of 
			: (FORM Get current page:C276(*)=1)
				// add load functions
		End case 
	End if 
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())  //It's time to resize the object or set visible
		This:C1470.redrawAndSetVisible()
	End if 
	
	
Function drawPup_XXX()
	//This function updates the dropdown by displaying the name
	Form:C1466.sfw.drawButtonPup("pup_xxx"; $xxxName; "xxxx.png"; (Form:C1466.current_item.xxxx=Null:C1517))
	
	
Function pup_XXX()
	//Create pop up menu
	If (Form:C1466.sfw.checkIsInModification())
	End if 
	This:C1470.drawPup_XXX()
	
	
Function redrawAndSetVisible()
	//Adjusts the layout and visibility of form elements based on the current page and modification state
	OBJECT SET ENABLED:C1123(*; "entryField_rb_@"; Form:C1466.sfw.checkIsInModification())
	
	This:C1470.qcarManage()
	This:C1470.hideDatePickers()
	
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($widthSubform; $heightSubform)
	
	Case of 
		: (FORM Get current page:C276(*)=2)
			OBJECT GET COORDINATES:C663(*; "subform_qcar"; $left; $top; $right; $bottom)
			
			$offset:=4
			
			OBJECT SET COORDINATES:C1248(*; "subform_qcar"; $left; $top; $right; $heightSubform-$offset)
	End case 
	
Function qcarManage()
	If (Form:C1466.current_item#Null:C1517)
		If (Form:C1466.situation.mode="add")
			Form:C1466.current_item._initCorrectiveActionReport()
		End if 
		
		Form:C1466.subForm_qcar:=New object:C1471()
		Form:C1466.subForm_qcar.correctiveActionReport:=Form:C1466.current_item.correctiveActionReport
		Form:C1466.subForm_qcar.situation:=Form:C1466.situation
	End if 
	
Function selectCustomer()
	If (Form:C1466.sfw.checkIsInModification())
		Case of 
			: (FORM Event:C1606.code=On Getting Focus:K2:7) | (FORM Event:C1606.code=On Clicked:K2:4)
				OBJECT GET COORDINATES:C663(*; "Field_customerName"; $l; $t; $r; $b)
				CONVERT COORDINATES:C1365($l; $b; XY Current form:K27:5; XY Screen:K27:7)
				
				$form:=New object:C1471(\
					"colName"; "name"; \
					"lb_items"; ds:C1482.Customer.all()\
					)
				
				$winRef:=Open form window:C675("selectNto1"; Pop up form window:K39:11; $l; $b-20)
				DIALOG:C40("selectNto1"; $form)
				CLOSE WINDOW:C154($winRef)
				
				If (ok=1)
					Form:C1466.current_item.UUID_Customer:=$form.item.UUID
					cs:C1710.panel_purchaseOrder.me._activate_save_cancel_button()
				End if 
		End case 
	End if 
	
Function selectLot()
	If (Form:C1466.sfw.checkIsInModification())
		Case of 
			: (FORM Event:C1606.code=On Getting Focus:K2:7) | (FORM Event:C1606.code=On Clicked:K2:4)
				OBJECT GET COORDINATES:C663(*; "Field_customerName"; $l; $t; $r; $b)
				CONVERT COORDINATES:C1365($l; $b; XY Current form:K27:5; XY Screen:K27:7)
				
				$form:=New object:C1471(\
					"colName"; "lotNumber"; \
					"lb_items"; ds:C1482.Lot.all()\
					)
				
				$winRef:=Open form window:C675("selectNto1"; Pop up form window:K39:11; $l; $b-20)
				DIALOG:C40("selectNto1"; $form)
				CLOSE WINDOW:C154($winRef)
				
				If (ok=1)
					Form:C1466.current_item.UUID_Lot:=$form.item.UUID
					cs:C1710.panel_purchaseOrder.me._activate_save_cancel_button()
				End if 
		End case 
	End if 
	
Function subFormEvent()
	Form:C1466.current_item.correctiveActionReport:=Form:C1466.subForm_qcar.correctiveActionReport
	This:C1470._activate_save_cancel_button()
	
	
Function hideDatePickers()
	OBJECT SET VISIBLE:C603(*; "dp_@"; Form:C1466.sfw.checkIsInModification())
	
Function loadXXX()
	//Loads and initializes a list
	
Function bActionXXX()
	//Manages actions: add, or remove, using dynamic menus and modification checks
	
Function verifyQcar()
	If (Form:C1466.sfw.checkIsInModification())
		If (Form:C1466.current_item.verified)
			Form:C1466.current_item.verifiedBy:=cs:C1710.sfw_userManager.me.info.name
			Form:C1466.current_item.verifiedDate:=Current date:C33()
		End if 
	End if 
	