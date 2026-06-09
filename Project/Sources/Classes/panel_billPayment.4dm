// Purpose: Skeleton panel for Bill Payment entry (no form fields yet).
// created by 4D/PS [2026-june-09]
singleton Class constructor

Function _activate_save_cancel_button()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID

Function formMethod()
	Form:C1466.sfw.panelFormMethod()
	If (Form:C1466.sfw.updateOfPanelNeeded())
	End if
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())
		Case of
			: (FORM Get current page:C276(*)=1)
		End case
	End if
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())
		This:C1470.redrawAndSetVisible()
	End if

Function redrawAndSetVisible()
