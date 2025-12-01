Case of 
	: (FORM Event:C1606.code=On Load:K2:1)
		Form:C1466.searchBox:=""
		
		Form:C1466.purchaseOrder:=ds:C1482.PurchaseOrder.query("poNumber = :1"; Form:C1466.job.poNumber).first()
		If (Form:C1466.purchaseOrder#Null:C1517)
			Form:C1466.poLines:=Form:C1466.purchaseOrder.lineItems
		End if 
End case 