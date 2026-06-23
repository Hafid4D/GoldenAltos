// Purpose: Entity helpers for Deposit line items (child of Deposit).
// created by 4D/PS [2026-june-22]
Class extends Entity

local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=String:C10(This:C1470.lineNumber)
