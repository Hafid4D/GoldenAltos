//%attributes = {}

// Purpose: Force listbox refresh after loading check bill lines.
// created by 4D/PS [2026-june-29]

If (Form:C1466.checkBillLines#Null:C1517)
	Form:C1466.checkBillLines:=Form:C1466.checkBillLines.copy()
End if
