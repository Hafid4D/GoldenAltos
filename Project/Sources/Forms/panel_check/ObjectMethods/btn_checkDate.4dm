// Purpose: Calendar picker for check date on the check panel.
// created by 4D/PS [2026-june-29]
Case of 
	: (Form event:C1606.code=On Clicked:K2:4)
		If (cs:C1710.panel_check.me._canEdit())
			Form:C1466.panelCheckWorkDate:=Form:C1466.current_item.checkDate
			If (Form:C1466.panelCheckWorkDate=Null:C1517) || (Form:C1466.panelCheckWorkDate=!00-00-00!)
				Form:C1466.panelCheckWorkDate:=Current date:C33(*)
			End if
			cs:C1710.Util.me.btnDatePicker(Form:C1466; "panelCheckWorkDate")
			Form:C1466.current_item.checkDate:=Form:C1466.panelCheckWorkDate
		End if
End case 
