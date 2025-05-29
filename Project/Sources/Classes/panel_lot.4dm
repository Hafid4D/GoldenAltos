singleton Class constructor
	//It's a singleton class
	
Function _activate_save_cancel_button()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	
Function formMethod()
	//This function manages the main logic for updating and refreshing the form
	Form:C1466.sfw.panelFormMethod()  //The main body of the form method and basic sfw functionalities 
	If (Form:C1466.sfw.updateOfPanelNeeded())  //The current item is changed or reloaded, so it's necessary ti refresh 
		This:C1470.loadAllTabs()
	End if 
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())  //a page is displayed so it's time to load the sources of data to display
		Case of 
			: (FORM Get current page:C276(*)=2)
				This:C1470.manageReOrderBtns()
				
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
	This:C1470.hideDatePickers()
	
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($widthSubform; $heightSubform)
	Use (Form:C1466.sfw.entry.panel.pages)
		Form:C1466.sfw.entry.panel.pages[1].label:="Lot Steps ("+String:C10(Form:C1466.lb_steps.length)+")"
		
	End use 
	Form:C1466.sfw.drawHTab()
	
	Case of 
		: (FORM Get current page:C276(*)=2)  // Lot Steps
			OBJECT GET COORDINATES:C663(*; "rec_bkgd_"+String:C10(FORM Get current page:C276(*)); $left; $top; $right; $bottom)
			OBJECT GET COORDINATES:C663(*; "lb_steps"; $left_lb; $top_lb; $right_lb; $bottom_lb)
			OBJECT GET COORDINATES:C663(*; "bActionLotSteps"; $left_bAc; $top_bAc; $right_bAc; $bottom_bAc)
			
			
			OBJECT GET COORDINATES:C663(*; "btnMoveTop"; $left_mt; $top_mt; $right_mt; $bottom_mt)
			OBJECT GET COORDINATES:C663(*; "btnMoveUp"; $left_mu; $top_mu; $right_mu; $bottom_mu)
			OBJECT GET COORDINATES:C663(*; "btnMoveDown"; $left_md; $top_md; $right_md; $bottom_md)
			OBJECT GET COORDINATES:C663(*; "btnMoveBottom"; $left_mb; $top_mb; $right_mb; $bottom_mb)
			
			$offset:=4
			$offset_r:=60
			$offset_btns_r:=15
			$offset_bAc:=10
			
			$width:=$right-$left
			$height:=$bottom-$top
			
			$height_bAc:=$bottom_bAc-$top_bAc
			
			$width_mt:=$right_mt-$left_mt
			$width_mu:=$right_mu-$left_mu
			$width_md:=$right_md-$left_md
			$width_mb:=$right_mb-$left_mb
			
			OBJECT SET COORDINATES:C1248(*; "rec_bkgd_"+String:C10(FORM Get current page:C276(*)); $left; $top; $right; $heightSubform-$offset)
			OBJECT SET COORDINATES:C1248(*; "lb_steps"; $left_lb; $top_lb; $widthSubform-$offset_r; $heightSubform-$offset-1)
			OBJECT SET COORDINATES:C1248(*; "bActionLotSteps"; $left_bAc; $heightSubform-$offset_bAc-$height_bAc; $right_bAc; $heightSubform-$offset_bAc)
			
			OBJECT SET COORDINATES:C1248(*; "btnMoveTop"; $widthSubform-$offset_btns_r-$width_mt; $top_mt; $widthSubform-$offset_btns_r; $bottom_mt)
			OBJECT SET COORDINATES:C1248(*; "btnMoveUp"; $widthSubform-$offset_btns_r-$width_mu; $top_mu; $widthSubform-$offset_btns_r; $bottom_mu)
			OBJECT SET COORDINATES:C1248(*; "btnMoveDown"; $widthSubform-$offset_btns_r-$width_md; $top_md; $widthSubform-$offset_btns_r; $bottom_md)
			OBJECT SET COORDINATES:C1248(*; "btnMoveBottom"; $widthSubform-$offset_btns_r-$width_mb; $top_mb; $widthSubform-$offset_btns_r; $bottom_mb)
	End case 
	
