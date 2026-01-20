//%attributes = {}


_ga_findScannerSeriaPort


var $commandLine; $output; $in : Text

$commandLine:="powershell Get-CimInstance Win32_SerialPort | Where-Object { ($_.PNPDeviceID -like '*USB*') -or ($_.PNPDeviceID -like '*BTHENUM*') } | ForEach-Object { $_.DeviceID }"
SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
LAUNCH EXTERNAL PROCESS:C811($commandLine; $in; $output; $error; $pid)

$result:=Split string:C1554($output; "\r\n"; sk ignore empty strings:K86:1+sk trim spaces:K86:2)  //; ""; sk ignore empty strings+sk trim spaces)




//$dolder:=System folder()

$file:=Get 4D folder:C485(Active 4D Folder:K5:10)  //+"ScannerConfig.json")

$data:="Q4Oa2w20kkOKyfVpcNk02w=="
$isUUID:=(Substring:C12($data; 23)="==")


$setting:=0
$portNum:=104

SET CHANNEL:C77(11)
SET CHANNEL:C77($portNum; $setting)


SET CHANNEL:C77(11)
DELAY PROCESS:C323(Current process:C322; 120)
SET CHANNEL:C77($portNum; $setting)


SET CHANNEL:C77($portNum; $setting)




$staff:=ds:C1482.Staff.query("lastName =:1"; "LOSENDO")

$job:=ds:C1482.Job.all().first()


$nameA:="897673"
$nameB:="897673_1"

$bool:=$nameA=$nameB

var $JobLineItem : cs:C1710.JobLineItemEntity
$selection:=ds:C1482.JobLineItem.query("itemNumber=:1"; 0)
For each ($JobLineItem; $selection)
	$JobLineItem.drop()
	
End for each 




$svgRef:=SVG_New
$objectRef:=SVG_New_line($svgRef; 0; 1; 730; 1; "black"; 1)
SVG_SAVE_AS_PICTURE($svgRef; "test.png")

$idents:=cs:C1710.sfw_definition.me.entries.extract("ident")

$counter:=0
String:C10($counter+1; "00000#")


$file:=Folder:C1567(fk resources folder:K87:11).file("excelTemplates/jobsTemplate.xlsx")

var $fields : Collection:=New collection:C1472("jobNumber"; "expectedDate"; "recommitDate"; \
"lastShipDate"; "invoiceDate"; "customer"; "poNumber"; "process"; "currency"; "totalCharge"; \
"shipped"; "postToPO")
$jobs:=ds:C1482.Job.query("lineItem =:1"; True:C214)
$offscreen:=cs:C1710.jobDataExporter.new($file.platformPath; $fields; $jobs; "TestJobExport")
$excelSheet:=VP Run offscreen area($offscreen)

//$offscreen.fillDataAndExport($offscreen)




//$hashOptions:=New shared object("algorithm"; "bcrypt"; "cost"; 10)
//$newPassword:="pSzjGX!Ey9P1c~p"
//$hash:=Generate password hash($newPassword; $hashOptions)

//ds.sfw_Notification.all().drop()
//ds.sfw_User.all().drop()

//$staff:=ds.Staff.query("user.userInscriptions.userProfile.ident = :1 | memberships.team.name =:2"; "pm"; "Facilities")

//$users:=$staff.extract("user").extract("UUID")

//$a:="    "
//$a:=Split string($a; ";"; sk ignore empty strings+sk trim spaces).join(";")
//If ($a="")
////ALERT("ok")
//End if 

//var $audit_e : cs.AuditEntity
//var $audit_es : cs.AuditEntity
//$audit_es:=ds.Audit.all()
//For each ($audit_e; $audit_es)
//$file:=Temporary folder+Folder separator+$audit_e.attachedDocuments.documents.sourcePath

//BLOB TO DOCUMENT($file; $audit_e.attachedDocuments.documents.blob)

//End for each 


//$file:=Folder(fk data folder).file("2300_Names.json")
//$names:=JSON Parse($file.getText())

//$i:=0
//$es:=ds.Contact.all()
//For each ($e; $es)
//$e.firstName:=$names[$i].firstName
//$e.lastName:=$names[$i].lastName
//$e.save()
//$i+=1
//End for each 

//$text:="   \r  "

//$text:=cs.Util.me.trim($text; [" "; "\r"])






