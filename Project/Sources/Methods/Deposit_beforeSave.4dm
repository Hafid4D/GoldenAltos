//%attributes = {}

// Purpose: Validate deposit panel state before SFW create/save.
// Parameters: $subForm : Object — Form.subForm passed by SFW
// Returns: nothing (alerts on validation failure)
// modified by 4D/PS [2026-june-22]

#DECLARE($subForm : Object)

var $check : Object

$check:=_ga_depositValidateForm()
If (Not:C34($check.valid))
	If ($check.error#"")
		cs:C1710.sfw_dialog.me.alert($check.error)
	End if
End if
