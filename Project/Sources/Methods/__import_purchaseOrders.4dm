//%attributes = {"executedOnServer":true}
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
	
	$poNumber:=0
	
	For each ($record; $records)
		
		$poNumber:=$poNumber+1
		
		$po:=ds:C1482.PurchaseOrder.new()
		
		$customer_es:=ds:C1482.Customer.query("name = :1"; $record.customer_name)
		
		If ($customer_es.length>0)
			$po.UUID_Customer:=$customer_es[0].UUID
		Else 
			$erreur.push($record.customer_name)
		End if 
		
		//$po.customer_name:=$record.customer_name
		
		$po.poNumber:=$poNumber
		$po.oldPoNumber:=$record.poNumber
		$po.poAmount:=$record.poAmount
		$po.amountBilled:=$record.amountBilled
		
		//$po.ourQuote:=$record.ourQuote
		$quote:=ds:C1482.Quote.query("code =:1"; Split string:C1554($record.ourQuote; "\r"; sk trim spaces:K86:2).join("\r"))
		If ($quote.length>0)
			$po.UUID_Quote:=$quote[0].UUID
		Else 
			
		End if 
		
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
		$po.log_date:=$record.Log_date
		
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
				$invoice_e.customerId:=$invoice.customerId
				$invoice_e.amountPaid:=$invoice.amountPaid
				$invoice_e.saleAmount:=$invoice.saleAmount
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
		//TRACE
	End if 
End if 

/**
import jobs & lot (job <-- lots) & Archives
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
		
		//$job.poNumber:=$record.poNumber
		$po_s:=ds:C1482.PurchaseOrder.query("oldPoNumber =:1"; Split string:C1554($record.poNumber; "\r"; sk trim spaces:K86:2).join("\r"))
		If ($po_s.length>0)
			$job.poNumber:=$po_s[0].poNumber
		Else 
			$job.poNumber:=0
		End if 
		
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
		$job.pr_qualifier:=$record.pr_qualifier
		
		$res:=$job.save()
		
		If (Not:C34($res.success))
			TRACE:C157
		End if 
		
		For each ($poline; $record.poLines)
			$poLine_es:=ds:C1482.PurchaseOrderLine.query("seqNum = :1"; $poLine.seqNum)
			
			If ($poLine_es.length>0)
				$poLine_e:=$poLine_es[0]
				
				If ($poLine_e.purchaseOrder.oldPoNumber=$record.poNumber) & ($poline.description=$poLine_e.description)
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
			
			//$lot_e.poNumber:=$lot.poNumber
			$po_s:=ds:C1482.PurchaseOrder.query("oldPoNumber =:1"; Split string:C1554($record.poNumber; "\r"; sk trim spaces:K86:2).join("\r"))
			If ($po_s.length>0)
				$lot_e.poNumber:=$po_s[0].poNumber
			Else 
				$lot_e.poNumber:=0
			End if 
			
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

/**
import inventories
**/
If (True:C214)
	TRUNCATE TABLE:C1051([Inventory:126])
	TRUNCATE TABLE:C1051([InventoryPull:127])
	
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
		$inventory_e.availableQty:=$record.AvailableQty
		$inventory_e.originalQty:=$record.originalQty
		
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
If (True:C214)
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
If (True:C214)
	TRUNCATE TABLE:C1051([ToolType:122])
	TRUNCATE TABLE:C1051([Tool:6])
	
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
				
				$tool_e.name:=Split string:C1554($tool; "*")[0]
				$tool_e.date:=Date:C102(Split string:C1554($tool; "*")[1])
				
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
If (True:C214)
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

