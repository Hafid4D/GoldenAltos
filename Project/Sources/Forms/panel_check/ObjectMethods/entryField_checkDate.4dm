// Purpose: Sync check date from manual entry (modify/add mode).
// created by 4D/PS [2026-june-29]
Case of 
	: (Form event:C1606.code=On Data Change:K2:15)
		If (cs:C1710.panel_check.me._canEdit()) && (Form:C1466.current_item#Null:C1517)
			Form:C1466.current_item.checkDate:=Form:C1466.current_item.checkDate
		End if
End case 
