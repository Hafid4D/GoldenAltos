//%attributes = {}
/**
import po & po lines (po <-- po_lines)
**/
If (True:C214)
	TRUNCATE TABLE:C1051([PurchaseOrder:115])
	TRUNCATE TABLE:C1051([PurchaseOrderLine:116])
	TRUNCATE TABLE:C1051([Invoice:4])
	
	$file:=Folder:C1567(fk data folder:K87:12).file("DataJson/po_log_export.json")
	
	$records:=JSON Parse:C1218($file.getText())
	
	$erreur:=New collection:C1472()
	
	For each ($record; $records)
		$po:=ds:C1482.PurchaseOrder.new()
		
		$customer_es:=ds:C1482.Customer.query("name = :1"; $record.customer_name)
		
		If ($customer_es.length>0)
			$po.UUID_Customer:=$customer_es[0].UUID
		Else 
			$erreur.push($record.customer_name)
		End if 
		
		//$po.customer_name:=$record.customer_name
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
		
		var $customer : Object
		$customer:=ds:C1482.Customer.query("name =:1"; $record.customer_name).first()
		If ($customer#Null:C1517)
			$po.UUID_Customer:=$customer.UUID
			
		End if 
		
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
	
	If ($erreur.length>0)
		TRACE:C157
	End if 
End if 

/**
import jobs & lot (job <-- lots)
**/
If (True:C214)
	TRUNCATE TABLE:C1051([Job:117])
	TRUNCATE TABLE:C1051([Lot:118])
	TRUNCATE TABLE:C1051([LotStep:5])
	
	$file:=Folder:C1567(fk data folder:K87:12).file("DataJson/job_log_export.json")
	
	$records:=JSON Parse:C1218($file.getText())
	
	For each ($record; $records)
		$job:=ds:C1482.Job.new()
		
		$job.jobNumber:=$record.jobNumber
		$job.poNumber:=$record.poNumber
		$job.division:=$record.division
		$job.dateCreated:=$record.dateCreated
		$job.expectedDate:=$record.expectedDate
		$job.invoiceDate:=$record.invoiceDate
		$job.lastShipDate:=$record.lastShipDate
		$job.archivedDate:=$record.archivedDate
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
		$job.customer:=$record.customer
		$job.qty:=$record.qty
		$job.qtyOnHand:=$record.qtyOnHand
		$job.shipMemo:=$record.shipMemo
		$job.jobComment:=$record.jobComment
		$job.archived:=$record.archived
		
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
			$lot_e.OQADone:=$lot.OQADone
			$lot_e.OQADate:=$lot.OQADate
			$lot_e.OQASimpleSize:=$lot.OQASimpleSize
			$lot_e.releaseNumber:=$lot.releaseNumber
			$lot_e.trackingNumber:=$lot.trackingNumber
			$lot_e.readyToShipDate:=$lot.readyToShipDate
			$lot_e.shippingMemo:=$lot.shippingMemo
			$lot_e.location:=$lot.location
			$lot_e.comment:=$lot.comment
			$lot_e.status:=$lot.status
			
			$lot_e.UUID_Job:=$job.UUID
			
			$res:=$lot_e.save()
			
			If (Not:C34($res.success))
				TRACE:C157
			Else 
				
				For each ($step; $lot.steps)
					$lotStep_e:=ds:C1482.LotStep.new()
					
					$lotStep_e.order:=$step.order
					$lotStep_e.description:=$step.description
					$lotStep_e.lotSpecs:=$step.lotSpecs
					$lotStep_e.specRevision:=$step.specRevision
					$lotStep_e.alert:=$step.alert
					$lotStep_e.qtyIn:=$step.qtyIn
					$lotStep_e.qtyOut:=$step.qtyOut
					$lotStep_e.dateIn:=$step.dateIn
					$lotStep_e.dateOut:=$step.dateOut
					
					$lotStep_e.UUID_Lot:=$lot_e.UUID
					
					$res:=$lotStep_e.save()
					
					If (Not:C34($res.success))
						TRACE:C157
					End if 
				End for each 
			End if 
		End for each 
		
	End for each 
End if 

/**
import inventories
**/
If (False:C215)
	TRUNCATE TABLE:C1051([Inventory:126])
	
	$file:=Folder:C1567(fk data folder:K87:12).file("DataJson/inventory_export.json")
	
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

/**
import step template
**/
If (False:C215)
	TRUNCATE TABLE:C1051([StepTemplate:121])
	
	$file:=Folder:C1567(fk data folder:K87:12).file("DataJson/step_template_export.json")
	
	$records:=JSON Parse:C1218($file.getText())
	
	For each ($record; $records)
		$stepTemplate_e:=ds:C1482.StepTemplate.new()
		
		$stepTemplate_e.name:=$record.name
		$stepTemplate_e.operation:=$record.operation
		$stepTemplate_e.division:=$record.division
		$stepTemplate_e.status:=$record.status
		$stepTemplate_e.binning:=$record.binning
		$stepTemplate_e.smallLayout:=$record.smallLayout
		$stepTemplate_e.largeLayout:=$record.largeLayout
		$stepTemplate_e.comment1:=$record.comment1
		$stepTemplate_e.comment2:=$record.comment2
		
		$res:=$stepTemplate_e.save()
		
		If (Not:C34($res.success))
			
		End if 
	End for each 
End if 

/**
import tools
**/
If (False:C215)
	TRUNCATE TABLE:C1051([ToolType:122])
	
	$file:=Folder:C1567(fk data folder:K87:12).file("DataJson/tools_export.json")
	
	$records:=JSON Parse:C1218($file.getText())
	
	For each ($record; $records)
		$toolType_e:=ds:C1482.ToolType.new()
		
		$toolType_e.name:=$record.name
		$toolType_e.type:=$record.type
		$toolType_e.date:=$record.date
		
		$res:=$toolType_e.save()
		
		If (Not:C34($res.success))
			TRACE:C157
		Else 
			For each ($tool; $record.tools)
				$tool_e:=ds:C1482.Tool.new()
				
				$tool_e.name:=$tool
				$tool_e.UUID_ToolType:=$toolType_e.UUID
				
				$res:=$tool_e.save()
				
				If (Not:C34($res.success))
					TRACE:C157
				End if 
			End for each 
		End if 
	End for each 
End if 

/**
import cetifications
**/
If (False:C215)
	TRUNCATE TABLE:C1051([Certification:124])
	
	$file:=Folder:C1567(fk data folder:K87:12).file("DataJson/certifications_export.json")
	
	$records:=JSON Parse:C1218($file.getText())
	
	For each ($record; $records)
		$certification_e:=ds:C1482.Certification.new()
		
		$certification_e.ref:=$record.ref
		$certification_e.name:=$record.name
		
		$res:=$certification_e.save()
		
		If (Not:C34($res.success))
			TRACE:C157
		End if 
	End for each 
End if 

ALERT:C41("END!!")
