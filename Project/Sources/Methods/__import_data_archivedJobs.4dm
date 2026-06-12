//%attributes = {"executedOnServer":true}
// Archived Lots -->{ARCHIVES] in the old sytem

If (True:C214)
	
	$file:=Folder:C1567(fk data folder:K87:12).file("DataJson/archived_jobs_export.json")
	
	$records:=JSON Parse:C1218($file.getText())
	$counter:=ds:C1482.JobInvoice.all().extract("invoiceNumber").map(Formula:C1597(Num:C11($1.value))).max()
	$lotCollection:=New collection:C1472()
	
	// Purpose: lotNumber → UUID dictionary built by PASS 1 (single-pass Lot creation).
	// Used by PASS 2 (parent resolution) and PASS 3 (LotStep creation) to look up entities
	// in O(1) instead of running `ds.Lot.query("lotNumber = ...").first()` per record.
	// modified by 4D/PS [2026-may-21]
	$lotsByNumber:=New object:C1471()
	
	
	For each ($record; $records)
		$counter:=$counter+1
		$job:=ds:C1482.Job.new()
		
		$job.jobNumber:=$record.jobNumber
		
		//$job.poNumber:=$record.poNumber
		$po_s:=ds:C1482.PurchaseOrder.query("oldPoNumber =:1"; Split string:C1554($record.poNumber; "\r"; sk trim spaces:K86:2).join("\r"))
		If ($po_s.length>0)
			$job.poNumber:=$po_s[0].poNumber
			$job.UUID_PurchaseOrder:=$po_s[0].UUID
			
		Else 
			$job.poNumber:=0
		End if 
		
		$division:=ds:C1482.Division.query("name =:1"; Split string:C1554($record.division; "\r"; sk trim spaces:K86:2).join("\r"))
		If ($division.length>0)
			$job.UUID_Division:=$division[0].UUID
		Else 
			
		End if 
		
		//$job.division:=$record.division
		$job.stmpCreated:=Date:C102($record.dateCreated)=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build(Date:C102($record.dateCreated))  //$record.dateCreated
		$job.stmpExpected:=(Date:C102($record.expectedDate)=!00-00-00!) | ($record.expectedDate=Null:C1517) ? 0 : cs:C1710.sfw_stmp.me.build(Date:C102($record.expectedDate))  //$record.expectedDate
		$job.stmpInvoiced:=Date:C102($record.invoiceDate)=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build(Date:C102($record.invoiceDate))  //$record.invoiceDate
		$job.stmpLastShipped:=Date:C102($record.lastShipDate)=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build(Date:C102($record.lastShipDate))  //$record.lastShipDate
		$job.stmpArchived:=Date:C102($record.archivedDate)=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build(Date:C102($record.archivedDate))  //$record.archivedDate
		
		$job.deviceNumber:=$record.deviceNumber
		$job.process:=$record.process
		$job.totalTax:=$record.salesTax
		$job.totalCharge:=$record.totalCharge
		$job.shipped:=$record.shipped
		$job.lineItem:=$record.lineItem
		$job.noLots:=$record.noLots
		$job.postToPO:=$record.postToPO
		$job.parentJobNumber:=$record.parentJobNumber
		$job.address:=$record.address
		$job.alternateShipAddress:=$record.alternateShipAddress
		$job.shippers:=$record.shippers
		
		$customer:=ds:C1482.Customer.query("name =:1"; Split string:C1554($record.customer; "\r"; sk trim spaces:K86:2).join("\r"))
		If ($customer.length>0)
			$job.UUID_Customer:=$customer[0].UUID
		Else 
			
		End if 
		
		$job.customerName:=$record.customer
		$job.qty:=$record.qty
		$job.qtyOnHand:=$record.qtyOnHand
		$job.shipMemo:=$record.shipMemo
		$job.jobComment:=$record.jobComment
		$job.archived:=True:C214
		$job.pr_qualifier:=$record.pr_qualifier
		$job.dropShipCustomer:=$record.dropShipCustomer
		
		$job.smtpRecommit:=Date:C102($record.recommitDate)=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build(Date:C102($record.recommitDate))  //$record.recommitDate
		
		$job.currency:=$record.currency
		$job.altDeviceNumber:=$record.altDeviceNumber
		$job.customerShipper:=$record.customerShipper
		$job.initials:=$record.initials
		$job.miscCharges:=$record.miscCharges
		$job.miscNote:=$record.miscNote
		$job.glAcc:=$record.glAcc
		$job.taxable:=$record.taxable
		
		$salesTax:=ds:C1482.SalesTax.query("rate =:1"; $record.salesTaxRate)
		If ($salesTax.length>0)
			$job.UUID_SalesTax:=$salesTax[0].UUID
		Else 
			$job.UUID_SalesTax:=16*"00"
		End if 
		
		$job.freight:=$record.freight
		$job.minimumJobCharge:=$record.minimumJobCharge
		$job.boxStockShipment:=$record.boxStockShipment
		$job.poRel:=$record.poRel
		$job.packageType:=$record.packageType
		$job.testerType:=$record.testerType
		$job.acNote:=$record.acNote
		$job.inventoryCost:=$record.inventoryCost
		$job.directCost:=$record.directCost
		
		$res:=$job.save()
		If (Not:C34($res.success))
			TRACE:C157
		End if 
		
		//If ($job.shipped) & Not($job.postToPO)
		
		$jobInvoice:=ds:C1482.JobInvoice.new()
		
		$jobInvoice.UUID_Job:=$job.UUID
		$jobInvoice.invoiceNumber:=String:C10($counter; "00000#")
		$jobInvoice.invoiceStmp:=Date:C102($record.invoiceDate)=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build(Date:C102($record.invoiceDate))
		//$jobInvoice.status:="Paid" or "Closed"
		$jobInvoice.poBasedCharges:=$record.poBasedCharges
		$jobInvoice.travBasedCharges:=$record.travBasedCharges
		$jobInvoice.totalSalesTax:=$record.salesTax
		$jobInvoice.total:=$record.totalCharge
		
		$res:=$jobInvoice.save()
		
		If (Not:C34($res.success))
			TRACE:C157
		End if 
		
		//End if 
		
		
		//var $unitCost : cs.UnitCostEntity
		
		//$unitCost:=ds.UnitCost.query("device =:1"; $job.unitPriceCode).first()
		//If ($unitCost#Null)
		//$job.UUID_UnitCost:=$unitCost.UUID
		//End if 
		
		var $ejobLineItem : cs:C1710.JobLineItemEntity
		
		For each ($jobLineItem; $record.jobLineItems)
			
			$ejobLineItem:=ds:C1482.JobLineItem.new()
			$ejobLineItem.UUID_Job:=$job.UUID
			$ejobLineItem.description:=$jobLineItem.description
			$ejobLineItem.quantity:=$jobLineItem.quantity
			$ejobLineItem.unitPrice:=$jobLineItem.unitPrice
			$ejobLineItem.taxable:=$jobLineItem.taxable
			$ejobLineItem.lineTotal:=$jobLineItem.lineTotal
			$ejobLineItem.salesTax:=$jobLineItem.salesTax
			
			$res:=$ejobLineItem.save()
			If (Not:C34($res.success))
				TRACE:C157
			End if 
			
		End for each 
		
		
		For each ($poline; $record.poLines)
			
			$poLine_es:=ds:C1482.PurchaseOrderLine.query("seqNum = :1"; $poLine.seqNum)
			
			If ($poLine_es.length>0)
				$poLine_e:=$poLine_es[0]
				
				If ($poLine_e.purchaseOrder.oldPoNumber=$record.poNumber) & ($poline.description=$poLine_e.description)
					$poLine_e.UUID_Job:=$job.UUID
					$poLine_e.total:=$poline.total
					$poLine_e.saleTax:=$poline.saleTax
					$poLine_e.taxable:=$poline.taxable
					$poLine_e.unitPrice:=$poline.unitPrice
					
					$res:=$poLine_e.save()
					
					If (Not:C34($res.success))
						TRACE:C157
					End if 
				End if 
			End if 
		End for each 
		
		
		// Purpose: Tag each lot with its owning job UUID, then aggregate into $lotCollection.
		// The previous design ran an extra Loop A here that created skeleton lots
		// (lotNumber + poNumber) only to re-query and overwrite them in the post-records
		// loop, doubling the number of saves. That Loop A is now removed because the
		// single-pass Lot creation (PASS 1, below) does everything in one save() per lot.
		// Also fixes a latent bug where the post-records loop used `$job.UUID` (= the
		// LAST job processed in the outer loop) for every lot regardless of its actual job.
		// modified by 4D/PS [2026-may-21]
		For each ($lotItem; $record.lots)
			$lotItem._jobUUID:=$job.UUID
		End for each 
		
		$lotCollection:=$lotCollection.concat($record.lots)
		
