var $medicalHouse : Object
var $choose : Text
var $refMenu : Text


$esCoach:=ds:C1482.LessonCapability.query("UUID_Activity = :1 & UUID_MedicalHouse = :2"; Form:C1466.UUID_Activity; Form:C1466.UUID_MedicalHouse).coach.orderBy("lastName")

$refMenu:=Create menu:C408

For each ($eCoach; $esCoach)
	APPEND MENU ITEM:C411($refMenu; $eCoach.getFullName(); *)
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; $eCoach.UUID)
	If (Form:C1466.UUID_Coach=$eCoach.UUID)
		SET MENU ITEM MARK:C208($refMenu; -1; Char:C90(18))
	End if 
End for each 

$choose:=Dynamic pop up menu:C1006($refMenu)
RELEASE MENU:C978($refMenu)

If ($choose#"")
	Form:C1466.UUID_Coach:=$choose
	wizard_newLesson_Redraw
	
End if 
