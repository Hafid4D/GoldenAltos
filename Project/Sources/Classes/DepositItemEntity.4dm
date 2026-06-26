// Purpose: Entity helpers for Deposit line items (typed catalog fields).
// modified by 4D/PS [2026-june-23]
Class extends Entity

local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=String:C10(This:C1470.lineNumber)
