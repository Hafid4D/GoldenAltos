singleton Class constructor
	//It's a singleton class
	
Function formMethod()
	//This function manages the main logic for updating and refreshing the form
	Form:C1466.sfw.panelFormMethod()  //The main body of the form method and basic sfw functionalities 
	If (Form:C1466.sfw.updateOfPanelNeeded())  //The current item is changed or reloaded, so it's necessary ti refresh 
		
		
	End if 
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())  //a page is displayed so it's time to load the sources of data to display
		Case of 
			: (FORM Get current page:C276(*)=1)
				// add load functions
				This:C1470.loadContact()
				
		End case 
	End if 
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())  //It's time to resize the object or set visible
		This:C1470.redrawAndSetVisible()
	End if 
	
	
Function drawPup_XXX()
	//This function updates the dropdown by displaying the name
	Form:C1466.sfw.drawButtonPup("pup_xxx"; $xxxName; "xxxx.png"; (Form:C1466.current_item.xxxx=Null:C1517))
	
	
	
Function drawPup_Customer()
	If (Form:C1466.current_item#Null:C1517)
		$customer:=ds:C1482.Customer.query("UUID= :1"; Form:C1466.current_item.UUID_Customer).first() || New object:C1471()
		$customerName:=$customer.name
		If ($customerName=Null:C1517)
			$customerName:="Customer"
		End if 
		$color:="#FFFFFF"  //cs.sfw_htmlColor.me.getName($customer.color)
		$pathIcon:=($color#"") ? "sfw/colors/"+$color+"-circle.png" : "sfw/image/skin/rainbow/icon/spacer-1x24.png"
		Form:C1466.sfw.drawButtonPup("pup_Customer"; $customerName; $pathIcon; ($customer=Null:C1517))
	End if 
	
	
Function pup_Customer()
	//Create pop up menu
	If (Form:C1466.sfw.checkIsInModification())
		$menu:=Create menu:C408
		If (Storage:C1525.cache=Null:C1517) || (Storage:C1525.cache.customers=Null:C1517)
			ds:C1482.Customer.cacheLoad()
		End if 
		
		For each ($eCustomer; Storage:C1525.cache.customers)
			APPEND MENU ITEM:C411($menu; $eCustomer.name; *)
			SET MENU ITEM PARAMETER:C1004($menu; -1; $eCustomer.UUID)
			If ($eCustomer.UUID=Form:C1466.current_item.UUID_Customer)
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
				$eCustomer:=ds:C1482.Customer.get($choose)
				Form:C1466.current_item.UUID_Customer:=$eCustomer.UUID
		End case 
		
	End if 
	This:C1470.drawPup_Customer()
	
	
	
Function redrawAndSetVisible()
	//Adjusts the layout and visibility of form elements based on the current page and modification state
	If (Form:C1466.current_item#Null:C1517)
		$visibility_bool:=(Form:C1466.current_item.title#"Status") && (Form:C1466.current_item.title#"AP")
	Else 
		$visibility_bool:=False:C215
	End if 
	
	OBJECT SET VISIBLE:C603(*; "lbl_address"; $visibility_bool)
	OBJECT SET VISIBLE:C603(*; "header_bkgd2"; $visibility_bool)
	OBJECT SET VISIBLE:C603(*; "subFormAddress"; $visibility_bool)
	
	OBJECT SET VISIBLE:C603(*; "bActionContact"; Form:C1466.sfw.checkIsInModification())
	This:C1470.contactDetails()
	This:C1470.drawPup_Customer()
	
Function contactDetails()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.subFormAddress:=New object:C1471()
		Form:C1466.subFormAddress.address:=Form:C1466.current_item.rebuildAddress()
		Form:C1466.subFormAddress.situation:=Form:C1466.situation
	End if 
	
	
Function loadXXX()
	//Loads and initializes a list
	
	
Function loadContact()
	
	Form:C1466.lb_contact:=New collection:C1472()
	
	If (Form:C1466.current_item#Null:C1517)
		
		Form:C1466.lb_contact:=Form:C1466.current_item.rebuidComunications()
		
		This:C1470.displayContact()
	End if 
	
Function displayContact()
	
	OBJECT SET ENTERABLE:C238(*; "entryField_contact@"; False:C215)
	
	If (Form:C1466.current_contact=Null:C1517)
		OBJECT SET VISIBLE:C603(*; "label_contact@"; False:C215)
		OBJECT SET VISIBLE:C603(*; "entryField_contact@"; False:C215)
		OBJECT SET VISIBLE:C603(*; "bSave"; False:C215)
	Else 
		OBJECT SET VISIBLE:C603(*; "label_contact@"; True:C214)
		OBJECT SET VISIBLE:C603(*; "entryField_contact@"; True:C214)
		OBJECT SET VISIBLE:C603(*; "bSave"; True:C214)
		
	End if 
	
	
Function bActionXXX()
	//Manages actions: add, or remove, using dynamic menus and modification checks
	
Function bActionContact()
	
	$mainMenu:=Create menu:C408
	
	APPEND MENU ITEM:C411($mainMenu; "Add contact"; *)
	SET MENU ITEM PARAMETER:C1004($mainMenu; -1; "--addContact")
	SET MENU ITEM SHORTCUT:C423($mainMenu; -1; "L"; Command key mask:K16:1)
	APPEND MENU ITEM:C411($mainMenu; "-")
	
	APPEND MENU ITEM:C411($mainMenu; "Delete contact"; *)
	SET MENU ITEM PARAMETER:C1004($mainMenu; -1; "--deleteContact")
	APPEND MENU ITEM:C411($mainMenu; "-")
	
	APPEND MENU ITEM:C411($mainMenu; "Modify contact"; *)
	SET MENU ITEM PARAMETER:C1004($mainMenu; -1; "--modifyContact")
	
	If (Form:C1466.current_contact=Null:C1517)
		DISABLE MENU ITEM:C150($mainMenu; 3)
		DISABLE MENU ITEM:C150($mainMenu; 5)
	End if 
	
	
	$choose:=Dynamic pop up menu:C1006($mainMenu)
	RELEASE MENU:C978($mainMenu)
	
	Case of 
		: ($choose="--addContact")
			
			$contact:=New object:C1471()
			
			OB SET:C1220($contact; "name"; "contact type")
			OB SET:C1220($contact; "value"; "contact value")
			
			Form:C1466.lb_contact.push($contact)
			LISTBOX INSERT ROWS:C913(*; "lb_contact"; Form:C1466.lb_contact.length; 1)
			This:C1470._activate_save_cancel_button()
			LISTBOX SELECT ROW:C912(*; "lb_contact"; Form:C1466.lb_contact.length; lk replace selection:K53:1)
			Form:C1466.current_contact:=$contact
			This:C1470.displayContact()
			
			GOTO OBJECT:C206(*; "entryField_contactType")
			OBJECT SET ENTERABLE:C238(*; "label_contact@"; True:C214)
			OBJECT SET ENTERABLE:C238(*; "entryField_contact@"; True:C214)
			
		: ($choose="--deleteContact")
			
			OBJECT SET ENTERABLE:C238(*; "label_contact@"; False:C215)
			OBJECT SET ENTERABLE:C238(*; "entryField_contact@"; False:C215)
			
			$ok:=cs:C1710.sfw_dialog.me.confirm("Do you really want to delete this contact? "; "Delete"; "CANCEL")
			If ($ok)
				If (Form:C1466.current_item#Null:C1517)
					OB REMOVE:C1226(Form:C1466.current_item.contactDetails.communications[0]; Form:C1466.current_contact.name)
					This:C1470.loadContact()
				End if 
			End if 
			
			
		: ($choose="--modifyContact")
			
			OBJECT SET ENTERABLE:C238(*; "label_contact@"; True:C214)
			OBJECT SET ENTERABLE:C238(*; "entryField_contact@"; True:C214)
			OBJECT SET VISIBLE:C603(*; "bSave"; True:C214)
			
	End case 
	
	
Function _activate_save_cancel_button()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	
	
Function saveContact()
	
	If (Form:C1466.current_contact.name#"contact type") & (Form:C1466.current_contact.value#"contact value")
		
		var $comm : Object
		
		If (OB Is defined:C1231(Form:C1466.current_item.contactDetails; "communications"))
			
			
			If (Form:C1466.current_item.contactDetails.communications.length>0)
				OB SET:C1220(Form:C1466.current_item.contactDetails.communications[0]; Form:C1466.current_contact.name; Form:C1466.current_contact.value)
				
				
			Else 
				
				$comm:=New object:C1471()
				Form:C1466.current_item.contactDetails.communications.push($comm)
				OB SET:C1220(Form:C1466.current_item.contactDetails.communications[0]; Form:C1466.current_contact.name; Form:C1466.current_contact.value)
				
			End if 
			
		Else 
			
			Form:C1466.current_item.contactDetails.communications:=New collection:C1472()
			$comm:=New object:C1471()
			Form:C1466.current_item.contactDetails.communications.push($comm)
			OB SET:C1220(Form:C1466.current_item.contactDetails.communications[0]; Form:C1466.current_contact.name; Form:C1466.current_contact.value)
			
		End if 
		
		OBJECT SET VISIBLE:C603(*; "label_contact@"; False:C215)
		OBJECT SET VISIBLE:C603(*; "entryField_contact@"; False:C215)
		OBJECT SET VISIBLE:C603(*; "bSave"; False:C215)
	Else 
		
		cs:C1710.sfw_dialog.me.alert("'contact type' and 'contact value' are default values. Please enter valid value")
		
	End if 
	
	
	
	
	
	
	