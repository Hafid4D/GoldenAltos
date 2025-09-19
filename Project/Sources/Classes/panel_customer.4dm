singleton Class constructor
	
	// It's a singleton class
	
Function formMethod()
	
	// This function manages the main logic for updating and refreshing the form
	Form:C1466.sfw.panelFormMethod()  // The main body of the form method and basic sfw functionalities
	
	If (Form:C1466.sfw.updateOfPanelNeeded())  // The current item is changed or reloaded, so it's necessary ti refresh
		
		Form:C1466.addressBilling:=1
		Form:C1466.addressShipping:=0
		Form:C1466.apContact:=1
		Form:C1466.statusContact:=0
		This:C1470.LoadContact()
		This:C1470.loadAllTabs()
		
	End if 
	
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())  // a page is displayed so it's time to load the sources of data to display
		
		Case of 
				
				//________________________________________
			: (FORM Get current page:C276(*)=1)
				
				// add load functions
				This:C1470.LoadContact()
				
				//________________________________________
			: (FORM Get current page:C276(*)=2)
				
				This:C1470.loadPOs()
				
				//________________________________________
			: (FORM Get current page:C276(*)=3)
				
				This:C1470.loadJobs()
				
				//________________________________________
			: (FORM Get current page:C276(*)=4)
				
				This:C1470.loadPlannings()
				
				//________________________________________
			: (FORM Get current page:C276(*)=5)
				
				This:C1470.loadCFMReceiving()
				
				//________________________________________
			: (FORM Get current page:C276(*)=6)
				
				This:C1470.loadInvoices()
				
				//________________________________________
		End case 
	End if 
	
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())  // It's time to resize the object or set visible
		
		This:C1470.redrawAndSetVisible()
		
	End if 
	
Function redrawAndSetVisible()
	
	// Adjusts the layout and visibility of form elements based on the current page and modification state
	
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($widthSubform; $heightSubform)
	$offset:=4
	
	Case of 
			
			//________________________________________
		: (FORM Get current page:C276(*)=1)
			
			OBJECT GET COORDINATES:C663(*; "subFormAddress"; $g; $h; $d; $b)
			OBJECT SET COORDINATES:C1248(*; "subFormAddress"; $g; $h; $widthSubform-5; $b)
			
			//________________________________________
		: (FORM Get current page:C276(*)=2)
			
			OBJECT GET COORDINATES:C663(*; "lb_POs"; $left_lb; $top_lb; $right_lb; $bottom_lb)
			
			OBJECT SET COORDINATES:C1248(*; "lb_POs"; $left_lb; $top_lb; $widthSubform-$offset; $heightSubform-$offset-1)
			
			//________________________________________
		: (FORM Get current page:C276(*)=3)
			
			OBJECT GET COORDINATES:C663(*; "lb_Jobs"; $left_lb; $top_lb; $right_lb; $bottom_lb)
			
			OBJECT SET COORDINATES:C1248(*; "lb_Jobs"; $left_lb; $top_lb; $widthSubform-$offset; $heightSubform-$offset-1)
			
			//________________________________________
		: (FORM Get current page:C276(*)=4)
			
			OBJECT GET COORDINATES:C663(*; "lb_Planning"; $left_lb; $top_lb; $right_lb; $bottom_lb)
			
			OBJECT SET COORDINATES:C1248(*; "lb_Planning"; $left_lb; $top_lb; $widthSubform-$offset; $heightSubform-$offset-1)
			
			//________________________________________
		: (FORM Get current page:C276(*)=5)
			
			OBJECT GET COORDINATES:C663(*; "lb_CFM_Receiving"; $left_lb; $top_lb; $right_lb; $bottom_lb)
			
			OBJECT SET COORDINATES:C1248(*; "lb_CFM_Receiving"; $left_lb; $top_lb; $widthSubform-$offset; $heightSubform-$offset-1)
			
			//________________________________________
		: (FORM Get current page:C276(*)=6)
			
			OBJECT GET COORDINATES:C663(*; "lb_Invoices"; $left_lb; $top_lb; $right_lb; $bottom_lb)
			
			OBJECT SET COORDINATES:C1248(*; "lb_Invoices"; $left_lb; $top_lb; $widthSubform-$offset; $heightSubform-$offset-1)
			
			//________________________________________
	End case 
	
	This:C1470.contactDetails()
	
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
	
