// Purpose: Panel controller for Supplier Credit entry (typed legacy CM_items vendor credit fields).
// modified by 4D/PS [2026-june-29]
singleton Class constructor

Function _activate_save_cancel_button()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID

Function formMethod()
	Form:C1466.sfw.panelFormMethod()
	If (Form:C1466.sfw.updateOfPanelNeeded())
		This:C1470.initFormState()
	End if
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())
		Case of
			: (FORM Get current page:C276(*)=1)
		End case
	End if
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())
		This:C1470.redrawAndSetVisible()
	End if

// Purpose: Initialize panel state when opening a supplier credit record.
// modified by 4D/PS [2026-june-29]
Function initFormState()
	If (Form:C1466.current_item#Null:C1517) && (Form:C1466.situation.mode="add")
		Form:C1466.current_item._ensureMoreData()
	End if

Function redrawAndSetVisible()
	var $widthSubform : Integer
	var $heightSubform : Integer
	var $g : Integer
	var $h : Integer
	var $d : Integer
	var $b : Integer
	
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($widthSubform; $heightSubform)
	If ($widthSubform<720)
		$widthSubform:=720
	End if
	If ($heightSubform<180)
		$heightSubform:=180
	End if
	
	OBJECT GET COORDINATES:C663(*; "header_bkgd5"; $g; $h; $d; $b)
	OBJECT SET COORDINATES:C1248(*; "header_bkgd5"; $g; $h; $widthSubform; $heightSubform)
