// Purpose: Entity helpers for Check (window title from check number).
// created by 4D/PS [2026-june-09]
Class extends Entity

local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=String:C10(This:C1470.checkNumber)
