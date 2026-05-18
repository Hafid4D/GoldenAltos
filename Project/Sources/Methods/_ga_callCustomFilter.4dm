//%attributes = {}
$form:=$1

MOUSE POSITION:C468($mouseX; $mouseY; $mouseButtons)
CONVERT COORDINATES:C1365($mouseX; $mouseY; XY Current form:K27:5; XY Main window:K27:8)

$windRef:=Open window:C153($mouseX; $mouseY; $mouseX+270; $mouseY+165; Movable dialog box:K34:7; "")

DIALOG:C40("_ga_customFilter"; $form)

$0:=$form
