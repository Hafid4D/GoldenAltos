//%attributes = {}


$project:=cs:C1710.Util_entryFactory.new()




//$sharedParam:=New shared object("result"; New shared object())

//$assets:=ds.AssetType.all()

//var $commandLine; $output; $in : Text

//$commandLine:="powershell Get-CimInstance Win32_SerialPort | Where-Object { ($_.PNPDeviceID -like '*USB*') -or ($_.PNPDeviceID -like '*BTHENUM*') } | ForEach-Object { $_.DeviceID }"
//SET ENVIRONMENT VARIABLE("_4D_OPTION_HIDE_CONSOLE"; "true")
//LAUNCH EXTERNAL PROCESS($commandLine; $in; $output; $error; $pid)

//$result:=Split string($output; "\r\n"; sk ignore empty strings+sk trim spaces)  //; ""; sk ignore empty strings+sk trim spaces)


//$dolder:=System folder()

//$file:=Get 4D folder(Active 4D Folder)  //+"ScannerConfig.json")

//$data:="Q4Oa2w20kkOKyfVpcNk02w=="
//$isUUID:=(Substring($data; 23)="==")


//$setting:=0
//$portNum:=104

//SET CHANNEL(11)
//SET CHANNEL($portNum; $setting)


//SET CHANNEL(11)
//DELAY PROCESS(Current process; 120)
//SET CHANNEL($portNum; $setting)


//SET CHANNEL($portNum; $setting)



//$staff:=ds.Staff.query("lastName =:1"; "LOSENDO")

//$job:=ds.Job.all().first()


//$nameA:="897673"
//$nameB:="897673_1"

//$bool:=$nameA=$nameB

//var $JobLineItem : cs.JobLineItemEntity
//$selection:=ds.JobLineItem.query("itemNumber=:1"; 0)
//For each ($JobLineItem; $selection)
//$JobLineItem.drop()

//End for each 




//$svgRef:=SVG_New
//$objectRef:=SVG_New_line($svgRef; 0; 1; 730; 1; "black"; 1)
//SVG_SAVE_AS_PICTURE($svgRef; "test.png")

//$idents:=cs.sfw_definition.me.entries.extract("ident")

//$counter:=0
//String($counter+1; "00000#")


//$file:=Folder(fk resources folder).file("excelTemplates/jobsTemplate.xlsx")

//var $fields : Collection:=New collection("jobNumber"; "expectedDate"; "recommitDate"; \
"lastShipDate"; "invoiceDate"; "customer"; "poNumber"; "process"; "currency"; "totalCharge"; \
"shipped"; "postToPO")
//$jobs:=ds.Job.query("lineItem =:1"; True)
//$offscreen:=cs.jobDataExporter.new($file.platformPath; $fields; $jobs; "TestJobExport")
//$excelSheet:=VP Run offscreen area($offscreen)

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






