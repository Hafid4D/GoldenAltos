//%attributes = {}

/*
Method Name : _ga_exportInvoicesSelection
Author : Medard /4D PS
Date : 22-December-2025
Purpose : This method export current invoice selection to .xlsx document
*/


var $fields : Collection

If (Form:C1466.sfw.lb_items.length>0)
	
	$fileName:=Form:C1466.sfw.view.ident
	
	$templateFile:=Folder:C1567(fk resources folder:K87:11).file("excelTemplates/invoiceTemplate.xlsx")
	
	$headers:=New collection:C1472("Div"; "Job#"; "Date In"; "Expected Out"; "Last ship on"; "Invoice date"; "Customer"; \
		"PO#"; "Process"; "Ccy"; "Charge"; "Shipped?"; "Invoiced"; "Qty In"; "In-House"; "Device"; "Parent"; "Tester"; \
		"Pkg"; "Note"; "Inven-cost"; "Derect-cost")
	
	$fields:=New collection:C1472("job.division.name"; "job.jobNumber"; "job.dateCreated"; "job.expectedDate"; "job.lastShipDate"; "job.invoiceDate"; "job.purchaseOrder.customer.name"; \
		"job.purchaseOrder.poNumber"; "job.process"; "job.currency"; "Charge"; "Shipped?"; "Invoiced"; "Qty In"; ""; "job.deviceNumber"; ""; ""; \
		"job.packageType"; ""; ""; "")
	C_COLLECTION:C1488($mapping)
	
	$mapping:=New collection:C1472(\
		New object:C1471("header"; "Div"; "field"; "job.division.name"); \
		New object:C1471("header"; "Job#"; "field"; "job.jobNumber"); \
		New object:C1471("header"; "Date In"; "field"; "job.dateCreated"); \
		New object:C1471("header"; "Expected Out"; "field"; "job.expectedDate"); \
		New object:C1471("header"; "Last ship on"; "field"; "job.lastShipDate"); \
		New object:C1471("header"; "Invoice date"; "field"; "job.invoiceDate"); \
		New object:C1471("header"; "Customer"; "field"; "job.purchaseOrder.customer.name"); \
		New object:C1471("header"; "PO#"; "field"; "job.purchaseOrder.poNumber"); \
		New object:C1471("header"; "Process"; "field"; "job.process"); \
		New object:C1471("header"; "Ccy"; "field"; "job.currency"); \
		New object:C1471("header"; "Charge"; "field"; "job.totalCharge"); \
		New object:C1471("header"; "Shipped?"; "field"; "job.shipped"); \
		New object:C1471("header"; "Invoiced"; "field"; "job.postToPO"); \
		New object:C1471("header"; "Qty In"; "field"; "job.qty"); \
		New object:C1471("header"; "In-House"; "field"; "job.qtyOnHand"); \
		New object:C1471("header"; "Device"; "field"; "job.deviceNumber"); \
		New object:C1471("header"; "Parent"; "field"; "job.parentJobNumber"); \
		New object:C1471("header"; "Tester"; "field"; "job.testerType"); \
		New object:C1471("header"; "Pkg"; "field"; "job.packageType"); \
		New object:C1471("header"; "Note"; "field"; "job.acNote"); \
		New object:C1471("header"; "Inven-cost"; "field"; "job.inventoryCost"); \
		New object:C1471("header"; "Derect-cost"; "field"; "job.directCost")\
		)
	
	
	If ($fileName="main")
		$fileName:="AllInvoices"
	End if 
	
	$destinationFolderPath:=Get 4D folder:C485(Current resources folder:K5:16)+"exportedData"  //+Folder separator+"Jobs"
	
	$destinationFileName:=Split string:C1554(String:C10($fileName+"_"+Replace string:C233(String:C10(Date:C102(Timestamp:C1445)); "/"; "_")); " "; sk ignore empty strings:K86:1+sk trim spaces:K86:2).join("")
	
	$selection:=Form:C1466.sfw.lb_items
	$offscreen:=cs:C1710.ExcelDataExporter.new($templateFile.platformPath; $mapping; $selection; $destinationFileName; $destinationFolderPath)
	$excelSheet:=VP Run offscreen area($offscreen)
	
	//cs.sfw_dialog.me.info(ds.sfw_readXliff("export.done"; "The export is done"))
	//OPEN URL($file.platformPath; *)
Else 
	
	cs:C1710.sfw_dialog.me.alert(ds:C1482.sfw_readXliff("No items in the list to Export"))
	
End if 





