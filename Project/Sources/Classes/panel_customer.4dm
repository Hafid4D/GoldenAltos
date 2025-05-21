singleton Class constructor
	//It's a singleton class
	
Function formMethod()
	//This function manages the main logic for updating and refreshing the form
	Form:C1466.sfw.panelFormMethod()  //The main body of the form method and basic sfw functionalities 
	If (Form:C1466.sfw.updateOfPanelNeeded())  //The current item is changed or reloaded, so it's necessary ti refresh 
		Form:C1466.addressBilling:=1
		Form:C1466.addressShipping:=0
		This:C1470.loadAllTabs()
		This:C1470.LoadApContact()
		This:C1470.LoadStatusContact()
	End if 
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())  //a page is displayed so it's time to load the sources of data to display
		Case of 
			: (FORM Get current page:C276(*)=1)
				// add load functions
				This:C1470.LoadApContact()
				This:C1470.LoadStatusContact()
				
				
			: (FORM Get current page:C276(*)=2)
				This:C1470.loadPOs()
				
			: (FORM Get current page:C276(*)=3)
				This:C1470.loadJobs()
				
			: (FORM Get current page:C276(*)=4)
				This:C1470.loadPlannings()
				
			: (FORM Get current page:C276(*)=5)
				This:C1470.loadCFMReceiving()
				
			: (FORM Get current page:C276(*)=6)
				This:C1470.loadInvoices()
				
		End case 
	End if 
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())  //It's time to resize the object or set visible
		This:C1470.redrawAndSetVisible()
	End if 
	
	
Function drawPup_XXX()
	//This function updates the dropdown by displaying the name
	Form:C1466.sfw.drawButtonPup("pup_xxx"; $xxxName; "xxxx.png"; (Form:C1466.current_item.xxxx=Null:C1517))
	
	
