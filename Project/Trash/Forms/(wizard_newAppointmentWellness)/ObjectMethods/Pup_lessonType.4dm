var $refMenu : Text

$refMenu:=Create menu:C408

APPEND MENU ITEM:C411($refMenu; "Private Lesson")
SET MENU ITEM PARAMETER:C1004($refMenu; -1; "PrivateLesson")

APPEND MENU ITEM:C411($refMenu; "Group Lesson")
SET MENU ITEM PARAMETER:C1004($refMenu; -1; "GroupLesson")


$choose:=Dynamic pop up menu:C1006($refMenu)
RELEASE MENU:C978($refMenu)

If ($choose#"")
	Form:C1466.lessonTypeDataclass:=$choose
	wizard_newLesson_Redraw
	
End if 


