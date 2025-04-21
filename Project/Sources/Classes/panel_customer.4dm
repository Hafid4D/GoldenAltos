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
	
	
Function pup_status()
	//Create pop up menu
	If (Form:C1466.sfw.checkIsInModification())
	End if 
	This:C1470.drawPup_XXX()
	
	
Function redrawAndSetVisible()
	//Adjusts the layout and visibility of form elements based on the current page and modification state
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($widthSubform; $heightSubform)
	OBJECT GET COORDINATES:C663(*; "subFormAddress"; $g; $h; $d; $b)
	OBJECT SET COORDINATES:C1248(*; "subFormAddress"; $g; $h; $widthSubform-5; $b)
	This:C1470.contactDetails()
	OBJECT SET VISIBLE:C603(*; "bActionApContact"; Form:C1466.sfw.checkIsInModification())
	OBJECT SET VISIBLE:C603(*; "bActionStatusContact"; Form:C1466.sfw.checkIsInModification())
	
	
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
		If (Form:C1466.current_item.contactDetails#Null:C1517)
			Form:C1466.lb_apContact:=New collection:C1472()
			Form:C1466.lb_apContact:=Form:C1466.current_item.rebuidComunications("AP Contact")
			This:C1470.displayApContact()
		End if 
	End if 
	
	
Function LoadStatusContact()
	If (Form:C1466.current_item#Null:C1517)
		If (Form:C1466.current_item.contactDetails#Null:C1517)
			Form:C1466.lb_statusContact:=New collection:C1472()
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
/*
//$customer:=ds.Customer.query("UUID = :1"; Form.current_item.UUID).first()
//OB SET($customer.contactDetails.communications[$i].detail; "type"; "contact value")
//$info:=$customer.save()
//Form.lb_apContact:=Form.current_item.rebuidComunications("AP Contact")
			
//$communications:=Form.current_item.contactDetails.communications
//If ($communications#Null)
//$contacts:=New collection()
//For ($i; 0; $communications.length-1)
			
//If ($communications[$i].type="AP Contact")
//End if 
//End for 
			
//End if 
			
			
			
//$eQuoteLine:=ds.QuoteLine.new()
//$eQuoteLine.UUID_Quote:=Form.current_item.UUID
//$info:=$eQuoteLine.save()
//This._activate_save_cancel_button()
//Form.current_apContact:=$eQuoteLine
//This.displayQuoteLine()
//Form.apContact:=ds.QuoteLine.query("UUID_Quote == :1"; Form.current_item.UUID)
//LISTBOX SELECT ROW(*; "lb_quoteLines"; Form.apContact.length; lk replace selection)
//GOTO OBJECT(*; "entryField_quoteLineQuantity")
*/
			$contact:=New object:C1471()
			
			OB SET:C1220($contact; "name"; "type")
			OB SET:C1220($contact; "value"; "contact value")
			
			Form:C1466.lb_apContact.push($contact)
			LISTBOX INSERT ROWS:C913(*; "lb_apContact"; Form:C1466.lb_apContact.length; 1)
			
			LISTBOX SELECT ROW:C912(*; "lb_apContact"; Form:C1466.lb_apContact.length; lk replace selection:K53:1)
			Form:C1466.current_apContact:=$contact
			This:C1470.displayApContact()
			
			GOTO OBJECT:C206(*; "entryField_apContactType")
			
			
		: ($choose="--deleteContact")
			$ok:=cs:C1710.sfw_dialog.me.confirm("Do you really want to delete this contact? "; "Delete"; "CANCEL")
			If ($ok)
				
				
				//Drop code
				//$info:=Form.current_apContact.drop()
				//This._activate_save_cancel_button()
				//LISTBOX SELECT ROW(*; "lb_quoteLines"; 0; lk remove from selection)
				Form:C1466.current_apContact:=Null:C1517
				//This.displayQuoteLine()
			End if 
			
	End case 
*/
	
	
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
	
	
	
	
	
	
	
	
	
	