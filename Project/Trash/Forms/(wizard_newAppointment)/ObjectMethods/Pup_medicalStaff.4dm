var $medicalHouse : Object
var $choose : Text
var $refMenu : Text

var $eMedicalStaff : cs:C1710.MedicalStaffEntity
var $esMedicalStaff : cs:C1710.MedicalStaffSelection

$esMedicalStaff:=ds:C1482.MedicalCapability.query("UUID_ConsultationKind = :1 & UUID_MedicalHouse = :2"; Form:C1466.UUID_ConsultationKind; Form:C1466.UUID_MedicalHouse).medicalStaff.orderBy("lastName")

$refMenu:=Create menu:C408

For each ($eMedicalStaff; $esMedicalStaff)
	APPEND MENU ITEM:C411($refMenu; $eMedicalStaff.getFullName(); *)
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; $eMedicalStaff.UUID)
	If (Form:C1466.UUID_MedicalStaff=$eMedicalStaff.UUID)
		SET MENU ITEM MARK:C208($refMenu; -1; Char:C90(18))
	End if 
End for each 

$choose:=Dynamic pop up menu:C1006($refMenu)
RELEASE MENU:C978($refMenu)

If ($choose#"")
	Form:C1466.UUID_MedicalStaff:=$choose
	wizard_newAppointment_Redraw
	
End if 
