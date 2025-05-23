singleton Class constructor
	//It's a singleton class
	
Function _activate_save_cancel_button()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	
Function formMethod()
	//This function manages the main logic for updating and refreshing the form
	Form:C1466.sfw.panelFormMethod()  //The main body of the form method and basic sfw functionalities 
	If (Form:C1466.sfw.updateOfPanelNeeded())  //The current item is changed or reloaded, so it's necessary ti refresh 
		//OBJECT SET VISIBLE(*; "wr30_@"; (Form.current_item.getCertiExpiredIn(30).length>0))
		This:C1470.loadAllTabs()
	End if 
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())  //a page is displayed so it's time to load the sources of data to display
		ds:C1482.Staff.checkRetraining(30)
		
		Case of 
			: (FORM Get current page:C276(*)=1)
				This:C1470.loadCommunications()
			: (FORM Get current page:C276(*)=2)
				This:C1470.loadCertifications()
		End case 
	End if 
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())  //It's time to resize the object or set visible
		This:C1470.redrawAndSetVisible()
	End if 
	
	
Function redrawAndSetVisible()
	//Adjusts the layout and visibility of form elements based on the current page and modification state
	This:C1470.hideDatePickers()
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($widthSubform; $heightSubform)
	Use (Form:C1466.sfw.entry.panel.pages)
		Form:C1466.sfw.entry.panel.pages[1].label:="Certifications Assignment ("+String:C10(Form:C1466.lb_assignments.length)+")"
	End use 
	Form:C1466.sfw.drawHTab()
	
	Case of 
		: (FORM Get current page:C276(*)=2)  // assignments
			OBJECT GET COORDINATES:C663(*; "rec_bkgd_1"; $left; $top; $right; $bottom)
			OBJECT GET COORDINATES:C663(*; "lb_assignments"; $left_lb; $top_lb; $right_lb; $bottom_lb)
			
			$offset:=4
			
			OBJECT SET COORDINATES:C1248(*; "rec_bkgd_1"; $left; $top; $right; $heightSubform-$offset)
			OBJECT SET COORDINATES:C1248(*; "lb_assignments"; $left_lb; $top_lb; $right_lb; $heightSubform-$offset-1)
	End case 
	
Function loadAllTabs()
	This:C1470.loadCertifications()
	
Function loadCommunications()
	Form:C1466.subFormCommunication:=New object:C1471(\
		"communications"; Form:C1466.current_item.contactDetails.communications; \
		"situation"; Form:C1466.situation\
		)
	
	Form:C1466.subFormCommunication:=Form:C1466.subFormCommunication
	
