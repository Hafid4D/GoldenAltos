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
				This:C1470.loadQuoteLines()
		End case 
	End if 
	
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())  //It's time to resize the object or set visible
		This:C1470.redrawAndSetVisible()
	End if 
	
	
	Case of 
		: (FORM Event:C1606.code=On Bound Variable Change:K2:52)
			This:C1470.onBoundVariableChange()
			
	End case 
	
	
	
Function drawPup_XXX()
	//This function updates the dropdown by displaying the name
	Form:C1466.sfw.drawButtonPup("pup_xxx"; $xxxName; "xxxx.png"; (Form:C1466.current_item.xxxx=Null:C1517))
	
	
Function pup_XXX()
	//Create pop up menu
	If (Form:C1466.sfw.checkIsInModification())
	End if 
	This:C1470.drawPup_XXX()
	
	
Function redrawAndSetVisible()
	//Adjusts the layout and visibility of form elements based on the current page and modification state
	OBJECT SET VISIBLE:C603(*; "bActionQuoteLines"; Form:C1466.sfw.checkIsInModification())
	
	
Function loadQuoteLines()
	Form:C1466.lb_quoteLines:=Form:C1466.current_item.lines
	If (Form:C1466.current_quoteLine=Null:C1517)
		OBJECT SET VISIBLE:C603(*; "label_quoteLine@"; False:C215)
		OBJECT SET VISIBLE:C603(*; "entryField_quoteLineD@"; False:C215)
		
	Else 
		OBJECT SET VISIBLE:C603(*; "label_quoteLine@"; True:C214)
		OBJECT SET VISIBLE:C603(*; "entryField_quoteLineD@"; True:C214)
		
	End if 
	
Function bActionQuoteLines()
	$mainMenu:=Create menu:C408
	$isInModification:=Form:C1466.sfw.checkIsInModification()
	
	APPEND MENU ITEM:C411($mainMenu; "Add quote line..."; *)
	SET MENU ITEM PARAMETER:C1004($mainMenu; -1; "--addQuoteLine")
	SET MENU ITEM SHORTCUT:C423($mainMenu; -1; "Q"; Command key mask:K16:1)
	APPEND MENU ITEM:C411($mainMenu; "-")
	
	APPEND MENU ITEM:C411($mainMenu; "Delete quote line..."; *)
	SET MENU ITEM PARAMETER:C1004($mainMenu; -1; "--deleteQuoteLine")
	If (Form:C1466.current_quoteLine=Null:C1517)
		DISABLE MENU ITEM:C150($mainMenu; -1)
	End if 
	
	$choose:=Dynamic pop up menu:C1006($mainMenu)
	RELEASE MENU:C978($mainMenu)
	
	
	Case of 
		: ($choose="--addQuoteLine")
			$eQuoteLine:=ds:C1482.QuoteLine.new()
			$eQuoteLine.UUID_Quote:=Form:C1466.current_item.UUID
			$info:=$eQuoteLine.save()
			This:C1470._activate_save_cancel_button()
			Form:C1466.current_quoteLine:=$eQuoteLine
			This:C1470.lb_quoteLines()
			Form:C1466.lb_quoteLines:=ds:C1482.QuoteLine.query("UUID_Quote == :1"; Form:C1466.current_item.UUID)
			LISTBOX SELECT ROW:C912(*; "lb_quoteLines"; Form:C1466.lb_quoteLines.length; lk replace selection:K53:1)
			GOTO OBJECT:C206(*; "entryField_quoteLineQuantity")
			
		: ($choose="--deleteQuoteLine")
			$ok:=cs:C1710.sfw_dialog.me.confirm("Do you really want to delete this quote line? "; "Delete"; "CANCEL")
			If ($ok)
				
				
				
				$info:=Form:C1466.current_quoteLine.drop()
				This:C1470._activate_save_cancel_button()
				LISTBOX SELECT ROW:C912(*; "lb_quoteLines"; 0; lk remove from selection:K53:3)
				Form:C1466.current_quoteLine:=Null:C1517
				This:C1470.lb_quoteLines()
			End if 
			
	End case 
	
	
Function lb_quoteLines()
	
	If (Form:C1466.current_quoteLine=Null:C1517)
		OBJECT SET VISIBLE:C603(*; "label_quoteLine@"; False:C215)
		OBJECT SET VISIBLE:C603(*; "entryField_quoteLineD@"; False:C215)
		
	Else 
		OBJECT SET VISIBLE:C603(*; "label_quoteLine@"; True:C214)
		OBJECT SET VISIBLE:C603(*; "entryField_quoteLineD@"; True:C214)
		
	End if 
	
	
Function _activate_save_cancel_button()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	
Function onBoundVariableChange()
	This:C1470.loadQuoteLines()
	
	If (Form:C1466.current_quoteLine#Null:C1517)
		$index:=Form:C1466.current_quoteLine.indexOf()
		If ($index=-1)
			LISTBOX SELECT ROW:C912(*; "lb_quoteLines"; 0; lk remove from selection:K53:3)
		Else 
			LISTBOX SELECT ROW:C912(*; "lb_quoteLines"; $index+1; lk replace selection:K53:1)
		End if 
	Else 
		LISTBOX SELECT ROW:C912(*; "lb_quoteLines"; 0; lk remove from selection:K53:3)
	End if 
	