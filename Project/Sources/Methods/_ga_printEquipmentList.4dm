//%attributes = {}


/*

subr_access("QA_Manager")
mbardis1
DEFAULT TABLE([ATE])


ALL RECORDS([ATE])
FORM SET INPUT([ATE]; "Output")
FORM SET OUTPUT([ATE]; "list")
PrinterOption("Orientation"; "Portrait")
QUERY([ATE]; [ATE]SchedulableResource=True)
Reportitle:="List of  Schedulable Resources"
PRINT SELECTION(*)

DISTINCT VALUES([ATE]EquipmentType; $EquipmentTypes)

For ($i; 1; Size of array($EquipmentTypes))
ALL RECORDS([ATE])
FORM SET INPUT([ATE]; "Output")
FORM SET OUTPUT([ATE]; "list")
PrinterOption("Orientation"; "Portrait")
QUERY([ATE]; [ATE]EquipmentType=$EquipmentTypes{$i})
Reportitle:="List of Equipment. Type: "+$EquipmentTypes{$i}

PRINT SELECTION(*)

End for 


*/

var $identEntry : Text:=Form:C1466.sfw.view.ident

$file:=Folder:C1567(fk resources folder:K87:11).file("4DWriteProPrintTemplates/equipmentsListPrint.4wp")
$template:=WP Import document:C1318($file.platformPath)

Case of 
	: ($identEntry="main")
		
		$template.subject:="Equipments"
		$template.Location:="Location"
		$template.division:="Division"
		$template.equipmentType:="Type"
		
	: ($identEntry="equipmentsOutOfCalibration")
		
		$template.subject:="Equipments Out of Calibration"
		
	: ($identEntry="pmEquipments")
		
		$template.subject:="PM Equipments"
		
	: ($identEntry="dueCalibrationEquipments")
		
		$template.subject:="Equipment overdue for calibration"
		
	: ($identEntry="duePMEquipments")
		
		$template.subject:="Due PM Equipments"
		
	: ($identEntry="equipmentsDownOrOnHold")
		
		$template.subject:="Equipments down or on hold"
		
		
End case 



PRINT SETTINGS:C106(2)
WP PRINT:C1343($template)