Function loadCertifications()
	GOTO OBJECT:C206(*; "lb_assignments")
	Form:C1466.selectedCertification:=Form:C1466.selectedCertification
	Form:C1466.lb_assignments:=New collection:C1472()
	
	For each ($certification; ds:C1482.Certification.all().orderBy("ref asc"))
		Form:C1466.lb_assignments.push(New object:C1471(\
			"UUID"; $certification.UUID; \
			"name"; $certification.name; \
			"duration"; $certification.duration; \
			"oneTime"; $certification.oneTime; \
			"expiredIn"; Form:C1466.current_item.getExpiredDate($certification.UUID); \
			"certifiedAt"; Form:C1466.current_item.getCertificationDate($certification.UUID); \
			"certified"; Form:C1466.current_item.hasCertification($certification.UUID)\
			))
	End for each 
	
	$find:=""
	
	$find:=cs:C1710.sfw_userManager.me.authorizedProfiles.find(Formula:C1597((Value type:C1509($1.value)=Is text:K8:3) && ($1.value=$2)); "qa")
	
	If ($find#"")
		//TRACE
		$nb_cols:=LISTBOX Get number of columns:C831(*; "lb_assignments")
		
		If ($nb_cols=2)
			var $NilPtr : Pointer
			var $width_new_col : Integer:=70
			
			LISTBOX INSERT COLUMN FORMULA:C970(*; "lb_assignments"; 2; "col_expired_in"; "This.expiredIn"; Is date:K8:7; "hd_expiredIn"; $NilPtr)
			LISTBOX INSERT COLUMN FORMULA:C970(*; "lb_assignments"; 2; "col_certified_at"; "This.certifiedAt"; Is date:K8:7; "hd_certifiedAt"; $NilPtr)
			
			$width:=LISTBOX Get column width:C834(*; "header_certifName")
			
			$width:=LISTBOX SET COLUMN WIDTH:C833(*; "header_certifName"; $width-($width_new_col*2))
			$width:=LISTBOX SET COLUMN WIDTH:C833(*; "col_certified_at"; $width_new_col)
			$width:=LISTBOX SET COLUMN WIDTH:C833(*; "col_expired_in"; $width_new_col)
			
			OBJECT SET TITLE:C194(*; "hd_certifiedAt"; "Certified At")
			OBJECT SET TITLE:C194(*; "hd_expiredIn"; "Expired In")
			
			OBJECT SET FONT STYLE:C166(*; "hd_certifiedAt"; Bold:K14:2)
			OBJECT SET FONT STYLE:C166(*; "hd_expiredIn"; Bold:K14:2)
			
			OBJECT SET FORMAT:C236(*; "col_certified_at"; "dd/MM/yyyy blankIfNull")
			OBJECT SET FORMAT:C236(*; "col_expired_in"; "dd/MM/yyyy blankIfNull")
			
			OBJECT SET HORIZONTAL ALIGNMENT:C706(*; "col_certified_at"; Align center:K42:3)
			OBJECT SET HORIZONTAL ALIGNMENT:C706(*; "col_expired_in"; Align center:K42:3)
		End if 
	End if 
	
Function manageCertification()
	Case of 
		: (FORM Event:C1606.code=On Data Change:K2:15)
			If (Form:C1466.selectedCertification.certified)
				Form:C1466.current_item.createCertification(Form:C1466.selectedCertification.UUID; (Not:C34(Form:C1466.selectedCertification.oneTime)) ? Form:C1466.selectedCertification.duration : 0)
				This:C1470.loadCertifications()
			Else 
				Form:C1466.current_item.deleteCertification(Form:C1466.selectedCertification.UUID)
				This:C1470.loadCertifications()
			End if 
			
			This:C1470._activate_save_cancel_button()
	End case 
	
	//Function manageDataPicker($objectName : Text)
	//If (Form.sfw.checkIsInModification() && ((FORM Event.code=On Clicked) || (FORM Event.code=On Getting Focus)))
	//Case of 
	//: (OBJECT Get visible(*; "dp_terminationDate"))
	//OBJECT SET VISIBLE(*; "dp_terminationDate"; False)
	//: (OBJECT Get visible(*; "dp_retrainDate"))
	//OBJECT SET VISIBLE(*; "dp_retrainDate"; False)
	//: (OBJECT Get visible(*; "dp_hireDate"))
	//OBJECT SET VISIBLE(*; "dp_hireDate"; False)
	//: (OBJECT Get visible(*; "dp_creationDate"))
	//OBJECT SET VISIBLE(*; "dp_creationDate"; False)
	//: (FORM Event.code=On Clicked) | (FORM Event.code=On Getting Focus)
	//OBJECT Get pointer(Object named; *; "SelectedDate"; "dp_creationDate")->:=Form.current_item[$objectName]
	
	//OBJECT SET VALUE("dp_creationDate"; Form.current_item[$objectName])
	//cs.panel_staff.me.hideDatePickers()
	
	//OBJECT GET COORDINATES(*; "entryField_"+$objectName; $ob_left; $ob_top; $ob_right; $ob_bottom)
	
	//OBJECT GET COORDINATES(*; "dp_"+$objectName; $dp_left; $dp_top; $dp_right; $dp_bottom)
	
	//$dp_width:=$dp_right-$dp_left
	//$dp_height:=$dp_bottom-$dp_top
	
	//OBJECT SET COORDINATES(*; "dp_"+$objectName; $ob_right-$dp_width; $ob_bottom; $ob_right; $ob_bottom+$dp_height)
	
	//OBJECT SET VISIBLE(*; "dp_"+$objectName; True)
	//End case 
	
	//If (FORM Event.code=On Clicked)
	//Case of 
	//: (OBJECT Get visible(*; "dp_terminationDate"))
	//OBJECT SET VISIBLE(*; "dp_terminationDate"; False)
	//: (OBJECT Get visible(*; "dp_retrainDate"))
	//OBJECT SET VISIBLE(*; "dp_retrainDate"; False)
	//: (OBJECT Get visible(*; "dp_hireDate"))
	//OBJECT SET VISIBLE(*; "dp_hireDate"; False)
	//: (OBJECT Get visible(*; "dp_creationDate"))
	//OBJECT SET VISIBLE(*; "dp_creationDate"; False)
	//End case 
	//End if 
	//End if 
	
Function hideDatePickers()
	OBJECT SET VISIBLE:C603(*; "dp_@"; Form:C1466.sfw.checkIsInModification())
	