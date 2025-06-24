//%attributes = {"executedOnServer":true}


If (True:C214)
	
	$file:=Folder:C1567(fk data folder:K87:12).file("DataJson/archived_jobs_export.json")
	
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
		$job.archived:=True:C214
		$job.pr_qualifier:=$record.pr_qualifier
		
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
					$lotStep_e.timeIn:=$step.timeIn
					$lotStep_e.timeOut:=$step.timeOut
					$lotStep_e.discard:=$step.discard
					$lotStep_e.type:=$step.type
					$lotStep_e.outOperator:=$step.outOperator
					$lotStep_e.inOperator:=$step.inOperator
					$lotStep_e.actualHours:=$step.actualHours
					$lotStep_e.plannedHours:=$step.plannedHours
					$lotStep_e.tools:=New object:C1471()
					$lotStep_e.tools:=$step.tools
					
					While ($lotStep_e.tools.items.indexOf("")#-1)
						
						$lotStep_e.tools.items:=$lotStep_e.tools.items.remove($lotStep_e.tools.items.indexOf(""))
						
					End while 
					
					$lotStep_e.parametricMeasurements:=New object:C1471("items"; New collection:C1472())
					$lotStep_e.stepInterruptions:=New object:C1471("items"; New collection:C1472())
					$lotStep_e.dataTables:=New object:C1471("items"; New collection:C1472())
					$lotStep_e.bins:=New object:C1471("items"; New collection:C1472())
					$lotStep_e.skills:=New object:C1471("items"; New collection:C1472())
					$lotStep_e.requitedCertifications:=New object:C1471("items"; New collection:C1472())
					
					
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