Function drawPup_CustomerStatus()
	If (Form:C1466.current_item#Null:C1517)
		$customerStatus:=ds:C1482.CustomerStatus.query("statusID= :1"; Form:C1466.current_item.IDT_status).first() || New object:C1471()
		$statusName:=$customerStatus.name
		If ($statusName=Null:C1517)
			$statusName:=""
		End if 
		$color:=cs:C1710.sfw_htmlColor.me.getName($customerStatus.color)
		$pathIcon:=($color#"") ? "sfw/colors/"+$color+"-circle.png" : "sfw/image/skin/rainbow/icon/spacer-1x24.png"
		Form:C1466.sfw.drawButtonPup("pup_customerStatus"; $statusName; $pathIcon; ($customerStatus=Null:C1517))
	End if 
	
	
Function pup_status()
	//Create pop up menu
	If (Form:C1466.sfw.checkIsInModification())
		$menu:=Create menu:C408
		If (Storage:C1525.cache=Null:C1517) || (Storage:C1525.cache.customerStatus=Null:C1517)
			ds:C1482.CustomerStatus.cacheLoad()
		End if 
		
		For each ($eCustomerStatus; Storage:C1525.cache.customerStatus)
			APPEND MENU ITEM:C411($menu; $eCustomerStatus.name; *)
			SET MENU ITEM PARAMETER:C1004($menu; -1; $eCustomerStatus.UUID)
			If ($eCustomerStatus.statusID=Form:C1466.current_item.IDT_status)
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
				$eCustomerStatus:=ds:C1482.CustomerStatus.get($choose)
				Form:C1466.current_item.IDT_status:=$eCustomerStatus.statusID
		End case 
		
	End if 
	This:C1470.drawPup_CustomerStatus()
	
	
Function drawPup_CustomerCarrier()
	If (Form:C1466.current_item#Null:C1517)
		$customerCarrier:=ds:C1482.CustomerCarrier.query("carrierID= :1"; Form:C1466.current_item.IDT_carrier).first() || New object:C1471()
		$carrierName:=$customerCarrier.name
		If ($carrierName=Null:C1517)
			$carrierName:=""
		End if 
		$color:=cs:C1710.sfw_htmlColor.me.getName($customerCarrier.color)
		$pathIcon:=($color#"") ? "sfw/colors/"+$color+"-circle.png" : "sfw/image/skin/rainbow/icon/spacer-1x24.png"
		Form:C1466.sfw.drawButtonPup("pup_customerCarrier"; $carrierName; $pathIcon; ($customerCarrier=Null:C1517))
	End if 
	
	
Function pup_carrier()
	//Create pop up menu
	If (Form:C1466.sfw.checkIsInModification())
		$menu:=Create menu:C408
		If (Storage:C1525.cache=Null:C1517) || (Storage:C1525.cache.customerCarriers=Null:C1517)
			ds:C1482.CustomerCarrier.cacheLoad()
		End if 
		
		For each ($eCustomerCarrier; Storage:C1525.cache.customerCarriers)
			APPEND MENU ITEM:C411($menu; $eCustomerCarrier.name; *)
			SET MENU ITEM PARAMETER:C1004($menu; -1; $eCustomerCarrier.UUID)
			If ($eCustomerCarrier.carrierID=Form:C1466.current_item.IDT_carrier)
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
				$eCustomerCarrier:=ds:C1482.CustomerCarrier.get($choose)
				Form:C1466.current_item.IDT_carrier:=$eCustomerCarrier.carrierID
		End case 
		
	End if 
	This:C1470.drawPup_CustomerCarrier()
	
	
Function redrawAndSetVisible()
	//Adjusts the layout and visibility of form elements based on the current page and modification state
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($widthSubform; $heightSubform)
	OBJECT GET COORDINATES:C663(*; "subFormAddress"; $g; $h; $d; $b)
	OBJECT SET COORDINATES:C1248(*; "subFormAddress"; $g; $h; $widthSubform-5; $b)
	This:C1470.contactDetails()
	//OBJECT SET VISIBLE(*; "bActionApContact"; Form.sfw.checkIsInModification())
	//OBJECT SET VISIBLE(*; "bActionStatusContact"; Form.sfw.checkIsInModification())
	This:C1470.drawPup_CustomerStatus()
	This:C1470.drawPup_CustomerCarrier()
	
	Use (Form:C1466.sfw.entry.panel.pages)
		Form:C1466.sfw.entry.panel.pages[1].label:="POs ("+String:C10(Form:C1466.lb_POs.length)+")"
		Form:C1466.sfw.entry.panel.pages[2].label:="Jobs ("+String:C10(Form:C1466.lb_Jobs.length)+")"
		Form:C1466.sfw.entry.panel.pages[3].label:="Planning ("+String:C10(Form:C1466.lb_Planning.length)+")"
		Form:C1466.sfw.entry.panel.pages[4].label:="CFM_Receiving ("+String:C10(Form:C1466.lb_CFM_Receiving.length)+")"
		Form:C1466.sfw.entry.panel.pages[5].label:="Invoices ("+String:C10(Form:C1466.lb_Invoices.length)+")"
	End use 
	Form:C1466.sfw.drawHTab()
	
	
Function contactDetails()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.subFormAddress:=New object:C1471()
		Form:C1466.subFormAddress.address:=Form:C1466.current_item.rebuildAddress()
		Form:C1466.subFormAddress.situation:=Form:C1466.situation
	End if 
	
	
Function loadXXX()
	//Loads and initializes a list
	
	
Function loadAllTabs()
	
	This:C1470.loadPOs()
	This:C1470.loadJobs()
	This:C1470.loadPlannings()
	This:C1470.loadCFMReceiving()
	This:C1470.loadInvoices()
	
	
Function LoadApContact()
	
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.lb_apContact:=New collection:C1472()
		If (Form:C1466.current_item.contacts.query("title=:1"; "AP").first()#Null:C1517)
			
			Form:C1466.lb_apContact:=Form:C1466.current_item.rebuidComunications("AP")
		End if 
	End if 
	
	
Function LoadStatusContact()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.lb_statusContact:=New collection:C1472()
		If (Form:C1466.current_item.contacts.query("title=:1"; "Status").first()#Null:C1517)
			
			Form:C1466.lb_statusContact:=Form:C1466.current_item.rebuidComunications("Status")
			
		End if 
	End if 
	
	
Function loadPOs()
	If (Form:C1466.current_item#Null:C1517)
		
		Form:C1466.lb_POs:=New collection:C1472()
		
		$PurchaseOrders:=ds:C1482.PurchaseOrder.query("UUID_Customer = :1"; Form:C1466.current_item.UUID).orderBy("poNumber")
		
		For ($i; 0; $PurchaseOrders.length-1)
			
			$POLines:=$PurchaseOrders[$i].lineItems
			
			$PO_item:=New object:C1471()
			$PO_item.division:=$PurchaseOrders[$i].division
			$PO_item.PO_date:=$PurchaseOrders[$i].log_date
			$PO_item.poNumber:=$PurchaseOrders[$i].poNumber
			$PO_item.identifier:=$PurchaseOrders[$i].identifier
			$PO_item.poAmount:=$PurchaseOrders[$i].poAmount
			$PO_item.amountBilled:=$PurchaseOrders[$i].amountBilled
			$PO_item.invoices:=$PurchaseOrders[$i].invoices.length
			
			Form:C1466.lb_POs.push($PO_item)
			
			
		End for 
		
	End if 
	
	
Function loadJobs()
	
	If (Form:C1466.current_item#Null:C1517)
		
		Form:C1466.lb_Jobs:=ds:C1482.Job.query("customer = :1"; Form:C1466.current_item.name).orderBy("dateCreated")
		
	End if 
	
	
Function loadPlannings()
	
	If (Form:C1466.current_item#Null:C1517)
		
		Form:C1466.lb_Planning:=New collection:C1472()
		
		$Plannings:=ds:C1482.Lot.query("customer = :1"; Form:C1466.current_item.name).orderBy("lotNumber")
		
		For ($i; 0; $Plannings.length-1)
			
			$Planning_item:=New object:C1471()
			$Planning_item.lotNumber:=$Plannings[$i].lotNumber
			$Planning_item.jobNumber:=$Plannings[$i].job.jobNumber
			$Planning_item.poNumber:=$Plannings[$i].poNumber
			$Planning_item.dateIn:=$Plannings[$i].dateIn
			$Planning_item.dateOut:=$Plannings[$i].dateOut
			$Planning_item.process:=$Plannings[$i].process
			$Planning_item.ourCount:=$Plannings[$i].ourCount
			
			Form:C1466.lb_Planning.push($Planning_item)
			
		End for 
		
	End if 
	
	
Function loadCFMReceiving()
	
	If (Form:C1466.current_item#Null:C1517)
		
		Form:C1466.lb_CFM_Receiving:=New collection:C1472()
		
		$Inventories:=ds:C1482.Inventory.query("vendor = :1"; Form:C1466.current_item.name)
		For ($i; 0; $Inventories.length-1)
			
			$CFM_Receiving_item:=New object:C1471()
			$CFM_Receiving_item.partNum:=$Inventories[$i].partNum
			$CFM_Receiving_item.stockNum:=$Inventories[$i].stockNum
			$CFM_Receiving_item.originalQty:=$Inventories[$i].originalQty
			$CFM_Receiving_item.availableQty:=$Inventories[$i].availableQty
			$CFM_Receiving_item.binLocation:=$Inventories[$i].binLocation
			$CFM_Receiving_item.description:=$Inventories[$i].description
			
			Form:C1466.lb_CFM_Receiving.push($CFM_Receiving_item)
			
		End for 
	End if 
	
	
Function loadInvoices()
	
	If (Form:C1466.current_item#Null:C1517)
		
		Form:C1466.lb_Invoices:=New collection:C1472()
		
		$invoices:=ds:C1482.Invoice.query("customerId = :1"; Form:C1466.current_item.code).orderBy("date")
		
		For ($i; 0; $invoices.length-1)
			
			$invoices_item:=New object:C1471()
			$invoices_item.date:=$invoices[$i].date
			$invoices_item.customerId:=$invoices[$i].customerId
			$invoices_item.total:=$invoices[$i].total
			$invoices_item.amountPaid:=$invoices[$i].amountPaid
			$invoices_item.due:=$invoices[$i].due
			$invoices_item.saleAmount:=$invoices[$i].saleAmount
			
			Form:C1466.lb_Invoices.push($invoices_item)
			
			
		End for 
		
	End if 
	
	
Function bActionXXX()
	//Manages actions: add, or remove, using dynamic menus and modification checks
	
Function bActionApContact()
	$refMenu:=Create menu:C408
	APPEND MENU ITEM:C411($refMenu; "Open in new window"; *)
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "openInWindow")
	If (Form:C1466.current_item.contacts.query("title=:1"; "AP").first()=Null:C1517)
		DISABLE MENU ITEM:C150($refMenu; -1)
	End if 
	
	$choice:=Dynamic pop up menu:C1006($refMenu)
	RELEASE MENU:C978($refMenu)
	Case of 
		: ($choice="openInWindow")
			Form:C1466.sfw.openInANewWindow(Form:C1466.current_item.contacts.query("title=:1"; "AP").first(); "customerService"; "contact")
	End case 
	This:C1470.LoadApContact()
	
Function bActionStatusContact()
	$refMenu:=Create menu:C408
	APPEND MENU ITEM:C411($refMenu; "Open in new window"; *)
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "openInWindow")
	If (Form:C1466.current_item.contacts.query("title=:1"; "AP").first()=Null:C1517)
		DISABLE MENU ITEM:C150($refMenu; -1)
	End if 
	
	$choice:=Dynamic pop up menu:C1006($refMenu)
	RELEASE MENU:C978($refMenu)
	Case of 
		: ($choice="openInWindow")
			Form:C1466.sfw.openInANewWindow(Form:C1466.current_item.contacts.query("title=:1"; "Status").first(); "customerService"; "contact")
	End case 
	This:C1470.LoadStatusContact()
	
	
Function loadDpAddress()
	Form:C1466.dpAddress:=New object:C1471(\
		"values"; New collection:C1472("billing"; "shipping"); \
		"index"; 0; \
		"currentValue"; "Billing Address"\
		)
	
	
Function _activate_save_cancel_button()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	
	