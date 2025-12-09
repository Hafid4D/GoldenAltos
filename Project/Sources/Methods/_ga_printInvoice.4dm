//%attributes = {}
/*
Method Name : _ga_printInvoice
Author : Medard /4D PS
Date : 01-December-2025
Purpose : Print Invoice
*/

If (Form:C1466.current_item#Null:C1517)
	
	var $context : Object
	
	$context:=New object:C1471()
	
	$file:=Folder:C1567(fk resources folder:K87:11).file("4DWriteProPrintTemplates/invoicePrintOutTemplate.4wp")
	$template:=WP Import document:C1318($file.platformPath)
	
	$customer:=ds:C1482.Customer.query("name =:1"; Form:C1466.current_item.job.customer).first()
	
	$billingAddress:=Form:C1466.current_item.job.address.addresses.query("type =:1"; "billing").first()
	$billingAddress.detail.state:=$billingAddress.detail.state#Null:C1517 ? $billingAddress.detail.state : ""
	$address:=$billingAddress.detail.street_1+"\n"+$billingAddress.detail.city+"\n"+\
		$billingAddress.detail.state+" "+$billingAddress.detail.postcode+"\n"+$billingAddress.detail.country
	
	//$context.address:=Form.current_item.dropShipCustomer+"\n"+$address
	$context.invoiceNumber:=Form:C1466.current_item.invoiceNumber
	$context.jobNumber:=Form:C1466.current_item.job.jobNumber
	$context.invoiceDate:=Form:C1466.current_item.invoiceDate
	$context.customer:=Form:C1466.current_item.job.customer
	$context.address:=$address
	$context.posted:=Form:C1466.current_item.job.postToPO
	
	$case_a_cocher:=WP Get element by ID:C1549($template; "textBox6")
	If ($context.posted=False:C215)
		WP DELETE TEXT BOX:C1798($case_a_cocher)
	End if 
	
	$context.customerShipper:=Form:C1466.current_item.customerShipper
	$context.poNumber:=Form:C1466.current_item.poNumber
	$context.process:=Form:C1466.current_item.process
	$context.pr_qualifier:=Form:C1466.current_item.pr_qualifier
	$context.deviceNumber:=Form:C1466.current_item.deviceNumber
	//$context.po_Rel:=Form.current_item.po_Rel
	
	
	//$context.customerShipper:=Form.current_item.customerShipper#"" ? Form.current_item.customerShipper : "N/A"
	//$context.poNumber:=Form.current_item.poNumber
	//$context.deviceNumber:=Form.current_item.deviceNumber
	//$context.shippers:=Form.current_item.shippers
	
	//$context.altDeviceNumber:=Form.current_item.altDeviceNumber
	//$context.carrier:=Form.current_item.carrier
	
	
	
	//If ($customer#Null)
	//$context.carrier:=$customer.customerCarrier.name
	//$context.accountNumber:=$customer.accountNumber
	//End if 
	
	WP SET DATA CONTEXT:C1786($template; $context)
	
	PRINT SETTINGS:C106(2)
	WP PRINT:C1343($template)
	
Else 
	cs:C1710.sfw_dialog.me.info(ds:C1482.sfw_readXliff("Info"; "Select an Invoice to print"))
	
End if 
