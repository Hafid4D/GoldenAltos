property process : Text
singleton Class constructor
	
	
Function formMethod()
	Form:C1466.sfw.panelFormMethod()  //The main body of the form method and basic sfw functionalities 
	If (Form:C1466.sfw.updateOfPanelNeeded())  //The current item is changed or reloaded, so it's necessary ti refresh 
		Form:C1466.steps_lb:=New collection:C1472()
		Form:C1466.current_process:=Null:C1517
		This:C1470.drawPup_customer()
		This:C1470.drawPup_process()
		
	End if 
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())  //a page is displayed so it's time to load the sources of data to display
		Case of 
			: (FORM Get current page:C276(*)=1)
				This:C1470.loadSteps()
				This:C1470.loadSelectedSteps()
				This:C1470.manageReOrderBtns()
		End case 
	End if 
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())
		This:C1470.redrawAndSetVisible()
	End if 
	
Function loadSteps()
	Form:C1466.selectedStep:=Null:C1517
	Form:C1466.selectedStepPos:=0
	
	If (Form:C1466.current_process#Null:C1517)
		Form:C1466.steps_lb:=ds:C1482.Step.query("moreData.Process = :1"; Form:C1466.current_process).copy()
	End if 
	
	
Function drawPup_customer()
	If (Form:C1466.current_item#Null:C1517)
		$name:=Form:C1466.current_item.customer.name || " "
		Form:C1466.sfw.drawButtonPup("pup_customer"; $name; "sfw/image/skin/rainbow/icon/spacer-1x24.png"; (Form:C1466.current_item.customer=Null:C1517))
	End if 
	
Function selectCustomer()
	
	If (Form:C1466.sfw.checkIsInModification())
		
		$selector:=cs:C1710.sfw_definitionSelector.new("selectorCustomers"; "customer")
		$selector.setTitle("Choose a Customer")
		$selector.setCurrentItem(Form:C1466.current_item.customer)
		$selector.setOptions("noCutLink")
		$selector.openSelector()
		
		Case of 
			: ($selector.isSelected())
				$itemSeleted:=$selector.getCurrentItem()
				
				Case of 
					: ($itemSeleted=Null:C1517)
					: (cs:C1710.sfw_string.me.isAnEmptyUUID($itemSeleted.UUID)=False:C215)
						Form:C1466.current_item.UUID_Customer:=$itemSeleted.UUID
						If (cs:C1710.sfw_string.me.isAnEmptyUUID(Form:C1466.current_item.UUID_Customer)=True:C214)
							Form:C1466.current_item.UUID_Customer:=16*"00"
						End if 
				End case 
				This:C1470.drawPup_customer()
			: ($selector.asCutTheLink())
				Form:C1466.current_item.UUID_Customer:=16*"00"
			: ($selector.needCreation())
				$selector.createANewEntity("cs.panel_stepFile.me.callbackAfterCreationCustomer($1)")
		End case 
	End if 
	
Function callbackAfterCreationCustomer($key : Text)
	Form:C1466.current_item.UUID_Customer:=$key
	If (cs:C1710.sfw_string.me.isAnEmptyUUID(Form:C1466.current_item.UUID_Customer)=True:C214)
		Form:C1466.current_item.UUID_Customer:=16*"00"
	End if 
	EXECUTE METHOD IN SUBFORM:C1085("detail_panel"; Formula:C1597(cs:C1710.panel_lead.me.drawPup_customer()); *)
	
	
	
Function drawPup_process()
	If (Form:C1466.current_process#Null:C1517)
		OBJECT SET TITLE:C194(*; "pup_process"; Form:C1466.current_process)
	Else 
		OBJECT SET TITLE:C194(*; "pup_process"; "⚙️ processes")
	End if 
	
	//OBJECT SET VISIBLE(*; "@billable"; False)
	
Function pup_process()
	
	
	If (Form:C1466.sfw.checkIsInModification())
		$menu:=Create menu:C408
		If (Storage:C1525.cache=Null:C1517) || (Storage:C1525.cache.process=Null:C1517)
			ds:C1482.Step.cacheLoad()
		End if 
		
		For each ($process; Storage:C1525.cache.process)
			APPEND MENU ITEM:C411($menu; $process; *)
			SET MENU ITEM PARAMETER:C1004($menu; -1; $process)
			If ($process=Form:C1466.current_process)
				SET MENU ITEM MARK:C208($menu; -1; Char:C90(18))
				If (Is Windows:C1573)
					SET MENU ITEM STYLE:C425($menu; -1; Bold:K14:2)
				End if 
			End if 
		End for each 
		$choose:=Dynamic pop up menu:C1006($menu)
		RELEASE MENU:C978($menu)
		
		
		Case of 
			: ($choose#"")
				OBJECT SET TITLE:C194(*; "pup_process"; $choose)
				Form:C1466.current_process:=$choose
		End case 
	End if 
	
	
Function loadSelectedSteps()
	
	$selectedSteps:=New collection:C1472()
	If (Form:C1466.current_item.moreData#Null:C1517) && (Form:C1466.current_item.moreData.selectedSteps#Null:C1517) && (Form:C1466.current_item.moreData.selectedSteps.length>0)
		$uuids:=Form:C1466.current_item.moreData.selectedSteps.extract("UUID")
		$steps:=ds:C1482.Step.query("UUID in :1"; $uuids)
		
		For each ($step; Form:C1466.current_item.moreData.selectedSteps)
			$object:=New object:C1471()
			$object.order:=$step.order
			$object.step:=$steps.query("UUID = :1"; $step.UUID).first().toObject()
			$selectedSteps.push($object)
		End for each 
	End if 
	Form:C1466.selectedSteps:=$selectedSteps
	
Function selectedStep()
	var $object : Object
	
	If (Form:C1466.sfw.checkIsInModification()) && (Form:C1466.selectedStep#Null:C1517)
		
		If (Form:C1466.current_item.moreData=Null:C1517)
			Form:C1466.current_item.moreData:=New object:C1471()
			Form:C1466.current_item.moreData.selectedSteps:=New collection:C1472()
		End if 
		If (Form:C1466.current_item.moreData.selectedSteps=Null:C1517)
			Form:C1466.current_item.moreData.selectedSteps:=New collection:C1472()
		End if 
		
		If (Form:C1466.current_item.moreData.selectedSteps.query("UUID = :1"; Form:C1466.selectedStep.UUID).first()=Null:C1517)
			
			$order:=Form:C1466.current_item.moreData.selectedSteps.length+1
			$object:=New object:C1471("order"; $order; "UUID"; Form:C1466.selectedStep.UUID)
			Form:C1466.current_item.moreData.selectedSteps.push($object)
			
			//$info:=Form.current_item.save()
		End if 
		This:C1470.loadSelectedSteps()
		
	End if 
	
	
	
Function redrawAndSetVisible()
	
	Case of 
		: (FORM Get current page:C276(*)=1)  // Lot Steps
			OBJECT GET SUBFORM CONTAINER SIZE:C1148($widthSubForm; $heightSubform)
			OBJECT GET COORDINATES:C663(*; "lb_steps"; $left_l; $top_l; $right_l; $bottom_l)
			OBJECT SET COORDINATES:C1248(*; "lb_steps"; $left_l; $top_l; $widthSubform; $bottom_l)
			
			OBJECT GET COORDINATES:C663(*; "rec_bkgd"; $left_r; $top_r; $right_r; $bottom_r)
			OBJECT SET COORDINATES:C1248(*; "rec_bkgd"; $left_r; $top_r; $right_r; $heightSubform)
			
			OBJECT GET COORDINATES:C663(*; "bAction_delete"; $left_bAc; $top_bAc; $right_bAc; $bottom_bAc)
			$offset:=4
			$offset_bAc:=10
			$height_bAc:=$bottom_bAc-$top_bAc
			OBJECT SET COORDINATES:C1248(*; "bAction_delete"; $left_bAc; $heightSubform-$offset_bAc-$height_bAc; $right_bAc; $heightSubform-$offset_bAc)
			
			
			OBJECT GET COORDINATES:C663(*; "lb_selectedSteps"; $left_lb; $top_lb; $right_lb; $bottom_lb)
			OBJECT GET COORDINATES:C663(*; "btnMoveTop"; $left_mt; $top_mt; $right_mt; $bottom_mt)
			OBJECT GET COORDINATES:C663(*; "btnMoveUp"; $left_mu; $top_mu; $right_mu; $bottom_mu)
			OBJECT GET COORDINATES:C663(*; "btnMoveDown"; $left_md; $top_md; $right_md; $bottom_md)
			OBJECT GET COORDINATES:C663(*; "btnMoveBottom"; $left_mb; $top_mb; $right_mb; $bottom_mb)
			
			$offset:=4
			$offset_r:=60
			$offset_btns_r:=15
			$offset_bAc:=10
			
			$width_mt:=$right_mt-$left_mt
			$width_mu:=$right_mu-$left_mu
			$width_md:=$right_md-$left_md
			$width_mb:=$right_mb-$left_mb
			
			OBJECT SET COORDINATES:C1248(*; "lb_selectedSteps"; $left_lb; $top_lb; $widthSubform-$offset_r; $heightSubform)
			OBJECT SET COORDINATES:C1248(*; "btnMoveTop"; $widthSubform-$offset_btns_r-$width_mt; $top_mt; $widthSubform-$offset_btns_r; $bottom_mt)
			OBJECT SET COORDINATES:C1248(*; "btnMoveUp"; $widthSubform-$offset_btns_r-$width_mu; $top_mu; $widthSubform-$offset_btns_r; $bottom_mu)
			OBJECT SET COORDINATES:C1248(*; "btnMoveDown"; $widthSubform-$offset_btns_r-$width_md; $top_md; $widthSubform-$offset_btns_r; $bottom_md)
			OBJECT SET COORDINATES:C1248(*; "btnMoveBottom"; $widthSubform-$offset_btns_r-$width_mb; $top_mb; $widthSubform-$offset_btns_r; $bottom_mb)
			
	End case 
	
	
	This:C1470.drawPup_customer()
	This:C1470.loadSteps()
	This:C1470.drawPup_process()
	OBJECT SET ENABLED:C1123(*; "pup_process"; Form:C1466.sfw.checkIsInModification())
	
	
	
Function manageReOrderBtns()
	
	OBJECT SET VISIBLE:C603(*; "btnMoveTop"; Form:C1466.sfw.checkIsInModification())
	OBJECT SET VISIBLE:C603(*; "btnMoveUp"; Form:C1466.sfw.checkIsInModification())
	OBJECT SET VISIBLE:C603(*; "btnMoveDown"; Form:C1466.sfw.checkIsInModification())
	OBJECT SET VISIBLE:C603(*; "btnMoveBottom"; Form:C1466.sfw.checkIsInModification())
	
	OBJECT SET ENABLED:C1123(*; "btnMoveTop"; (Form:C1466.step#Null:C1517))
	OBJECT SET ENABLED:C1123(*; "btnMoveUp"; (Form:C1466.step#Null:C1517))
	OBJECT SET ENABLED:C1123(*; "btnMoveDown"; (Form:C1466.step#Null:C1517))
	OBJECT SET ENABLED:C1123(*; "btnMoveBottom"; (Form:C1466.step#Null:C1517))
	
	If (Form:C1466.sfw.checkIsInModification() & (Form:C1466.step#Null:C1517))
		Case of 
			: (Form:C1466.stepPos=1)
				OBJECT SET ENABLED:C1123(*; "btnMoveTop"; False:C215)
				OBJECT SET ENABLED:C1123(*; "btnMoveUp"; False:C215)
				
			: (Form:C1466.stepPos=Form:C1466.selectedSteps.length)
				OBJECT SET ENABLED:C1123(*; "btnMoveBottom"; False:C215)
				OBJECT SET ENABLED:C1123(*; "btnMoveDown"; False:C215)
		End case 
	End if 
	
	
	
	
Function btnReOrderSteps($from : Integer; $to : Integer)
	
	If (Form:C1466.step#Null:C1517)
		$coef:=1
		
		If (($to-$from)>0)
			$coef:=-1
		End if 
		
		If ($coef>0)
			$stepsToReOrder:=Form:C1466.selectedSteps.query("order >= :1 AND order < :2"; Choose:C955(($from>$to); $to; $from); Choose:C955(($from>$to); $from; $to))
		Else 
			$stepsToReOrder:=Form:C1466.selectedSteps.query("order > :1 AND order <= :2"; Choose:C955(($from>$to); $to; $from); Choose:C955(($from>$to); $from; $to))
		End if 
		
		For each ($step; $stepsToReOrder)
			$step.order:=$step.order+$coef
			
		End for each 
		
		Form:C1466.step.order:=$to
		Form:C1466.selectedSteps:=Form:C1466.selectedSteps.orderBy("order")
		$selectedsteps:=Form:C1466.selectedSteps.extract("step.UUID")
		$i:=0
		$collection:=New collection:C1472()
		For each ($step; $selectedsteps)
			$i+=1
			$collection.push(New object:C1471("order"; $i; "UUID"; $step))
		End for each 
		
		Form:C1466.current_item.moreData.selectedSteps:=$collection
		
		This:C1470.loadSelectedSteps()
		
		Form:C1466.step:=Form:C1466.selectedSteps.query("order = :1"; $to).first()
		LISTBOX SELECT ROW:C912(*; "lb_selectedSteps"; $to)
		This:C1470.manageReOrderBtns()
	End if 
	
Function bAction_deleteStep()
	
	$refMenus:=New collection:C1472
	$mainMenu:=Create menu:C408
	$refMenus.push($mainMenu)
	
	APPEND MENU ITEM:C411($mainMenu; "Drop Step"; *)
	SET MENU ITEM PARAMETER:C1004($mainMenu; -1; "--drop")
	If (Not:C34(Form:C1466.sfw.checkIsInModification())) || (Form:C1466.step=Null:C1517)
		DISABLE MENU ITEM:C150($mainMenu; -1)
	End if 
	
	$choose:=Dynamic pop up menu:C1006($mainMenu)
	RELEASE MENU:C978($mainMenu)
	
	Case of 
		: ($choose="")
		: ($choose="--drop")
			
			$object:=Form:C1466.current_item.moreData.selectedSteps.query("UUID = :1"; Form:C1466.step.step.UUID).first()
			
			$index:=Form:C1466.current_item.moreData.selectedSteps.indexOf($object)
			Form:C1466.current_item.moreData.selectedSteps.remove($index)
			
			$i:=0
			For each ($step; Form:C1466.current_item.moreData.selectedSteps)
				$i+=1
				$step.order:=$i
			End for each 
			
			
	End case 
	
	This:C1470.loadSelectedSteps()
	
	