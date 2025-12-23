//%attributes = {}

/*
Method Name : _ga_exportEquipmentList
Author : Medard /4D PS
Date : 10-November-2025
Purpose : This method export current job selection to an .xlsx document
*/



var $fields : Collection

If (Form:C1466.sfw.lb_items.length>0)
	
	$fileName:=Form:C1466.sfw.view.ident
	
	If ($fileName="archivedJobs")
		$file:=Folder:C1567(fk resources folder:K87:11).file("excelTemplates/archivedJobsTemplate.xlsx")
		
		$fields:=New collection:C1472("jobNumber"; "lastShipDate"; "invoiceDate"; "customer"; \
			"poNumber"; "process"; "currency"; "totalCharge")
		
	Else 
		$file:=Folder:C1567(fk resources folder:K87:11).file("excelTemplates/jobsTemplate.xlsx")
		
		$fields:=New collection:C1472("jobNumber"; "expectedDate"; "recommitDate"; \
			"lastShipDate"; "invoiceDate"; "customer"; "poNumber"; "process"; "currency"; \
			"totalCharge"; "shipped"; "postToPO")
	End if 
	If ($fileName="main")
		$fileName:="AllJobs"
	End if 
	
	$folderPath:=Get 4D folder:C485(Current resources folder:K5:16)+"exportedData"  //+Folder separator+"Jobs"
	
	$fileName:=Split string:C1554(String:C10($fileName+"_"+Replace string:C233(String:C10(Date:C102(Timestamp:C1445)); "/"; "_")); " "; sk ignore empty strings:K86:1+sk trim spaces:K86:2).join("")
	$collection:=Form:C1466.sfw.lb_items.toCollection()
	$offscreen:=cs:C1710.jobDataExporter.new($file.platformPath; $fields; $collection; $fileName; $folderPath)
	$excelSheet:=VP Run offscreen area($offscreen)
	
	//cs.sfw_dialog.me.info(ds.sfw_readXliff("export.done"; "The export is done"))
	//OPEN URL($file.platformPath; *)
Else 
	
	cs:C1710.sfw_dialog.me.alert(ds:C1482.sfw_readXliff("No items in the list to Export"))
	
End if 





