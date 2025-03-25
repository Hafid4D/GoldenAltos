singleton Class constructor
	//It's a singleton class
	
Function formMethod()
	//This function manages the main logic for updating and refreshing the form
	Form:C1466.sfw.panelFormMethod()  //The main body of the form method and basic sfw functionalities 
	If (Form:C1466.sfw.updateOfPanelNeeded())  //The current item is changed or reloaded, so it's necessary ti refresh 
	End if 
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())  //a page is displayed so it's time to load the sources of data to display
		Case of 
			: (FORM Get current page:C276(*)=2)
				This:C1470.loadInventoryPulls()
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
	
Function loadInventoryPulls()
	Form:C1466.lb_pulls:=Form:C1466.current_item.pulls
	
Function bActionInvPull()
	$refMenu:=Create menu:C408
	APPEND MENU ITEM:C411($refMenu; "(New Inv Pull")
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--create")
	APPEND MENU ITEM:C411($refMenu; "-")
	APPEND MENU ITEM:C411($refMenu; "(Delete")
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--delete")
	
	$choose:=Dynamic pop up menu:C1006($refMenu)