//%attributes = {}
/*
_ga_printReceivingTag
created by 4D/PS [2026-may-04]

*/

If (Form:C1466.current_item#Null:C1517)
	var $context : Object:=New object:C1471()
	var $template : Object:=WP New:C1317()
	
	$model:=ds:C1482.sfw_DocumentModel.query("name =:1"; "RECV_TAG").first()
	If ($model#Null:C1517)
		$template:=$model.area
	End if 
	
	$customer:=ds:C1482.Customer.query("UUID =:1"; Form:C1466.current_item.job.UUID_Customer).first()
	
	$shippingAddress:=$customer.contactDetails.addresses.query("type =:1"; "shipping").first()
	$shippingAddress.detail.state:=$shippingAddress.detail.state#Null:C1517 ? $shippingAddress.detail.state : ""
	$address:=$shippingAddress.detail.street_1+"\n"+$shippingAddress.detail.city+"\n"+\
		$shippingAddress.detail.state+" "+$shippingAddress.detail.postcode+"\n"+$shippingAddress.detail.country
	$context.address:=$address
	$context.customerShipper:=Form:C1466.current_item.job.customerShipper#"" ? Form:C1466.current_item.job.customerShipper : "N/A"
	$context.poNumber:=Form:C1466.current_item.job.poNumber
	$context.deviceNumber:=Form:C1466.current_item.job.deviceNumber
	$context.receivingSlip:=Form:C1466.current_item.job.jobNumber
	
	Form:C1466.inventoriesCollection:=New collection:C1472()
	$lots:=Form:C1466.current_item.job.lots
	For each ($lot; $lots)
		$object:=New object:C1471(\
			"type"; "Mgf Lot"; \
			"lotNumber"; ""; \
			"statedQty"; ""; \
			"ourQty"; ""; \
			"dateIn"; ""; \
			"packageType"; ""; \
			"location"; ""\
			)
		
	End for each 
	WP SET DATA CONTEXT:C1786($template; $context)
	
	PRINT SETTINGS:C106(2)
	WP PRINT:C1343($template)
	
	
End if 