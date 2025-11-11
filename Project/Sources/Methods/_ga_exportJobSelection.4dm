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
	
	$offscreen:=cs:C1710.jobDataExporter.new($file.platformPath; $fields; Form:C1466.sfw.lb_items; $fileName)
	$excelSheet:=VP Run offscreen area($offscreen)
	
Else 
	
	cs:C1710.sfw_dialog.me.alert(ds:C1482.sfw_readXliff("No items in the list to print"))
	
End if 

//End if 