/**
import specifications
**/
If (True:C214)
	
	var $blob : Blob
	
	TRUNCATE TABLE:C1051([Specification:10])
	
	$file:=Folder:C1567(fk data folder:K87:12).file("DataJson/specification_export.json")
	
	$records:=JSON Parse:C1218($file.getText())
	
	$docs:=Folder:C1567(fk data folder:K87:12).file("DataJson/docServerIndex_export.json")
	If ($docs.exists)
		$documents:=JSON Parse:C1218($docs.getText())
	End if 
	
	
	For each ($record; $records)
		$specification_e:=ds:C1482.Specification.new()
		
		$specification_e.spec:=$record.Spec
		$specification_e.title:=$record.Spec_Title
		$specification_e.revisionDate:=Date:C102($record.Revsion_Date)
		$specification_e.revision:=$record.Rev
		
		//$specification_e.division:=$record.Division  //TO CHANGE
		$division:=ds:C1482.Division.query("name =:1"; Split string:C1554($record.Division; "\r"; sk trim spaces:K86:2).join("\r"))
		If ($division.length>0)
			$specification_e.divisionID:=$division[0].divisionID
		Else 
			$specification_e.divisionID:=0
		End if 
		
		$specification_e.isForm:=$record.Form
		
		//$specification_e.category:=$record.PublishedDocCategory  //TO CHANGE
		$category:=ds:C1482.SpecCategory.query("name =:1"; Split string:C1554($record.PublishedDocCategory; "\r"; sk trim spaces:K86:2).join("\r"))
		If ($category.length>0)
			$specification_e.categoryID:=$category[0].categoryID
		Else 
			$specification_e.categoryID:=0
		End if 
		
		$specification_e.remark:=$record.Remarks
		$specification_e.extension:=$record.Dosext
		$specification_e.addendum:=$record.Addendum
		$specification_e.addendumToSpec:=$record.AddendumToSpec
		$specification_e.suppress:=$record.Suppress
		$specification_e.reviewIntervalInDays:=$record.ReviewIntervalInDays
		$specification_e.reviewDate:=$record.Review_Date
		
		//$specification_e.departmentID:=$record.ControllingDept
		$stecControllingDetpt:=ds:C1482.SpecControllingDept.query("name =:1"; Split string:C1554($record.ControllingDept; "\r"; sk trim spaces:K86:2).join("\r"))
		If ($stecControllingDetpt.length>0)
			$specification_e.departmentID:=$stecControllingDetpt[0].departmentID
		Else 
			$specification_e.departmentID:=0
		End if 
		
		
		$PublishedDocumentBlob:=Folder:C1567(fk data folder:K87:12).file("DataJson/SpecificationsPublishedDocumentBlobFields/"+String:C10($record.Spec))
		If ($PublishedDocumentBlob.exists)
			
			DOCUMENT TO BLOB:C525($PublishedDocumentBlob.platformPath; $blob)
			$specification_e.publishedDocumentBlob:=$blob
			
		Else 
			
		End if 
		
		
		$_documents:=$documents.query("PrimaryKeyValue=:1 & TableNumber=:2"; String:C10($record.UniqueID); 21)
		
		$specification_e.documents:=New object:C1471()
		$specification_e.documents.documentsCollection:=New collection:C1472()
		
		For each ($document; $_documents)
			$docObj:=New object:C1471
			
			$docObj.code:=$document.DocCode
			$docObj.dateTimeStamp:=$document.DateTimeStamp
			$docObj.creationDateTimeStamp:=$document.CreationDateTimeStamp
			$docObj.documentPath:=$document.DocumentPath
			$docObj.sourcePath:=$document.SourcePath
			$docObj.description:=$document.DocDescription
			$docObj.approvalDate:=!00-00-00!
			$docObj.approvedBy:=""
			$docObj.isApproved:=False:C215
			
			$doc:=Folder:C1567(fk data folder:K87:12).file("DataJson/SpecificationsDocuments/"+String:C10($document.UniqueID+$document.PrimaryKeyValue))
			If ($doc.exists)
				
				
				DOCUMENT TO BLOB:C525($doc.platformPath; $blob)
				
				$docObj.blob:=$blob
				
			End if 
			
			$specification_e.documents.documentsCollection.push($docObj)
		End for each 
		
		
		$res:=$specification_e.save()
		If (Not:C34($res.success))
			TRACE:C157
		End if 
	End for each 
End if 

/**
Create user: sfw_User & Staff tables
**/
If (True:C214)
	TRUNCATE TABLE:C1051([Staff:135])
	TRUNCATE TABLE:C1051([sfw_User:16])
	
	//$user:=ds.sfw_User.new()
	//$user.firstName:="Hassan"
	//$user.lastName:="Sribet"
	//$user.login:="hassansribet"
	//$user.accesses:=JSON Parse("{\"asDesigner\":true,\"password\":{\"temporary\":false,\"sendTemporaryByMail\":false,\"lastReset\":705253775,\"hash\":\"$2b$10$cLpZxBy5QcJCQ0K5DbscjuC3KC2bUblf0l5IJLtByF342d6OFlmFS\",\"lastChange\":705253879}}")
	//$user.asDesigner:=True
	
	//$res:=$user.save()
	
	If (Not:C34($res.success))
		TRACE:C157
	End if 
	
	$staff:=ds:C1482.Staff.new()
	$staff.UUID_User:=$user.UUID
	$staff.firstName:="Hassan"
	$staff.lastName:="Sribet"
	$staff.code:="001144"
	
	$staff.contactDetails:=New object:C1471(\
		"addresses"; New collection:C1472(); \
		"communications"; New collection:C1472()\
		)
	
	$res:=$staff.save()
	
	If (Not:C34($res.success))
		TRACE:C157
	End if 
	
	//$user:=ds.sfw_User.new()
	//$user.firstName:="Omar"
	//$user.lastName:="Debbagh"
	//$user.login:="omardebbagh"
	//$user.accesses:=JSON Parse("{\"asDesigner\":true,\"password\":{\"temporary\":false,\"sendTemporaryByMail\":false,\"lastReset\":706358866,\"hash\":\"$2b$10$jWCPtle9cInwDJfVJbCrsecHbiVfbbBISVGEOOGXMILflvJnv9aJG\",\"lastChange\":706358916}}")
	
	//$res:=$user.save()
	
	If (Not:C34($res.success))
		TRACE:C157
	End if 
	
	$staff:=ds:C1482.Staff.new()
	$staff.UUID_User:=$user.UUID
	$staff.firstName:="Omar"
	$staff.lastName:="Debbagh"
	$staff.code:="001155"
	
	$staff.contactDetails:=New object:C1471(\
		"addresses"; New collection:C1472(); \
		"communications"; New collection:C1472()\
		)
	
	$res:=$staff.save()
	
	If (Not:C34($res.success))
		TRACE:C157
	End if 