/*
For each ($lot; $record.lots)
$lot_e:=ds.Lot.new()
		
$lot_e.lotNumber:=$lot.lotNum
$lot_e.dateIn:=$lot.dateIn
$lot_e.dateOut:=$lot.dateOut
$lot_e.process:=$lot.process
$lot_e.device:=$lot.device
//$lot_e.altLotNumber:=$lot.altLotNumber
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
$lot_e.cOfCInspector:=$lot.cOfCInspector
$lot_e.packageType:=$lot.packageType
$lot_e.dateCode:=$lot.dateCode
$lot_e.carrier:=$lot.carrier
$lot_e.shipRel:=$lot.shipRel
$lot_e.totalCharge:=$lot.totalCharge
$lot_e.unitCost:=$lot.unitCost
		
$lot_e.UUID_Job:=$job.UUID
		
If ($lot.parentLotNumber#"") & Not(Undefined($lot.parentLotNumber))
$lots_es:=ds.Lot.query("lotNumber = :1"; $lot.parentLotNumber)
		
If ($lots_es.length>0)
$lot_e.UUID_LotParent:=$lots_es[0].UUID
Else 
TRACE
End if 
End if 
		
$res:=$lot_e.save()
		
If (Not($res.success))
TRACE
Else 
		
For each ($step; $lot.steps)
// Purpose: Mirror the active-jobs import: populate LotStep object fields (bins/parametricMeasurements/properties/moreData) from the legacy archived-job JSON, with backward-compatible fallbacks.
// modified by 4D/PS [2026-april-27]
$lotStep_e:=ds.LotStep.new()
		
$lotStep_e.order:=$step.order
$lotStep_e.description:=$step.description
$lotStep_e.lotSpecs:=$step.lotSpecs
$lotStep_e.specRevision:=$step.specRevision
$lotStep_e.alert:=$step.alert
$lotStep_e.qtyIn:=$step.qtyIn
$lotStep_e.qtyOut:=$step.qtyOut
$lotStep_e.rejects:=$step.rejects
$lotStep_e.minYield:=$step.minYield
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
$lotStep_e.tools:=New object()
$lotStep_e.tools:=$step.tools
$lotStep_e.areas:=$step.areas
$lotStep_e.mechanicalRejects:=$step.mechanicalRejects
$lotStep_e.missingOrExcluded:=$step.missingOrExcluded
$lotStep_e.yield:=$step.yield
$lotStep_e.supervisor:=$step.supervisor
$lotStep_e.enableBins:=$step.enableBins
		
While (($lotStep_e.tools#Null) && ($lotStep_e.tools.items.indexOf("")#-1))
		
$lotStep_e.tools.items:=$lotStep_e.tools.items.remove($lotStep_e.tools.items.indexOf(""))
		
End while 
		
$lotStep_e.parametricMeasurements:=New object(\
"items"; New collection(); \
"in"; New object("par1"; 0; "par2"; 0; "par3"; 0); \
"out"; New object("par1"; 0; "par2"; 0; "par3"; 0)\
)
If ($step.parametricMeasurements#Null)
If ($step.parametricMeasurements.in#Null)
$lotStep_e.parametricMeasurements.in:=$step.parametricMeasurements.in
End if 
If ($step.parametricMeasurements.out#Null)
$lotStep_e.parametricMeasurements.out:=$step.parametricMeasurements.out
End if 
End if 
		
$lotStep_e.stepInterruptions:=New object("items"; New collection())
$lotStep_e.dataTables:=New object("items"; New collection())
		
$lotStep_e.bins:=New object(\
"items"; New collection())
If ($step.bins#Null) && ($step.bins.items#Null)
For each ($bin; $step.bins.items)
$newBin:=New object()
$newBin.num:=$bin.num
$newBin.definition:=($bin.definition=Null) ? "" : $bin.definition
$newBin.type:=($bin.type=Null) ? "" : $bin.type
$newBin.value:=($bin.value=Null) ? 0 : $bin.value
$lotStep_e.bins.items.push($newBin)
End for each 
End if 
		
$lotStep_e.properties:=New object(\
"pgm"; ""; \
"pgmSwitch"; ""; \
"hardware1"; ""; \
"hardware2"; ""; \
"probeCard"; ""; \
"count1"; 0; \
"count2"; 0; \
"count3"; 0\
)
If ($step.properties#Null)
$lotStep_e.properties:=$step.properties
End if 
		
$lotStep_e.skills:=New object("items"; New collection())
$lotStep_e.requitedCertifications:=New object("items"; New collection())
		
		
$lotStep_e.UUID_Lot:=$lot_e.UUID
		
$res:=$lotStep_e.save()
		
If (Not($res.success))
TRACE
End if 
End for each 
End if 
		
End for each 
*/
		
	End for each 
	
	// PASS 1 — Create every archived lot in a single save() per record (no parent yet,
	// no steps yet) and build the lotNumber → UUID dictionary used by PASS 2 and PASS 3.
	// This replaces the old two-pass design (skeleton Loop A + fill Loop B) that re-queried
	// each lot just after creating it. The orderBy("parentLotNumber asc") is kept for stable
	// processing order; parent UUIDs are filled in PASS 2 so cross-job parents are handled.
	// created by 4D/PS [2026-may-21]
	For each ($lot; $lotCollection.orderBy("parentLotNumber asc"))
		
		var $lot_e : cs:C1710.LotEntity
		$lot_e:=ds:C1482.Lot.new()
		$lot_e.lotNumber:=$lot.lotNum
		$lot_e.dateIn:=$lot.dateIn
		$lot_e.dateOut:=$lot.dateOut
		$lot_e.process:=$lot.process
		$lot_e.device:=$lot.device
		//$lot_e.altLotNumber:=$lot.altLotNumber
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
		$lot_e.altDevNumber:=$lot.altDevNumber
		$lot_e.cOfCInspector:=$lot.cOfCInspector
		$lot_e.packageType:=$lot.packageType
		$lot_e.dateCode:=$lot.dateCode
		$lot_e.carrier:=$lot.carrier
		$lot_e.shipRel:=$lot.shipRel
		$lot_e.totalCharge:=$lot.totalCharge
		$lot_e.unitCost:=$lot.unitCost
		
		// Purpose: Use the per-lot job UUID tagged inside the records loop instead of
		// `$job.UUID`, which here would be the LAST job processed.
		// modified by 4D/PS [2026-may-21]
		$lot_e.UUID_Job:=$lot._jobUUID
		
		//$lot_e.moreData:=New object()
		//$recodNumber:=ds:C1482.sfw_Counter.getNextValue("Lot")
		//$lot_e.moreData.barcodeData:=String:C10($recodNumber; "0000000000")
		
		$res:=$lot_e.save()
		
		If (Not:C34($res.success))
			TRACE:C157
		Else 
			$lotsByNumber[$lot.lotNum]:=$lot_e.UUID
		End if 
		
		
	End for each 
	
	// PASS 2 — Resolve UUID_LotParent via the dictionary built in PASS 1. No DB queries:
	// every lot is already in the dict, so parent lookup is O(1). Cross-job parents are
	// handled naturally because $lotCollection aggregates lots from every record.
	// created by 4D/PS [2026-may-21]
	For each ($lot; $lotCollection)
		If (($lot.parentLotNumber#"") & Not:C34(Undefined:C82($lot.parentLotNumber)))
			$parentUUID:=$lotsByNumber[$lot.parentLotNumber]
			$childUUID:=$lotsByNumber[$lot.lotNum]
			If (($parentUUID#Null:C1517) & ($childUUID#Null:C1517))
				$lot_e:=ds:C1482.Lot.get($childUUID)
				If ($lot_e#Null:C1517)
					$lot_e.UUID_LotParent:=$parentUUID
					$res:=$lot_e.save()
					If (Not:C34($res.success))
						TRACE:C157
					End if 
					
				End if 
			Else 
				If ($parentUUID=Null:C1517)
					TRACE:C157  // parent lot missing from the import — kept for diagnostic
				End if 
			End if 
		End if 
	End for each 
	
	// PASS 3 — Create LotSteps for every archived lot. UUID_Lot comes from the dictionary,
	// created by 4D/PS [2026-may-21]
	For each ($lot; $lotCollection)
		$lotUUID:=$lotsByNumber[$lot.lotNum]
		If ($lotUUID#Null:C1517)
			For each ($step; $lot.steps)
				$lotStep_e:=ds:C1482.LotStep.new()
				
				$lotStep_e.order:=$step.order
				$lotStep_e.description:=$step.description
				$lotStep_e.lotSpecs:=$step.lotSpecs
				$lotStep_e.specRevision:=$step.specRevision
				$lotStep_e.alert:=$step.alert
				$lotStep_e.qtyIn:=$step.qtyIn
				$lotStep_e.qtyOut:=$step.qtyOut
				$lotStep_e.rejects:=$step.rejects
				$lotStep_e.minYield:=$step.minYield
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
				$lotStep_e.areas:=$step.areas
				$lotStep_e.mechanicalRejects:=$step.mechanicalRejects
				$lotStep_e.missingOrExcluded:=$step.missingOrExcluded
				$lotStep_e.yield:=$step.yield
				$lotStep_e.supervisor:=$step.supervisor
				$lotStep_e.enableBins:=$step.enableBins
				
				// Purpose: Direct copy from parsed legacy JSON; LotStepEntity.validateSave normalizes object fields on save().
				// modified by 4D/PS [2026-june-01]
				If ($step.tools#Null:C1517)
					$lotStep_e.tools:=$step.tools
				End if 
				If ($step.bins#Null:C1517)
					$lotStep_e.bins:=$step.bins
				End if 
				If ($step.parametricMeasurements#Null:C1517)
					$lotStep_e.parametricMeasurements:=$step.parametricMeasurements
				End if 
				If ($step.properties#Null:C1517)
					$lotStep_e.properties:=$step.properties
				End if 
				
				$lotStep_e.stepInterruptions:=New object:C1471("items"; New collection:C1472())
				$lotStep_e.dataTables:=New object:C1471("items"; New collection:C1472())
				
				// Purpose: Fill skills + requitedCertifications from StepTemplate (LotStep.type = templateNumber).
				// modified by 4D/PS [2026-june-09]
				// Purpose: Renamed helper to fit 4D 31-char project method name limit.
				// modified by 4D/PS [2026-june-09]
				__import_stLotStepApplyCerts($lotStep_e)
				
/*
				
$lotStep_e.tools:=New object()
$lotStep_e.tools:=$step.tools.items.filter(Formula($1.value#""))  //$step.tools
				
$lotStep_e.parametricMeasurements:=New object(\
"items"; New collection(); \
"in"; New object(); \
"out"; New object()\
)
				
$lotStep_e.parametricMeasurements:=New object(\
"items"; New collection(); \
"in"; New object("par1"; 0; "par2"; 0; "par3"; 0); \
"out"; New object("par1"; 0; "par2"; 0; "par3"; 0)\
)
If ($step.parametricMeasurements#Null)
If ($step.parametricMeasurements.in#Null)
$lotStep_e.parametricMeasurements.in:=$step.parametricMeasurements.in
End if 
If ($step.parametricMeasurements.out#Null)
$lotStep_e.parametricMeasurements.out:=$step.parametricMeasurements.out
End if 
End if 
				
$lotStep_e.stepInterruptions:=New object("items"; New collection())
$lotStep_e.dataTables:=New object("items"; New collection())
				
$lotStep_e.bins:=New object(\
"items"; $step.bins.items)
				
$lotStep_e.properties:=New object(\
"pgm"; ""; \
"pgmSwitch"; ""; \
"hardware1"; ""; \
"hardware2"; ""; \
"probeCard"; ""; \
"count1"; 0; \
"count2"; 0; \
"count3"; 0\
)
If ($step.properties#Null)
$lotStep_e.properties:=$step.properties
End if 
				
$lotStep_e.skills:=New object("items"; New collection())
$lotStep_e.requitedCertifications:=New object("items"; New collection())
*/
				$lotStep_e.UUID_Lot:=$lotUUID
				
				$res:=$lotStep_e.save()
				
				If (Not:C34($res.success))
					TRACE:C157
				End if 
				
				
			End for each 
		End if 
	End for each 
	
	
/**
fix lotParent for some lots
**/
	
	$lots_es:=ds:C1482.Lot.all().minus(ds:C1482.Lot.all().lotParent.subLots).query("lotNumber = :1"; "@-@")
	
	For each ($lot; $lots_es)
		$parentLotNumber:=Split string:C1554($lot.lotNumber; "-")[0]
		
		// Purpose: Reuse the in-memory dictionary first to avoid a per-row query; fall back
		// to ds.Lot.query() only when the parent lot isn't in the dict (shouldn't happen
		// unless its save() failed in PASS 1).
		// modified by 4D/PS [2026-may-21]
		$parentUUID:=$lotsByNumber[$parentLotNumber]
		If ($parentUUID=Null:C1517)
			$parent_es:=ds:C1482.Lot.query("lotNumber = :1"; $parentLotNumber)
			If ($parent_es.length>0)
				$parentUUID:=$parent_es[0].UUID
			End if 
		End if 
		
		If ($parentUUID#Null:C1517)
			$lot.UUID_LotParent:=$parentUUID
			$res:=$lot.save()
			If (Not:C34($res.success))
				TRACE:C157
			End if 
		End if 
	End for each 
	
	
End if 



