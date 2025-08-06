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
				
				
				
		End case 
	End if 
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())  //It's time to resize the object or set visible
		This:C1470.redrawAndSetVisible()
	End if 
	
	
Function redrawAndSetVisible()
	//Adjusts the layout and visibility of form elements based on the current page and modification state
	
	This:C1470.cipManage()
	
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($widthSubform; $heightSubform)
	
	Case of 
		: (FORM Get current page:C276(*)=1)
			OBJECT GET COORDINATES:C663(*; "subform_cip"; $left; $top; $right; $bottom)
			
			$hOffset:=20
			$vOffset:=4
			
			OBJECT SET COORDINATES:C1248(*; "subform_cip"; $left; $top; $widthSubform-$hOffset; $heightSubform-$vOffset)
	End case 
	
	Form:C1466.sfw.drawHTab()
	
	
	
Function cipManage()
	If (Form:C1466.current_item#Null:C1517)
		If (Form:C1466.situation.mode="add")
			//Form.current_item._initCorrectiveActionReport()
		End if 
		
		Form:C1466.subform_cip:=New object:C1471()
		Form:C1466.subform_cip.current_item:=Form:C1466.current_item
		Form:C1466.subform_cip.situation:=Form:C1466.situation
		Form:C1466.subform_cip.sfw:=Form:C1466.sfw
	End if 
	
	
	
Function subFormEvent()
	Form:C1466.current_item:=Form:C1466.subform_cip.current_item
	This:C1470._activate_save_cancel_button()
	
	
Function interestedPartyEdit()
	
	$interestedParties:=New collection:C1472()
	$allInterestedParties:=New collection:C1472("Company"; "Customer"; "Customers"; "DLA"; "Employees"; "Management"; "Operator"; "Organization"; "Supplier"; "Suppliers"; "Top Management")  //TODO :Need clarification
	
	$currentInterestedParties:=Split string:C1554(Form:C1466.current_item.interestedParty; ",")
	
	For ($i; 0; $allInterestedParties.length-1)
		
		$obj:=New object:C1471("name"; $allInterestedParties[$i]; "selected"; Not:C34($currentInterestedParties.indexOf($allInterestedParties[$i])<0))
		
		$interestedParties.push($obj)
	End for 
	
	$form:=New object:C1471()
	$form.interestedParties:=$interestedParties
	$winRef:=Open form window:C675("_ga_cipInterestedPartiesChoices"; Movable dialog box:K34:7; Horizontally centered:K39:1; Vertically centered:K39:4)
	DIALOG:C40("_ga_cipInterestedPartiesChoices"; $form)
	
	
	If (OK=1)
		$interestedParties:=New collection:C1472()
		$choices:=$form.interestedParties
		
		
		For ($i; 0; $choices.length-1)
			
			If ($choices[$i].selected=True:C214) & ($interestedParties.indexOf($choices[$i].name)=-1)
				$interestedParties.push($choices[$i].name)
				
			End if 
			
		End for 
		
		
		Form:C1466.current_item.interestedParty:=$interestedParties.join(",")
		cs:C1710.panel_continuousImprovement.me._activate_save_cancel_button()
		
		
	End if 
	
	
	
	