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
				OBJECT SET TITLE:C194(*; "pupFilter_status"; "All Status")
				This:C1470.loadPoLineItems()
				
			: (FORM Get current page:C276(*)=3)  //PO -> jobs
				OBJECT SET TITLE:C194(*; "pupFilter_jobs"; "All Status")
				This:C1470.loadPoJobs()
				
			: (FORM Get current page:C276(*)=4)  //PO -> Lots
				This:C1470.loadLots()
				
			: (FORM Get current page:C276(*)=5)  //PO -> Invoices
				This:C1470.loadInvoices()
		End case 
	End if 
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())  //It's time to resize the object or set visible
		This:C1470.redrawAndSetVisible()
	End if 
	
	
Function drawPup_XXX()
	//This function updates the dropdown by displaying the name
	//Form.sfw.drawButtonPup("pup_xxx"; $xxxName; "xxxx.png"; (Form.current_item.xxxx=Null))
	
	
Function pup_lineItemsStatus()
	//Create pop up menu
	$refMenu:=Create menu:C408
	APPEND MENU ITEM:C411($refMenu; "All status")
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--all")
	APPEND MENU ITEM:C411($refMenu; "-")
	APPEND MENU ITEM:C411($refMenu; "Unreleased")
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--unreleased")
	APPEND MENU ITEM:C411($refMenu; "Closed")
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--closed")
	
	$choose:=Dynamic pop up menu:C1006($refMenu)
	
	Case of 
		: ($choose="--all")
			$title:="All Status"
			Form:C1466.lb_lineItems:=Form:C1466.current_item.lineItems
			
		: ($choose="--unreleased")
			$title:="Status: Unreleased"
			Form:C1466.lb_lineItems:=Form:C1466.current_item.lineItems.query("unreleased = :1"; True:C214)
			
		: ($choose="--closed")
			$title:="Status: Closed"
			Form:C1466.lb_lineItems:=Form:C1466.current_item.lineItems.query("closed = :1"; True:C214)
		Else 
			$title:="All Status"
			Form:C1466.lb_lineItems:=Form:C1466.current_item.lineItems
	End case 
	
	OBJECT SET TITLE:C194(*; FORM Event:C1606.objectName; $title)
	
Function pup_jobsStatus()
	ALERT:C41("TODO: Add filters !")
	
Function redrawAndSetVisible()
	//Adjusts the layout and visibility of form elements based on the current page and modification state
	
Function loadDpAddress()
	Form:C1466.dpAddress:=New object:C1471(\
		"values"; New collection:C1472("billing"; "shipping"); \
		"index"; 0; \
		"currentValue"; "Billing Address"\
		)
	
Function loadPoLineItems()
	Form:C1466.lb_lineItems:=Form:C1466.current_item.lineItems
	
Function loadPoJobs()
	Form:C1466.lb_jobs:=Form:C1466.current_item.lineItems.job
	
Function loadLots()
	Form:C1466.lb_lots:=Form:C1466.current_item.lineItems.job.lots
	
Function loadInvoices()
	Form:C1466.lb_invoices:=Form:C1466.current_item.invoices
	