/*
Function drawPup_CustomerStatus()
	
If (Form.current_item#Null)
	
$customerStatus:=ds.CustomerStatus.query("UUID= :1"; Form.current_item.UUID_CustomerStatus).first() || New object(\
)
$statusName:=$customerStatus.name
	
If ($statusName=Null)
	
$statusName:=""
	
End if
	
$color:=cs.sfw_htmlColor.me.getName($customerStatus.color)
$pathIcon:=(Length($color)#0) ? "sfw/colors/"+$color+"-circle.png" : "sfw/image/skin/rainbow/icon/spacer-1x24.png"
Form.sfw.drawButtonPup("pup_customerStatus"; $statusName; $pathIcon; ($customerStatus=Null))
	
End if
	
*/
	
/*
Function pup_status()
	
// Create pop up menu
If (Form.sfw.checkIsInModification())
	
$menu:=Create menu
	
If (Storage.cache=Null) || (Storage.cache.customerStatus=Null)
	
ds.CustomerStatus.cacheLoad()
	
End if
	
For each ($eCustomerStatus; Storage.cache.customerStatus)
	
APPEND MENU ITEM($menu; $eCustomerStatus.name; *)
SET MENU ITEM PARAMETER($menu; -1; $eCustomerStatus.UUID)
	
If ($eCustomerStatus.UUID=Form.current_item.UUID_CustomerStatus)
	
SET MENU ITEM MARK($menu; -1; Char(18))
	
If (Is Windows)
	
SET MENU ITEM STYLE($menu; -1; Bold)
	
End if
End if
End for each
	
$choose:=Dynamic pop up menu($menu)
RELEASE MENU($menu)
	
Case of
	
//________________________________________
: (Length($choose)#0)
	
$eCustomerStatus:=ds.CustomerStatus.get($choose)
Form.current_item.UUID_CustomerStatus:=$eCustomerStatus.UUID
	
//________________________________________
End case
	
End if
	
This.drawPup_CustomerStatus()
*/
	
Function drawPup_CustomerStatus()
	cs:C1710.Dropdown.me.drowPup("CustomerStatus"; "UUID"; "UUID_CustomerStatus"; "pup_customerStatus")
	
Function pup_status()
	cs:C1710.Dropdown.me.pup("customerStatus"; "CustomerStatus"; "UUID"; "UUID_CustomerStatus")
	This:C1470.drawPup_CustomerStatus()
	
/*
Function drawPup_CustomerCarrier()
	
If (Form.current_item#Null)
	
$customerCarrier:=ds.CustomerCarrier.query("UUID =:1"; Form.current_item.UUID_CustomerCarrier).first() || New object(\
)
$carrierName:=$customerCarrier.name
	
If ($carrierName=Null)
	
$carrierName:=" "
	
End if
	
$color:=cs.sfw_htmlColor.me.getName($customerCarrier.color)
$pathIcon:=(Length($color)#0) ? "sfw/colors/"+$color+"-circle.png" : "sfw/image/skin/rainbow/icon/spacer-1x24.png"
Form.sfw.drawButtonPup("pup_customerCarrier"; $carrierName; $pathIcon; ($customerCarrier=Null))
	
End if
	
*/
	
/*
	
Function pup_carrier()
	
// Create pop up menu
If (Form.sfw.checkIsInModification())
	
$menu:=Create menu
	
If (Storage.cache=Null) || (Storage.cache.customerCarriers=Null)
	
ds.CustomerCarrier.cacheLoad()
	
End if
	
For each ($eCustomerCarrier; Storage.cache.customerCarriers)
	
APPEND MENU ITEM($menu; $eCustomerCarrier.name; *)
SET MENU ITEM PARAMETER($menu; -1; $eCustomerCarrier.UUID)
	
If ($eCustomerCarrier.UUID=Form.current_item.UUID_CustomerCarrier)
	
SET MENU ITEM MARK($menu; -1; Char(18))
	
If (Is Windows)
	
SET MENU ITEM STYLE($menu; -1; Bold)
	
End if
End if
End for each
	
$choose:=Dynamic pop up menu($menu)
RELEASE MENU($menu)
	
Case of
	
//________________________________________
: (Length($choose)#0)
	
$eCustomerCarrier:=ds.CustomerCarrier.get($choose)
Form.current_item.UUID_CustomerCarrier:=$eCustomerCarrier.UUID
	
//________________________________________
End case
	
End if
	
This.drawPup_CustomerCarrier()
*/
	
