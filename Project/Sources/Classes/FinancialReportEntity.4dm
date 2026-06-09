// Purpose: Entity helpers for FinancialReport (window title from report name).
// created by 4D/PS [2026-june-09]
Class extends Entity

local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=String:C10(This:C1470.reportName)
