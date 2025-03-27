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
				This:C1470.loadTermsConditions()
				
			: (FORM Get current page:C276(*)=4)
				This:C1470.buildQuotePreview()
				
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
	OBJECT SET VISIBLE:C603(*; "bActionTerms"; Form:C1466.sfw.checkIsInModification())
	
	This:C1470.drawPup_quoteStatus()
	
Function loadQuoteLines()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.lb_quoteLines:=Form:C1466.current_item.lines
		This:C1470.displayQuoteLine()
	End if 
	
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
	$plurial:=Form:C1466.selected_assumptions.length>1 ? True:C214 : False:C215
	
	APPEND MENU ITEM:C411($mainMenu; "Add assumption..."; *)
	SET MENU ITEM PARAMETER:C1004($mainMenu; -1; "--addAssumption")
	APPEND MENU ITEM:C411($mainMenu; "-")
	
	APPEND MENU ITEM:C411($mainMenu; "Remove the assumption"+($plurial ? "s" : "")+"..."; *)
	SET MENU ITEM PARAMETER:C1004($mainMenu; -1; "--deleteAssumption")
	If (Form:C1466.current_assumption=Null:C1517)
		DISABLE MENU ITEM:C150($mainMenu; -1)
	End if 
	
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
			
		: ($choose="--deleteAssumption")
			$ok:=cs:C1710.sfw_dialog.me.confirm("Do you really want to remove the assumption"+($plurial ? "s" : "")+" from the quote? "; "Delete"; "CANCEL")
			
			If ($ok)
				For each ($selected_assumption; Form:C1466.selected_assumptions)
					$index:=Form:C1466.current_item.assumptions.UUIDs.indexOf($selected_assumption.UUID)
					If ($index#-1)
						Form:C1466.current_item.assumptions.UUIDs.remove($index)
					End if 
				End for each 
				This:C1470.loadAssumptions()
				cs:C1710.panel_quote.me._activate_save_cancel_button()
			End if 
			
	End case 
	
Function loadTermsConditions()
	Form:C1466.lb_terms:=ds:C1482.TermCondition.query("UUID in :1"; Form:C1466.current_item.termsConditions.UUIDs)
	
Function bActionTerms()
	$mainMenu:=Create menu:C408
	$plurial:=Form:C1466.selected_assumptions.length>1 ? True:C214 : False:C215
	
	APPEND MENU ITEM:C411($mainMenu; "Add term and condition..."; *)
	SET MENU ITEM PARAMETER:C1004($mainMenu; -1; "--addTermCondition")
	APPEND MENU ITEM:C411($mainMenu; "-")
	
	APPEND MENU ITEM:C411($mainMenu; "Remove the term"+($plurial ? "s" : "")+"..."; *)
	SET MENU ITEM PARAMETER:C1004($mainMenu; -1; "--deleteTermCondition")
	If (Form:C1466.current_term=Null:C1517)
		DISABLE MENU ITEM:C150($mainMenu; -1)
	End if 
	
	$choose:=Dynamic pop up menu:C1006($mainMenu)
	RELEASE MENU:C978($mainMenu)
	
	
	Case of 
		: ($choose="--addTermCondition")
			$form:=New object:C1471()
			
			$form.lb_terms:=New collection:C1472()
			For each ($eTerm; ds:C1482.TermCondition.query("not(UUID in :1)"; Form:C1466.current_item.termsConditions.UUIDs))
				$term:=$eTerm.toObject()
				$selected:=(Form:C1466.current_item.termsConditions.UUIDs.indexOf($eTerm.UUID)#-1)
				$term.selected:=False:C215
				
				$form.lb_terms.push($term)
			End for each 
			$ref:=Open form window:C675("Quote_chooseTerm"; Sheet form window:K39:12)
			DIALOG:C40("Quote_chooseTerm"; $form)
			CLOSE WINDOW:C154($ref)
			If (ok=1)
				For each ($term; $form.lb_terms)
					If ($term.selected)
						Form:C1466.current_item.termsConditions.UUIDs.push($term.UUID)
					End if 
				End for each 
				This:C1470.loadTermsConditions()
				cs:C1710.panel_quote.me._activate_save_cancel_button()
			End if 
			
		: ($choose="--deleteTermCondition")
			$ok:=cs:C1710.sfw_dialog.me.confirm("Do you really want to remove the term"+($plurial ? "s" : "")+" from the quote? "; "Delete"; "CANCEL")
			
			If ($ok)
				For each ($selected_term; Form:C1466.selected_terms)
					$index:=Form:C1466.current_item.termsConditions.UUIDs.indexOf($selected_term.UUID)
					If ($index#-1)
						Form:C1466.current_item.termsConditions.UUIDs.remove($index)
					End if 
				End for each 
				This:C1470.loadTermsConditions()
				cs:C1710.panel_quote.me._activate_save_cancel_button()
			End if 
			
	End case 
	
Function buildQuotePreview()
	Form:C1466.preview:=WP New:C1317()
	$headerLogoFile:=Folder:C1567(fk resources folder:K87:11).file("picts_GA/HeaderPortrait.jpeg")
	If ($headerLogoFile.exists)
		$headerLogoBlob:=$headerLogoFile.getContent()
		BLOB TO PICTURE:C682($headerLogoBlob; $headerLogoPict)
	End if 
	
	$section:=WP Get section:C1581(Form:C1466.preview; 1)
	
	$header:=WP New header:C1586($section)
	WP INSERT PICTURE:C1437($header; $headerLogoPict; wk append:K81:179)
	
	$footer:=WP New footer:C1587($section)
	WP SET TEXT:C1574($footer; "CONFIDENTIAL. For the exclusive use og the customer named herein. Please destroy or return to sender immediately if you are not the customer named."; wk append:K81:179)
	
	$leftTxtBox:=WP New text box:C1797(Form:C1466.preview; 1)
	WP SET ATTRIBUTES:C1342($leftTxtBox; wk margin top:K81:13; "100pt")
	WP SET ATTRIBUTES:C1342($leftTxtBox; wk margin left:K81:11; "11cm")
	WP SET ATTRIBUTES:C1342($leftTxtBox; wk border color:K81:34; "white")
	WP SET ATTRIBUTES:C1342($leftTxtBox; wk width:K81:45; "9cm")
	WP SET TEXT:C1574($leftTxtBox; "Quotation#: Q294\tRevision: R\tDated: 6/9/2023"; wk append:K81:179)
	WP INSERT BREAK:C1413($leftTxtBox; wk line break:K81:186; wk append:K81:179)
	WP INSERT BREAK:C1413($leftTxtBox; wk line break:K81:186; wk append:K81:179)
	WP SET TEXT:C1574($leftTxtBox; "From: Ben Mendoza"; wk append:K81:179)
	WP INSERT BREAK:C1413($leftTxtBox; wk line break:K81:186; wk append:K81:179)
	WP SET TEXT:C1574($leftTxtBox; "\tbmendoza@goldenaltos.com"; wk append:K81:179)
	WP INSERT BREAK:C1413($leftTxtBox; wk line break:K81:186; wk append:K81:179)
	WP SET TEXT:C1574($leftTxtBox; "\tel: 408-569-1010"; wk append:K81:179)
	WP INSERT BREAK:C1413($leftTxtBox; wk line break:K81:186; wk append:K81:179)
	WP INSERT BREAK:C1413($leftTxtBox; wk line break:K81:186; wk append:K81:179)
	WP SET TEXT:C1574($leftTxtBox; "Copy: Rosie Medina"; wk append:K81:179)
	WP INSERT BREAK:C1413($leftTxtBox; wk line break:K81:186; wk append:K81:179)
	WP SET TEXT:C1574($leftTxtBox; "\trosimedina@goldenaltos.com"; wk append:K81:179)
	
	$paragraph:=WP Get elements:C1550($section; wk type paragraph:K81:191)[0]
	WP SET ATTRIBUTES:C1342($paragraph; wk width:K81:45; "7cm")
	
	WP SET TEXT:C1574($paragraph; Form:C1466.current_item.contact.fullName; wk append:K81:179)
	WP INSERT BREAK:C1413($paragraph; wk line break:K81:186; wk append:K81:179)
	WP SET TEXT:C1574($paragraph; "Sandia National Laboratories"; wk append:K81:179)
	WP INSERT BREAK:C1413($paragraph; wk line break:K81:186; wk append:K81:179)
	WP SET TEXT:C1574($paragraph; "Po Box 5800, Albuqyerque NM97 185-1484 Po Box 5800, Albuqyerque "; wk append:K81:179)
	WP INSERT BREAK:C1413($paragraph; wk line break:K81:186; wk append:K81:179)
	WP INSERT BREAK:C1413($paragraph; wk line break:K81:186; wk append:K81:179)
	WP SET TEXT:C1574($paragraph; "Tel: (505)845-0596"; wk append:K81:179)
	WP INSERT BREAK:C1413($paragraph; wk line break:K81:186; wk append:K81:179)
	WP SET TEXT:C1574($paragraph; "Email: mcline@sandia.gov"; wk append:K81:179)
	
	WP INSERT BREAK:C1413($section; wk paragraph break:K81:259; wk append:K81:179)
	$paragraph:=WP Get elements:C1550($section; wk type paragraph:K81:191)[1]
	WP SET ATTRIBUTES:C1342($paragraph; wk width:K81:45; "auto")
	
	WP INSERT BREAK:C1413($paragraph; wk line break:K81:186; wk append:K81:179)
	WP INSERT BREAK:C1413($paragraph; wk line break:K81:186; wk append:K81:179)
	WP SET TEXT:C1574($paragraph; "Subject:\tPlastic Qualification And DPA"; wk append:K81:179)
	WP INSERT BREAK:C1413($paragraph; wk line break:K81:186; wk append:K81:179)
	WP SET TEXT:C1574($paragraph; "Reference:\tPS4A2702"; wk append:K81:179)
	
	WP INSERT BREAK:C1413($paragraph; wk line break:K81:186; wk append:K81:179)
	WP INSERT BREAK:C1413($paragraph; wk line break:K81:186; wk append:K81:179)
	WP SET TEXT:C1574($paragraph; "  Dear Mellisa"; wk append:K81:179)
	WP INSERT BREAK:C1413($paragraph; wk line break:K81:186; wk append:K81:179)
	WP SET TEXT:C1574($paragraph; "We are pleased to submit to you the following quotation:"; wk append:K81:179)
	WP INSERT BREAK:C1413($paragraph; wk line break:K81:186; wk append:K81:179)
	
	$table:=WP Insert table:C1473($paragraph; wk append:K81:179; wk include in range:K81:180)
	$tableHeaders:=WP Table append row:C1474($table; "Item#"; "Description"; "Qty"; "Unit-Price"; "Amount")
	
	$numCol:=WP Table get columns:C1476($table; 1)
	$descCol:=WP Table get columns:C1476($table; 2)
	$qtyCol:=WP Table get columns:C1476($table; 3)
	$amountcols:=WP Table get columns:C1476($table; 4; 2)
	
	WP SET ATTRIBUTES:C1342($numCol; wk width:K81:45; "1cm")
	WP SET ATTRIBUTES:C1342($descCol; wk width:K81:45; "9cm")
	WP SET ATTRIBUTES:C1342($qtyCol; wk width:K81:45; "1.5cm")
	WP SET ATTRIBUTES:C1342($amountcols; wk width:K81:45; "2.5cm")
	$index:=1
	For each ($line; Form:C1466.current_item.lines)
		$row:=WP Table append row:C1474($table; String:C10($index); $line.description; $line.quantity; $line.unitPrice; $line.quantity*$line.unitPrice)
		$index+=1
	End for each 
	
	
	WP INSERT BREAK:C1413($section; wk paragraph break:K81:259; wk append:K81:179)
	$paragraphs:=WP Get elements:C1550($section; wk type paragraph:K81:191)
	$paragraph:=$paragraphs[$paragraphs.length-1]
	WP SET ATTRIBUTES:C1342($paragraph; wk width:K81:45; "auto")
	WP INSERT DOCUMENT:C1411($paragraph; Form:C1466.current_item.optionalPreliminaryTxt_wr; wk append:K81:179)
	
	
	$paragraphs:=WP Get elements:C1550($section; wk type paragraph:K81:191)
	$paragraph:=$paragraphs[$paragraphs.length-1]
	
	$assumptions:=ds:C1482.Assumption.query("UUID in :1"; Form:C1466.current_item.assumptions.UUIDs)
	If ($assumptions.length#0)
		WP INSERT BREAK:C1413($paragraph; wk line break:K81:186; wk append:K81:179)
		WP INSERT BREAK:C1413($paragraph; wk line break:K81:186; wk append:K81:179)
		WP INSERT BREAK:C1413($paragraph; wk line break:K81:186; wk append:K81:179)
		WP SET TEXT:C1574($paragraph; "Assumptions:"; wk append:K81:179)
		WP INSERT BREAK:C1413($paragraph; wk line break:K81:186; wk append:K81:179)
		
		For each ($assumption; $assumptions)
			WP SET TEXT:C1574($paragraph; " - "+$assumption.value; wk append:K81:179)
			WP INSERT BREAK:C1413($paragraph; wk line break:K81:186; wk append:K81:179)
		End for each 
	End if 
	
	
	$conditions:=ds:C1482.TermCondition.query("UUID in :1"; Form:C1466.current_item.termsConditions.UUIDs)
	If ($conditions.length#0)
		WP INSERT BREAK:C1413($section; wk page break:K81:188; wk append:K81:179)
		WP INSERT BREAK:C1413($section; wk paragraph break:K81:259; wk append:K81:179)
		$paragraphs:=WP Get elements:C1550($section; wk type paragraph:K81:191)
		$paragraph:=$paragraphs[$paragraphs.length-1]
		WP SET TEXT:C1574($paragraph; "GOLDEN ALTOS"; wk append:K81:179)
		WP SET ATTRIBUTES:C1342($paragraph; wk text align:K81:49; wk center:K81:99)
		WP INSERT BREAK:C1413($paragraph; wk line break:K81:186; wk append:K81:179)
		WP SET TEXT:C1574($paragraph; "Terms and conditions of sales"; wk append:K81:179)
		WP INSERT BREAK:C1413($paragraph; wk line break:K81:186; wk append:K81:179)
		
		WP SET ATTRIBUTES:C1342($paragraph; wk text color:K81:64; "grey")
		
		WP INSERT BREAK:C1413($section; wk paragraph break:K81:259; wk append:K81:179)
		$paragraphs:=WP Get elements:C1550($section; wk type paragraph:K81:191)
		$paragraph:=$paragraphs[$paragraphs.length-1]
		
		$index:=1
		For each ($condition; $conditions)
			WP SET TEXT:C1574($paragraph; String:C10($index)+".  "+$condition.code+": "+$condition.value; wk append:K81:179)
			WP INSERT BREAK:C1413($paragraph; wk line break:K81:186; wk append:K81:179)
			$index+=1
		End for each 
		WP SET ATTRIBUTES:C1342($paragraph; wk text align:K81:49; wk left:K81:95)
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
	
Function pup_status()
	var $eQuoteStatus : cs:C1710.QuoteStatusEntity
	
	If (Form:C1466.sfw.checkIsInModification())
		$menu:=Create menu:C408
		If (Storage:C1525.cache=Null:C1517) || (Storage:C1525.cache.quoteStatus=Null:C1517)
			ds:C1482.QuoteStatus.cacheLoad()
		End if 
		
		For each ($eQuoteStatus; Storage:C1525.cache.quoteStatus)
			APPEND MENU ITEM:C411($menu; $eQuoteStatus.code+" - "+$eQuoteStatus.name; *)
			SET MENU ITEM PARAMETER:C1004($menu; -1; $eQuoteStatus.UUID)
			If ($eQuoteStatus.statusID=Form:C1466.current_item.currentStatusID)
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
				$eQuoteStatus:=ds:C1482.QuoteStatus.get($choose)
				Form:C1466.current_item.currentStatusID:=$eQuoteStatus.statusID
		End case 
		
	End if 
	This:C1470.drawPup_quoteStatus()
	
Function drawPup_quoteStatus()
	If (Form:C1466.current_item#Null:C1517)
		$quoteStatus:=ds:C1482.QuoteStatus.query("statusID= :1"; Form:C1466.current_item.currentStatusID).first() || New object:C1471()
		$parts:=New collection:C1472($quoteStatus.code; $quoteStatus.name)
		$statusName:=$parts.join(" - "; ck ignore null or empty:K85:5)
		If ($statusName="")
			$statusName:="Status"
		End if 
		$color:=cs:C1710.sfw_htmlColor.me.getName($quoteStatus.color)
		$pathIcon:=($color#"") ? "sfw/colors/"+$color+"-circle.png" : "sfw/image/skin/rainbow/icon/spacer-1x24.png"
		Form:C1466.sfw.drawButtonPup("pup_quoteStatus"; $statusName; $pathIcon; ($quoteStatus=Null:C1517))
	End if 