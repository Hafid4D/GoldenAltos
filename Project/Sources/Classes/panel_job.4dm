singleton Class constructor
	//It's a singleton class
	
Function _activate_save_cancel_button()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	
Function formMethod()
	//This function manages the main logic for updating and refreshing the form
	Form:C1466.sfw.panelFormMethod()  //The main body of the form method and basic sfw functionalities 
	If (Form:C1466.sfw.updateOfPanelNeeded())  //The current item is changed or reloaded, so it's necessary ti refresh
		Form:C1466.addressBilling:=1
		Form:C1466.addressShipping:=0
		
		This:C1470.loadAllTabs()
		
	End if 
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())  //a page is displayed so it's time to load the sources of data to display
		Case of 
			: (FORM Get current page:C276(*)=1)
				This:C1470.initAddresses()
				
			: (FORM Get current page:C276(*)=2)
				
			: (FORM Get current page:C276(*)=3)  //PO -> line items
				This:C1470.loadPoLineItems()
				
			: (FORM Get current page:C276(*)=4)  //PO -> line items
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
	This:C1470.hideDatePickers()
	This:C1470.drawPup_jobType()
	This:C1470.drawPup_PO()
	This:C1470.drawPup_Customer()
	
	OBJECT SET ENABLED:C1123(*; "entryField_jobNumber"; False:C215)
	OBJECT SET ENABLED:C1123(*; "entryField_jobNumber"; Form:C1466.situation.mode="add")
	OBJECT SET ENABLED:C1123(*; "entryField_jobNumber"; Form:C1466.situation.mode="add")
	
	//Adjusts the layout and visibility of form elements based on the current page and modification state
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($widthSubform; $heightSubform)
	Use (Form:C1466.sfw.entry.panel.pages)
		Form:C1466.sfw.entry.panel.pages[2].label:="PO Lines ("+String:C10(Form:C1466.lb_lineItems.length)+")"
		Form:C1466.sfw.entry.panel.pages[3].label:="Lots ("+String:C10(Form:C1466.lb_lots.length)+")"
	End use 
	
	OBJECT SET ENABLED:C1123(*; "pup_jobType"; Form:C1466.situation.mode="add")
	Form:C1466.sfw.drawHTab()
	
	
	Case of 
			
		: (FORM Get current page:C276(*)=1)
			
			OBJECT GET COORDINATES:C663(*; "header_bkgd9"; $left; $top; $right; $bottom)
			OBJECT GET COORDINATES:C663(*; "header_bkgd5"; $left_lb; $top_lb; $right_lb; $bottom_lb)
			OBJECT GET COORDINATES:C663(*; "header_bkgd6"; $left_bAc; $top_bAc; $right_bAc; $bottom_bAc)
			OBJECT GET COORDINATES:C663(*; "entryField_jobComment"; $left_l; $top_l; $right_l; $bottom_l)
			OBJECT GET COORDINATES:C663(*; "header_bkgd10"; $left_c; $top_c; $right_c; $bottom_c)
			
			$offset:=2
			
			OBJECT SET COORDINATES:C1248(*; "header_bkgd9"; $left; $top; $widthSubform-$offset; $bottom)
			OBJECT SET COORDINATES:C1248(*; "header_bkgd5"; $left_lb; $top_lb; $widthSubform-$offset; $bottom_lb)
			OBJECT SET COORDINATES:C1248(*; "header_bkgd6"; $left_bAc; $top_bAc; $widthSubform-$offset; $bottom_bAc)
			OBJECT SET COORDINATES:C1248(*; "entryField_jobComment"; $left_l; $top_l; $widthSubform-30; $heightSubform-10)
			OBJECT SET COORDINATES:C1248(*; "header_bkgd10"; $left_c; $top_c; $widthSubform-$offset; $heightSubform-$offset)
			
		: (FORM Get current page:C276(*)=2)
			
			OBJECT GET COORDINATES:C663(*; "subFormAddress"; $left_l; $top_l; $right_l; $bottom_l)
			OBJECT GET COORDINATES:C663(*; "header_bkgd3"; $left_c; $top_c; $right_c; $bottom_c)
			
			$offset:=2
			
			OBJECT SET COORDINATES:C1248(*; "subFormAddress"; $left_l; $top_l; $widthSubform-30; $heightSubform-10)
			OBJECT SET COORDINATES:C1248(*; "header_bkgd3"; $left_c; $top_c; $widthSubform-$offset; $heightSubform-$offset)
			
			
		: (FORM Get current page:C276(*)=3)  // po lines
			OBJECT GET COORDINATES:C663(*; "rec_bkgd_2"; $left; $top; $right; $bottom)
			OBJECT GET COORDINATES:C663(*; "lb_poLinesItems"; $left_lb; $top_lb; $right_lb; $bottom_lb)
			OBJECT GET COORDINATES:C663(*; "bActionLineItems"; $left_bAc; $top_bAc; $right_bAc; $bottom_bAc)
			
			$offset:=4
			$offset_bAc:=10
			
			$height_bAc:=$bottom_bAc-$top_bAc
			
			OBJECT SET COORDINATES:C1248(*; "rec_bkgd_2"; $left; $top; $right; $heightSubform-$offset)
			OBJECT SET COORDINATES:C1248(*; "lb_poLinesItems"; $left_lb; $top_lb; $widthSubform-$offset; $heightSubform-$offset-1)
			OBJECT SET COORDINATES:C1248(*; "bActionLineItems"; $left_bAc; $heightSubform-$offset_bAc-$height_bAc; $right_bAc; $heightSubform-$offset_bAc)
			
		: (FORM Get current page:C276(*)=4)  // lots
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
	
	If (Form:C1466.sfw.checkIsInModification())
		
		$authorizedProfile:=New collection:C1472("qs"; "qm")  // only QC Team allowed to modify  // only QC Team allowed to modify           
		
		$hasAuthorizedProfile:=cs:C1710.sfw_userManager.me.authorizedProfiles.find(Formula:C1597((Value type:C1509($1.value)=Is text:K8:3) && ($authorizedProfile.indexOf($1.value)#-1)))#Null:C1517
		
		OBJECT SET ENTERABLE:C238(*; "entryField_shipMemo"; $hasAuthorizedProfile)
		
		$authorizedProfile:=New collection:C1472("sr")  // only Shipping and Receiving Team allowed to modify 
		
		$hasAuthorizedProfile:=cs:C1710.sfw_userManager.me.authorizedProfiles.find(Formula:C1597((Value type:C1509($1.value)=Is text:K8:3) && ($authorizedProfile.indexOf($1.value)#-1)))#Null:C1517
		
		OBJECT SET ENTERABLE:C238(*; "entryField_jobComment"; $hasAuthorizedProfile)
		
	End if 
	
	
Function loadAllTabs()
	This:C1470.loadPoLineItems()
	This:C1470.loadLots()
	
	
Function initAddresses()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.subFormAddress:=New object:C1471()
		Form:C1466.subFormAddress.address:=Form:C1466.current_item.rebuildAddress()
		Form:C1466.subFormAddress.situation:=Form:C1466.situation
	End if 
	
	
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
		APPEND MENU ITEM:C411($refMenu; "(Delete")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--delete")
		
		APPEND MENU ITEM:C411($refMenu; "-")
		
		APPEND MENU ITEM:C411($refMenu; "Split Lot")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--split-lot")
		
		If (Form:C1466.selectedLot=Null:C1517)
			DISABLE MENU ITEM:C150($refMenu; -1)
		End if 
		
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
				
			: ($choose="--split-lot")
				$answer:=cs:C1710.sfw_dialog.me.request("Would you like to split the Lot into : ")
				If ($answer.ok) & ($answer.answer#"")
					$subLots:=Num:C11($answer.answer)
				End if 
				
				If ($subLots>0)
					If (Undefined:C82(Form:C1466.selectedLot.lotParent))
						
						$dataclassObject:=ds:C1482.Lot
						
						For ($i; 1; $subLots)
							$newLot:=ds:C1482.Lot.new()
							
							$id:=Form:C1466.selectedLot.subLots.length+$i
							
							$newLotNumber:=Form:C1466.selectedLot.lotNumber+"-"+String:C10($id)
							
							$lot_es:=ds:C1482.Lot.query("lotNumber = :1"; $newLotNumber)
							
							While ($lot_es.length>0)
								$id:=$id+1
								
								$newLotNumber:=(Form:C1466.selectedLot.lotNumber)+"-"+String:C10($id)
								
								$lot_es:=ds:C1482.Lot.query("lotNumber = :1"; $newLotNumber)
							End while 
							
							For each ($attributeName; $dataclassObject)
								$attribute:=$dataclassObject[$attributeName]
								
								If ($attribute.kind="storage")
									Case of 
										: ($attributeName="UUID") & ($attribute.type="string")
											$newLot[$attributeName]:=Generate UUID:C1066
										: ($attributeName="UUID_LotParent") & ($attribute.type="string")
											$newLot.UUID_LotParent:=Form:C1466.selectedLot.UUID
										: ($attributeName="lotNumber")
											$newLot.lotNumber:=$newLotNumber
										: ($attributeName="original")
											$newLot.original:=0
										: ($attributeName="ourCount")
											$newLot.ourCount:=0
										Else 
											$newLot[$attributeName]:=Form:C1466.selectedLot[$attributeName]
									End case 
								End if 
							End for each 
							
							$res:=$newLot.save()
							
							If ($res.success)
								//cs.panel_lot.me._activate_save_cancel_button()
								Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
							End if 
						End for 
						
						This:C1470.loadLots()
						
					Else 
						//Sub Lot
						ALERT:C41("sub lot")
					End if 
				End if 
				
		End case 
	Else 
		$refMenu:=Create menu:C408
		APPEND MENU ITEM:C411($refMenu; "(Attach a Lot")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--create")
		APPEND MENU ITEM:C411($refMenu; "(Delete")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--delete")
		APPEND MENU ITEM:C411($refMenu; "-")
		APPEND MENU ITEM:C411($refMenu; "Split Lot")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--split-lot")
		DISABLE MENU ITEM:C150($refMenu; -1)
		
		$choose:=Dynamic pop up menu:C1006($refMenu)
		
	End if 
	
Function btnOpenCustomer()
	$es:=ds:C1482.Customer.query("name = :1"; Form:C1466.current_item.customer.name)
	
	If ($es.length>0)
		Form:C1466.sfw.openInANewWindow($es[0]; "customerService"; "customer")
	End if 
	
Function btnOpenPurchaseOrder()
	$es:=ds:C1482.PurchaseOrder.query("poNumber = :1"; Form:C1466.current_item.purchaseOrder.poNumber)
	
	If ($es.length>0)
		Form:C1466.sfw.openInANewWindow($es[0]; "customerService"; "purchaseOrders")
	End if 
	
Function hideDatePickers()
	OBJECT SET VISIBLE:C603(*; "dp_@"; Form:C1466.sfw.checkIsInModification())
	
Function loadMaterials()
	Form:C1466.lb_materials:=ds:C1482.Inventory.query("UUID_Job = :1"; Form:C1466.current_item.UUID)
	
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
			
			$form.inventory_e.vendor:=Form:C1466.current_item.job.customerName
			$form.inventory_e.UUID_Job:=Form:C1466.current_item.UUID
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
	
Function drawPup_jobType()
	If (Form:C1466.current_item#Null:C1517)
		$jobType:=Form:C1466.current_item || New object:C1471()
		$typeName:=$jobType.lineItem=False:C215 ? "Job Order" : "NR Job Order"
		If ($typeName=Null:C1517)
			$typeName:=""
		End if 
		$color:=""  //cs.sfw_htmlColor.me.getName($jobType.color)
		$pathIcon:=($color#"") ? "sfw/colors/"+$color+"-circle.png" : "sfw/image/skin/rainbow/icon/spacer-1x24.png"
		Form:C1466.sfw.drawButtonPup("pup_jobType"; $typeName; $pathIcon; ($jobType=Null:C1517))
	End if 
	
Function pup_jobType()
	//Create pop up menu
	If (Form:C1466.sfw.checkIsInModification())
		$menu:=Create menu:C408
		$jobTypes:=New collection:C1472(New object:C1471("name"; "Job Order"; "lineItem"; False:C215); New object:C1471("name"; "NR Job Order"; "lineItem"; True:C214))
		For each ($eType; $jobTypes)
			APPEND MENU ITEM:C411($menu; $eType.name; *)
			SET MENU ITEM PARAMETER:C1004($menu; -1; $eType.name)
			If ($eType.name=Form:C1466.current_item.jobType)
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
				Form:C1466.current_item.lineItem:=$choose="Job Order" ? False:C215 : True:C214
		End case 
		
	End if 
	This:C1470.drawPup_jobType()
	
	
	
Function drawPup_PO()
	If (Form:C1466.current_item#Null:C1517)
		$poNumber:=String:C10(Form:C1466.current_item.purchaseOrder.poNumber) || " "
		Form:C1466.sfw.drawButtonPup("pup_purchaseOrder"; $poNumber; ""; (Form:C1466.current_item.purchaseOrder=Null:C1517))
	End if 
	//sfw/image/skin/rainbow/icon/spacer-1x24.png
	
Function selectPO()
	
	If (Form:C1466.sfw.checkIsInModification())
		
		$selector:=cs:C1710.sfw_definitionSelector.new("selectorPurchaseOrder"; "purchaseOrders")
		$selector.setTitle("Choose a Purchase Order")
		$selector.setCurrentItem(Form:C1466.current_item.purchaseOrder)
		$selector.setOptions("noCutLink")
		$selector.openSelector()
		
		Case of 
			: ($selector.isSelected())
				$itemSeleted:=$selector.getCurrentItem()
				
				Case of 
					: ($itemSeleted=Null:C1517)
					: (cs:C1710.sfw_string.me.isAnEmptyUUID($itemSeleted.UUID)=False:C215)
						Form:C1466.current_item.UUID_PurchaseOrder:=$itemSeleted.UUID
						If (cs:C1710.sfw_string.me.isAnEmptyUUID(Form:C1466.current_item.UUID_PurchaseOrder)=True:C214)
							Form:C1466.current_item.UUID_PurchaseOrder:=16*"00"
						End if 
				End case 
				This:C1470.drawPup_PO()
				
			: ($selector.asCutTheLink())
				Form:C1466.current_item.UUID_PurchaseOrder:=16*"00"
				
		End case 
	End if 
	
	
Function drawPup_Customer()
	If (Form:C1466.current_item#Null:C1517)
		$customerName:=String:C10(Form:C1466.current_item.customer.name) || " "
		Form:C1466.sfw.drawButtonPup("pup_customer"; $customerName; ""; (Form:C1466.current_item.customer=Null:C1517))
	End if 
	//sfw/image/skin/rainbow/icon/spacer-1x24.png
	
Function selectCustomer()
	
	If (Form:C1466.sfw.checkIsInModification())
		
		$selector:=cs:C1710.sfw_definitionSelector.new("selectorCustomer"; "customer")
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
				This:C1470.drawPup_Customer()
				
			: ($selector.asCutTheLink())
				Form:C1466.current_item.UUID_Customer:=16*"00"
				
		End case 
	End if 
	
	