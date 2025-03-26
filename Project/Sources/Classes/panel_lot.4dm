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
				This:C1470.loadLotSteps()
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
	
Function loadLotSteps()
	Form:C1466.lb_steps:=Form:C1466.current_item.steps
	
Function bActionSteps()
	//Manages actions: add, or remove, using dynamic menus and modification checks
	If (Form:C1466.sfw.checkIsInModification())
		$refMenu:=Create menu:C408
		APPEND MENU ITEM:C411($refMenu; "Create a step from template")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--create_from_template")
		
		APPEND MENU ITEM:C411($refMenu; "(Edit a step")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--edit")
		
		APPEND MENU ITEM:C411($refMenu; "(Remove a step")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--remove")
		
		APPEND MENU ITEM:C411($refMenu; "(Add steps from step file")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--create_from_step_file")
		
		$choose:=Dynamic pop up menu:C1006($refMenu)
		
		Case of 
			: ($choose="--create_from_template")
				$winRef:=Open form window:C675("createStepFromTemplate"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4)
				DIALOG:C40("createStepFromTemplate"; $form)
				CLOSE WINDOW:C154($winRef)
				
			: ($choose="--create_from_step_file")
			: ($choose="--edit")
			: ($choose="--remove")
		End case 
		
	Else 
		
	End if 