Function loadAllTabs()
	This:C1470.loadLotSteps()
	
	
Function loadLotSteps()
	//Form.lb_steps:=Form.current_item.steps.orderBy("order asc")
	Form:C1466.currentstep:=0
	
	Form:C1466.lb_steps:=ds:C1482.LotStep.query("UUID_Lot = :1"; Form:C1466.current_item.UUID).orderBy("order asc")
	$currentstep:=Form:C1466.lb_steps.query("qtyIn = :1 AND qtyOut = :1 AND dateIn = :2 AND dateOut = :2"; 0; !00-00-00!).orderBy("order asc")
	
	If ($currentstep.length>0)
		Form:C1466.currentstep:=$currentstep[0].order
	End if 
	
Function bActionSteps()
	//Manages actions: add, or remove, using dynamic menus and modification checks
	If (Form:C1466.sfw.checkIsInModification())
		$refMenu:=Create menu:C408
		
		APPEND MENU ITEM:C411($refMenu; "Create a step from template")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--create_from_template")
		
		APPEND MENU ITEM:C411($refMenu; "Edit a step")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--edit")
		DISABLE MENU ITEM:C150($refMenu; -1)
		
		APPEND MENU ITEM:C411($refMenu; "Remove a step")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--remove")
		DISABLE MENU ITEM:C150($refMenu; -1)
		
		APPEND MENU ITEM:C411($refMenu; "Add steps from step file")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--create_from_step_file")
		
		$choose:=Dynamic pop up menu:C1006($refMenu)
		
		Case of 
			: ($choose="--create_from_template")
				$form:=New object:C1471(\
					"lotStep"; ds:C1482.LotStep.new()\
					)
				
				$form.lotStep.UUID_Lot:=Form:C1466.current_item.UUID
				$form.lotStep.order:=Form:C1466.lb_steps.length+1
				
				$winRef:=Open form window:C675("createStep_StepTemplate"; Controller form window:K39:17; Horizontally centered:K39:1; Vertically centered:K39:4)
				DIALOG:C40("createStep_StepTemplate"; $form)
				CLOSE WINDOW:C154($winRef)
				
				If (ok=1)
					$lotStep_e:=$form.lotStep
					
					$res:=$lotStep_e.save()
					
					If ($res.success)
						This:C1470.loadLotSteps()
						This:C1470._activate_save_cancel_button()
					End if 
				End if 
				
			: ($choose="--create_from_step_file")
				$form:=New object:C1471("lotInfo"; New object:C1471("customer"; Form:C1466.current_item.customer))
				
				$winRef:=Open form window:C675("createStepFromStepFile"; Controller form window:K39:17; Horizontally centered:K39:1; Vertically centered:K39:4)
				DIALOG:C40("createStepFromStepFile"; $form)
				CLOSE WINDOW:C154($winRef)
				
				If (ok=1)
					For each ($step; $form.selectedSteps)
						$step_o:=$step.toObject("description, alert, qtyIn, qtyOut, dateIn, dateOut")
						
						$step_new:=ds:C1482.LotStep.new()
						
						$step_new.fromObject($step_o)
						
						$step_new.UUID_Lot:=Form:C1466.current_item.UUID
						$step_new.order:=Form:C1466.lb_steps.length+1
						
						$res:=$step_new.save()
					End for each 
					
					This:C1470.loadLotSteps()
					
					This:C1470._activate_save_cancel_button()
				End if 
				
			: ($choose="--edit")
			: ($choose="--remove")
		End case 
		
	Else 
		$refMenu:=Create menu:C408
		
		APPEND MENU ITEM:C411($refMenu; "Create a step from template")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--create_from_template")
		DISABLE MENU ITEM:C150($refMenu; -1)
		
		APPEND MENU ITEM:C411($refMenu; "(Edit a step")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--edit")
		DISABLE MENU ITEM:C150($refMenu; -1)
		
		APPEND MENU ITEM:C411($refMenu; "(Remove a step")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--remove")
		DISABLE MENU ITEM:C150($refMenu; -1)
		
		APPEND MENU ITEM:C411($refMenu; "(Add steps from step file")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--create_from_step_file")
		DISABLE MENU ITEM:C150($refMenu; -1)
		
		$choose:=Dynamic pop up menu:C1006($refMenu)
	End if 
	
