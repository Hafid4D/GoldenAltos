var $activity : Object
var $choose : Text
var $refMenu : Text


$refMenu:=Create menu:C408

For each ($activity; Storage:C1525.cache.activity)
	APPEND MENU ITEM:C411($refMenu; $activity.name; *)
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; $activity.UUID)
	If (Form:C1466.UUID_Activity=$activity.UUID)
		SET MENU ITEM MARK:C208($refMenu; -1; Char:C90(18))
	End if 
End for each 

$choose:=Dynamic pop up menu:C1006($refMenu)
RELEASE MENU:C978($refMenu)

If ($choose#"")
	Form:C1466.UUID_Activity:=$choose
	wizard_newLesson_Redraw
	
End if 
