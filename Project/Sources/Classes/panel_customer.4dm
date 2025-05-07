singleton Class constructor
	//It's a singleton class
	
Function formMethod()
	//This function manages the main logic for updating and refreshing the form
	Form:C1466.sfw.panelFormMethod()  //The main body of the form method and basic sfw functionalities 
	If (Form:C1466.sfw.updateOfPanelNeeded())  //The current item is changed or reloaded, so it's necessary ti refresh 
		Form:C1466.addressBilling:=1
		Form:C1466.addressShipping:=0
		
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
			$statusName:="Status"
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
			$carrierName:="Carrier"
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
	
	
Function contactDetails()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.subFormAddress:=New object:C1471()
		Form:C1466.subFormAddress.address:=Form:C1466.current_item.rebuildAddress()
		Form:C1466.subFormAddress.situation:=Form:C1466.situation
	End if 
	
	
Function loadXXX()
	//Loads and initializes a list
	
Function LoadApContact()
	
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.lb_apContact:=New collection:C1472()
		If (Form:C1466.current_item.contacts.query("title=:1"; "AP").first()#Null:C1517)
			
			Form:C1466.lb_apContact:=Form:C1466.current_item.rebuidComunications("AP Contact")
			This:C1470.displayApContact()
		End if 
	End if 
	
	
Function LoadStatusContact()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.lb_statusContact:=New collection:C1472()
		If (Form:C1466.current_item.contacts.query("title=:1"; "Status").first()#Null:C1517)
			
			Form:C1466.lb_statusContact:=Form:C1466.current_item.rebuidComunications("Status Contact")
			This:C1470.displayStatusContact()
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
/*
$mainMenu:=Create menu
	
APPEND MENU ITEM($mainMenu; "Add AP contact"; *)
SET MENU ITEM PARAMETER($mainMenu; -1; "--addApContact")
SET MENU ITEM SHORTCUT($mainMenu; -1; "L"; Command key mask)
APPEND MENU ITEM($mainMenu; "-")
	
APPEND MENU ITEM($mainMenu; "Delete AP contact"; *)
SET MENU ITEM PARAMETER($mainMenu; -1; "--deleteApContact")
APPEND MENU ITEM($mainMenu; "-")
	
APPEND MENU ITEM($mainMenu; "Modify AP contact"; *)
SET MENU ITEM PARAMETER($mainMenu; -1; "--modifyApContact")
	
If (Form.current_apContact=Null)
DISABLE MENU ITEM($mainMenu; 3)
DISABLE MENU ITEM($mainMenu; 5)
End if 
	
	
$choose:=Dynamic pop up menu($mainMenu)
RELEASE MENU($mainMenu)
	
Case of 
: ($choose="--addApContact")
	
$contact:=New object()
	
OB SET($contact; "name"; "contact type")
OB SET($contact; "value"; "contact value")
	
Form.lb_apContact.push($contact)
LISTBOX INSERT ROWS(*; "lb_apContact"; Form.lb_apContact.length; 1)
This._activate_save_cancel_button()
LISTBOX SELECT ROW(*; "lb_apContact"; Form.lb_apContact.length; lk replace selection)
Form.current_apContact:=$contact
This.displayApContact()
	
GOTO OBJECT(*; "entryField_apContactType")
OBJECT SET ENTERABLE(*; "label_apContact@"; True)
OBJECT SET ENTERABLE(*; "entryField_apContact@"; True)
	
: ($choose="--deleteApContact")
OBJECT SET ENTERABLE(*; "label_apContact@"; False)
OBJECT SET ENTERABLE(*; "entryField_apContact@"; False)
	
$ok:=cs.sfw_dialog.me.confirm("Do you really want to delete this contact? "; "Delete"; "CANCEL")
If ($ok)
If (Form.current_item.contacts.query("title=:1"; "AP").first()#Null)
For ($i; 0; Form.current_item.contacts.query("title=:1"; "AP").first().contactDetails.communications.length-1)
OB REMOVE(Form.current_item.contacts.query("title=:1"; "AP").first().contactDetails.communications; Form.current_apContact.name)
This.LoadApContact()
End for 
End if 
End if 
	
	
: ($choose="--modifyApContact")
OBJECT SET ENTERABLE(*; "label_apContact@"; True)
OBJECT SET ENTERABLE(*; "entryField_apContact@"; True)
	
End case 
*/
	
Function bActionStatusContact()
/*
$mainMenu:=Create menu
	
APPEND MENU ITEM($mainMenu; "Add status contact"; *)
SET MENU ITEM PARAMETER($mainMenu; -1; "--addStatusContact")
SET MENU ITEM SHORTCUT($mainMenu; -1; "L"; Command key mask)
APPEND MENU ITEM($mainMenu; "-")
	
APPEND MENU ITEM($mainMenu; "Delete status contact"; *)
SET MENU ITEM PARAMETER($mainMenu; -1; "--deleteStatusContact")
APPEND MENU ITEM($mainMenu; "-")
	
APPEND MENU ITEM($mainMenu; "Modify status contact"; *)
SET MENU ITEM PARAMETER($mainMenu; -1; "--modifyStatusContact")
	
	
If (Form.current_statusContact=Null)
DISABLE MENU ITEM($mainMenu; 3)
DISABLE MENU ITEM($mainMenu; 5)
End if 
	
$choose:=Dynamic pop up menu($mainMenu)
RELEASE MENU($mainMenu)
	
	
Case of 
: ($choose="--addStatusContact")
	
$contact:=New object()
	
OB SET($contact; "name"; "contact type")
OB SET($contact; "value"; "contact value")
	
Form.lb_statusContact.push($contact)
LISTBOX INSERT ROWS(*; "lb_statusContact"; Form.lb_statusContact.length; 1)
This._activate_save_cancel_button()
LISTBOX SELECT ROW(*; "lb_statusContact"; Form.lb_statusContact.length; lk replace selection)
Form.current_statusContact:=$contact
This.displayStatusContact()
	
GOTO OBJECT(*; "entryField_statusContactType")
OBJECT SET ENTERABLE(*; "label_statusContact@"; True)
OBJECT SET ENTERABLE(*; "entryField_statusContact@"; True)
	
: ($choose="--deleteStatusContact")
OBJECT SET ENTERABLE(*; "label_statusContact@"; False)
OBJECT SET ENTERABLE(*; "entryField_statusContact@"; False)
	
$ok:=cs.sfw_dialog.me.confirm("Do you really want to delete this contact? "; "Delete"; "CANCEL")
If ($ok)
If (Form.current_item.contacts.query("title=:1"; "Status").first()#Null)
//For ($i; 0; Form.current_item.contacts.query("title=:1"; "Status").first().contactDetails.communications.length-1)
OB REMOVE(Form.current_item.contacts.query("title=:1"; "Status").first().contactDetails.communications[0]; Form.current_statusContact.name)
This.LoadStatusContact()
//End for 
End if 
End if 
	
: ($choose="--modifyStatusContact")
OBJECT SET ENTERABLE(*; "label_statusContact@"; True)
OBJECT SET ENTERABLE(*; "entryField_statusContact@"; True)
	
End case 
*/
	
Function loadDpAddress()
	Form:C1466.dpAddress:=New object:C1471(\
		"values"; New collection:C1472("billing"; "shipping"); \
		"index"; 0; \
		"currentValue"; "Billing Address"\
		)
	
	
Function displayApContact()
	
/*
OBJECT SET ENTERABLE(*; "label_apContact@"; False)
OBJECT SET ENTERABLE(*; "entryField_apContact@"; False)
	
If (Form.current_apContact=Null)
OBJECT SET VISIBLE(*; "label_apContact@"; False)
OBJECT SET VISIBLE(*; "entryField_apContact@"; False)
Else 
OBJECT SET VISIBLE(*; "label_apContact@"; True)
OBJECT SET VISIBLE(*; "entryField_apContact@"; True)
	
End if 
*/
	
Function displayStatusContact()
/*
OBJECT SET ENTERABLE(*; "label_statusContact@"; False)
OBJECT SET ENTERABLE(*; "entryField_statusContact@"; False)
	
If (Form.current_statusContact=Null)
OBJECT SET VISIBLE(*; "label_statusContact@"; False)
OBJECT SET VISIBLE(*; "entryField_statusContact@"; False)
Else 
OBJECT SET VISIBLE(*; "label_statusContact@"; True)
OBJECT SET VISIBLE(*; "entryField_statusContact@"; True)
	
End if 
*/
	
Function _activate_save_cancel_button()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	
	
Function saveAPContact()
	
/*
var $detail : Object
var $communications : Collection
	
If (Form.current_item.contactDetails=Null)
Form.current_item.contactDetails:=New object()
End if 
	
If (OB Is defined(Form.current_item.contactDetails; "communications"))
$communications:=Form.current_item.contactDetails.communications
If ($communications.length>0)
$contacts:=New collection()
For ($i; 0; $communications.length-1)
If (OB Is defined($communications[$i]; "type"))
If ($communications[$i].type="AP Contact")
	
If (OB Is defined($communications[$i]; "detail"))
	
If (Form.current_apContact.name#"contact type") & (Form.current_apContact.value#"contact value")
OB SET(Form.current_item.contactDetails.communications[$i].detail; Form.current_apContact.name; Form.current_apContact.value)
End if 
	
Else 
If (Form.current_apContact.name#"contact type") & (Form.current_apContact.value#"contact value")
$detail:=New object()
OB SET($detail; Form.current_apContact.name; Form.current_apContact.value)
OB SET(Form.current_item.contactDetails.communications[$i]; "detail"; $detail)
End if 
	
End if 
	
End if 
	
Else 
If (Form.current_apContact.name#"contact type") & (Form.current_apContact.value#"contact value")
OB SET(Form.current_item.contactDetails.communications[$i]; "type"; "AP Contact")
	
$detail:=New object()
	
OB SET($detail; Form.current_apContact.name; Form.current_apContact.value)
OB SET(Form.current_item.contactDetails.communications[$i]; "detail"; $detail)
End if 
End if 
	
End for 
	
Else 
If (Form.current_apContact.name#"contact type") & (Form.current_apContact.value#"contact value")
$comm:=New object()
$comm.type:="AP Contact"
$detail:=New object()
	
OB SET($detail; Form.current_apContact.name; Form.current_apContact.value)
$comm.detail:=$detail
Form.current_item.contactDetails.communications.push($comm)
End if 
	
End if 
	
Else 
If (Form.current_apContact.name#"contact type") & (Form.current_apContact.value#"contact value")
$comm:=New object()
$comm.type:="AP Contact"
$detail:=New object()
	
OB SET($detail; Form.current_apContact.name; Form.current_apContact.value)
$comm.detail:=$detail
$communications:=New collection()
$communications.push($comm)
Form.current_item.contactDetails.communications:=$communications
End if 
	
End if 
*/
	
Function saveStatusContact()
	
/*
	
var $detail : Object
var $communications : Collection
	
If (Form.current_item.contactDetails=Null)
Form.current_item.contactDetails:=New object()
End if 
	
If (OB Is defined(Form.current_item.contactDetails; "communications"))
$communications:=Form.current_item.contactDetails.communications
If ($communications.length>0)
$contacts:=New collection()
For ($i; 0; $communications.length-1)
If (OB Is defined($communications[$i]; "type"))
If ($communications[$i].type="Status Contact")
	
If (OB Is defined($communications[$i]; "detail"))
If (Form.current_statusContact.name#"contact type") & (Form.current_statusContact.name#"contact value")
OB SET(Form.current_item.contactDetails.communications[$i].detail; Form.current_statusContact.name; Form.current_statusContact.value)
End if 
Else 
If (Form.current_statusContact.name#"contact type") & (Form.current_statusContact.name#"contact value")
$detail:=New object()
OB SET($detail; Form.current_statusContact.name; Form.current_statusContact.value)
OB SET(Form.current_item.contactDetails.communications[$i]; "detail"; $detail)
End if 
End if 
	
End if 
	
Else 
	
	
If (Form.current_statusContact.name#"contact type") & (Form.current_statusContact.name#"contact value")
OB SET(Form.current_item.contactDetails.communications[$i]; "type"; "Status Contact")
	
$detail:=New object()
OB SET($detail; Form.current_statusContact.name; Form.current_statusContact.value)
OB SET(Form.current_item.contactDetails.communications[$i]; "detail"; $detail)
End if 
End if 
	
End for 
	
Else 
If (Form.current_statusContact.name#"contact type") & (Form.current_statusContact.name#"contact value")
$comm:=New object()
$comm.type:="Status Contact"
$detail:=New object()
OB SET($detail; Form.current_statusContact.name; Form.current_statusContact.value)
$comm.detail:=$detail
Form.current_item.contactDetails.communications.push($comm)
End if 
End if 
	
Else 
If (Form.current_statusContact.name#"contact type") & (Form.current_statusContact.name#"contact value")
$comm:=New object()
$comm.type:="Status Contact"
$detail:=New object()
OB SET($detail; Form.current_statusContact.name; Form.current_statusContact.value)
$comm.detail:=$detail
$communications:=New collection()
$communications.push($comm)
Form.current_item.contactDetails.communications:=$communications
End if 
End if 
*/
	
	
	