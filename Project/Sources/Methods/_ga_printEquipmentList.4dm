//%attributes = {}


/*
Method Name : _ga_printEquipmentList
Author : Medard /4D PS
Date : 20-May-2025
Purpose : Print Equipments View List
*/

var $identEntry : Text:=Form:C1466.sfw.view.ident
var $context : Object

$context:=New object:C1471()

$file:=Folder:C1567(fk resources folder:K87:11).file("4DWriteProPrintTemplates/equipmentsListPrint.4wp")
$template:=WP Import document:C1318($file.platformPath)

$context.length:=Form:C1466.sfw.lb_items.length

$context.location:=_ga_getListFiltersValues("EquipmentLocation"; "locationID")
$context.equipmentType:=_ga_getListFiltersValues("ToolType"; "UUID")  //("EquipmentType"; "typeID")
$context.division:=_ga_getListFiltersValues("Division"; "divisionID")
$context.user:=Current machine:C483

Case of 
	: ($identEntry="main")
		
		$context.subject:="Equipments"
		
	: ($identEntry="equipmentsOutOfCalibration")
		
		$template.subject:="Equipments Out of Calibration"
		
	: ($identEntry="pmEquipments")
		
		$template.subject:="PM Equipments"
		
	: ($identEntry="dueCalibrationEquipments")
		
		$template.subject:="Equipments overdue for calibration"
		
	: ($identEntry="duePMEquipments")
		
		$template.subject:="Due PM Equipments"
		
	: ($identEntry="equipmentsDownOrOnHold")
		
		$template.subject:="Equipments down or on hold"
		
End case 


WP SET DATA CONTEXT:C1786($template; $context)

PRINT SETTINGS:C106(2)
WP PRINT:C1343($template)
