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
	
	
Function drawPup_XXX()
	//This function updates the dropdown by displaying the name
	Form:C1466.sfw.drawButtonPup("pup_xxx"; $xxxName; "xxxx.png"; (Form:C1466.current_item.xxxx=Null:C1517))
	
	
Function pup_XXX()
	//Create pop up menu
	
	
Function redrawAndSetVisible()
	//Adjusts the layout and visibility of form elements based on the current page and modification state
	This:C1470.drawPup_priority()
	This:C1470.drawPup_origin()
	This:C1470.drawPup_category()
	This:C1470.drawPup_disposition()
	This:C1470.drawPup_humanFactor()
	This:C1470.drawPup_yesNoQuestion()
	This:C1470.drawPup_procedureType()
	
	OBJECT SET VISIBLE:C603(*; "PopupDa@"; Form:C1466.sfw.checkIsInModification())
	Form:C1466.sfw.drawHTab()
	
	
	
Function drawPup_priority()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.current_item.drowPup("CIPriority"; "priorityID"; "priority"; "pup_priority")
	End if 
	
	
Function pup_priority()
	//Create pop up menu
	Form:C1466.current_item.pup("ImprovementPriorities"; "CIPriority"; "priorityID"; "priority")
	This:C1470.drawPup_priority()
	
	
Function drawPup_origin()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.current_item.drowPup("CIOrigin"; "originID"; "origin"; "pup_origin")
	End if 
	
	
Function pup_origin()
	//Create pop up menu
	Form:C1466.current_item.pup("ImprovementOrigins"; "CIOrigin"; "originID"; "origin")
	This:C1470.drawPup_origin()
	
	
Function drawPup_category()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.current_item.drowPup("CICategory"; "categoryID"; "category"; "pup_category")
	End if 
	
	
Function pup_category()
	//Create pop up menu
	Form:C1466.current_item.pup("ImprovementCategories"; "CICategory"; "categoryID"; "category")
	This:C1470.drawPup_category()
	
	
Function drawPup_disposition()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.current_item.drowPup("CIDisposition"; "dispositionID"; "disposition"; "pup_disposition")
	End if 
	
	
Function pup_disposition()
	//Create pop up menu
	Form:C1466.current_item.pup("ImprovementDispositions"; "CIDisposition"; "dispositionID"; "disposition")
	This:C1470.drawPup_disposition()
	
	
	
Function drawPup_humanFactor()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.current_item.drowPup("CIHumanFactor"; "factorID"; "humanFactor"; "pup_humanFactor")
	End if 
	
	
Function pup_humanFactor()
	//Create pop up menu
	Form:C1466.current_item.pup("ImprovementFactors"; "CIHumanFactor"; "factorID"; "humanFactor")
	This:C1470.drawPup_humanFactor()
	
	
Function drawPup_yesNoQuestion()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.current_item.drowPup("YesNoQuestion"; "responseID"; "IsAcceptable"; "pup_yesNoQuestion")
	End if 
	
	
Function pup_yesNoQuestion()
	//Create pop up menu
	Form:C1466.current_item.pup("ImprovementResponses"; "YesNoQuestion"; "responseID"; "IsAcceptable")
	This:C1470.drawPup_yesNoQuestion()
	
	
Function drawPup_procedureType()
	If (Form:C1466.current_item#Null:C1517)
		
		
	End if 
	
	
Function pup_procedureType()
	//Create pop up menu
	
	This:C1470.drawPup_procedureType()
	
	
	
	