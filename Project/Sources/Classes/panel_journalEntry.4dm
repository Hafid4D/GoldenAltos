// Purpose: Panel controller for Journal Entries (GL ledger view + manual adjusting entries).
// created by 4D/PS [2026-june-29]
singleton Class constructor

Function _activate_save_cancel_button()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID

Function formMethod()
	Form:C1466.sfw.panelFormMethod()
	If (Form:C1466.sfw.updateOfPanelNeeded())
		This:C1470.initFormState()
		This:C1470.loadPanelData()
	End if
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())
		Case of
			: (FORM Get current page:C276(*)=1)
				This:C1470.loadPanelData()
		End case
	End if
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())
		This:C1470.redrawAndSetVisible()
	End if

// Purpose: Initialize Form variables for journal lines and totals.
// created by 4D/PS [2026-june-29]
Function initFormState()
	If (Form:C1466.journalEntryLines=Null:C1517)
		Form:C1466.journalEntryLines:=New collection:C1472()
	End if
	If (Form:C1466.journalEntryLinesSelected=Null:C1517)
		Form:C1466.journalEntryLinesSelected:=New collection:C1472()
	End if
	If (Form:C1466.journalTotalDebit=Null:C1517)
		Form:C1466.journalTotalDebit:=0
	End if
	If (Form:C1466.journalTotalCredit=Null:C1517)
		Form:C1466.journalTotalCredit:=0
	End if
	If (Form:C1466.current_item#Null:C1517) && (Form:C1466.situation.mode="add")
		Form:C1466.current_item._initOnCreation()
		// Purpose: Default journal date and work variable for calendar picker (same pattern as panel_deposit).
		// modified by 4D/PS [2026-june-29]
		If (Form:C1466.current_item.journalDate=Null:C1517) || (Form:C1466.current_item.journalDate=!00-00-00!)
			Form:C1466.current_item.journalDate:=Current date:C33(*)
		End if
		Form:C1466.panelJournalWorkDate:=Form:C1466.current_item.journalDate
	End if

// Purpose: Load journal lines when the panel page is displayed or the item changes.
// created by 4D/PS [2026-june-29]
Function loadPanelData()
	This:C1470.initFormState()
	If (Form:C1466.situation.mode="add")
		If (Form:C1466.journalEntryLines.length=0)
			This:C1470.addLine()
		End if
	Else
		If (Form:C1466.current_item#Null:C1517)
			Form:C1466.journalEntryLines:=_ga_jeLoadLines(Form:C1466.current_item)
			Form:C1466.journalTotalDebit:=Num:C11(Form:C1466.current_item.totalDebit)
			Form:C1466.journalTotalCredit:=Num:C11(Form:C1466.current_item.totalCredit)
			Form:C1466.panelJournalWorkDate:=Form:C1466.current_item.journalDate
		End if
	End if
	_ga_jeRecalcTotals()
	_ga_jeTouchCollections()

Function redrawAndSetVisible()
	var $editable : Boolean
	var $widthSubform : Integer
	var $heightSubform : Integer
	var $g : Integer
	var $h : Integer
	var $d : Integer
	var $b : Integer
	
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($widthSubform; $heightSubform)
	$editable:=This:C1470._canEdit()
	
	// Purpose: Subform container size can be 0 on first draw — use a safe minimum for layout math.
	// modified by 4D/PS [2026-june-29]
	If ($widthSubform<780)
		$widthSubform:=780
	End if
	If ($heightSubform<400)
		$heightSubform:=400
	End if
	
	OBJECT GET COORDINATES:C663(*; "header_bkgd5"; $g; $h; $d; $b)
	OBJECT SET COORDINATES:C1248(*; "header_bkgd5"; $g; $h; $widthSubform; $heightSubform)
	
	// Purpose: Header fields stay on page 0 but remain visible on the Main tab — layout on every redraw.
	// modified by 4D/PS [2026-june-29]
	This:C1470._layoutHeaderFields($widthSubform)
	
	OBJECT SET ENABLED:C1123(*; "entryField_journalDate"; $editable)
	OBJECT SET ENABLED:C1123(*; "btn_journalDate"; $editable)
	OBJECT SET ENABLED:C1123(*; "entryField_memo"; $editable)
	OBJECT SET ENABLED:C1123(*; "lb_journalLines"; $editable)
	OBJECT SET ENABLED:C1123(*; "btn_addLine"; $editable)
	OBJECT SET ENABLED:C1123(*; "btn_removeLine"; $editable)
	OBJECT SET ENABLED:C1123(*; "btn_pickDebit"; $editable)
	OBJECT SET ENABLED:C1123(*; "btn_pickCredit"; $editable)
	
	OBJECT SET VISIBLE:C603(*; "btn_addLine"; $editable)
	OBJECT SET VISIBLE:C603(*; "btn_removeLine"; $editable)
	OBJECT SET VISIBLE:C603(*; "btn_pickDebit"; $editable)
	OBJECT SET VISIBLE:C603(*; "btn_pickCredit"; $editable)
	
	Case of
		: (FORM Get current page:C276(*)=1)
			This:C1470._layoutMainPage($widthSubform; $heightSubform)
	End case

Function _canEdit()->$can : Boolean
	$can:=False:C215
	If (Form:C1466.situation.mode="add")
		$can:=True:C214
	End if

// Purpose: Position header fields on page 0 (visible across tabs) per mockup layout.
// modified by 4D/PS [2026-june-29]
Function _layoutHeaderFields($widthSubform : Integer)
	var $margin : Integer
	var $labelColW : Integer
	var $headerFieldLeft : Integer
	var $hdrFieldWidth : Integer
	var $dateFieldW : Integer
	var $dateLabelLeft : Integer
	var $dateFieldLeft : Integer
	var $subformWidth : Integer
	var $minDateLabelLeft : Integer
	var $btnSize : Integer
	var $dateBlockW : Integer
	
	$margin:=8
	$labelColW:=120
	$headerFieldLeft:=142
	$subformWidth:=$widthSubform
	If ($subformWidth<780)
		$subformWidth:=780
	End if
	$hdrFieldWidth:=$subformWidth-$headerFieldLeft-$margin
	If ($hdrFieldWidth<200)
		$hdrFieldWidth:=200
	End if
	
	// Purpose: Place Journal Date and calendar on the same row as Journal #, aligned to the right (deposit pattern).
	// modified by 4D/PS [2026-june-29]
	$dateFieldW:=100
	$btnSize:=17
	$dateBlockW:=$labelColW+$dateFieldW+4+$btnSize
	$dateLabelLeft:=$subformWidth-$dateBlockW-$margin
	$minDateLabelLeft:=$headerFieldLeft+100
	If ($dateLabelLeft<$minDateLabelLeft)
		$dateLabelLeft:=$minDateLabelLeft
	End if
	$dateFieldLeft:=$dateLabelLeft+$labelColW
	
	OBJECT SET COORDINATES:C1248(*; "label_entryNumber"; 12; 12; 132; 29)
	OBJECT SET COORDINATES:C1248(*; "entryField_entryNumber"; $headerFieldLeft; 12; $headerFieldLeft+80; 29)
	OBJECT SET COORDINATES:C1248(*; "label_journalDate"; $dateLabelLeft; 12; $dateLabelLeft+$labelColW; 29)
	OBJECT SET COORDINATES:C1248(*; "entryField_journalDate"; $dateFieldLeft; 12; $dateFieldLeft+$dateFieldW; 29)
	OBJECT SET COORDINATES:C1248(*; "btn_journalDate"; $dateFieldLeft+$dateFieldW+4; 12; $dateFieldLeft+$dateFieldW+4+$btnSize; 12+$btnSize)
	
	OBJECT SET COORDINATES:C1248(*; "label_transactionType"; 12; 37; 132; 54)
	OBJECT SET COORDINATES:C1248(*; "entryField_transactionType"; $headerFieldLeft; 37; $headerFieldLeft+180; 54)
	OBJECT SET COORDINATES:C1248(*; "label_transactionNum"; $dateLabelLeft; 37; $dateLabelLeft+$labelColW; 54)
	OBJECT SET COORDINATES:C1248(*; "entryField_transactionNum"; $dateFieldLeft; 37; $dateFieldLeft+120; 54)
	
	OBJECT SET COORDINATES:C1248(*; "label_memo"; 12; 62; 132; 79)
	OBJECT SET COORDINATES:C1248(*; "entryField_memo"; $headerFieldLeft; 62; $headerFieldLeft+$hdrFieldWidth; 79)

// Purpose: Position main-tab listbox, action buttons and totals below the header band.
// modified by 4D/PS [2026-june-29]
Function _layoutMainPage($widthSubform : Integer; $heightSubform : Integer)
	var $margin : Integer
	var $rowH : Integer
	var $bottomMargin : Integer
	var $footerContentH : Integer
	var $footerTop : Integer
	var $btnTop : Integer
	var $btnRowH : Integer
	var $btnGap : Integer
	var $lbTop : Integer
	var $lbBottom : Integer
	var $lbH : Integer
	var $y : Integer
	var $totalLabelW : Integer
	var $totalValW : Integer
	var $minListboxWidth : Integer
	var $subformHeight : Integer
	var $minLbH : Integer
	
	$margin:=8
	$rowH:=20
	$btnRowH:=22
	$btnGap:=4
	$totalLabelW:=120
	$totalValW:=120
	$minListboxWidth:=720
	$bottomMargin:=44
	$footerContentH:=56
	$minLbH:=120
	$subformHeight:=$heightSubform
	If ($subformHeight<400)
		$subformHeight:=400
	End if
	
	OBJECT SET COORDINATES:C1248(*; "header_bkgd_main"; 0; 114; $widthSubform; 144)
	
	$y:=148
	OBJECT SET COORDINATES:C1248(*; "lbl_journalLines"; $margin; $y; $margin+240; $y+$rowH)
	$lbTop:=$y+$rowH+4
	
	$footerTop:=$subformHeight-$bottomMargin-$footerContentH
	$btnTop:=$footerTop-$btnGap-$btnRowH
	
// Purpose: Listbox fills available space above totals; browse mode has no button row below it.
// modified by 4D/PS [2026-june-26]
	If (Form:C1466.situation.mode="add")
		$lbBottom:=$btnTop-$btnGap
	Else
		$lbBottom:=$footerTop-8
	End if
	
	$lbH:=$lbBottom-$lbTop
	If ($lbH<$minLbH)
		$lbBottom:=$lbTop+$minLbH
	End if
	
	OBJECT SET COORDINATES:C1248(*; "lb_journalLines"; $margin; $lbTop; $margin+$minListboxWidth; $lbBottom)
	
	If (Form:C1466.situation.mode="add")
		OBJECT SET COORDINATES:C1248(*; "btn_addLine"; $margin; $btnTop; $margin+80; $btnTop+$btnRowH)
		OBJECT SET COORDINATES:C1248(*; "btn_removeLine"; $margin+88; $btnTop; $margin+168; $btnTop+$btnRowH)
		OBJECT SET COORDINATES:C1248(*; "btn_pickDebit"; $margin+176; $btnTop; $margin+276; $btnTop+$btnRowH)
		OBJECT SET COORDINATES:C1248(*; "btn_pickCredit"; $margin+284; $btnTop; $margin+384; $btnTop+$btnRowH)
	End if
	
	This:C1470._placeRightTotal("lbl_totalDebit"; "val_totalDebit"; $footerTop; $widthSubform; $margin; $rowH; $totalLabelW; $totalValW)
	This:C1470._placeRightTotal("lbl_totalCredit"; "val_totalCredit"; $footerTop+26; $widthSubform; $margin; $rowH; $totalLabelW; $totalValW)

// Purpose: Position a label/value total pair aligned to the right edge of the main tab.
// modified by 4D/PS [2026-june-29]
Function _placeRightTotal($labelObj : Text; $valueObj : Text; $y : Integer; $widthSubform : Integer; $margin : Integer; $rowH : Integer; $labelW : Integer; $valW : Integer)
	var $right : Integer
	
	$right:=$widthSubform-$margin
	OBJECT SET COORDINATES:C1248(*; $labelObj; $right-$labelW-$valW-8; $y; $right-$valW-4; $y+$rowH)
	OBJECT SET COORDINATES:C1248(*; $valueObj; $right-$valW; $y; $right; $y+$rowH)

Function addLine()
	var $line : Object
	If (This:C1470._canEdit())
		$line:=New object:C1471(\
			"lineNumber"; Form:C1466.journalEntryLines.length+1; \
			"UUID_CAO_debit"; ""; \
			"UUID_CAO_credit"; ""; \
			"debitAccountName"; ""; \
			"creditAccountName"; ""; \
			"debitAmount"; 0; \
			"creditAmount"; 0; \
			"entityName"; ""; \
			"description"; "")
		Form:C1466.journalEntryLines.push($line)
		This:C1470._renumberLines()
		_ga_jeRecalcTotals()
		_ga_jeTouchCollections()
	End if

Function removeLine()
	var $line : Object
	var $idx : Integer
	If (This:C1470._canEdit())
		If (Form:C1466.journalEntryLinesSelected#Null:C1517) && (Form:C1466.journalEntryLinesSelected.length>0)
			For each ($line; Form:C1466.journalEntryLinesSelected)
				$idx:=Form:C1466.journalEntryLines.indexOf($line)
				If ($idx>=0)
					Form:C1466.journalEntryLines.remove($idx)
				End if
			End for each
			Form:C1466.journalEntryLinesSelected:=New collection:C1472()
			This:C1470._renumberLines()
			_ga_jeRecalcTotals()
			_ga_jeTouchCollections()
		End if
	End if

Function pickDebitAccount()
	If (This:C1470._canEdit())
		_ga_jePickAccount("debit")
		_ga_jeRecalcTotals()
	End if

Function pickCreditAccount()
	If (This:C1470._canEdit())
		_ga_jePickAccount("credit")
		_ga_jeRecalcTotals()
	End if

Function onJournalLinesChange()
	var $line : Object
	If (This:C1470._canEdit())
		// Purpose: Keep debit and credit equal on each line (legacy AccTransaction single-amount model).
		// modified by 4D/PS [2026-june-29]
		For each ($line; Form:C1466.journalEntryLines)
			If (Num:C11($line.debitAmount)>0) && (Num:C11($line.creditAmount)=0)
				$line.creditAmount:=$line.debitAmount
			Else
				If (Num:C11($line.creditAmount)>0) && (Num:C11($line.debitAmount)=0)
					$line.debitAmount:=$line.creditAmount
				End if
			End if
		End for each
		_ga_jeRecalcTotals()
		_ga_jeTouchCollections()
		cs:C1710.panel_journalEntry.me._activate_save_cancel_button()
	End if

Function _renumberLines()
	var $line : Object
	var $i : Integer
	$i:=0
	For each ($line; Form:C1466.journalEntryLines)
		$i:=$i+1
		$line.lineNumber:=$i
	End for each
