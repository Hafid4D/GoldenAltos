// Purpose: Entity helpers for Deposit (window title from deposit number).
// created by 4D/PS [2026-june-09]
Class extends Entity

local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=String:C10(This:C1470.depositNumber)
