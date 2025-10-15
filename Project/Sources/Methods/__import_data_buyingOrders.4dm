//%attributes = {}
/**
import buyingOrders
**/
If (True:C214)
	TRUNCATE TABLE:C1051([BuyingOrder:46])
	
	$file:=Folder:C1567(fk data folder:K87:12).file("DataJson/buyOrders_export.json")
	
	$records:=JSON Parse:C1218($file.getText())
	
	$terms:=WP Import document:C1318(Folder:C1567(fk data folder:K87:12).file("DataJson/terms.4wp").platformPath)
	$termsCriticalMaterials:=WP Import document:C1318(Folder:C1567(fk data folder:K87:12).file("DataJson/termsCriticalMaterials.4wp").platformPath)
	$termsCriticalService:=WP Import document:C1318(Folder:C1567(fk data folder:K87:12).file("DataJson/termsCriticalService.4wp").platformPath)
	
	For each ($record; $records)
		$buyingOrder:=ds:C1482.BuyingOrder.new()
		
		$buyingOrder.boNumber:=$record.boNumber
		$buyingOrder.orderDate:=cs:C1710.sfw_stmp.me.build(Date:C102($record.orderDate))
		$buyingOrder.buyOrderLimit:=$record.buyOrderLimit
		$buyingOrder.accountNumber:=$record.accountNumber
		$buyingOrder.salesTaxRate:=$record.salesTaxRate
		$buyingOrder.currency:=$record.currency
		$buyingOrder.discount:=$record.discount
		$buyingOrder.discountDays:=$record.discountDays
		$buyingOrder.netDays:=$record.netDays
		$buyingOrder.shippingAddress:=$record.shippingAddress
		$buyingOrder.fob:=$record.fob
		$buyingOrder.shipVia:=$record.shipVia
		$buyingOrder.division:=$record.division
		$buyingOrder.requestedBy:=$record.requestedBy
		$buyingOrder.salesTax:=$record.salesTax
		$buyingOrder.lineItemsTotal:=$record.lineItemsTotal
		$buyingOrder.approver1:=$record.approver1
		$buyingOrder.approver2:=$record.approver2
		$buyingOrder.signature1:=$record.signature1
		$buyingOrder.signature2:=$record.signature2
		$buyingOrder.terms:=$terms
		$buyingOrder.termsCriticalMaterials:=$termsCriticalMaterials
		$buyingOrder.termsCriticalService:=$termsCriticalService
		
		$res:=$buyingOrder.save()
		
		If (Not:C34($res.success))
			
		Else 
			For each ($line; $buyingOrder.lines)
				$bo_line_e:=ds:C1482.BuyingOrderLine.new()
				
				$bo_line_e.order:=$line.order
				$bo_line_e.description:=$line.description
				$bo_line_e.qty:=$line.qty
				$bo_line_e.unitPrice:=$line.unitPrice
				$bo_line_e.lineTotal:=$line.lineTotal
				$bo_line_e.glAccount:=$line.glAccount
				$bo_line_e.orderDate:=cs:C1710.sfw_stmp.me.build(Date:C102($line.orderDate))
				$bo_line_e.requiredDate:=cs:C1710.sfw_stmp.me.build(Date:C102($line.requiredDate))
				$bo_line_e.dateIn:=cs:C1710.sfw_stmp.me.build(Date:C102($line.dateIn))
				$bo_line_e.checkNumber:=$line.checkNumber
				$bo_line_e.paidDate:=cs:C1710.sfw_stmp.me.build(Date:C102($line.paidDate))
				$bo_line_e.amountPaid:=$line.amountPaid
				$bo_line_e.jobNumber:=$line.jobNumber
				$bo_line_e.assetListNumber:=$line.assetListNumber
				$bo_line_e.supPsNumber:=$line.supPsNumber
				
				$res:=$bo_line_e.save()
				
				If (Not:C34($res.success))
					TRACE:C157
				End if 
			End for each 
		End if 
	End for each 
End if 
