//%attributes = {}
/**
import po & po lines (po <-- po_lines)
**/
If (True:C214)
	TRUNCATE TABLE:C1051([PurchaseOrder:115])
	TRUNCATE TABLE:C1051([PurchaseOrderLine:116])
	TRUNCATE TABLE:C1051([Invoice:4])
	
	$file:=Folder:C1567(fk database folder:K87:14).file("po_log_export.json")
	
	$records:=JSON Parse:C1218($file.getText())
	
	For each ($record; $records)
		$po:=ds:C1482.PurchaseOrder.new()
		
		$po.customer_name:=$record.customer_name
		$po.poNumber:=$record.poNumber
		$po.poAmount:=$record.poAmount
		$po.amountBilled:=$record.amountBilled
		$po.ourQuote:=$record.ourQuote
		$po.resaleNumber:=$record.resaleNumber
		$po.identifier:=$record.identifier
		$po.initials:=$record.initials
		$po.division:=$record.division
		$po.openPO:=$record.openPO
		$po.address:=$record.address
		$po.altBillTo:=$record.altBillTo
		$po.dropShipCustomer:=$record.dropShipCustomer
		$po.releaseNumber:=$record.releaseNumber
		$po.forTimeBilling:=$record.forTimeBilling
		$po.timeBillingRate:=$record.timeBillingRate
		$po.timeBilling:=$record.timeBilling
		$po.description:=$record.description
		
		$res:=$po.save()
		
		If (Not:C34($res.success))
			TRACE:C157
		Else 
			
			For each ($invoice; $record.invoices)
				$invoice_e:=ds:C1482.Invoice.new()
				
				$invoice_e.division:=$invoice.division
				$invoice_e.invoice:=$invoice.invoice
				$invoice_e.date:=$invoice.date
				$invoice_e.currency:=$invoice.currency
				$invoice_e.total:=$invoice.total
				$invoice_e.due:=$invoice.due
				$invoice_e.slip:=$invoice.slip
				$invoice_e.UUID_PurchaseOrder:=$po.UUID
				
				$res:=$invoice_e.save()
				
				If (Not:C34($res.success))
					TRACE:C157
				End if 
			End for each 
			
			For each ($line; $record.lineItems)
				$poLine:=ds:C1482.PurchaseOrderLine.new()
				
				$poLine.UUID_PurchaseOrder:=$po.UUID
				$poLine.itemNum:=$line.itemNum
				$poLine.description:=$line.description
				$poLine.partNum:=$line.partNum
				$poLine.dateOrdered:=$line.dateOrdered
				$poLine.customerRequestedDate:=$line.customerRequestedDate
				$poLine.qtyOrdered:=$line.qtyOrdered
				$poLine.currency:=$line.currency
				$poLine.unitPrice:=$line.unitPrice
				$poLine.shipJobNumber:=$line.shipJobNumber
				$poLine.buildJobNumber:=$line.buildJobNumber
				$poLine.unreleased:=$line.unreleased
				$poLine.closed:=$line.closed
				$poLine.seqNum:=$line.seqNum
				
				$res:=$poLine.save()
				
				If (Not:C34($res.success))
					TRACE:C157
				End if 
				
			End for each 
		End if 
	End for each 
End if 

