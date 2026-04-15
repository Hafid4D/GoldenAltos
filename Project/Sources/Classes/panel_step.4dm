// ============================================
// Class: panel_step
// ============================================

singleton Class constructor
	// It's a singleton class
	
	
	// ----------------------------------------------
	// _activate_save_cancel_button
	// ----------------------------------------------
Function _activate_save_cancel_button()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	
	// ----------------------------------------------
	// formMethod
	// ----------------------------------------------
Function formMethod()
	// This function manages the main logic for updating and refreshing the form
	Form:C1466.sfw.panelFormMethod()  // The main body of the form method and basic sfw functionalities
	If (Form:C1466.sfw.updateOfPanelNeeded())  // The current item is changed or reloaded, so it's necessary to refresh
		This:C1470.loadStepProperties()
	End if 
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())  // A page is displayed so it's time to load the data sources
		Case of 
			: (FORM Get current page:C276(*)=1)
				// add load functions for page 1
			: (FORM Get current page:C276(*)=2)
				This:C1470.loadStepProperties()
		End case 
	End if 
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())  // It's time to resize the object or set visibility
		This:C1470.redrawAndSetVisible()
	End if 
	
	
	// ----------------------------------------------
	// redrawAndSetVisible
	// ----------------------------------------------
Function redrawAndSetVisible()
	// Adjusts the layout and visibility of form elements based on the current page and modification state to be implemented
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($widthSubform; $heightSubform)
	Case of 
		: (FORM Get current page:C276(*)=2)
			OBJECT GET COORDINATES:C663(*; "rec_bkgd_stepProperties"; $left; $top; $right; $bottom)
			OBJECT GET COORDINATES:C663(*; "lb_stepProperties"; $left_lb; $top_lb; $right_lb; $bottom_lb)
			OBJECT GET COORDINATES:C663(*; "bActionStepProperties"; $left_bAc; $top_bAc; $right_bAc; $bottom_bAc)
			
			$offset:=4
			$offset_bAc:=10
			$height_bAc:=$bottom_bAc-$top_bAc
			
			OBJECT SET COORDINATES:C1248(*; "rec_bkgd_stepProperties"; $left; $top; $right; $heightSubform-$offset)
			OBJECT SET COORDINATES:C1248(*; "lb_stepProperties"; $left_lb; $top_lb; $right_lb; $heightSubform-$offset-1)
			OBJECT SET COORDINATES:C1248(*; "bActionStepProperties"; $left_bAc; $heightSubform-$offset_bAc-$height_bAc; $right_bAc; $heightSubform-$offset_bAc)
	End case 
	
	Form:C1466.sfw.drawHTab()
	
	
Function loadStepProperties
	Form:C1466.selectedStepProperty:=Null:C1517
	If (Form:C1466.current_item=Null:C1517)
		Form:C1466.lb_stepProperties:=New collection:C1472
	Else 
		If (Form:C1466.current_item.stepProperties=Null:C1517)
			Form:C1466.current_item.stepProperties:=New object:C1471("items"; New collection:C1472)
		End if 
		If (Form:C1466.current_item.stepProperties.items=Null:C1517)
			Form:C1466.current_item.stepProperties.items:=New collection:C1472
		End if 
		Form:C1466.lb_stepProperties:=Form:C1466.current_item.stepProperties.items
	End if 
	
	
Function bActionStepProperties()
	$refMenu:=Create menu:C408
	
	APPEND MENU ITEM:C411($refMenu; "Add step property")
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--add")
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/button/add.png")
	If (Not:C34(Form:C1466.sfw.checkIsInModification()))
		DISABLE MENU ITEM:C150($refMenu; -1)
	End if 
	
	APPEND MENU ITEM:C411($refMenu; "Delete step property")
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--delete")
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/button/delete.png")
	If (Not:C34(Form:C1466.sfw.checkIsInModification()))
		DISABLE MENU ITEM:C150($refMenu; -1)
	Else 
		If (Form:C1466.selectedStepProperty=Null:C1517)
			DISABLE MENU ITEM:C150($refMenu; -1)
		End if 
	End if 
	
	$choose:=Dynamic pop up menu:C1006($refMenu)
	
	Case of 
		: ($choose="--add")
			$form:=New object:C1471
			$existingNames:=Form:C1466.current_item.stepProperties.items.extract("name")
			$properties:=ds:C1482.StepProperty.query("NOT(name IN :1)"; $existingNames)
			$form.stepRules:=$properties
			$form.stepRulesSelected:=New collection:C1472
			
			$winRef:=Open form window:C675("_ga_multiSelectListbox"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4)
			SET WINDOW TITLE:C213("Select step properties to add"; $winRef)
			DIALOG:C40("_ga_multiSelectListbox"; $form)
			CLOSE WINDOW:C154($winRef)
			
			If (OK=1)
				For each ($property; $form.stepRulesSelected)
					Form:C1466.current_item.stepProperties.items.push($property)
				End for each 
				
				This:C1470.loadStepProperties()
				This:C1470._activate_save_cancel_button()
			End if 
			
		: ($choose="--delete")
			Form:C1466.current_item.stepProperties.items:=Form:C1466.current_item.stepProperties.items.filter(Formula:C1597($1.value.name#Form:C1466.selectedStepProperty.name))
			
			This:C1470.loadStepProperties()
			This:C1470._activate_save_cancel_button()
	End case 
	
	