End if 

/**
import staffs
**/
If (True:C214)
	TRUNCATE TABLE:C1051([Staff:135])
	
	$file:=Folder:C1567(fk data folder:K87:12).file("DataJson/staff_export.json")
	
	$records:=JSON Parse:C1218($file.getText())
	
	
	For each ($record; $records)
		$staff_e:=ds:C1482.Staff.new()
		
		$staff_e.firstName:=$record.firstName
		$staff_e.lastName:=$record.lastName
		$staff_e.retrainDate:=$record.retrainDate
		$staff_e.terminationDate:=$record.terminationDate
		$staff_e.creationDate:=cs:C1710.sfw_stmp.me.getDate($record.creationDate)
		$staff_e.code:=$record.code
		$staff_e.department:=$record.department
		$staff_e.terminated:=$record.terminated
		$staff_e.hireDate:=$record.hireDate
		$staff_e.division:=$record.division
		$staff_e.citizenShipStatus:=$record.citizenShipStatus
		$staff_e.contactDetails:=$record.contactDetails
		
		//If ($staff_e.firstName="Analyn") & ($staff_e.lastName="Tolentino")
		//TRACE
		//End if 
		
		For ($i; 1; 31)
			$value:=$record.teamMemberShip[String:C10($i)]
			
			If ($value)
				$team_es:=ds:C1482.Team.query("id = :1"; $i)
				
				If ($team_es.length>0)
					$membership_e:=ds:C1482.Membership.new()
					$membership_e.UUID_Staff:=$staff_e.UUID
					$membership_e.UUID_Team:=$team_es[0].UUID
					
					$res:=$membership_e.save()
					
					If (Not:C34($res.success))
						TRACE:C157
					End if 
				End if 
			End if 
		End for 
		
		$res:=$staff_e.save()
		
		If (Not:C34($res.success))
			TRACE:C157
		End if 
	End for each 
End if 

/**
import qcars
**/
If (True:C214)
	TRUNCATE TABLE:C1051([Qcar:138])
	
	$file:=Folder:C1567(fk data folder:K87:12).file("DataJson/qcar_export.json")
	
	$records:=JSON Parse:C1218($file.getText())
	
	For each ($record; $records)
		$qcar_e:=ds:C1482.Qcar.new()
		
		$qcar_e.qcarNumber:=$record.qcarNumber
		$qcar_e.device:=$record.device
		$qcar_e.closedDate:=$record.closedDate
		$qcar_e.targetCloseDate:=$record.targetCloseDate
		$qcar_e.actualCloseDate:=$record.actualCloseDate
		$qcar_e.verifiedBy:=$record.verifiedBy
		$qcar_e.verifiedDate:=$record.verifiedDate
		$qcar_e.void:=$record.void
		$qcar_e.submit:=$record.submit
		$qcar_e.submitDate:=$record.submitDate
		$qcar_e.category:=$record.category
		$qcar_e.issuedBy:=$record.issuedBy
		$qcar_e.issuedTo:=$record.issuedTo
		$qcar_e.issuedDate:=$record.issuedDate
		
		$qcar_e._initCorrectiveActionReport()
		
		
		$customer_es:=ds:C1482.Customer.query("name = :1"; $record.customer)
		
		If ($customer_es.length>0)
			$qcar_e.UUID_Customer:=$customer_es[0].UUID
		Else 
			//TRACE
		End if 
		
		$lot_es:=ds:C1482.Lot.query("lotNumber = :1"; $record.lotNumber)
		
		If ($lot_es.length>0)
			$qcar_e.UUID_Lot:=$lot_es[0].UUID
		Else 
			//TRACE
		End if 
		
		$res:=$qcar_e.save()
		
		If (Not:C34($res.success))
			TRACE:C157
		End if 
	End for each 
End if 