Function btnReOrderLots($from : Integer; $to : Integer)
	If (Form:C1466.selectedLot#Null:C1517)
		$coef:=1
		
		If (($to-$from)>0)
			$coef:=-1
		End if 
		
		If ($coef>0)
			$lotsToReOrder:=Form:C1466.lb_steps.query("order >= :1 AND order < :2"; Choose:C955(($from>$to); $to; $from); Choose:C955(($from>$to); $from; $to))
		Else 
			$lotsToReOrder:=Form:C1466.lb_steps.query("order > :1 AND order <= :2"; Choose:C955(($from>$to); $to; $from); Choose:C955(($from>$to); $from; $to))
		End if 
		
		For each ($lot; $lotsToReOrder)
			$lot.order:=$lot.order+$coef
			
			$res:=$lot.save()
		End for each 
		
		Form:C1466.selectedLot.order:=$to
		
		$res:=Form:C1466.selectedLot.save()
		
		This:C1470.loadLotSteps()
		
		Form:C1466.selectedLot:=Form:C1466.lb_steps.query("order = :1"; $to).first()
		LISTBOX SELECT ROW:C912(*; "lb_steps"; $to)
		This:C1470.manageReOrderBtns()
		This:C1470._activate_save_cancel_button()
	End if 
	
Function manageReOrderBtns()
	OBJECT SET VISIBLE:C603(*; "btnMoveTop"; Form:C1466.sfw.checkIsInModification())
	OBJECT SET VISIBLE:C603(*; "btnMoveUp"; Form:C1466.sfw.checkIsInModification())
	OBJECT SET VISIBLE:C603(*; "btnMoveDown"; Form:C1466.sfw.checkIsInModification())
	OBJECT SET VISIBLE:C603(*; "btnMoveBottom"; Form:C1466.sfw.checkIsInModification())
	
	OBJECT SET ENABLED:C1123(*; "btnMoveTop"; (Form:C1466.selectedLot#Null:C1517))
	OBJECT SET ENABLED:C1123(*; "btnMoveUp"; (Form:C1466.selectedLot#Null:C1517))
	OBJECT SET ENABLED:C1123(*; "btnMoveDown"; (Form:C1466.selectedLot#Null:C1517))
	OBJECT SET ENABLED:C1123(*; "btnMoveBottom"; (Form:C1466.selectedLot#Null:C1517))
	
	If (Form:C1466.sfw.checkIsInModification() & (Form:C1466.selectedLot#Null:C1517))
		Case of 
			: (Form:C1466.selectedLotPos=1)
				OBJECT SET ENABLED:C1123(*; "btnMoveTop"; False:C215)
				OBJECT SET ENABLED:C1123(*; "btnMoveUp"; False:C215)
				
			: (Form:C1466.selectedLotPos=Form:C1466.lb_steps.length)
				OBJECT SET ENABLED:C1123(*; "btnMoveBottom"; False:C215)
				OBJECT SET ENABLED:C1123(*; "btnMoveDown"; False:C215)
		End case 
	End if 
	
Function btnOpenCustomer()
	$es:=ds:C1482.Customer.query("name = :1"; Form:C1466.current_item.customer)
	
	If ($es.length>0)
		Form:C1466.sfw.openInANewWindow($es[0]; "customerService"; "customer")
	End if 
	
Function btnOpenPurchaseOrder()
	$es:=ds:C1482.PurchaseOrder.query("poNumber = :1"; Form:C1466.current_item.poNumber)
	
	If ($es.length>0)
		Form:C1466.sfw.openInANewWindow($es[0]; "customerService"; "purchaseOrders")
	End if 
	
Function btnOpenJob()
	$entity:=Form:C1466.current_item.job
	Form:C1466.sfw.openInANewWindow($entity; "customerService"; "jobs")
	
Function hideDatePickers()
	OBJECT SET VISIBLE:C603(*; "dp_@"; Form:C1466.sfw.checkIsInModification())
	