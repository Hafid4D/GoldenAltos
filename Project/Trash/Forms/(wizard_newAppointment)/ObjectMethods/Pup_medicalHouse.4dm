var $medicalHouse : Object
var $choose : Text
var $refMenu : Text


$UUIDMedicalHouses:=ds:C1482.MedicalCapability.query("UUID_ConsultationKind = :1"; Form:C1466.UUID_ConsultationKind).medicalHouse.UUID

$refMenu:=Create menu:C408

For each ($medicalHouse; Storage:C1525.cache.medicalHouse)
	APPEND MENU ITEM:C411($refMenu; $medicalHouse.name; *)
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; $medicalHouse.UUID)
	If (Form:C1466.UUID_MedicalHouse=$medicalHouse.UUID)
		SET MENU ITEM MARK:C208($refMenu; -1; Char:C90(18))
	End if 
	If ($UUIDMedicalHouses.indexOf($medicalHouse.UUID)=-1)
		DISABLE MENU ITEM:C150($refMenu; -1)
	End if 
End for each 

$choose:=Dynamic pop up menu:C1006($refMenu)
RELEASE MENU:C978($refMenu)

If ($choose#"")
	Form:C1466.UUID_MedicalHouse:=$choose
	wizard_newAppointment_Redraw
	
End if 
