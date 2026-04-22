singleton Class constructor
	//It's a singleton class
	
Function _activate_save_cancel_button()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	
Function formMethod()
	//This function manages the main logic for updating and refreshing the form
	Form:C1466.sfw.panelFormMethod()  //The main body of the form method and basic sfw functionalities 
	If (Form:C1466.sfw.updateOfPanelNeeded())  //The current item is changed or reloaded, so it's necessary ti refresh 
		This:C1470.LoadAllTabs()
	End if 
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())  //a page is displayed so it's time to load the sources of data to display
		Case of 
			: (FORM Get current page:C276(*)=1)
				// add load functions
				
			: (FORM Get current page:C276(*)=3)
				This:C1470.loadTerms()
		End case 
	End if 
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())  //It's time to resize the object or set visible
		This:C1470.redrawAndSetVisible()
	End if 
	
	
Function redrawAndSetVisible()
	//Adjusts the layout and visibility of form elements based on the current page and modification state
	Use (Form:C1466.sfw.entry.panel.pages)
		Form:C1466.sfw.entry.panel.pages[1].label:="BO Line Items ("+String:C10(Form:C1466.lb_boLines.length)+")"
	End use 
	
	
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($widthSubform; $heightSubform)
	$offset:=2
	Case of 
			
		: (FORM Get current page:C276(*)=2)
			OBJECT GET COORDINATES:C663(*; "lb_boLines"; $left_lb; $top_lb; $right_lb; $bottom_lb)
			OBJECT SET COORDINATES:C1248(*; "lb_boLines"; $left_lb; $top_lb; $widthSubform-$offset; $heightSubform-$offset)
			
			
	End case 
	
	This:C1470.drawPup_supplier()
	
	Form:C1466.sfw.drawHTab()
	
	
Function LoadAllTabs()
	This:C1470.loadLineItems()
	
Function loadLineItems()
	Form:C1466.lb_boLines:=ds:C1482.BuyingOrderLine.query("UUID_BuyingOrder = :1"; Form:C1466.current_item.UUID)
	
	
Function bActionTerms()
	
	
Function loadTerms()
	Form:C1466.lb_terms:=New collection:C1472(\
		New object:C1471("type"; "terms"; "name"; "Terms"); \
		New object:C1471("type"; "termsCriticalMaterials"; "name"; "Critical Materials"); \
		New object:C1471("type"; "termsCriticalService"; "name"; "Critical Service")\
		)
	
	
