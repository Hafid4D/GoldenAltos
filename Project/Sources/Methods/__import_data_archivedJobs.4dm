//%attributes = {}


If (True:C214)
	
	$file:=Folder:C1567(fk data folder:K87:12).file("DataJson/archives_export.json")
	
	$records:=JSON Parse:C1218($file.getText())
	
	For each ($record; $records)
		$job:=ds:C1482.Job.new()
		
		$job.jobNumber:=$record.ErpJobNumber
		$job.poNumber:=$record.Purchase_Order
		$job.division:=$record.Division
		$job.dateCreated:=$record.Datein
		$job.expectedDate:=$record.expectedDate  //1
		$job.invoiceDate:=$record.Invoice_Date
		$job.lastShipDate:=$record.Last_lot_ship_date
		$job.archivedDate:=$record.Archive_Date
		$job.deviceNumber:=$record.Device_Number
		$job.process:=$record.Process
		$job.salesTax:=$record.Sales_Tax
		$job.totalCharge:=$record.Total_Charge
		$job.shipped:=$record.Shipped
		$job.lineItem:=$record.line_item
		$job.noLots:=$record.No_Lots
		$job.postToPO:=$record.postToPO  //2
		$job.parentJobNumber:=$record.ParentJobNumber
		$job.address:=$record.address  //3
		$job.alternateShipAddress:=$record.AlternateAddress
		$job.shippers:=$record.Shippers
		$job.customer:=$record.Customer
		$job.qty:=$record.Qty
		$job.qtyOnHand:=0  //$record.qtyOnHand  
		$job.shipMemo:=$record.Ship_Memo
		$job.jobComment:=""  //$record.jobComment
		$job.archived:=True:C214  //$record.archived
		
		$res:=$job.save()
		
		
		
	End for each 
End if 


If (True:C214)
	$file:=Folder:C1567(fk data folder:K87:12).file("DataJson/receiver_export.json")
	
	$records:=JSON Parse:C1218($file.getText())
	var $job : cs:C1710.JobEntity
	
	For each ($record; $records)
		
		$jobNumber:=$record.ErpJobNumber
		
		$job:=ds:C1482.Job.query("jobNumber=:1"; $jobNumber).first()
		
		If ($record.Pr_qualifier#"")
			
		End if 
		
		$job.pr_qualifier:=$record.Pr_qualifier
		$success:=$job.save()
		If ($success.success=False:C215)
			TRACE:C157
		End if 
		
	End for each 
	
	
End if 

ALERT:C41("END!!")

