singleton Class constructor
	//It's a singleton class
	
Function formMethod()
	//This function manages the main logic for updating and refreshing the form
	Form:C1466.sfw.panelFormMethod()  //The main body of the form method and basic sfw functionalities 
	If (Form:C1466.sfw.updateOfPanelNeeded())  //The current item is changed or reloaded, so it's necessary ti refresh 
		This:C1470.loadAllTabs()
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
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($widthSubform; $heightSubform)
	Use (Form:C1466.sfw.entry.panel.pages)
		Form:C1466.sfw.entry.panel.pages[1].label:="Inventory Pulls ("+String:C10(Form:C1466.lb_pulls.length)+")"
	End use 
	Form:C1466.sfw.drawHTab()
	
	Case of 
		: (FORM Get current page:C276(*)=2)  // po lines
			OBJECT GET COORDINATES:C663(*; "rec_bkgd_2"; $left; $top; $right; $bottom)
			OBJECT GET COORDINATES:C663(*; "lb_pulls"; $left_lb; $top_lb; $right_lb; $bottom_lb)
			OBJECT GET COORDINATES:C663(*; "bActionPulls"; $left_bAc; $top_bAc; $right_bAc; $bottom_bAc)
			
			$offset:=4
			$offset_bAc:=10
			
			$height_bAc:=$bottom_bAc-$top_bAc
			
			OBJECT SET COORDINATES:C1248(*; "rec_bkgd_2"; $left; $top; $right; $heightSubform-$offset)
			OBJECT SET COORDINATES:C1248(*; "lb_pulls"; $left_lb; $top_lb; $widthSubform-$offset; $heightSubform-$offset-1)
			OBJECT SET COORDINATES:C1248(*; "bActionPulls"; $left_bAc; $heightSubform-$offset_bAc-$height_bAc; $right_bAc; $heightSubform-$offset_bAc)
	End case 
	
Function loadAllTabs()
	This:C1470.loadInventoryPulls()
	
Function loadInventoryPulls()
	Form:C1466.lb_pulls:=Form:C1466.current_item.pulls
	
Function bActionInvPull()
	$refMenu:=Create menu:C408
	
	APPEND MENU ITEM:C411($refMenu; "Pull")
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--pull")
	If (Not:C34(Form:C1466.sfw.checkIsInModification()))
		DISABLE MENU ITEM:C150($refMenu; -1)
	End if 
	
	$choose:=Dynamic pop up menu:C1006($refMenu)
	
	If ($choose#"")
		$form:=New object:C1471(\
			"invPull"; New object:C1471(\
			"order"; Form:C1466.lb_pulls.length+1; \
			"isPull"; True:C214; \
			"date"; Current date:C33(); \
			"currentQty"; Form:C1466.current_item.availableQty; \
			"qtyToPull"; 0; \
			"pulledBy"; "Hassan Sribet"; \
			"note"; ""\
			))
		
		$winRef:=Open form window:C675("create_invPull"; Controller form window:K39:17; Horizontally centered:K39:1; Vertically centered:K39:4)
		DIALOG:C40("create_invPull"; $form)
		CLOSE WINDOW:C154($winRef)
		
		If (OK=1)
			$pull_e:=ds:C1482.InventoryPull.new()
			
			$pull_e.type:="Pull"
			$pull_e.date:=cs:C1710.sfw_stmp.me.build($form.invPull.date)
			$pull_e.qty:=$form.invPull.qtyToPull
			$pull_e.remaining:=$form.invPull.currentQty-$form.invPull.qtyToPull
			$pull_e.performedBy:=$form.invPull.pulledBy
			$pull_e.lotNumber:=Form:C1466.currentStep.lotNumber
			$pull_e.statusIQA:="N/A"
			
			$pull_e.UUID_Inventory:=Form:C1466.current_item.UUID
			
			$res:=$pull_e.save()
			
			If ($res.success)
				Form:C1466.current_item.availableQty:=$pull_e.remaining
				
				This:C1470.loadInventoryPulls()
				This:C1470._activate_save_cancel_button()
			End if 
		End if 
	End if 