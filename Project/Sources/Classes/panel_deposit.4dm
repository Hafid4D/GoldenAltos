// Purpose: Panel controller for Deposits entry (QuickBooks-style bank deposit).
// created by 4D/PS [2026-june-22]
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

// Purpose: Initialize Form variables and default header values for a new deposit.
// modified by 4D/PS [2026-june-23]
Function initFormState()
	If (Form:C1466.depositPaymentLines=Null:C1517)
		Form:C1466.depositPaymentLines:=New collection:C1472()
	End if
	If (Form:C1466.depositOtherFundLines=Null:C1517)
		Form:C1466.depositOtherFundLines:=New collection:C1472()
	End if
	// Purpose: Collection listbox selection (4D v20 — no LB Get selected rows on collection listboxes).
	// modified by 4D/PS [2026-june-23]
	If (Form:C1466.depositOtherFundLinesSelected=Null:C1517)
		Form:C1466.depositOtherFundLinesSelected:=New collection:C1472()
	End if
	If (Form:C1466.depositSelectedPaymentsTotal=Null:C1517)
		Form:C1466.depositSelectedPaymentsTotal:=0
	End if
	If (Form:C1466.depositOtherFundsTotal=Null:C1517)
		Form:C1466.depositOtherFundsTotal:=0
	End if
	If (Form:C1466.depositGrandTotal=Null:C1517)
		Form:C1466.depositGrandTotal:=0
	End if
	If (Form:C1466.depositNetToBank=Null:C1517)
		Form:C1466.depositNetToBank:=0
	End if
	// Purpose: Panel payment-line filters (same pattern as panel_lead.interactons_filters).
	// modified by 4D/PS [2026-june-23]
	If (Form:C1466.situation.mode="add")
		If (Form:C1466.depositLine_filters=Null:C1517)
			Form:C1466.depositLine_filters:=New object:C1471
		End if
		If (Form:C1466.depositLine_filters.customer=Null:C1517)
			Form:C1466.depositLine_filters.customer:=New collection:C1472()
		End if
	End if
	If (Form:C1466.current_item#Null:C1517) && (Form:C1466.situation.mode="add")
		Form:C1466.current_item._initOnCreation()
		If (Form:C1466.current_item.depositDate=Null:C1517) || (Form:C1466.current_item.depositDate=!00-00-00!)
			Form:C1466.current_item.depositDate:=Current date:C33(*)
		End if
		Form:C1466.panelDepositWorkDate:=Form:C1466.current_item.depositDate
	End if

// Purpose: Load payment/other-fund listboxes when the panel page is displayed or the item changes.
// modified by 4D/PS [2026-june-23]
Function loadPanelData()
	var $data : Object
	var $filterUUID : Text
	
	This:C1470.initFormState()
	
	If (Form:C1466.situation.mode="add")
		$filterUUID:=This:C1470._paymentCustomerFilterUUID()
		If (cs:C1710.sfw_string.me.isAnEmptyUUID($filterUUID))
			$filterUUID:=""
		End if
		Form:C1466.depositPaymentLines:=_ga_depositBuildPaymentLines($filterUUID)
	Else
		If (Form:C1466.current_item#Null:C1517)
			$data:=_ga_depositLoadSavedLines(Form:C1466.current_item)
			Form:C1466.depositPaymentLines:=$data.paymentLines
			Form:C1466.depositOtherFundLines:=$data.otherFundLines
			Form:C1466.depositSelectedPaymentsTotal:=Num:C11(Form:C1466.current_item.paymentsTotal)
			Form:C1466.depositOtherFundsTotal:=Num:C11(Form:C1466.current_item.otherFundsTotal)
			Form:C1466.depositGrandTotal:=Num:C11(Form:C1466.current_item.total)
			Form:C1466.depositNetToBank:=Num:C11(Form:C1466.current_item.netToBank)
			// Purpose: Recompute totals from lines when header totals were not stored (older rows).
			// modified by 4D/PS [2026-june-23]
			If (Form:C1466.depositGrandTotal=0) && ((Form:C1466.depositPaymentLines.length>0) || (Form:C1466.depositOtherFundLines.length>0))
				_ga_depositRecalcTotals()
			End if
			Form:C1466.panelDepositWorkDate:=Form:C1466.current_item.depositDate
		End if
	End if
	If (Form:C1466.situation.mode="add")
		_ga_depositRecalcTotals()
	Else
		If ((Form:C1466.depositPaymentLines#Null:C1517) && (Form:C1466.depositPaymentLines.length>0)) || ((Form:C1466.depositOtherFundLines#Null:C1517) && (Form:C1466.depositOtherFundLines.length>0))
			_ga_depositRecalcTotals()
		End if
	End if
	_ga_depositTouchCollections()

// Purpose: Return the optional customer UUID used to filter undeposited PAY lines (empty = all).
// Returns: Text
// modified by 4D/PS [2026-june-26]
Function _paymentCustomerFilterUUID()->$uuid : Text
	$uuid:=""
	If (Form:C1466.depositLine_filters#Null:C1517) && (Form:C1466.depositLine_filters.customer#Null:C1517) && (Form:C1466.depositLine_filters.customer.length>0)
		$uuid:=Form:C1466.depositLine_filters.customer[0]
	End if

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
	
	// Purpose: Subform container size can be 0 on first draw — use a safe minimum for header layout math.
	// modified by 4D/PS [2026-june-23]
	If ($widthSubform<780)
		$widthSubform:=780
	End if
	If ($heightSubform<400)
		$heightSubform:=400
	End if
	
	OBJECT GET COORDINATES:C663(*; "header_bkgd5"; $g; $h; $d; $b)
	OBJECT SET COORDINATES:C1248(*; "header_bkgd5"; $g; $h; $widthSubform; $heightSubform)
	
	This:C1470.drawPup_customer()
	This:C1470.drawPup_bank()
	This:C1470.drawPup_cashBackAccount()
	
	// Purpose: Header fields stay on page 0 but remain visible on the Main tab — layout on every redraw.
	// modified by 4D/PS [2026-june-23]
	This:C1470._layoutHeaderFields($widthSubform)
	
	OBJECT SET ENABLED:C1123(*; "entryField_depositDate"; $editable)
	OBJECT SET ENABLED:C1123(*; "btn_depositDate"; $editable)
	OBJECT SET ENABLED:C1123(*; "pup_customer"; $editable)
	OBJECT SET ENABLED:C1123(*; "pup_bank"; $editable)
	
	// Purpose: Header memo is kept in the data model but hidden to match the deposit mockup layout.
	// modified by 4D/PS [2026-june-23]
	OBJECT SET VISIBLE:C603(*; "label_memo"; False:C215)
	OBJECT SET VISIBLE:C603(*; "entryField_memo"; False:C215)
	// Purpose: Customer filter is creation-only (mockup); hide in browse mode.
	// modified by 4D/PS [2026-june-23]
	OBJECT SET VISIBLE:C603(*; "label_customer"; (Form:C1466.situation.mode="add"))
	OBJECT SET VISIBLE:C603(*; "pup_customer"; (Form:C1466.situation.mode="add"))
	OBJECT SET VISIBLE:C603(*; "lbl_customerHint"; (Form:C1466.situation.mode="add"))
	
	OBJECT SET ENABLED:C1123(*; "lb_paymentLines"; $editable)
	OBJECT SET ENABLED:C1123(*; "lb_otherFundLines"; $editable)
	OBJECT SET ENABLED:C1123(*; "btn_addOtherFund"; $editable)
	OBJECT SET ENABLED:C1123(*; "btn_removeOtherFund"; $editable)
	OBJECT SET ENABLED:C1123(*; "btn_pickOtherFundAccount"; $editable)
	OBJECT SET ENABLED:C1123(*; "btn_pickOtherFundCustomer"; $editable)
	OBJECT SET ENABLED:C1123(*; "entryField_cashBackAmount"; $editable)
	OBJECT SET ENABLED:C1123(*; "entryField_cashBackMemo"; $editable)
	OBJECT SET ENABLED:C1123(*; "pup_cashBackAccount"; $editable)
	
	This:C1470._applyDepositListboxColumns($editable)
	
	Case of
		: (FORM Get current page:C276(*)=1)
			This:C1470._layoutMainPage($widthSubform; $heightSubform)
	End case

// Purpose: Lock listbox column minimum widths so headers stay readable when the panel is resized.
// Parameters: $editable : Boolean — when False (browse), hide the include checkbox column.
// modified by 4D/PS [2026-june-23]
Function _applyDepositListboxColumns($editable : Boolean)
	If ($editable)
		LISTBOX SET COLUMN WIDTH:C833(*; "col_include"; 40; 36)
	Else
		LISTBOX SET COLUMN WIDTH:C833(*; "col_include"; 0; 0)
	End if
	LISTBOX SET COLUMN WIDTH:C833(*; "col_customer"; 140; 100)
	LISTBOX SET COLUMN WIDTH:C833(*; "col_date"; 80; 72)
	LISTBOX SET COLUMN WIDTH:C833(*; "col_type"; 80; 64)
	LISTBOX SET COLUMN WIDTH:C833(*; "col_memo"; 160; 96)
	LISTBOX SET COLUMN WIDTH:C833(*; "col_ref"; 80; 64)
	LISTBOX SET COLUMN WIDTH:C833(*; "col_amount"; 90; 72)
	LISTBOX SET COLUMN WIDTH:C833(*; "col_of_num"; 40; 36)
	LISTBOX SET COLUMN WIDTH:C833(*; "col_of_customer"; 120; 96)
	LISTBOX SET COLUMN WIDTH:C833(*; "col_of_account"; 140; 100)
	LISTBOX SET COLUMN WIDTH:C833(*; "col_of_desc"; 160; 96)
	LISTBOX SET COLUMN WIDTH:C833(*; "col_of_ref"; 80; 64)
	LISTBOX SET COLUMN WIDTH:C833(*; "col_of_amount"; 90; 72)

// Purpose: Return True when the deposit panel accepts user edits (new deposit only).
// Returns: Boolean
// created by 4D/PS [2026-june-22]
Function _canEdit()->$can : Boolean
	$can:=(Form:C1466.situation.mode="add") && (Form:C1466.sfw.checkIsInModification())

Function _layoutHeaderFields($widthSubform : Integer)
	var $left : Integer
	var $top : Integer
	var $right : Integer
	var $bottom : Integer
	var $hdrFieldWidth : Integer
	var $btnSize : Integer
	var $labelColW : Integer
	var $dateFieldW : Integer
	var $dateBlockW : Integer
	var $dateLabelLeft : Integer
	var $dateFieldLeft : Integer
	var $headerFieldLeft : Integer
	var $margin : Integer
	var $subformWidth : Integer
	var $minDateLabelLeft : Integer
	
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
	
	OBJECT GET COORDINATES:C663(*; "pup_customer"; $left; $top; $right; $bottom)
	OBJECT SET COORDINATES:C1248(*; "pup_customer"; $left; $top; $left+$hdrFieldWidth; $bottom)
	OBJECT GET COORDINATES:C663(*; "pup_bank"; $left; $top; $right; $bottom)
	OBJECT SET COORDINATES:C1248(*; "pup_bank"; $left; $top; $left+$hdrFieldWidth; $bottom)
	OBJECT SET COORDINATES:C1248(*; "lbl_customerHint"; $headerFieldLeft; 59; $headerFieldLeft+$hdrFieldWidth; 76)
	
	// Purpose: Place Deposit Date and calendar on the same row as Deposit #, aligned to the right (mockup layout).
	// modified by 4D/PS [2026-june-23]
	$dateFieldW:=100
	$btnSize:=17
	$dateBlockW:=$labelColW+$dateFieldW+4+$btnSize
	$dateLabelLeft:=$subformWidth-$dateBlockW-$margin
	$minDateLabelLeft:=$headerFieldLeft+100
	If ($dateLabelLeft<$minDateLabelLeft)
		$dateLabelLeft:=$minDateLabelLeft
	End if
	$dateFieldLeft:=$dateLabelLeft+$labelColW
	OBJECT SET COORDINATES:C1248(*; "label_depositDate"; $dateLabelLeft; 12; $dateLabelLeft+$labelColW; 29)
	OBJECT SET COORDINATES:C1248(*; "entryField_depositDate"; $dateFieldLeft; 12; $dateFieldLeft+$dateFieldW; 29)
	OBJECT SET COORDINATES:C1248(*; "btn_depositDate"; $dateFieldLeft+$dateFieldW+4; 12; $dateFieldLeft+$dateFieldW+4+$btnSize; 12+$btnSize)
	
	// Purpose: Compact header in browse mode when the customer filter row is hidden.
	// modified by 4D/PS [2026-june-23]
	If (Form:C1466.situation.mode#"add")
		OBJECT SET COORDINATES:C1248(*; "label_account"; 12; 37; 132; 54)
		OBJECT GET COORDINATES:C663(*; "pup_bank"; $left; $top; $right; $bottom)
		OBJECT SET COORDINATES:C1248(*; "pup_bank"; $headerFieldLeft; 34; $headerFieldLeft+$hdrFieldWidth; 57)
	End if

// Purpose: Position a label/value total pair aligned to the right edge of the main tab.
// Parameters:
// $labelObj / $valueObj : Text — form object names
// $y : Integer — top coordinate
// $widthSubform / $margin : Integer — container width and right margin
// $rowH / $labelW / $valW : Integer — row and column widths
// modified by 4D/PS [2026-june-23]
Function _placeRightTotal($labelObj : Text; $valueObj : Text; $y : Integer; $widthSubform : Integer; $margin : Integer; $rowH : Integer; $labelW : Integer; $valW : Integer)
	var $right : Integer
	
	$right:=$widthSubform-$margin
	OBJECT SET COORDINATES:C1248(*; $labelObj; $right-$labelW-$valW-8; $y; $right-$valW-4; $y+$rowH)
	OBJECT SET COORDINATES:C1248(*; $valueObj; $right-$valW; $y; $right; $y+$rowH)

// Purpose: Return True when the Net to bank row should be shown (cash back entered on a new or saved deposit).
// Returns: Boolean
// created by 4D/PS [2026-june-22]
Function _showNetToBank()->$show : Boolean
	var $cashBack : Real
	
	$show:=False:C215
	If (Form:C1466.current_item#Null:C1517)
		$cashBack:=Num:C11(Form:C1466.current_item.cashBackAmount)
		If ($cashBack>0)
			$show:=True:C214
		End if
	End if

Function _layoutMainPage($widthSubform : Integer; $heightSubform : Integer)
	var $margin : Integer
	var $labelLeft : Integer
	var $labelWidth : Integer
	var $fieldLeft : Integer
	var $fieldWidth : Integer
	var $rowH : Integer
	var $footerContentH : Integer
	var $footerTop : Integer
	var $btnTop : Integer
	var $btnRowH : Integer
	var $btnGap : Integer
	var $bottomMargin : Integer
	var $otherLbBottom : Integer
	var $otherLbTop : Integer
	var $minOtherLbH : Integer
	var $reservedBelowPayLb : Integer
	var $maxPayBottom : Integer
	var $payLbTop : Integer
	var $y : Integer
	var $hasPayments : Boolean
	var $payLbH : Integer
	var $showNoPaymentsMsg : Boolean
	var $showNetToBank : Boolean
	var $isAddMode : Boolean
	var $totalLabelW : Integer
	var $totalValW : Integer
	var $addFundsHintH : Integer
	var $selectHintH : Integer
	var $otherLbGap : Integer
	var $subformHeight : Integer
	var $otherLbMaxH : Integer
	var $lineCount : Integer
	var $desiredLbBottom : Integer
	
	$margin:=8
	$labelLeft:=$margin
	$labelWidth:=120
	$fieldLeft:=136
	$rowH:=20
	$totalLabelW:=180
	$totalValW:=120
	$fieldWidth:=$widthSubform-$fieldLeft-$margin
	If ($fieldWidth<240)
		$fieldWidth:=240
	End if
	
	// Purpose: Keep listboxes at a readable width; horizontal scroll when the panel is narrower.
	// modified by 4D/PS [2026-june-23]
	$minListboxWidth:=720
	$isAddMode:=(Form:C1466.situation.mode="add")
	$hasPayments:=(Form:C1466.depositPaymentLines#Null:C1517) && (Form:C1466.depositPaymentLines.length>0)
	$showNoPaymentsMsg:=False:C215
	$showNetToBank:=This:C1470._showNetToBank()
	$selectHintH:=0
	$addFundsHintH:=0
	If ($isAddMode) && ($hasPayments)
		$selectHintH:=18
	End if
	If ($isAddMode)
		$addFundsHintH:=18
	End if
	
	OBJECT SET VISIBLE:C603(*; "lbl_selectPaymentHint"; ($isAddMode) && ($hasPayments))
	OBJECT SET VISIBLE:C603(*; "lbl_addFundsHint"; $isAddMode)
	OBJECT SET VISIBLE:C603(*; "lbl_selectPayment"; $hasPayments)
	OBJECT SET VISIBLE:C603(*; "lb_paymentLines"; $hasPayments)
	OBJECT SET VISIBLE:C603(*; "lbl_selectedPaymentsTotal"; $hasPayments)
	OBJECT SET VISIBLE:C603(*; "val_selectedPaymentsTotal"; $hasPayments)
	OBJECT SET VISIBLE:C603(*; "lbl_noUndeposited"; $showNoPaymentsMsg)
	OBJECT SET VISIBLE:C603(*; "lbl_netToBank"; $showNetToBank)
	OBJECT SET VISIBLE:C603(*; "val_netToBank"; $showNetToBank)
	OBJECT SET VISIBLE:C603(*; "btn_addOtherFund"; $isAddMode)
	OBJECT SET VISIBLE:C603(*; "btn_removeOtherFund"; $isAddMode)
	OBJECT SET VISIBLE:C603(*; "btn_pickOtherFundAccount"; $isAddMode)
	OBJECT SET VISIBLE:C603(*; "btn_pickOtherFundCustomer"; $isAddMode)
	
	// Purpose: Anchor footer from the bottom; shrink footer when Net to bank is hidden (mockup shows Total only).
	// modified by 4D/PS [2026-june-23]
	// Purpose: Reserve space for the SFW bottom toolbar so Total stays visible.
	// modified by 4D/PS [2026-june-23]
	$bottomMargin:=44
	$footerContentH:=132
	If ($showNetToBank)
		$footerContentH:=158
	End if
	$btnRowH:=22
	$btnGap:=4
	$minOtherLbH:=48
	$reservedBelowPayLb:=$rowH+2+$selectHintH+$rowH+2+$minOtherLbH+$btnGap+$btnRowH+$btnGap+$addFundsHintH+$rowH+2
	$subformHeight:=$heightSubform
	If ($subformHeight<400)
		$subformHeight:=400
	End if
	$footerTop:=$subformHeight-$bottomMargin-$footerContentH
	If ($footerTop<120)
		$footerTop:=120
	End if
	$btnTop:=$footerTop-$btnGap-$btnRowH
	$otherLbBottom:=$btnTop-$btnGap
	If (Not:C34($isAddMode))
		$otherLbBottom:=$footerTop-4
	End if
	
	OBJECT SET COORDINATES:C1248(*; "header_bkgd_main"; 0; 114; $widthSubform; 144)
	
	$y:=148
	If ($isAddMode) && ($hasPayments)
		OBJECT SET COORDINATES:C1248(*; "lbl_selectPaymentHint"; $labelLeft; $y; $widthSubform-$margin; $y+$selectHintH)
		$y:=$y+$selectHintH+4
	End if
	
	If ($hasPayments)
		OBJECT SET COORDINATES:C1248(*; "lbl_selectPayment"; $labelLeft; $y; $labelLeft+200; $y+$rowH)
		$payLbTop:=$y+$rowH+2
		$maxPayBottom:=$otherLbBottom-$reservedBelowPayLb
		$payLbH:=$maxPayBottom-$payLbTop
		If ($payLbH<72)
			$payLbH:=72
		End if
		OBJECT SET COORDINATES:C1248(*; "lb_paymentLines"; $margin; $payLbTop; $margin+$minListboxWidth; $payLbTop+$payLbH)
		$y:=$payLbTop+$payLbH+4
		This:C1470._placeRightTotal("lbl_selectedPaymentsTotal"; "val_selectedPaymentsTotal"; $y; $widthSubform; $margin; $rowH; $totalLabelW; $totalValW)
		$y:=$y+$rowH+8
	End if
	
	OBJECT SET COORDINATES:C1248(*; "lbl_addFunds"; $labelLeft; $y; $labelLeft+200; $y+$rowH)
	$y:=$y+$rowH+2
	If ($isAddMode)
		OBJECT SET COORDINATES:C1248(*; "lbl_addFundsHint"; $labelLeft; $y; $widthSubform-$margin; $y+$addFundsHintH)
		$y:=$y+$addFundsHintH+2
	End if
	$otherLbTop:=$y
	
	// Purpose: Clamp other-fund listbox height with precomputed gap (safe on browse / list selection).
	// modified by 4D/PS [2026-june-23]
	$otherLbGap:=$otherLbBottom-$otherLbTop
	If ($otherLbGap<$minOtherLbH)
		$otherLbTop:=$otherLbBottom-$minOtherLbH
		If ($otherLbTop<$y)
			$otherLbTop:=$y
		End if
	End if
	If ($otherLbBottom<=$otherLbTop)
		$otherLbBottom:=$otherLbTop+$minOtherLbH
	End if
	
	// Purpose: In browse mode, shrink empty listboxes instead of filling the whole panel.
	// modified by 4D/PS [2026-june-23]
	If (Not:C34($isAddMode))
		$lineCount:=0
		If (Form:C1466.depositOtherFundLines#Null:C1517)
			$lineCount:=Form:C1466.depositOtherFundLines.length
		End if
		$otherLbMaxH:=56
		If ($lineCount>0)
			$otherLbMaxH:=$lineCount*20+28
			If ($otherLbMaxH>220)
				$otherLbMaxH:=220
			End if
		End if
		$desiredLbBottom:=$otherLbTop+$otherLbMaxH
		If ($desiredLbBottom<$otherLbBottom)
			$otherLbBottom:=$desiredLbBottom
		End if
	End if
	OBJECT SET COORDINATES:C1248(*; "lb_otherFundLines"; $margin; $otherLbTop; $margin+$minListboxWidth; $otherLbBottom)
	
	If ($isAddMode)
		OBJECT SET COORDINATES:C1248(*; "btn_addOtherFund"; $margin; $btnTop; $margin+80; $btnTop+22)
		OBJECT SET COORDINATES:C1248(*; "btn_removeOtherFund"; $margin+88; $btnTop; $margin+168; $btnTop+22)
		OBJECT SET COORDINATES:C1248(*; "btn_pickOtherFundAccount"; $margin+176; $btnTop; $margin+266; $btnTop+22)
		OBJECT SET COORDINATES:C1248(*; "btn_pickOtherFundCustomer"; $margin+274; $btnTop; $margin+364; $btnTop+22)
	End if
	
	$y:=$footerTop
	This:C1470._placeRightTotal("lbl_otherFundsTotal"; "val_otherFundsTotal"; $y; $widthSubform; $margin; $rowH; $totalLabelW; $totalValW)
	$y:=$y+$rowH+4
	OBJECT SET COORDINATES:C1248(*; "lbl_cashBackAccount"; $labelLeft; $y+1; $labelLeft+$labelWidth; $y+$rowH)
	OBJECT SET COORDINATES:C1248(*; "pup_cashBackAccount"; $fieldLeft; $y; $fieldLeft+$fieldWidth; $y+23)
	$y:=$y+$rowH+6
	OBJECT SET COORDINATES:C1248(*; "lbl_cashBackMemo"; $labelLeft; $y+1; $labelLeft+$labelWidth; $y+$rowH)
	OBJECT SET COORDINATES:C1248(*; "entryField_cashBackMemo"; $fieldLeft; $y; $fieldLeft+$fieldWidth; $y+$rowH)
	$y:=$y+$rowH+4
	OBJECT SET COORDINATES:C1248(*; "lbl_cashBackAmount"; $labelLeft; $y+1; $labelLeft+$labelWidth; $y+$rowH)
	OBJECT SET COORDINATES:C1248(*; "entryField_cashBackAmount"; $fieldLeft; $y; $fieldLeft+120; $y+$rowH)
	$y:=$y+$rowH+6
	This:C1470._placeRightTotal("lbl_grandTotal"; "val_grandTotal"; $y; $widthSubform; $margin; 22; 80; 140)
	If ($showNetToBank)
		$y:=$y+28
		This:C1470._placeRightTotal("lbl_netToBank"; "val_netToBank"; $y; $widthSubform; $margin; $rowH; $totalLabelW; 140)
	End if

Function selectCustomer()
	var $selector : cs:C1710.sfw_definitionSelector
	var $itemSeleted : Object
	var $eCustomer : cs:C1710.CustomerEntity
	If (This:C1470._canEdit())
		$selector:=cs:C1710.sfw_definitionSelector.new("selectorCustomers"; "customer")
		$selector.setTitle("Filter payments by customer")
		$selector.setOptions("noCutLink")
		$eCustomer:=Null:C1517
		If (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID(This:C1470._paymentCustomerFilterUUID())))
			$eCustomer:=ds:C1482.Customer.get(This:C1470._paymentCustomerFilterUUID())
		End if
		$selector.setCurrentItem($eCustomer)
		$selector.openSelector()
		Case of
			: ($selector.isSelected())
				$itemSeleted:=$selector.getCurrentItem()
				Case of
					: ($itemSeleted=Null:C1517)
					: (cs:C1710.sfw_string.me.isAnEmptyUUID($itemSeleted.UUID)=False:C215)
						Form:C1466.depositLine_filters.customer:=New collection:C1472($itemSeleted.UUID)
				End case
				This:C1470.drawPup_customer()
			: ($selector.asCutTheLink())
				Form:C1466.depositLine_filters.customer:=New collection:C1472()
				This:C1470.drawPup_customer()
		End case
		This:C1470.reloadPaymentLines()
	End if

Function drawPup_customer()
	var $name : Text
	var $eCustomer : cs:C1710.CustomerEntity
	If (Form:C1466.current_item#Null:C1517)
		$name:="All customers"
		$eCustomer:=Null:C1517
		If (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID(This:C1470._paymentCustomerFilterUUID())))
			$eCustomer:=ds:C1482.Customer.get(This:C1470._paymentCustomerFilterUUID())
		End if
		If ($eCustomer#Null:C1517)
			$name:=$eCustomer.name
		End if
		Form:C1466.sfw.drawButtonPup("pup_customer"; $name; "sfw/image/skin/rainbow/icon/spacer-1x24.png"; False:C215)
	End if

Function selectBankAccount()
	If (This:C1470._canEdit())
		_ga_depositPickBankAccount("bank")
		This:C1470.drawPup_bank()
	End if

Function drawPup_bank()
	var $label : Text
	If (Form:C1466.current_item#Null:C1517)
		$label:=Form:C1466.current_item.bankAccountName
		If ($label="")
			$label:="Select bank account"
		End if
		Form:C1466.sfw.drawButtonPup("pup_bank"; $label; "sfw/image/skin/rainbow/icon/spacer-1x24.png"; ($label="Select bank account"))
	End if

Function selectCashBackAccount()
	If (This:C1470._canEdit())
		_ga_depositPickBankAccount("cashBack")
		This:C1470.drawPup_cashBackAccount()
	End if

Function drawPup_cashBackAccount()
	var $label : Text
	If (Form:C1466.current_item#Null:C1517)
		$label:=Form:C1466.current_item.cashBackAccountName
		If ($label="")
			$label:="Select account"
		End if
		Form:C1466.sfw.drawButtonPup("pup_cashBackAccount"; $label; "sfw/image/skin/rainbow/icon/spacer-1x24.png"; ($label="Select account"))
	End if

Function reloadPaymentLines()
	var $filterUUID : Text
	If (Form:C1466.situation.mode="add")
		$filterUUID:=This:C1470._paymentCustomerFilterUUID()
		If (cs:C1710.sfw_string.me.isAnEmptyUUID($filterUUID))
			$filterUUID:=""
		End if
		Form:C1466.depositPaymentLines:=_ga_depositBuildPaymentLines($filterUUID)
		_ga_depositRecalcTotals()
		_ga_depositTouchCollections()
		This:C1470.redrawAndSetVisible()
	End if

Function addOtherFundLine()
	var $line : Object
	If (This:C1470._canEdit())
		$line:=New object:C1471(\
			"lineNumber"; Form:C1466.depositOtherFundLines.length+1; \
			"UUID_Customer"; ""; \
			"customerName"; ""; \
			"UUID_CAO"; ""; \
			"accountName"; ""; \
			"description"; ""; \
			"refNo"; ""; \
			"amount"; 0)
		Form:C1466.depositOtherFundLines.push($line)
		This:C1470._renumberOtherFundLines()
		_ga_depositRecalcTotals()
		_ga_depositTouchCollections()
	End if

Function removeOtherFundLine()
	var $line : Object
	var $idx : Integer
	If (This:C1470._canEdit())
		// Purpose: Remove user-selected rows via selectedItemsSource (collection listbox pattern).
		// modified by 4D/PS [2026-june-23]
		If (Form:C1466.depositOtherFundLinesSelected#Null:C1517) && (Form:C1466.depositOtherFundLinesSelected.length>0)
			For each ($line; Form:C1466.depositOtherFundLinesSelected)
				$idx:=Form:C1466.depositOtherFundLines.indexOf($line)
				If ($idx>=0)
					Form:C1466.depositOtherFundLines.remove($idx)
				End if
			End for each
			Form:C1466.depositOtherFundLinesSelected:=New collection:C1472()
			This:C1470._renumberOtherFundLines()
			_ga_depositRecalcTotals()
			_ga_depositTouchCollections()
		End if
	End if

Function pickOtherFundAccount()
	var $line : Object
	var $idx : Integer
	If (This:C1470._canEdit())
		If (Form:C1466.depositOtherFundLinesSelected#Null:C1517) && (Form:C1466.depositOtherFundLinesSelected.length>0)
			$line:=Form:C1466.depositOtherFundLinesSelected[0]
			$idx:=Form:C1466.depositOtherFundLines.indexOf($line)
			If ($idx>=0)
				Form:C1466.depositOtherFundLineIndex:=$idx
				_ga_depositPickBankAccount("otherFund")
				_ga_depositRecalcTotals()
			Else
				cs:C1710.sfw_dialog.me.alert("Select an other-funds line first.")
			End if
		Else
			cs:C1710.sfw_dialog.me.alert("Select an other-funds line first.")
		End if
	End if

Function pickOtherFundCustomer()
	var $line : Object
	var $idx : Integer
	If (This:C1470._canEdit())
		If (Form:C1466.depositOtherFundLinesSelected#Null:C1517) && (Form:C1466.depositOtherFundLinesSelected.length>0)
			$line:=Form:C1466.depositOtherFundLinesSelected[0]
			$idx:=Form:C1466.depositOtherFundLines.indexOf($line)
			If ($idx>=0)
				Form:C1466.depositOtherFundLineIndex:=$idx
				_ga_depositPickCustomerForOtherFund()
			Else
				cs:C1710.sfw_dialog.me.alert("Select an other-funds line first.")
			End if
		Else
			cs:C1710.sfw_dialog.me.alert("Select an other-funds line first.")
		End if
	End if

Function onCashBackChange()
	_ga_depositRecalcTotals()
	This:C1470.redrawAndSetVisible()

Function onPaymentLinesChange()
	_ga_depositRecalcTotals()

Function onOtherFundLinesChange()
	_ga_depositRecalcTotals()

// Purpose: Keep line numbers sequential after add/remove on other-funds rows.
// modified by 4D/PS [2026-june-23]
Function _renumberOtherFundLines()
	var $line : Object
	var $num : Integer
	$num:=0
	For each ($line; Form:C1466.depositOtherFundLines)
		$num:=$num+1
		$line.lineNumber:=$num
	End for each
