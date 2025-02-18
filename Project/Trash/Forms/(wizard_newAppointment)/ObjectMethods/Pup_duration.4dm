var $choose : Text
var $refMenu : Text



$refMenu:=Create menu:C408

For ($q; 1; 16)
	APPEND MENU ITEM:C411($refMenu; String:C10(Time:C179($q*900); HH MM:K7:2); *)
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; String:C10($q*900))
	If (Num:C11(Form:C1466.duration)=($q*900))
		SET MENU ITEM MARK:C208($refMenu; -1; Char:C90(18))
	End if 
End for 

$choose:=Dynamic pop up menu:C1006($refMenu)
RELEASE MENU:C978($refMenu)

If ($choose#"")
	Form:C1466.duration:=Num:C11($choose)
	wizard_newAppointment_Redraw
	
End if 