Function drawPup_CustomerCarrier()
	cs:C1710.Dropdown.me.drowPup("CustomerCarrier"; "UUID"; "UUID_CustomerCarrier"; "pup_customerCarrier")
	
Function pup_carrier()
	cs:C1710.Dropdown.me.pup("customerCarriers"; "CustomerCarrier"; "UUID"; "UUID_CustomerCarrier")
	This:C1470.drawPup_CustomerCarrier()
	
Function contactDetails()
	
	If (Form:C1466.current_item#Null:C1517)
		
		Form:C1466.subFormAddress:=New object:C1471(\
			)
		Form:C1466.subFormAddress.address:=Form:C1466.current_item.rebuildAddress()
		Form:C1466.lb_contact:=Form:C1466.current_item.rebuildContact()
		Form:C1466.subFormAddress.situation:=Form:C1466.situation
		
	End if 
	
Function bActionContact()
	$refMenu:=Create menu:C408
	APPEND MENU ITEM:C411($refMenu; "Open in new window"; *)
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "openInWindow")
	
	Case of 
			
			//________________________________________
		: (Form:C1466.apContact=1)
			
			$type:="AP"
			
			//________________________________________
		: (Form:C1466.statusContact=1)
			
			$type:="Status"
			
			//________________________________________
	End case 
	
	If (ds:C1482.Contact.query("UUID_Company = :1"; Form:C1466.current_item.UUID).query("title=:1"; $type).first()=Null:C1517)
		
		DISABLE MENU ITEM:C150($refMenu; -1)
		
	End if 
	
	$choice:=Dynamic pop up menu:C1006($refMenu)
	RELEASE MENU:C978($refMenu)
	
	Case of 
			
			//________________________________________
		: ($choice="openInWindow")
			
			Form:C1466.sfw.openInANewWindow(ds:C1482.Contact.query("UUID_Company = :1"; Form:C1466.current_item.UUID).query("title=:1"; $type).first(); "customerService"; "contact")
			
			//________________________________________
	End case 
	
	This:C1470.LoadContact()
	
Function LoadContact()
	
	Case of 
			
			//________________________________________
		: (Form:C1466.apContact=1)
			
			$type:="AP"
			
			//________________________________________
		: (Form:C1466.statusContact=1)
			
			$type:="Status"
			
			//________________________________________
	End case 
	
	If (Form:C1466.current_item#Null:C1517)
		
		Form:C1466.lb_contact:=New collection:C1472()
		Form:C1466.lb_contact:=Form:C1466.current_item.rebuildContact()
		
	End if 
	
Function loadXXX()
	
	// Loads and initializes a list
	
Function loadAllTabs()
	
	This:C1470.loadPOs()
	This:C1470.loadJobs()
	This:C1470.loadPlannings()
	This:C1470.loadCFMReceiving()
	This:C1470.loadInvoices()
	
Function loadPOs()
	
	If (Form:C1466.current_item#Null:C1517)
		
		Form:C1466.lb_POs:=New collection:C1472()
		
		$PurchaseOrders:=ds:C1482.PurchaseOrder.query("UUID_Customer = :1"; Form:C1466.current_item.UUID).orderBy("poNumber")
		
		For ($i; 0; $PurchaseOrders.length-1; 1)
			
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
		
		For ($i; 0; $Plannings.length-1; 1)
			
			$Planning_item:=New object:C1471(\
				)
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
		
		For ($i; 0; $Inventories.length-1; 1)
			
			$CFM_Receiving_item:=New object:C1471(\
				)
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
		
		For ($i; 0; $invoices.length-1; 1)
			
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
	
Function loadDpAddress()
	Form:C1466.dpAddress:=New object:C1471(\
		"values"; New collection:C1472("billing"; "shipping"); \
		"index"; 0; \
		"currentValue"; "Billing Address"\
		)
	
Function _activate_save_cancel_button()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID