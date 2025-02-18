

$menu:=Create menu:C408()

For each ($person; Form:C1466.searchPersonES)
	APPEND MENU ITEM:C411($menu; $person.firstName+" "+$person.lastName)
	SET MENU ITEM PARAMETER:C1004($menu; -1; $person.UUID)
End for each 

$choose:=Dynamic pop up menu:C1006($menu)
RELEASE MENU:C978($menu)


Case of 
	: ($choose="")
	: ($choose#"")
		Form:C1466.UUID_Person:=$choose
		wizard_newAppointment_Redraw
End case 