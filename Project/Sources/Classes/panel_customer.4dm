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
		If ($statusName="")
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
		$statusName:=$customerCarrier.name
		If ($statusName="")
			$statusName:="Carrier"
		End if 
		$color:=cs:C1710.sfw_htmlColor.me.getName($customerCarrier.color)
		$pathIcon:=($color#"") ? "sfw/colors/"+$color+"-circle.png" : "sfw/image/skin/rainbow/icon/spacer-1x24.png"
		Form:C1466.sfw.drawButtonPup("pup_customerCarrier"; $statusName; $pathIcon; ($customerCarrier=Null:C1517))
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
	OBJECT SET VISIBLE:C603(*; "bActionApContact"; Form:C1466.sfw.checkIsInModification())
	OBJECT SET VISIBLE:C603(*; "bActionStatusContact"; Form:C1466.sfw.checkIsInModification())
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
		
		If (Form:C1466.current_item.contactDetails#Null:C1517)
			
			Form:C1466.lb_apContact:=Form:C1466.current_item.rebuidComunications("AP Contact")
			This:C1470.displayApContact()
		End if 
	End if 
	
	
Function LoadStatusContact()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.lb_statusContact:=New collection:C1472()
		
		If (Form:C1466.current_item.contactDetails#Null:C1517)
			
			Form:C1466.lb_statusContact:=Form:C1466.current_item.rebuidComunications("Status Contact")
			This:C1470.displayStatusContact()
		End if 
	End if 
	
	
Function bActionXXX()
	//Manages actions: add, or remove, using dynamic menus and modification checks
	
Function bActionApContact()
	
	$mainMenu:=Create menu:C408
	
	APPEND MENU ITEM:C411($mainMenu; "Add AP contact"; *)
	SET MENU ITEM PARAMETER:C1004($mainMenu; -1; "--addApContact")
	SET MENU ITEM SHORTCUT:C423($mainMenu; -1; "L"; Command key mask:K16:1)
	APPEND MENU ITEM:C411($mainMenu; "-")
	
	APPEND MENU ITEM:C411($mainMenu; "Delete AP contact"; *)
	SET MENU ITEM PARAMETER:C1004($mainMenu; -1; "--deleteApContact")
	
	If (Form:C1466.current_apContact=Null:C1517)
		DISABLE MENU ITEM:C150($mainMenu; -1)
	End if 
	
	$choose:=Dynamic pop up menu:C1006($mainMenu)
	RELEASE MENU:C978($mainMenu)
	
	
	Case of 
		: ($choose="--addApContact")
			
			$contact:=New object:C1471()
			
			OB SET:C1220($contact; "name"; "type")
			OB SET:C1220($contact; "value"; "contact value")
			
			Form:C1466.lb_apContact.push($contact)
			LISTBOX INSERT ROWS:C913(*; "lb_apContact"; Form:C1466.lb_apContact.length; 1)
			This:C1470._activate_save_cancel_button()
			LISTBOX SELECT ROW:C912(*; "lb_apContact"; Form:C1466.lb_apContact.length; lk replace selection:K53:1)
			Form:C1466.current_apContact:=$contact
			This:C1470.displayApContact()
			
			GOTO OBJECT:C206(*; "entryField_apContactType")
			
			
		: ($choose="--deleteContact")
			$ok:=cs:C1710.sfw_dialog.me.confirm("Do you really want to delete this contact? "; "Delete"; "CANCEL")
			If ($ok)
				
				
			End if 
			
	End case 
	
Function bActionStatusContact()
	
	$mainMenu:=Create menu:C408
	
	APPEND MENU ITEM:C411($mainMenu; "Add status contact"; *)
	SET MENU ITEM PARAMETER:C1004($mainMenu; -1; "--addStatusContact")
	SET MENU ITEM SHORTCUT:C423($mainMenu; -1; "L"; Command key mask:K16:1)
	APPEND MENU ITEM:C411($mainMenu; "-")
	
	APPEND MENU ITEM:C411($mainMenu; "Delete status contact"; *)
	SET MENU ITEM PARAMETER:C1004($mainMenu; -1; "--deleteStatusContact")
	
	If (Form:C1466.current_statusContact=Null:C1517)
		DISABLE MENU ITEM:C150($mainMenu; -1)
	End if 
	
	$choose:=Dynamic pop up menu:C1006($mainMenu)
	RELEASE MENU:C978($mainMenu)
	
	$contact:=New object:C1471()
	
	OB SET:C1220($contact; "name"; "type")
	OB SET:C1220($contact; "value"; "contact value")
	
	Form:C1466.lb_statusContact.push($contact)
	LISTBOX INSERT ROWS:C913(*; "lb_statusContact"; Form:C1466.lb_statusContact.length; 1)
	This:C1470._activate_save_cancel_button()
	LISTBOX SELECT ROW:C912(*; "lb_statusContact"; Form:C1466.lb_statusContact.length; lk replace selection:K53:1)
	Form:C1466.current_statusContact:=$contact
	This:C1470.displayStatusContact()
	
	GOTO OBJECT:C206(*; "entryField_statusContactType")
	
Function loadDpAddress()
	Form:C1466.dpAddress:=New object:C1471(\
		"values"; New collection:C1472("billing"; "shipping"); \
		"index"; 0; \
		"currentValue"; "Billing Address"\
		)
	
Function displayApContact()
	
	If (Form:C1466.current_apContact=Null:C1517)
		OBJECT SET VISIBLE:C603(*; "label_apContact@"; False:C215)
		OBJECT SET VISIBLE:C603(*; "entryField_apContact@"; False:C215)
	Else 
		OBJECT SET VISIBLE:C603(*; "label_apContact@"; True:C214)
		OBJECT SET VISIBLE:C603(*; "entryField_apContact@"; True:C214)
		
	End if 
	
Function displayStatusContact()
	
	If (Form:C1466.current_statusContact=Null:C1517)
		OBJECT SET VISIBLE:C603(*; "label_statusContact@"; False:C215)
		OBJECT SET VISIBLE:C603(*; "entryField_statusContact@"; False:C215)
	Else 
		OBJECT SET VISIBLE:C603(*; "label_statusContact@"; True:C214)
		OBJECT SET VISIBLE:C603(*; "entryField_statusContact@"; True:C214)
		
	End if 
	
Function _activate_save_cancel_button()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	
Function saveAPContact()
	var $detail : Object
	var $communications : Collection
	
	If (Form:C1466.current_item.contactDetails=Null:C1517)
		Form:C1466.current_item.contactDetails:=New object:C1471()
	End if 
	
	If (OB Is defined:C1231(Form:C1466.current_item.contactDetails; "communications"))
		$communications:=Form:C1466.current_item.contactDetails.communications
		If ($communications.length>0)
			$contacts:=New collection:C1472()
			For ($i; 0; $communications.length-1)
				If (OB Is defined:C1231($communications[$i]; "type"))
					If ($communications[$i].type="AP Contact")
						
						If (OB Is defined:C1231($communications[$i]; "detail"))
							
							OB SET:C1220(Form:C1466.current_item.contactDetails.communications[$i].detail; Form:C1466.current_apContact.name; Form:C1466.current_apContact.value)
							
						Else 
							
							$detail:=New object:C1471()
							OB SET:C1220($detail; Form:C1466.current_apContact.name; Form:C1466.current_apContact.value)
							OB SET:C1220(Form:C1466.current_item.contactDetails.communications[$i]; "detail"; $detail)
							
						End if 
						
					End if 
					
				Else 
					
					OB SET:C1220(Form:C1466.current_item.contactDetails.communications[$i]; "type"; "AP Contact")
					
					$detail:=New object:C1471()
					OB SET:C1220($detail; Form:C1466.current_apContact.name; Form:C1466.current_apContact.value)
					OB SET:C1220(Form:C1466.current_item.contactDetails.communications[$i]; "detail"; $detail)
					
				End if 
				
			End for 
			
		Else 
			
			$comm:=New object:C1471()
			$comm.type:="AP Contact"
			$detail:=New object:C1471()
			OB SET:C1220($detail; Form:C1466.current_apContact.name; Form:C1466.current_apContact.value)
			$comm.detail:=$detail
			Form:C1466.current_item.contactDetails.communications.push($comm)
			
		End if 
		
	Else 
		
		$comm:=New object:C1471()
		$comm.type:="AP Contact"
		$detail:=New object:C1471()
		OB SET:C1220($detail; Form:C1466.current_apContact.name; Form:C1466.current_apContact.value)
		$comm.detail:=$detail
		$communications:=New collection:C1472()
		$communications.push($comm)
		Form:C1466.current_item.contactDetails.communications:=$communications
		
	End if 
	
Function saveStatusContact()
	var $detail : Object
	var $communications : Collection
	
	If (Form:C1466.current_item.contactDetails=Null:C1517)
		Form:C1466.current_item.contactDetails:=New object:C1471()
	End if 
	
	If (OB Is defined:C1231(Form:C1466.current_item.contactDetails; "communications"))
		$communications:=Form:C1466.current_item.contactDetails.communications
		If ($communications.length>0)
			$contacts:=New collection:C1472()
			For ($i; 0; $communications.length-1)
				If (OB Is defined:C1231($communications[$i]; "type"))
					If ($communications[$i].type="Status Contact")
						
						If (OB Is defined:C1231($communications[$i]; "detail"))
							
							OB SET:C1220(Form:C1466.current_item.contactDetails.communications[$i].detail; Form:C1466.current_statusContact.name; Form:C1466.current_statusContact.value)
							
						Else 
							
							$detail:=New object:C1471()
							OB SET:C1220($detail; Form:C1466.current_statusContact.name; Form:C1466.current_statusContact.value)
							OB SET:C1220(Form:C1466.current_item.contactDetails.communications[$i]; "detail"; $detail)
							
						End if 
						
					End if 
					
				Else 
					
					OB SET:C1220(Form:C1466.current_item.contactDetails.communications[$i]; "type"; "Status Contact")
					
					$detail:=New object:C1471()
					OB SET:C1220($detail; Form:C1466.current_statusContact.name; Form:C1466.current_statusContact.value)
					OB SET:C1220(Form:C1466.current_item.contactDetails.communications[$i]; "detail"; $detail)
					
				End if 
				
			End for 
			
		Else 
			
			$comm:=New object:C1471()
			$comm.type:="Status Contact"
			$detail:=New object:C1471()
			OB SET:C1220($detail; Form:C1466.current_statusContact.name; Form:C1466.current_statusContact.value)
			$comm.detail:=$detail
			Form:C1466.current_item.contactDetails.communications.push($comm)
			
		End if 
		
	Else 
		
		$comm:=New object:C1471()
		$comm.type:="Status Contact"
		$detail:=New object:C1471()
		OB SET:C1220($detail; Form:C1466.current_statusContact.name; Form:C1466.current_statusContact.value)
		$comm.detail:=$detail
		$communications:=New collection:C1472()
		$communications.push($comm)
		Form:C1466.current_item.contactDetails.communications:=$communications
		
	End if 
	
	
	
	
	