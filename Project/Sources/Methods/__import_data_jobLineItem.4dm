//%attributes = {}

///*

//jobLineItem
var $ejobLineItem : cs:C1710.JobLineItemEntity

$jobLineItem_log:=Folder:C1567(fk data folder:K87:12).file("DataJson/receiverSubLot_export.json")

If ($jobLineItem_log.exists)
	$jobLineItems:=JSON Parse:C1218($jobLineItem_log.getText())
	
	TRUNCATE TABLE:C1051([JobLineItem:58])
	
	For each ($jobLineItem; $jobLineItems)
		
		$ejobLineItem:=ds:C1482.JobLineItem.new()
		$ejobLineItem.itemNumber:=$jobLineItem.Item_num
		$ejobLineItem.description:=$jobLineItem.Charge_Description
		$ejobLineItem.quantity:=$jobLineItem.OUR_Count
		$ejobLineItem.unitPrice:=$jobLineItem.Charge
		$ejobLineItem.taxable:=$jobLineItem.SpecialCharges
		$ejobLineItem.lineTotal:=$jobLineItem.Line_item_total
		//$ejobLineItem.timeCharge:=$jobLineItem.timeCharge
		//$ejobLineItem.salesTax:=$jobLineItem.salesTax
		$ejobLineItem.hourCount:=$jobLineItem.TBhours
		
		$res:=$ejobLineItem.save()
		If (Not:C34($res.success))
			TRACE:C157
		End if 
		
	End for each 
	
End if 

//*/