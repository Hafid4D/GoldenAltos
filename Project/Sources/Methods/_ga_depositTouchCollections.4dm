//%attributes = {}

// Purpose: Force listbox refresh after in-place edits to deposit panel collections.
// created by 4D/PS [2026-june-22]

If (Form:C1466.depositPaymentLines#Null:C1517)
	Form:C1466.depositPaymentLines:=Form:C1466.depositPaymentLines.copy()
End if
If (Form:C1466.depositOtherFundLines#Null:C1517)
	Form:C1466.depositOtherFundLines:=Form:C1466.depositOtherFundLines.copy()
End if
