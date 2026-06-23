//%attributes = {}

// Purpose: Stub for Print Deposit Receipt (Write Pro template to be added in a later phase).
// created by 4D/PS [2026-june-22]

If (Form:C1466.current_item=Null:C1517)
	cs:C1710.sfw_dialog.me.alert("Select a deposit to print.")
Else
	cs:C1710.sfw_dialog.me.alert("Print Deposit Receipt is not implemented yet.")
End if
