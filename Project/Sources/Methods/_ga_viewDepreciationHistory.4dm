//%attributes = {}

// Purpose: Rebuild depreciation history for the current item and open the history tab (page 2).
// Runs as a setItemAction — operates on Form.current_item only.
// modified by 4D/PS [2026-june-01]

If (Form:C1466.current_item=Null:C1517)
	cs:C1710.sfw_dialog.me.info("No asset selected")
Else 
	Form:C1466.current_item.rebuildDeprecationHistory()
	var $info : Object
	$info:=Form:C1466.current_item.save()
	FORM GOTO PAGE:C247(*; 2)
End if 
