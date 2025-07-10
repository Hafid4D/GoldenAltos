singleton Class constructor
	//It's a singleton class
	
Function _activate_save_cancel_button()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	
Function formMethod()
	//This function manages the main logic for updating and refreshing the form
	Form:C1466.sfw.panelFormMethod()  //The main body of the form method and basic sfw functionalities 
	If (Form:C1466.sfw.updateOfPanelNeeded())  //The current item is changed or reloaded, so it's necessary ti refresh 
		
		This:C1470.LoadAllTabs()
	End if 
	
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())  //a page is displayed so it's time to load the sources of data to display
		Case of 
			: (FORM Get current page:C276(*)=1)
				
			: (FORM Get current page:C276(*)=2)
				
		End case 
	End if 
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())  //It's time to resize the object or set visible
		This:C1470.redrawAndSetVisible()
	End if 
	
	
Function redrawAndSetVisible()
	//Adjusts the layout and visibility of form elements based on the current page and modification state
	
	This:C1470.drawPup_approvedBy()
	This:C1470.drawPup_empCode()
	This:C1470.drawPup_inventoryUnit()
	This:C1470.drawPup_procurementUnit()
	This:C1470.drawPup_division()
	
	OBJECT SET VISIBLE:C603(*; "Rectangle@"; Not:C34(Form:C1466.sfw.checkIsInModification()))
	Form:C1466.sfw.drawHTab()
	
	
	
Function drawPup_XXX()
	//This function updates the dropdown by displaying the name
	Form:C1466.sfw.drawButtonPup("pup_xxx"; $xxxName; "xxxx.png"; (Form:C1466.current_item.xxxx=Null:C1517))
	
	
Function pup_XXX()
	//Create pop up menu
	
	
	
Function LoadAllTabs()
	
	
	
	
Function drawPup_approvedBy()
	If (Form:C1466.current_item#Null:C1517)
		$operator:=ds:C1482.Staff.query("code= :1"; Form:C1466.current_item.approvedBy).first() || New object:C1471()
		$operatorCode:=$operator.code
		If ($operatorCode=Null:C1517)
			$operatorCode:=""
		End if 
		$color:=""
		$pathIcon:=""
		Form:C1466.sfw.drawButtonPup("pup_approvedBy"; $operatorCode; $pathIcon; ($operator=Null:C1517))
		
	End if 
	
	
Function pup_approvedBy()
	//Create pop up menu
	
	If (Form:C1466.sfw.checkIsInModification())
		
		OBJECT GET COORDINATES:C663(*; "pup_approvedBy"; $l; $t; $r; $b)
		CONVERT COORDINATES:C1365($l; $b; XY Current form:K27:5; XY Main window:K27:8)
		
		$form:=New object:C1471(\
			"colName"; "code"; \
			"lb_items"; ds:C1482.Staff.all(); \
			"allData"; ds:C1482.Staff.all(); \
			"dataclass"; "Staff"\
			)
		
		$winRef:=Open form window:C675("selectNto1"; Pop up form window:K39:11; $l; $b)
		DIALOG:C40("selectNto1"; $form)
		CLOSE WINDOW:C154($winRef)
		
		If (ok=1)
			Form:C1466.current_item.approvedBy:=$form.item.code
			cs:C1710.panel_AML.me._activate_save_cancel_button()
		End if 
	End if 
	
	This:C1470.drawPup_approvedBy()
	
	
Function drawPup_empCode()
	If (Form:C1466.current_item#Null:C1517)
		$operator:=ds:C1482.Staff.query("code= :1"; Form:C1466.current_item.enteredBy).first() || New object:C1471()
		$operatorCode:=$operator.code
		If ($operatorCode=Null:C1517)
			$operatorCode:=""
		End if 
		$color:=""
		$pathIcon:=""
		Form:C1466.sfw.drawButtonPup("pup_empCode"; $operatorCode; $pathIcon; ($operator=Null:C1517))
		
	End if 
	
	
Function pup_empCode()
	//Create pop up menu
	
	If (Form:C1466.sfw.checkIsInModification())
		
		OBJECT GET COORDINATES:C663(*; "pup_approvedBy"; $l; $t; $r; $b)
		CONVERT COORDINATES:C1365($l; $b; XY Current form:K27:5; XY Main window:K27:8)
		
		$form:=New object:C1471(\
			"colName"; "code"; \
			"lb_items"; ds:C1482.Staff.all(); \
			"allData"; ds:C1482.Staff.all(); \
			"dataclass"; "Staff"\
			)
		
		$winRef:=Open form window:C675("selectNto1"; Pop up form window:K39:11; $l; $b)
		DIALOG:C40("selectNto1"; $form)
		CLOSE WINDOW:C154($winRef)
		
		If (ok=1)
			Form:C1466.current_item.enteredBy:=$form.item.code
			cs:C1710.panel_AML.me._activate_save_cancel_button()
		End if 
	End if 
	
	This:C1470.drawPup_empCode()
	
	
Function drawPup_inventoryUnit()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.current_item.drowPup("Units"; "unitID"; "inventoryUnits"; "pup_inventoryUnit")
	End if 
	
	
Function pup_inventoryUnit()
	//Create pop up menu
	Form:C1466.current_item.pup("units"; "Units"; "unitID"; "inventoryUnits")
	This:C1470.drawPup_inventoryUnit()
	
	
Function drawPup_procurementUnit()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.current_item.drowPup("Units"; "unitID"; "inventoryUnits"; "pup_procurementUnit")
	End if 
	
	
Function pup_procurementUnit()
	//Create pop up menu
	Form:C1466.current_item.pup("units"; "Units"; "unitID"; "procurementUnits")
	This:C1470.drawPup_procurementUnit()
	
	
Function drawPup_division()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.current_item.drowPup("Division"; "divisionID"; "divisionID"; "pup_division")
	End if 
	
	
Function pup_division()
	//Create pop up menu
	Form:C1466.current_item.pup("divisions"; "Division"; "divisionID"; "divisionID")
	This:C1470.drawPup_division()
	
	