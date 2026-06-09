// Purpose: Entity helpers for TransactionType reference rows.
// created by 4D/PS [2026-june-08]
Class extends Entity

local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=This:C1470.name
