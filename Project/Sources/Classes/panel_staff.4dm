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
				This:C1470.loadCertifications()
		End case 
	End if 
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())  //It's time to resize the object or set visible
		This:C1470.redrawAndSetVisible()
	End if 
	
	
Function redrawAndSetVisible()
	//Adjusts the layout and visibility of form elements based on the current page and modification state
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($widthSubform; $heightSubform)
	
	Case of 
		: (FORM Get current page:C276(*)=1)  // main
			OBJECT GET COORDINATES:C663(*; "rec_bkgd_1"; $left; $top; $right; $bottom)
			OBJECT GET COORDINATES:C663(*; "lb_assignments"; $left_lb; $top_lb; $right_lb; $bottom_lb)
			
			$offset:=4
			
			OBJECT SET COORDINATES:C1248(*; "rec_bkgd_1"; $left; $top; $right; $heightSubform-$offset)
			OBJECT SET COORDINATES:C1248(*; "lb_assignments"; $left_lb; $top_lb; $right_lb; $heightSubform-$offset-1)
	End case 
	
Function loadCertifications()
	GOTO OBJECT:C206(*; "lb_assignments")
	Form:C1466.selectedCertification:=Form:C1466.selectedCertification
	Form:C1466.lb_assignments:=New collection:C1472()
	
	For each ($certification; ds:C1482.Certification.all().orderBy("ref asc"))
		Form:C1466.lb_assignments.push(New object:C1471(\
			"UUID"; $certification.UUID; \
			"name"; $certification.name; \
			"certified"; Form:C1466.current_item.hasCertification($certification.UUID)\
			))
	End for each 
	
Function manageCertification()
	Case of 
		: (FORM Event:C1606.code=On Data Change:K2:15)
			If (Form:C1466.selectedCertification.certified)
				Form:C1466.current_item.createCertification(Form:C1466.selectedCertification.UUID)
				This:C1470.loadCertifications()
			Else 
				Form:C1466.current_item.deleteCertification(Form:C1466.selectedCertification.UUID)
				This:C1470.loadCertifications()
			End if 
			
			This:C1470._activate_save_cancel_button()
	End case 
	