Function drawPup_supplier()
	If (Form:C1466.current_item#Null:C1517)
		//$supplier:=ds.Supplier.query("UUID= :1"; Form.current_item.UUID_Supplier).first() || New object()
		$supplier:=Form:C1466.current_item.supplier
		If ($supplier#Null:C1517)
			$supplierName:=$supplier.name
			If ($supplierName=Null:C1517)
				$supplierName:=""
			End if 
		Else 
			$supplierName:=""
		End if 
		
		$color:=""
		$pathIcon:=""
		Form:C1466.sfw.drawButtonPup("pup_supplier"; $supplierName; $pathIcon; ($supplier=Null:C1517))
		
	End if 
	
Function pup_supplier()
	//Create pop up menu
	
	If (Form:C1466.sfw.checkIsInModification())
		
		OBJECT GET COORDINATES:C663(*; "pup_supplier"; $l; $t; $r; $b)
		CONVERT COORDINATES:C1365($l; $b; XY Current form:K27:5; XY Main window:K27:8)
		
		$form:=New object:C1471(\
			"colName"; "name"; \
			"allData"; ds:C1482.Supplier.all(); \
			"dataclass"; "Supplier"\
			)
		
		$winRef:=Open form window:C675("selectNto1"; Pop up form window:K39:11; $l; $b)
		DIALOG:C40("selectNto1"; $form)
		CLOSE WINDOW:C154($winRef)
		
		If (ok=1)
			Form:C1466.current_item.UUID_Supplier:=$form.item.UUID
			cs:C1710.panel_buyingOrder.me._activate_save_cancel_button()
		End if 
	End if 
	
	This:C1470.drawPup_supplier()
	
	
	
Function bActionBuyItems()
	
	$refMenu:=Create menu:C408
	
	APPEND MENU ITEM:C411($refMenu; "add an Item"; *)
	SET MENU ITEM PARAMETER:C1004($refMenu; 1; "--add")
	If (sfw_checkIsInModification=False:C215)
		DISABLE MENU ITEM:C150($refMenu; 1)
	End if 
	
	APPEND MENU ITEM:C411($refMenu; "modify an Itenm"; *)
	SET MENU ITEM PARAMETER:C1004($refMenu; 2; "--modify")
	If (sfw_checkIsInModification=False:C215) | (Form:C1466.selectedBoLine=Null:C1517) | Undefined:C82(Form:C1466.selectedBoLine)
		DISABLE MENU ITEM:C150($refMenu; 2)
	End if 
	
	APPEND MENU ITEM:C411($refMenu; "delete an Item"; *)
	SET MENU ITEM PARAMETER:C1004($refMenu; 3; "--delete")
	If (sfw_checkIsInModification=False:C215) | (Form:C1466.selectedBoLine=Null:C1517) | Undefined:C82(Form:C1466.selectedBoLine)
		DISABLE MENU ITEM:C150($refMenu; 3)
	End if 
	
	$choice:=Dynamic pop up menu:C1006($refMenu)
	RELEASE MENU:C978($refMenu)
	Case of 
			
		: ($choice="--add")
			
			START TRANSACTION:C239
			$buyItem:=ds:C1482.BuyingOrderLine.new()
			$buyItem.UUID_BuyingOrder:=Form:C1466.current_item.UUID
			$buyItem.boNumber:=Form:C1466.current_item.boNumber
			$buyItem.orderDate:=Current date:C33(*)
			
			$form:=New object:C1471("details"; $buyItem)
			
			//$form.approverProfile:=New collection("qs"; "qm")  // only QC Team allowed to modify
			//$form.displayApprovalFields:=False
			
			$winRef:=Open form window:C675("_ga_buyingOrderLine"; Movable dialog box:K34:7; Horizontally centered:K39:1; Vertically centered:K39:4)
			SET WINDOW TITLE:C213("Add Buying Item"; $winRef)
			DIALOG:C40("_ga_buyingOrderLine"; $form)
			
			If (OK=1)
				//Form.lb_documents.push($form.details)
				
				//$buffer:=New object()
				//$buffer.event:="addDocument"
				//$buffer.label:="Document "+$form.details.sourcePath+" added"
				//$buffer.stmp:=cs.sfw_stmp.me.now()
				//Form.bufferOfEvents.push($buffer)
				
				$buyItem:=$form.details
				
				$res:=$buyItem.save()
				
				If ($res.success)
					
					VALIDATE TRANSACTION:C240
					
					This:C1470.loadLineItems()
					This:C1470._activate_save_cancel_button()
				Else 
					CANCEL TRANSACTION:C241
				End if 
			Else 
				CANCEL TRANSACTION:C241
				
			End if 
			
			
		: ($choice="--modify")
			
			START TRANSACTION:C239
			$buyItem:=ds:C1482.BuyingOrderLine.query("UUID = :1"; Form:C1466.lb_boLines[Form:C1466.selectedBoLinePos-1].UUID).first()
			
			$form:=New object:C1471("details"; $buyItem)
			
			//$form.approverProfile:=New collection("qs"; "qm")  // only QC Team allowed to modify 
			//$form.displayApprovalFields:=False
			
			$winRef:=Open form window:C675("_ga_buyingOrderLine"; Movable dialog box:K34:7; Horizontally centered:K39:1; Vertically centered:K39:4)
			SET WINDOW TITLE:C213("Modify Buying Item"; $winRef)
			DIALOG:C40("_ga_buyingOrderLine"; $form)
			
			If (OK=1)
				
				$buyItem:=$form.details
				
				$res:=$buyItem.save()
				
				If ($res.success)
					
					VALIDATE TRANSACTION:C240
					
					This:C1470.loadLineItems()
					This:C1470._activate_save_cancel_button()
				Else 
					CANCEL TRANSACTION:C241
				End if 
			Else 
				
				CANCEL TRANSACTION:C241
			End if 
			
		: ($choice="--delete")
			
			$ok:=cs:C1710.sfw_dialog.me.confirm("Do you really want to delete this Item? "; "Delete"; "CANCEL")
			If ($ok)
				
				
				//$buffer:=New object()
				//$buffer.event:="deleteDocument"
				//$buffer.label:="Document "+Form.current_item.RatingData.items[Form.selectedRatingItemPos-1].sourcePath+" deleted"
				//$buffer.stmp:=cs.sfw_stmp.me.now()
				//Form.bufferOfEvents.push($buffer)
				
				START TRANSACTION:C239
				$buyItem:=ds:C1482.BuyingOrderLine.query("UUID = :1"; Form:C1466.lb_boLines[Form:C1466.selectedBoLinePos-1].UUID).first()
				
				$res:=$buyItem.drop()
				
				If ($res.success)
					
					VALIDATE TRANSACTION:C240
					
					This:C1470.loadLineItems()
					This:C1470._activate_save_cancel_button()
				Else 
					CANCEL TRANSACTION:C241
				End if 
				
			End if 
			
			
	End case 
	
	