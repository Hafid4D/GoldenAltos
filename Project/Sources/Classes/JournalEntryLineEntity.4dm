// Purpose: Entity helpers for JournalEntry line items (typed debit/credit GL posting rows).
// created by 4D/PS [2026-june-29]
Class extends Entity

local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=String:C10(This:C1470.lineNumber)