/**
import jobs & lot (job <-- lots)
**/
If (True:C214)
	TRUNCATE TABLE:C1051([Job:117])
	TRUNCATE TABLE:C1051([Lot:118])
	
	$file:=Folder:C1567(fk database folder:K87:14).file("job_log_export.json")
	
	$records:=JSON Parse:C1218($file.getText())
	
	For each ($record; $records)
		$job:=ds:C1482.Job.new()
		
		$job.jobNumber:=$record.jobNumber
		$job.poNumber:=$record.poNumber
		$job.division:=$record.division
		$job.dateCreated:=$record.dateCreated
		$job.deviceNumber:=$record.deviceNumber
		$job.process:=$record.process
		$job.salesTax:=$record.salesTax
		$job.totalCharge:=$record.totalCharge
		$job.shipped:=$record.shipped
		$job.lineItem:=$record.lineItem
		$job.noLots:=$record.noLots
		$job.postToPO:=$record.postToPO
		$job.parentJobNumber:=$record.parentJobNumber
		$job.address:=$record.address
		$job.alternateShipAddress:=$record.alternateShipAddress
		$job.shippers:=$record.shippers
		$job.customerShipper:=$record.customerShipper
		$job.qty:=$record.qty
		$job.qtyOnHand:=$record.qtyOnHand
		$job.shipMemo:=$record.shipMemo
		$job.jobComment:=$record.jobComment
		
		$res:=$job.save()
		
		If (Not:C34($res.success))
			TRACE:C157
		End if 
		
		For each ($poline; $record.poLines)
			$poLine_es:=ds:C1482.PurchaseOrderLine.query("seqNum = :1"; $poLine.seqNum)
			
			If ($poLine_es.length>0)
				$poLine_e:=$poLine_es[0]
				
				If ($poLine_e.purchaseOrder.poNumber=$record.poNumber) & ($poline.description=$poLine_e.description)
					$poLine_e.UUID_Job:=$job.UUID
					
					$res:=$poLine_e.save()
					
					If (Not:C34($res.success))
						TRACE:C157
					End if 
				End if 
			End if 
		End for each 
		
		
		For each ($lot; $record.lots)
			$lot_e:=ds:C1482.Lot.new()
			
			$lot_e.lotNumber:=$lot.lotNum
			$lot_e.dateIn:=$lot.dateIn
			$lot_e.dateOut:=$lot.dateOut
			$lot_e.process:=$lot.process
			$lot_e.device:=$lot.device
			$lot_e.altLotNumber:=$lot.altLotNumber
			$lot_e.deviceTableLink:=$lot.deviceTableLink
			$lot_e.currentOrNextArea:=$lot.currentOrNextArea
			$lot_e.onHold:=$lot.onHold
			$lot_e.holdDate:=$lot.holdDate
			$lot_e.holdTime:=$lot.holdTime
			$lot_e.poNumber:=$lot.poNumber
			$lot_e.customer:=$lot.customer
			$lot_e.commit:=$lot.commit
			$lot_e.reCommit:=$lot.reCommit
			$lot_e.original:=$lot.original
			$lot_e.progressive:=$lot.progressive
			$lot_e.ourCount:=$lot.ourCount
			$lot_e.totalTested:=$lot.totalTested
			$lot_e.az:=$lot.az
			$lot_e.et:=$lot.et
			
			$lot_e.UUID_Job:=$job.UUID
			
			$res:=$lot_e.save()
			
			If (Not:C34($res.success))
				TRACE:C157
			End if 
		End for each 
		
	End for each 
End if 

/**
import inventories
**/
If (True:C214)
	TRUNCATE TABLE:C1051([Inventory:126])
	
	$file:=Folder:C1567(fk database folder:K87:14).file("inventory_export.json")
	
	$records:=JSON Parse:C1218($file.getText())
	
	For each ($record; $records)
		$inventory_e:=ds:C1482.Inventory.new()
		
		$inventory_e.customerSpecific:=$record.customerSpecific
		$inventory_e.partNum:=$record.partNum
		$inventory_e.vendor:=$record.vendor
		$inventory_e.description:=$record.description
		$inventory_e.classification:=$record.classification
		$inventory_e.lotNumber:=$record.lotNumber
		$inventory_e.stockNum:=$record.stockNum
		$inventory_e.dateIn:=$record.dateIn
		$inventory_e.expirationDate:=$record.expirationDate
		$inventory_e.qtyInStock:=$record.qtyInStock
		$inventory_e.unitCost:=$record.unitCost
		$inventory_e.inventoryUnits:=$record.inventoryUnits
		$inventory_e.currency:=$record.currency
		$inventory_e.binLocation:=$record.binLocation
		$inventory_e.recdBy:=$record.recdBy
		$inventory_e.division:=$record.division
		$inventory_e.totalCost:=$record.totalCost
		$inventory_e.property:=$record.property
		
		$res:=$inventory_e.save()
		
		If (Not:C34($res.success))
			TRACE:C157
		Else 
			For each ($pull; $record.pulls)
				$pull_e:=ds:C1482.InventoryPull.new()
				
				$pull_e.partNum:=$pull.partNum
				$pull_e.qty:=$pull.qty
				$pull_e.cost:=$pull.partNum
				$pull_e.datePulled:=$pull.datePulled
				$pull_e.jobNumber:=$pull.jobNumber
				$pull_e.uniqueID:=$pull.uniqueID
				$pull_e.pulledBy:=$pull.pulledBy
				$pull_e.division:=$pull.division
				$pull_e.docsInDocServer:=$pull.docsInDocServer
				$pull_e.currency:=$pull.currency
				$pull_e.units:=$pull.units
				$pull_e.currency:=$pull.currency
				$pull_e.pullMode:=$pull.pullMode
				$pull_e.lotNumber:=$pull.lotNumber
				$pull_e.property:=$pull.property
				$pull_e.jobInvoiceDate:=$pull.jobInvoiceDate
				$pull_e.UUID_Inventory:=$inventory_e.UUID
				
				$res:=$pull_e.save()
				
				If (Not:C34($res.success))
					TRACE:C157
				End if 
			End for each 
		End if 
		
	End for each 
End if 

ALERT:C41("END!!")
