//%attributes = {}



var $wpDoc : Object
var $context : Object
var $reportLogs; $reportLogs_1 : Collection
var $meanTbf; $minTbf; $maxTbf : Real

$reportLogs:=New collection:C1472()
$reportLogs_1:=New collection:C1472()
$meanTbf:=0
$minTbf:=0
$maxTbf:=0
$wpDoc:=WP New:C1317()

$form:=New object:C1471
$form.date:=Form:C1466.startDate
OBJECT GET COORDINATES:C663(*; "pup_startDate"; $left; $top; $rigth; $bottom)
CONVERT COORDINATES:C1365($left; $bottom; XY Current form:K27:5; XY Main window:K27:8)
Open window:C153($left; $bottom; $left+285; $bottom+210; Pop up form window:K39:11; "calendar")
DIALOG:C40("_ga_setDateInterval"; $form)

Form:C1466.startDate:=$form.calendar.display.date
OBJECT SET TITLE:C194(*; "pup_startDate"; String:C10(Form:C1466.startDate))
Form:C1466.interval:=String:C10(Form:C1466.endDate-Form:C1466.startDate)


$context:=New object:C1471()

$context.assignedID:=Form:C1466.current_item.assignedID
$context.startDate:=Form:C1466.subForm.startDate
$context.endDate:=Form:C1466.subForm.endDate
$context.today:=Current date:C33
$context.now:=String:C10(Current time:C178; HH MM AM PM:K7:5)
$context.currentUser:=String:C10(Current user:C182)

$file:=Folder:C1567(fk resources folder:K87:11).file("4DWriteProPrintTemplates/equipmentUsageLog.4wp")
$wpDoc:=WP Import document:C1318($file.platformPath)


//$reportLogs:=Form.current_item.repairLogs.toCollection().orderBy("reportDate asc, downAt asc")
//If ($reportLogs.length>0)
//$down_time:=Round($reportLogs.sum("downHrs"); 2)
//$uptime:=0
//$uptime:=Round(_up_time($reportLogs[0].reportDate; Current date(*); $down_time); 2)
//$adate:=$reportLogs.extract("reportDate")
//$atime:=$reportLogs.extract("downAt")
//Case of 
//: ($adate.length-1>0)
//ARRAY REAL($atbf; $adate.length-1)
//For ($i; 1; $adate.length-1)
//$atbf{$i}:=_time2hrs($adate[$i-1]; $atime[$i-1]; $adate[$i]; $atime[$i])
//$meanTbf:=$meanTbf+$atbf{$i}
//End for 
//$meanTbf:=Round($meanTbf/$adate.length-1; 2)
//SORT ARRAY($atbf; >)
//$minTbf:=Round($atbf{1}; 2)
//$maxTbf:=Round($atbf{Size of array($atbf)}; 2)
//End case 
//End if 


WP SET DATA CONTEXT:C1786($wpDoc; $context)

PRINT SETTINGS:C106(2)
WP PRINT:C1343($wpDoc)