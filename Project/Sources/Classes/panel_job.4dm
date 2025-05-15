singleton Class constructor
	//It's a singleton class
	
Function formMethod()
	//This function manages the main logic for updating and refreshing the form
	Form:C1466.sfw.panelFormMethod()  //The main body of the form method and basic sfw functionalities 
	If (Form:C1466.sfw.updateOfPanelNeeded())  //The current item is changed or reloaded, so it's necessary ti refresh 
	End if 
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())  //a page is displayed so it's time to load the sources of data to display
		Case of 
			: (FORM Get current page:C276(*)=2)  //PO -> line items
				This:C1470.loadPoLineItems()
				
			: (FORM Get current page:C276(*)=3)  //PO -> line items
				This:C1470.loadLots()
		End case 
	End if 
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())  //It's time to resize the object or set visible
		This:C1470.redrawAndSetVisible()
	End if 
	
Function loadDpAddress()
	Form:C1466.dpAddress:=New object:C1471(\
		"values"; New collection:C1472("billing"; "shipping"); \
		"index"; 0; \
		"currentValue"; "Billing Address"\
		)
	
	
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
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($widthSubform; $heightSubform)
	
	Case of 
		: (FORM Get current page:C276(*)=2)  // po lines
			OBJECT GET COORDINATES:C663(*; "rec_bkgd_2"; $left; $top; $right; $bottom)
			OBJECT GET COORDINATES:C663(*; "lb_poLinesItems"; $left_lb; $top_lb; $right_lb; $bottom_lb)
			OBJECT GET COORDINATES:C663(*; "bActionLineItems"; $left_bAc; $top_bAc; $right_bAc; $bottom_bAc)
			
			$offset:=4
			$offset_bAc:=10
			
			$height_bAc:=$bottom_bAc-$top_bAc
			
			OBJECT SET COORDINATES:C1248(*; "rec_bkgd_2"; $left; $top; $right; $heightSubform-$offset)
			OBJECT SET COORDINATES:C1248(*; "lb_poLinesItems"; $left_lb; $top_lb; $widthSubform-$offset; $heightSubform-$offset-1)
			OBJECT SET COORDINATES:C1248(*; "bActionLineItems"; $left_bAc; $heightSubform-$offset_bAc-$height_bAc; $right_bAc; $heightSubform-$offset_bAc)
			
		: (FORM Get current page:C276(*)=3)  // lots
			OBJECT GET COORDINATES:C663(*; "rec_bkgd_3"; $left; $top; $right; $bottom)
			OBJECT GET COORDINATES:C663(*; "lb_poLinesItems"; $left_lb; $top_lb; $right_lb; $bottom_lb)
			OBJECT GET COORDINATES:C663(*; "bActionLineItems"; $left_bAc; $top_bAc; $right_bAc; $bottom_bAc)
			
			$offset:=4
			$offset_bAc:=10
			
			$height_bAc:=$bottom_bAc-$top_bAc
			
			OBJECT SET COORDINATES:C1248(*; "rec_bkgd_3"; $left; $top; $right; $heightSubform-$offset)
			OBJECT SET COORDINATES:C1248(*; "lb_lots"; $left_lb; $top_lb; $widthSubform-$offset; $heightSubform-$offset-1)
			OBJECT SET COORDINATES:C1248(*; "bActionLots"; $left_bAc; $heightSubform-$offset_bAc-$height_bAc; $right_bAc; $heightSubform-$offset_bAc)
	End case 
	
Function loadPoLineItems()
	Form:C1466.lb_lineItems:=ds:C1482.PurchaseOrderLine.query("UUID_Job = :1"; Form:C1466.current_item.UUID)
	
Function loadLots()
	Form:C1466.lb_lots:=ds:C1482.Lot.query("UUID_Job = :1"; Form:C1466.current_item.UUID)
	
Function bActionAttachPoLine()
	//Manages actions: add, or remove, using dynamic menus and modification checks
	If (Form:C1466.sfw.checkIsInModification())
		$refMenu:=Create menu:C408
		APPEND MENU ITEM:C411($refMenu; "Attach a PO Line")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--create")
		APPEND MENU ITEM:C411($refMenu; "-")
		APPEND MENU ITEM:C411($refMenu; "(Delete")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--delete")
		
		$choose:=Dynamic pop up menu:C1006($refMenu)
		
		Case of 
			: ($choose="--create")
				$form:=New object:C1471("UUID_Job"; Form:C1466.current_item.UUID)
				
				$winRef:=Open form window:C675("createPoLine_job"; Controller form window:K39:17; Horizontally centered:K39:1; Vertically centered:K39:4)
				DIALOG:C40("createPoLine_job"; $form)
				CLOSE WINDOW:C154($winRef)
				
				If (OK=1)
					This:C1470.loadPoLineItems()
				End if 
				
			: ($choose="--delete")
				
		End case 
	Else 
		$refMenu:=Create menu:C408
		APPEND MENU ITEM:C411($refMenu; "(Attach a PO Line")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--create")
		APPEND MENU ITEM:C411($refMenu; "-")
		APPEND MENU ITEM:C411($refMenu; "(Delete")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--delete")
		
		$choose:=Dynamic pop up menu:C1006($refMenu)
		
	End if 
Function bActionAttachLot()
	//Manages actions: add, or remove, using dynamic menus and modification checks
	If (Form:C1466.sfw.checkIsInModification())
		$refMenu:=Create menu:C408
		APPEND MENU ITEM:C411($refMenu; "Attach a Lot")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--create")
		APPEND MENU ITEM:C411($refMenu; "-")
		APPEND MENU ITEM:C411($refMenu; "(Delete")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--delete")
		
		$choose:=Dynamic pop up menu:C1006($refMenu)
		
		Case of 
			: ($choose="--create")
				$form:=New object:C1471("UUID_Job"; Form:C1466.current_item.UUID)
				
				$winRef:=Open form window:C675("createLot_job"; Controller form window:K39:17; Horizontally centered:K39:1; Vertically centered:K39:4)
				DIALOG:C40("createLot_job"; $form)
				CLOSE WINDOW:C154($winRef)
				
				If (OK=1)
					This:C1470.loadLots()
				End if 
				
			: ($choose="--delete")
				
		End case 
	Else 
		$refMenu:=Create menu:C408
		APPEND MENU ITEM:C411($refMenu; "(Attach a Lot")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--create")
		APPEND MENU ITEM:C411($refMenu; "-")
		APPEND MENU ITEM:C411($refMenu; "(Delete")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--delete")
		
		$choose:=Dynamic pop up menu:C1006($refMenu)
		
	End if 