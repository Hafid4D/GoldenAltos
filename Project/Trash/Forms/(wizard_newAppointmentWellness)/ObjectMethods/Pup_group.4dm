

$menu:=Create menu:C408()

For each ($Group; Form:C1466.searchGroupES)
	APPEND MENU ITEM:C411($menu; $Group.name)
	SET MENU ITEM PARAMETER:C1004($menu; -1; $Group.UUID)
End for each 

$choose:=Dynamic pop up menu:C1006($menu)
RELEASE MENU:C978($menu)


Case of 
	: ($choose="")
	: ($choose#"")
		Form:C1466.UUID_Group:=$choose
		wizard_newLesson_Redraw
End case 