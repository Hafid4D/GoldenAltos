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
				
			: (FORM Get current page:C276(*)=2)
				This:C1470.loadAssumptions()
		End case 
	End if 
	
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())  //It's time to resize the object or set visible
		This:C1470.redrawAndSetVisible()
	End if 
	
	
	Case of 
		: (FORM Event:C1606.code=On Bound Variable Change:K2:52)
			This:C1470.onBoundVariableChange()
			
	End case 
	
	
	
Function redrawAndSetVisible()
	//Adjusts the layout and visibility of form elements based on the current page and modification state
	OBJECT SET VISIBLE:C603(*; "bActionQuoteLines"; Form:C1466.sfw.checkIsInModification())
	OBJECT SET VISIBLE:C603(*; "bActionAssumptions"; Form:C1466.sfw.checkIsInModification())
	
Function loadQuoteLines()
	Form:C1466.lb_quoteLines:=Form:C1466.current_item.lines
	This:C1470.displayQuoteLine()
	
Function bActionQuoteLines()
	$mainMenu:=Create menu:C408
	
	APPEND MENU ITEM:C411($mainMenu; "Add quote line..."; *)
	SET MENU ITEM PARAMETER:C1004($mainMenu; -1; "--addQuoteLine")
	SET MENU ITEM SHORTCUT:C423($mainMenu; -1; "L"; Command key mask:K16:1)
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
			This:C1470.displayQuoteLine()
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
				This:C1470.displayQuoteLine()
			End if 
			
	End case 
	
Function displayQuoteLine()
	If (Form:C1466.current_quoteLine=Null:C1517)
		OBJECT SET VISIBLE:C603(*; "label_quoteLine@"; False:C215)
		OBJECT SET VISIBLE:C603(*; "entryField_quoteLine@"; False:C215)
		
	Else 
		OBJECT SET VISIBLE:C603(*; "label_quoteLine@"; True:C214)
		OBJECT SET VISIBLE:C603(*; "entryField_quoteLine@"; True:C214)
		
	End if 
	
Function loadAssumptions()
	Form:C1466.lb_assumptions:=ds:C1482.Assumption.query("UUID in :1"; Form:C1466.current_item.assumptions.UUIDs)
	
Function bActionAssumptions()
	$mainMenu:=Create menu:C408
	
	APPEND MENU ITEM:C411($mainMenu; "Add assumption..."; *)
	SET MENU ITEM PARAMETER:C1004($mainMenu; -1; "--addAssumption")
	APPEND MENU ITEM:C411($mainMenu; "-")
	
	APPEND MENU ITEM:C411($mainMenu; "Delete quote line..."; *)
	SET MENU ITEM PARAMETER:C1004($mainMenu; -1; "--deleteAssumption")
	
	$choose:=Dynamic pop up menu:C1006($mainMenu)
	RELEASE MENU:C978($mainMenu)
	
	
	Case of 
		: ($choose="--addAssumption")
			$form:=New object:C1471()
			
			$form.lb_assumptions:=New collection:C1472()
			For each ($eAssumption; ds:C1482.Assumption.query("not(UUID in :1)"; Form:C1466.current_item.assumptions.UUIDs))
				$assumption:=$eAssumption.toObject()
				$selected:=(Form:C1466.current_item.assumptions.UUIDs.indexOf($eAssumption.UUID)#-1)
				$assumption.selected:=False:C215
				//$assumption.meta:=New object
				//If ($selected)
				//$assumption.meta.unselectable:=True
				//$assumption.meta.disabled:=True
				//End if 
				
				$form.lb_assumptions.push($assumption)
			End for each 
			$ref:=Open form window:C675("Quote_chooseAssumption"; Sheet form window:K39:12)
			DIALOG:C40("Quote_chooseAssumption"; $form)
			CLOSE WINDOW:C154($ref)
			If (ok=1)
				For each ($assumption; $form.lb_assumptions)
					If ($assumption.selected)
						Form:C1466.current_item.assumptions.UUIDs.push($assumption.UUID)
					End if 
				End for each 
				This:C1470.loadAssumptions()
				cs:C1710.panel_quote.me._activate_save_cancel_button()
			End if 
			
		: ($choose="--deleteQuoteLine") & False:C215
			$ok:=cs:C1710.sfw_dialog.me.confirm("Do you really want to delete this quote line? "; "Delete"; "CANCEL")
			If ($ok)
				
				
				
				$info:=Form:C1466.current_quoteLine.drop()
				This:C1470._activate_save_cancel_button()
				LISTBOX SELECT ROW:C912(*; "lb_quoteLines"; 0; lk remove from selection:K53:3)
				Form:C1466.current_quoteLine:=Null:C1517
				This:C1470.displayQuoteLine()
			End if 
			
	End case 
	
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
	