singleton Class constructor
	// It's a singleton class
	
Function _activate_save_cancel_button()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	
Function formMethod()
	// Minimal independent panel lifecycle for SFW pages/tabs.
	Form:C1466.sfw.panelFormMethod()
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())
		Case of 
			: (FORM Get current page:C276(*)=2)
				This:C1470.loadMaterials()
		End case 
	End if 
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())
		This:C1470.redrawAndSetVisible()
	End if 
	
Function redrawAndSetVisible()
	OBJECT SET VISIBLE:C603(*; "dp_@"; Form:C1466.sfw.checkIsInModification())
	
	OBJECT SET ENTERABLE:C238(*; "field_lotNumber"; False:C215)
	OBJECT SET ENTERABLE:C238(*; "field_jobNumber"; False:C215)
	OBJECT SET ENTERABLE:C238(*; "field_dateIn"; False:C215)
	OBJECT SET ENTERABLE:C238(*; "field_packageType"; Form:C1466.sfw.checkIsInModification())
	OBJECT SET ENABLED:C1123(*; "field_packageType"; Form:C1466.sfw.checkIsInModification())
	OBJECT SET ENTERABLE:C238(*; "pup_customer"; Form:C1466.sfw.checkIsInModification())
	
	Form:C1466.sfw.drawHTab()
	This:C1470.drawPup_customer()
	
	Case of 
		: (FORM Get current page:C276(*)=2)
			OBJECT GET SUBFORM CONTAINER SIZE:C1148($widthSubform; $heightSubform)
			OBJECT GET COORDINATES:C663(*; "rec_bkgd_2"; $left; $top; $right; $bottom)
			OBJECT GET COORDINATES:C663(*; "lb_materials"; $left_lb; $top_lb; $right_lb; $bottom_lb)
			OBJECT GET COORDINATES:C663(*; "bActionCustProvMat"; $left_bAc; $top_bAc; $right_bAc; $bottom_bAc)
			
			$offset:=4
			$offset_r:=5
			$offset_bAc:=10
			$height_bAc:=$bottom_bAc-$top_bAc
			
			OBJECT SET COORDINATES:C1248(*; "rec_bkgd_2"; $left; $top; $right; $heightSubform-$offset)
			OBJECT SET COORDINATES:C1248(*; "lb_materials"; $left_lb; $top_lb; $widthSubform; $heightSubform)
			OBJECT SET COORDINATES:C1248(*; "bActionCustProvMat"; $left_bAc; $heightSubform-$offset_bAc-$height_bAc; $right_bAc; $heightSubform-$offset_bAc)
	End case 
	
Function selectCustomer()
	var $job : cs:C1710.JobEntity
	var $form : Object
	
	If (Form:C1466.sfw.checkIsInModification())
		$job:=Form:C1466.current_item.job
		If ($job=Null:C1517)
			$job:=ds:C1482.Job.get(Form:C1466.current_item.UUID_Job)
		End if 
		
		If ($job#Null:C1517)
			$form:=New object:C1471()
			$form.lb_items:=ds:C1482.Customer.all().orderBy("name")
			$form.words:=""
			
			OBJECT GET COORDINATES:C663(*; "pup_customer"; $l; $t; $r; $b)
			CONVERT COORDINATES:C1365($l; $b; XY Current form:K27:5; XY Main window:K27:8)
			
			$winRef:=Open form window:C675("selectCustomer"; Pop up form window:K39:11; $l; $b+1)
			DIALOG:C40("selectCustomer"; $form)
			CLOSE WINDOW:C154($winRef)
			
			If (OK=1) && ($form.item#Null:C1517)
				$job.UUID_Customer:=$form.item.UUID
				$job.customerName:=$form.item.name
				
				$res:=$job.save()
				If ($res.success)
					This:C1470._activate_save_cancel_button()
					This:C1470.drawPup_customer()
				End if 
			End if 
		End if 
	End if 
	
Function drawPup_customer()
	var $customerName : Text
	var $disabled : Boolean
	
	$customerName:=""
	$disabled:=True:C214
	If (Form:C1466.current_item#Null:C1517)
		If (Form:C1466.current_item.job#Null:C1517)
			$customerName:=Form:C1466.current_item.job.customer.name || " "
			$disabled:=(Form:C1466.current_item.job.customer=Null:C1517)
		End if 
	End if 
	Form:C1466.sfw.drawButtonPup("pup_customer"; $customerName; "sfw/image/skin/rainbow/icon/spacer-1x24.png"; $disabled)
	
Function bActionCustProvMat()
	$refMenu:=Create menu:C408
	
	APPEND MENU ITEM:C411($refMenu; "Receive Material")
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--receive_material")
	
	If (Not:C34(Form:C1466.sfw.checkIsInModification()))
		DISABLE MENU ITEM:C150($refMenu; -1)
	End if 
	
	
	$choose:=Dynamic pop up menu:C1006($refMenu)
	
	Case of 
		: ($choose="--receive_material")
			$form:=New object:C1471(\
				"inventory_e"; ds:C1482.Inventory.new()\
				)
			
			$form.inventory_e.UUID_Lot:=Form:C1466.current_item.UUID
			$form.inventory_e.vendor:=Form:C1466.current_item.job.customerName
			$form.inventory_e.stockNum:="man_"+String:C10(ds:C1482.Inventory.all().length)+String:C10(Milliseconds:C459)
			$form.inventory_e.inventoryID:=(ds:C1482.Inventory.all().length>0) ? ds:C1482.Inventory.all().max("inventoryID")+1 : 1
			$form.inventory_e.code:="INV"+String:C10($form.inventory_e.inventoryID; "00000#")
			
			$winRef:=Open form window:C675("createManualInv_lot"; Controller form window:K39:17; Horizontally centered:K39:1; Vertically centered:K39:4)
			DIALOG:C40("createManualInv_lot"; $form)
			CLOSE WINDOW:C154($winRef)
			
			If (ok=1)
				$form.inventory_e.initialQty:=$form.inventory_e.qtyInStock
				$form.inventory_e.availableQty:=$form.inventory_e.qtyInStock
				
				$res:=$form.inventory_e.save()
				
				If ($res.success)
					This:C1470.loadMaterials()
					$form.inventory_e.afterCreation()
					This:C1470._activate_save_cancel_button()
				End if 
			End if 
			
			
	End case 
	
Function loadMaterials()
	Form:C1466.lb_materials:=ds:C1482.Inventory.query("UUID_Lot = :1"; Form:C1466.current_item.UUID)
	