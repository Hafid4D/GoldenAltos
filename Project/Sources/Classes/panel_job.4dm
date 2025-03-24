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
				
				$winRef:=Open form window:C675("createPoLine_job"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4)
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
				
				$winRef:=Open form window:C675("createLot_job"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4)
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