Function bActionLineItems()
	//Manages actions: add, or remove, using dynamic menus and modification checks
	If (Form:C1466.sfw.checkIsInModification())
		$refMenu:=Create menu:C408
		APPEND MENU ITEM:C411($refMenu; "Create Line Item")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--create")
		APPEND MENU ITEM:C411($refMenu; "Edit Line Item")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--edit")
		APPEND MENU ITEM:C411($refMenu; "-")
		APPEND MENU ITEM:C411($refMenu; "Delete")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--delete")
		
		$choose:=Dynamic pop up menu:C1006($refMenu)
		
		Case of 
			: ($choose="--create")
				$lineItem:=ds:C1482.PurchaseOrderLine.new()
				
				$lineItem.UUID_PurchaseOrder:=Form:C1466.current_item.UUID
				If (Form:C1466.lb_lineItems.length>0)
					$lineItem.itemNum:=Form:C1466.lb_lineItems.max("itemNum")+1
				Else 
					$lineItem.itemNum:=1
				End if 
				
				$form:=New object:C1471("poLine"; $lineItem)
				
				$winRef:=Open form window:C675("createPoLine"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4)
				DIALOG:C40("createPoLine"; $form)
				CLOSE WINDOW:C154($winRef)
				
				If (OK=1)
					$lineItem:=$form.poLine
					
					$res:=$lineItem.save()
					
					If ($res.success)
						Form:C1466.lb_lineItems:=ds:C1482.PurchaseOrderLine.query("UUID_PurchaseOrder = :1"; Form:C1466.current_item.UUID)
						Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
					End if 
				End if 
				
			: ($choose="--edit")
				$form:=New object:C1471("poLine"; Form:C1466.selectedPoLine)
				
				$winRef:=Open form window:C675("createPoLine"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4)
				DIALOG:C40("createPoLine"; $form)
				CLOSE WINDOW:C154($winRef)
				
				If (OK=1)
					$lineItem:=$form.poLine
					
					$res:=$lineItem.save()
					
					If ($res.success)
						Form:C1466.lb_lineItems:=ds:C1482.PurchaseOrderLine.query("UUID_PurchaseOrder = :1"; Form:C1466.current_item.UUID)
						Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
					End if 
				End if 
				
			: ($choose="--delete")
				If (Form:C1466.selectedPoLine#Null:C1517)
					CONFIRM:C162("Are you sure ?")
					If (OK=1)
						$res:=Form:C1466.selectedPoLine.drop()
						
						If (Not:C34($res.success))
							ALERT:C41("Something wen wrong !!")
						Else 
							Form:C1466.lb_lineItems:=ds:C1482.PurchaseOrderLine.query("UUID_PurchaseOrder = :1"; Form:C1466.current_item.UUID)
						End if 
					End if 
				Else 
					ALERT:C41("Select a PO line item !")
				End if 
		End case 
	Else 
		$refMenu:=Create menu:C408
		APPEND MENU ITEM:C411($refMenu; "(Create Line Item")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--create")
		APPEND MENU ITEM:C411($refMenu; "(Edit Line Item")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--edit")
		APPEND MENU ITEM:C411($refMenu; "-")
		APPEND MENU ITEM:C411($refMenu; "(Delete")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--delete")
		
		$choose:=Dynamic pop up menu:C1006($refMenu)
		
		Case of 
			: ($choose="--all")
				$title:="All Status"
				Form:C1466.lb_lineItems:=Form:C1466.current_item.lineItems
				
			: ($choose="--unreleased")
				$title:="Status: Unreleased"
				Form:C1466.lb_lineItems:=Form:C1466.current_item.lineItems.query("unreleased = :1"; True:C214)
				
			: ($choose="--closed")
				$title:="Status: Closed"
				Form:C1466.lb_lineItems:=Form:C1466.current_item.lineItems.query("closed = :1"; True:C214)
		End case 
	End if 
	
	
Function bActionInvoices()
	//Manages actions: add, or remove, using dynamic menus and modification checks
	If (Form:C1466.sfw.checkIsInModification())
		$refMenu:=Create menu:C408
		APPEND MENU ITEM:C411($refMenu; "Create new Invoice")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--create")
		APPEND MENU ITEM:C411($refMenu; "-")
		APPEND MENU ITEM:C411($refMenu; "(Delete")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--delete")
		
		$choose:=Dynamic pop up menu:C1006($refMenu)
		
		Case of 
			: ($choose="--create")
				$invoice:=ds:C1482.Invoice.new()
				
				$invoice.UUID_PurchaseOrder:=Form:C1466.current_item.UUID
				
				$form:=New object:C1471("invoice"; $invoice)
				
				$winRef:=Open form window:C675("createInvoice_po"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4)
				DIALOG:C40("createInvoice_po"; $form)
				CLOSE WINDOW:C154($winRef)
				
				If (OK=1)
					$invoice:=$form.invoice
					
					$res:=$invoice.save()
					
					If ($res.success)
						Form:C1466.lb_invoices:=ds:C1482.Invoice.query("UUID_PurchaseOrder = :1"; Form:C1466.current_item.UUID)
					End if 
				End if 
				
			: ($choose="--delete")
				
		End case 
	Else 
		$refMenu:=Create menu:C408
		APPEND MENU ITEM:C411($refMenu; "(Create new Invoice")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--create")
		APPEND MENU ITEM:C411($refMenu; "-")
		APPEND MENU ITEM:C411($refMenu; "(Delete")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--delete")
		
		$choose:=Dynamic pop up menu:C1006($refMenu)
		
		Case of 
			: ($choose="--all")
				$title:="All Status"
				Form:C1466.lb_lineItems:=Form:C1466.current_item.lineItems
				
			: ($choose="--unreleased")
				$title:="Status: Unreleased"
				Form:C1466.lb_lineItems:=Form:C1466.current_item.lineItems.query("unreleased = :1"; True:C214)
				
			: ($choose="--closed")
				$title:="Status: Closed"
				Form:C1466.lb_lineItems:=Form:C1466.current_item.lineItems.query("closed = :1"; True:C214)
		End case 
	End if 
	
	