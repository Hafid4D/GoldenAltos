// Purpose: Entity helpers for ExpenseTransaction (window title from expense number).
// created by 4D/PS [2026-june-09]
Class extends Entity

local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=String:C10(This:C1470.expenseNumber)
