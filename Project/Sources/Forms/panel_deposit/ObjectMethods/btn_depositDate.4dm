// Purpose: Calendar picker for deposit date on the deposit panel.
// modified by 4D/PS [2026-june-29]
Case of 
	: (Form event:C1606.code=On Clicked:K2:4)
		If (cs:C1710.panel_deposit.me._canEdit())
			Form:C1466.panelDepositWorkDate:=Form:C1466.current_item.depositDate
			If (Form:C1466.panelDepositWorkDate=Null:C1517) || (Form:C1466.panelDepositWorkDate=!00-00-00!)
				Form:C1466.panelDepositWorkDate:=Current date:C33(*)
			End if
			cs:C1710.Util.me.btnDatePicker(Form:C1466; "panelDepositWorkDate")
			Form:C1466.current_item.depositDate:=Form:C1466.panelDepositWorkDate
		End if
End case 
