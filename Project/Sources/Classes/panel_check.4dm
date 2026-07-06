// Purpose: Panel controller for Checks entry (AP check register + linked bills).
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

// Purpose: Initialize Form variables for the check panel.
// modified by 4D/PS [2026-june-29]
Function initFormState()
	If (Form:C1466.checkBillLines=Null:C1517)
		Form:C1466.checkBillLines:=New collection:C1472()
	End if
	If (Form:C1466.checkBillsTotal=Null:C1517)
		Form:C1466.checkBillsTotal:=0
	End if
	If (Form:C1466.current_item#Null:C1517) && (Form:C1466.situation.mode="add")
		Form:C1466.current_item._initOnCreation()
	End if

// Purpose: Load linked bill lines for the current check.
// modified by 4D/PS [2026-june-29]
Function loadPanelData()
	This:C1470.initFormState()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.checkBillLines:=_ga_checkLoadBillLines(Form:C1466.current_item.checkNumber)
		_ga_checkRecalcTotals()
		_ga_checkTouchCollections()
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
	
	If ($widthSubform<780)
		$widthSubform:=780
	End if
	If ($heightSubform<400)
		$heightSubform:=400
	End if
	
	OBJECT GET COORDINATES:C663(*; "header_bkgd5"; $g; $h; $d; $b)
	OBJECT SET COORDINATES:C1248(*; "header_bkgd5"; $g; $h; $widthSubform; $heightSubform)
	
	OBJECT SET ENABLED:C1123(*; "entryField_checkDate"; $editable)
	OBJECT SET ENABLED:C1123(*; "btn_checkDate"; $editable)
	OBJECT SET ENABLED:C1123(*; "entryField_payee"; $editable)
	OBJECT SET ENABLED:C1123(*; "entryField_amount"; $editable)
	OBJECT SET ENABLED:C1123(*; "entryField_memo"; $editable)
	OBJECT SET ENABLED:C1123(*; "entryField_acNumber"; $editable)
	
	OBJECT SET VISIBLE:C603(*; "lbl_void"; False:C215)
	If (Form:C1466.current_item#Null:C1517) && (Form:C1466.current_item.isVoid)
		OBJECT SET VISIBLE:C603(*; "lbl_void"; True:C214)
	End if
	
	Case of
		: (FORM Get current page:C276(*)=1)
			This:C1470._layoutMainPage($widthSubform; $heightSubform)
	End case

// Purpose: True when the user can edit check header fields (add or modify mode).
// Returns: Boolean
// modified by 4D/PS [2026-june-29]
Function _canEdit()->$editable : Boolean
	$editable:=False:C215
	If (Form:C1466.situation.mode="add") || (Form:C1466.situation.mode="modify")
		$editable:=True:C214
	End if

// Purpose: Position bill lines listbox below the header block.
// modified by 4D/PS [2026-june-29]
Function _layoutMainPage($widthSubform : Integer; $heightSubform : Integer)
	var $top : Integer
	var $listHeight : Integer
	
	$top:=130
	$listHeight:=$heightSubform-$top-60
	If ($listHeight<120)
		$listHeight:=120
	End if
	OBJECT SET COORDINATES:C1248(*; "lb_billLines"; 8; $top; $widthSubform-8; $top+$listHeight)
	OBJECT SET COORDINATES:C1248(*; "label_billsTotal"; $top+$listHeight+8; 8; $top+$listHeight+28; 120)
	OBJECT SET COORDINATES:C1248(*; "entryField_billsTotal"; $top+$listHeight+8; 130; $top+$listHeight+28; 230)
