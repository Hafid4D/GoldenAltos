singleton Class constructor
	//It's a singleton class
	
Function formMethod()
	//This function manages the main logic for updating and refreshing the form
	Form:C1466.sfw.panelFormMethod()  //The main body of the form method and basic sfw functionalities 
	If (Form:C1466.sfw.updateOfPanelNeeded())  //The current item is changed or reloaded, so it's necessary ti refresh 
	End if 
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())  //a page is displayed so it's time to load the sources of data to display
		Case of 
			: (FORM Get current page:C276(*)=1)
				// add load functions
				
			: (FORM Get current page:C276(*)=3)
				This:C1470.loadTerms()
		End case 
	End if 
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())  //It's time to resize the object or set visible
		This:C1470.redrawAndSetVisible()
	End if 
	
	
Function redrawAndSetVisible()
	//Adjusts the layout and visibility of form elements based on the current page and modification state
	
Function loadLineItems()
	Form:C1466.lb_boLines:=ds:C1482.BuyingOrderLine.query("UUID_BuyingOrder = :1"; Form:C1466.current_item.UUID)
	
Function bActionTerms()
	
	
Function loadTerms()
	Form:C1466.lb_terms:=New collection:C1472(\
		New object:C1471("type"; "terms"; "name"; "Terms"); \
		New object:C1471("type"; "termsCriticalMaterials"; "name"; "Critical Materials"); \
		New object:C1471("type"; "termsCriticalService"; "name"; "Critical Service")\
		)
	