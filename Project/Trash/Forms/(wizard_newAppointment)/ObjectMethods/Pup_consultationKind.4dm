var $consultationKind : Object
var $choose : Text
var $refMenu : Text


$refMenu:=Create menu:C408

For each ($consultationKind; Storage:C1525.cache.consultationKind)
	APPEND MENU ITEM:C411($refMenu; $consultationKind.name; *)
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; $consultationKind.UUID)
	If (Form:C1466.UUID_ConsultationKind=$consultationKind.UUID)
		SET MENU ITEM MARK:C208($refMenu; -1; Char:C90(18))
	End if 
End for each 

$choose:=Dynamic pop up menu:C1006($refMenu)
RELEASE MENU:C978($refMenu)

If ($choose#"")
	Form:C1466.UUID_ConsultationKind:=$choose
	wizard_newAppointment_Redraw
	
End if 
