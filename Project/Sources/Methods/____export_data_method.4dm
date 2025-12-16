//%attributes = {}

If (False:C215)  // export po & po lines (po <-- po_lines)
	ALL RECORDS:C47([PO_LOG])
	
	$records:=New collection:C1472()
	
	While (Not:C34(End selection:C36([PO_LOG])))
		$record:=New object:C1471(\
			"customer_name"; [PO_LOG]Customer; \
			"Log_date"; [PO_LOG]Log_date; \
			"poNumber"; [PO_LOG]PO_Number; \
			"poAmount"; [PO_LOG]PO_Amount; \
			"amountBilled"; [PO_LOG]AMT_Billed; \
			"ourQuote"; [PO_LOG]Our_Quote; \
			"resaleNumber"; [PO_LOG]Resale_Number; \
			"identifier"; [PO_LOG]Identifier; \
			"initials"; [PO_LOG]Initials; \
			"division"; [PO_LOG]Division; \Down_at
		"openPO"; [PO_LOG]Open_PO; \
			"address"; New object:C1471(\
			"billing"; New object:C1471("street"; [PO_LOG]Bill_add1; "additionalAddress"; [PO_LOG]Bill_add2; "city"; [PO_LOG]Bill_City; "state"; [PO_LOG]Bill_ST; "zipCode"; [PO_LOG]Bill_ZIP; "country"; [PO_LOG]BillAddrCountry); \
			"shipping"; New object:C1471("street"; [PO_LOG]Ship_add1; "additionalAddress"; [PO_LOG]Ship_add2; "city"; [PO_LOG]Ship_City; "state"; [PO_LOG]Ship_ST; "zipCode"; [PO_LOG]Ship_ZIP; "country"; [PO_LOG]ShipAddrCountry)\
			); \
			"altBillTo"; [PO_LOG]Alt_bill_to; \
			"dropShipCustomer"; [PO_LOG]Drop_Ship_Customer; \
			"releaseNumber"; [PO_LOG]Release_Number; \
			"forTimeBilling"; [PO_LOG]For_time_billing; \
			"timeBillingRate"; [PO_LOG]Time_billing_Rate; \
			"timeBilling"; [PO_LOG]Time_billing; \
			"description"; [PO_LOG]Description; \
			"invoices"; New collection:C1472(); \
			"lineItems"; New collection:C1472()\
			)
		
		QUERY:C277([Receivables]; [Receivables]POnum=[PO_LOG]PO_Number)
		
		If ([PO_LOG]PO_Number="0000003831")
			//TRACE
		End if 
		
		While (Not:C34(End selection:C36([Receivables])))
			$record.invoices.push(New object:C1471(\
				"customerId"; [Receivables]custid; \
				"saleAmount"; [Receivables]Saleamt; \
				"amountPaid"; [Receivables]Amt_Paid; \
				"division"; [Receivables]Division; \
				"invoice"; [Receivables]R_type+" "+String:C10([Receivables]Invoice); \
				"date"; [Receivables]Idate; \
				"customer"; [Receivables]Customer; \
				"currency"; [Receivables]Currency; \
				"total"; [Receivables]TotalInv; \
				"due"; [Receivables]NetDue; \
				"slip"; [Receivables]D_slip\
				))
			
			NEXT RECORD:C51([Receivables])
		End while 
		
		
		QUERY:C277([PO_Items]; [PO_Items]PO_number=[PO_LOG]PO_Number)
		
		While (Not:C34(End selection:C36([PO_Items])))
			If ([PO_Items]Part_Num#"")
				TRACE:C157
			End if 
			
			$lineItem:=New object:C1471(\
				"itemNum"; [PO_Items]Item_num; \
				"description"; [PO_Items]Item_Desc; \
				"partNum"; [PO_Items]Part_Num; \
				"dateOrdered"; [PO_Items]Date_Ordered; \
				"customerRequestedDate"; [PO_Items]CustomerRequestedDate; \
				"qtyOrdered"; [PO_Items]Qty_Ordered; \
				"currency"; [PO_Items]Currency; \
				"unitPrice"; [PO_Items]Unit_Price; \
				"shipJobNumber"; [PO_Items]ShipJobNumber; \
				"buildJobNumber"; [PO_Items]BuildJobNumber; \
				"unreleased"; [PO_Items]UnReleased; \
				"closed"; [PO_Items]Closed; \
				"seqNum"; [PO_Items]SeqNum\
				)
			
			$record.lineItems.push($lineItem)
			
			NEXT RECORD:C51([PO_Items])
		End while 
		
		$records.push($record)
		NEXT RECORD:C51([PO_LOG])
	End while 
	
	TEXT TO DOCUMENT:C1237("po_log_export.json"; JSON Stringify:C1217($records))
	
	SHOW ON DISK:C922("po_log_export.json")
End if 

If (True:C214)  // export jobs & lot (job <-- lots)
	$records:=New collection:C1472()
	
	ALL RECORDS:C47([Receiver])
	
	While (Not:C34(End selection:C36([Receiver])))
		
		ARRAY LONGINT:C221(AInvItemNum; 0)
		ARRAY TEXT:C222(AInvPO_ItemPartNum; 0)
		ARRAY TEXT:C222(AInvPO_itemDesc; 0)
		ARRAY DATE:C224(AInvPO_itemOrderDate; 0)
		ARRAY LONGINT:C221(AInvPO_itemID; 0)
		ARRAY LONGINT:C221(AInvPO_itemQty; 0)
		ARRAY BOOLEAN:C223(AInvPO_itemTaxable; 0)
		ARRAY REAL:C219(AInvPO_UnitPrice; 0)
		ARRAY REAL:C219(AInvPO_itemTotal; 0)
		ARRAY REAL:C219(AInvPO_itemSalesTax; 0)
		
		If ([Receiver]Ship_Memo#"")
			TRACE:C157
		End if 
		$record:=New object:C1471(\
			"pr_qualifier"; [Receiver]Pr_qualifier; \
			"jobNumber"; [Receiver]ErpJobNumber; \
			"poNumber"; [Receiver]Purchase_Order; \
			"division"; [Receiver]Division; \
			"dateCreated"; [Receiver]DateCreated; \
			"expectedDate"; [Receiver]ExpectedJobCompletionDate; \
			"invoiceDate"; [Receiver]Invoice_date; \
			"lastShipDate"; [Receiver]Last_lot_ship_date; \
			"archivedDate"; !00-00-00!; \
			"deviceNumber"; [Receiver]Device_Number; \
			"process"; [Receiver]Process; \
			"salesTax"; [Receiver]Sales_Tax; \
			"totalCharge"; [Receiver]Total_Charge; \
			"shipped"; [Receiver]Shipped; \
			"lineItem"; [Receiver]Line_item; \
			"noLots"; [Receiver]NO_lots; \
			"postToPO"; [Receiver]Post_to_PO; \
			"parentJobNumber"; [Receiver]ParentJobNumber; \
			"blobSize"; BLOB size:C605([Receiver]POLineItems); \
			"alternateShipAddress"; [Receiver]AlternateAddress; \
			"shippers"; [Receiver]Shippers; \
			"customer"; [Receiver]Customer; \
			"qty"; [Receiver]Qty; \
			"qtyOnHand"; [Receiver]QtyOnHand; \
			"shipMemo"; [Receiver]Ship_Memo; \
			"jobComment"; [Receiver]Job_Comment; \
			"archived"; False:C215; \
			"address"; New object:C1471(\
			"billing"; New object:C1471("street"; [Receiver]Bill_add1; "additionalAddress"; [Receiver]Bill_add2; "city"; [Receiver]Bill_addr_City; "state"; [Receiver]Bill_addr_ST; "zipCode"; [Receiver]Bill_addr_ZIP; "country"; [Receiver]BillAddrCountry); \
			"shipping"; New object:C1471("street"; [Receiver]Ship_add1; "additionalAddress"; [Receiver]Ship_add2; "city"; [Receiver]Ship_addr_City; "state"; [Receiver]Ship_addr_ST; "zipCode"; [Receiver]Ship_addr_ZIP; "country"; [Receiver]ShipAddrCountry)\
			); \
			"poLines"; New collection:C1472(); \
			"lots"; New collection:C1472()\
			)
		
		If (BLOB size:C605([Receiver]POLineItems)>0)
			GET_VAR_FROM_BLOB(->[Receiver]POLineItems; ->AInvItemNum; ->AInvPO_ItemPartNum; ->AInvPO_itemOrderDate; ->AInvPO_itemDesc; ->AInvPO_itemQty; ->AInvPO_UnitPrice; ->AInvPO_itemTaxable; ->AInvPO_itemTotal; ->AInvPO_itemID; ->AInvPO_itemSalesTax)
			
			If (Size of array:C274(AInvPO_itemID)>0)
				For ($i; 1; AInvPO_itemID)
					$record.poLines.push(New object:C1471(\
						"description"; AInvPO_itemDesc{$i}; \
						"seqNum"; AInvPO_itemID{$i}\
						))
				End for 
			End if 
		End if 
		
		QUERY:C277([Lotinfo]; [Lotinfo]ErpJobNumber=[Receiver]ErpJobNumber)
		
		If ([Lotinfo]Lotnum#"206735")
			//TRACE
		End if 
		
		While (Not:C34(End selection:C36([Lotinfo])))
			
			$steps:=New collection:C1472()
			
			QUERY:C277([LotSteps]; [LotSteps]Lotnum=[Lotinfo]Lotnum)
			ORDER BY:C49([LotSteps]; [LotSteps]Seq_Number; >)
			
			While (Not:C34(End selection:C36([LotSteps])))
				$tools:=New object:C1471("items"; New collection:C1472([LotSteps]Tool1; [LotSteps]Tool2; [LotSteps]Tool3; [LotSteps]Tool4; [LotSteps]Tool5; [LotSteps]Tool6; [LotSteps]Tool7; [LotSteps]Tool8))
				$steps.push(New object:C1471(\
					"order"; $steps.length+1; \
					"description"; [LotSteps]StepDesc; \
					"lotSpecs"; [LotSteps]ControlSpec; \
					"specRevision"; [LotSteps]ControlSpec_Rev; \
					"alert"; [LotSteps]Step_Alert; \
					"qtyIn"; [LotSteps]QtyIn; \
					"qtyOut"; [LotSteps]QtyOut; \
					"dateIn"; [LotSteps]DateIn; \
					"dateOut"; [LotSteps]DateOut; \
					"timeIn"; [LotSteps]Timein; \
					"timeOut"; [LotSteps]TimeOut; \
					"rejects"; [LotSteps]Rejects; \
					"good"; [LotSteps]; \
					"discard"; [LotSteps]Discard; \
					"type"; [LotSteps]Step_Type; \
					"outOperator"; [LotSteps]Operator; \
					"inOperator"; [LotSteps]IN_Oper; \
					"actualHours"; [LotSteps]ActualHours; \
					"plannedHours"; [LotSteps]Planned_hrs; \
					"areas"; [LotSteps]Step_Area; \
					"tools"; $tools\
					))
				
				NEXT RECORD:C51([LotSteps])
			End while 
			
			//If ([Lotinfo]Lotnum#"206735")
			//TRACE
			//End if 
			
			$record.lots.push(New object:C1471(\
				"lotNum"; [Lotinfo]Lotnum; \
				"jobNum"; [Lotinfo]ErpJobNumber; \
				"customer"; [Lotinfo]Customer; \
				"poNumber"; [Lotinfo]PO_num; \
				"dateIn"; [Lotinfo]Datein; \
				"dateOut"; [Lotinfo]Dateout; \
				"process"; [Lotinfo]Process; \
				"device"; [Lotinfo]Device; \
				"altLotNumber"; [Lotinfo]AltDevNum; \
				"deviceTableLink"; [Lotinfo]LinkToDeviceTable; \
				"onHold"; [Lotinfo]Hold; \
				"holdDate"; [Lotinfo]Hold_date; \
				"holdTime"; [Lotinfo]Hold_time; \
				"commit"; [Lotinfo]ExpectedOutDate; \
				"reCommit"; [Lotinfo]Recommit_date; \
				"original"; [Lotinfo]Customercount; \
				"progressive"; [Lotinfo]Progress_count; \
				"ourCount"; [Lotinfo]Our_count; \
				"totalTested"; [Lotinfo]TotalTestedOrTotalPulls; \
				"az"; [Lotinfo]Pyield; \
				"et"; [Lotinfo]Yield; \
				"OQADone"; [Lotinfo]OQAdone; \
				"OQADate"; [Lotinfo]OQADate; \
				"OQASimpleSize"; [Lotinfo]OQASamplesize; \
				"releaseNumber"; 0; \
				"trackingNumber"; [Lotinfo]ShipTrackingNumber; \
				"readyToShipDate"; [Lotinfo]ReadyToShipdate; \
				"shippingMemo"; [Lotinfo]ShippingMemo; \
				"currentOrNextArea"; [Lotinfo]CurrentOrNextArea; \
				"location"; [Lotinfo]Location; \
				"comment"; [Lotinfo]Lot_comment; \
				"status"; [Lotinfo]TravelerApprovalStatus; \
				"steps"; $steps\
				))
			
			NEXT RECORD:C51([Lotinfo])
		End while 
		
		
		$records.push($record)
		NEXT RECORD:C51([Receiver])
	End while 
	
	TEXT TO DOCUMENT:C1237("job_log_export.json"; JSON Stringify:C1217($records))
	
	SHOW ON DISK:C922("job_log_export.json")
End if 

If (True:C214)  // export archived jobs & lot (job <-- lots)
	$records:=New collection:C1472()
	
	ALL RECORDS:C47([ARCHIVES])
	
	While (Not:C34(End selection:C36([ARCHIVES])))
		
		ARRAY LONGINT:C221(AInvItemNum; 0)
		ARRAY TEXT:C222(AInvPO_ItemPartNum; 0)
		ARRAY TEXT:C222(AInvPO_itemDesc; 0)
		ARRAY DATE:C224(AInvPO_itemOrderDate; 0)
		ARRAY LONGINT:C221(AInvPO_itemID; 0)
		ARRAY LONGINT:C221(AInvPO_itemQty; 0)
		ARRAY BOOLEAN:C223(AInvPO_itemTaxable; 0)
		ARRAY REAL:C219(AInvPO_UnitPrice; 0)
		ARRAY REAL:C219(AInvPO_itemTotal; 0)
		ARRAY REAL:C219(AInvPO_itemSalesTax; 0)
		
		If ([ARCHIVES]Ship_Memo#"")
			//TRACE
		End if 
		$record:=New object:C1471(\
			"pr_qualifier"; [ARCHIVES]Pr_qualifier; \
			"jobNumber"; [ARCHIVES]ErpJobNumber; \
			"poNumber"; [ARCHIVES]Purchase_Order; \
			"division"; [ARCHIVES]Division; \
			"dateCreated"; [ARCHIVES]Datein; \
			"expectedDate"; Null:C1517; \
			"invoiceDate"; [ARCHIVES]Invoice_Date; \
			"lastShipDate"; [ARCHIVES]Last_lot_ship_date; \
			"archivedDate"; !00-00-00!; \
			"deviceNumber"; [ARCHIVES]Device_Number; \
			"process"; [ARCHIVES]Process; \
			"salesTax"; [ARCHIVES]Sales_Tax; \
			"totalCharge"; [ARCHIVES]Total_Charge; \
			"shipped"; [ARCHIVES]Shipped; \
			"lineItem"; [ARCHIVES]line_item; \
			"noLots"; [ARCHIVES]No_Lots; \
			"postToPO"; True:C214; \
			"parentJobNumber"; [ARCHIVES]ParentJobNumber; \
			"blobSize"; BLOB size:C605([ARCHIVES]POLineItems); \
			"alternateShipAddress"; [ARCHIVES]AlternateAddress; \
			"shippers"; [ARCHIVES]Shippers; \
			"customer"; [ARCHIVES]Customer; \
			"qty"; [ARCHIVES]Qty; \
			"qtyOnHand"; 0; \
			"shipMemo"; [ARCHIVES]Ship_Memo; \
			"jobComment"; ""; \
			"archived"; False:C215; \
			"address"; New object:C1471(\
			"billing"; New object:C1471("street"; ""; "additionalAddress"; ""; "city"; [ARCHIVES]Bill_addr_City; "state"; [ARCHIVES]Bill_addr_ST; "zipCode"; [ARCHIVES]Bill_addr_ZIP; "country"; [ARCHIVES]BillAddrCountry); \
			"shipping"; New object:C1471("street"; [ARCHIVES]Ship_add1; "additionalAddress"; [ARCHIVES]Ship_add2; "city"; [ARCHIVES]Ship_addr_City; "state"; [ARCHIVES]Ship_addr_ST; "zipCode"; [ARCHIVES]Ship_addr_ZIP; "country"; [ARCHIVES]ShipAddrCountry)\
			); \
			"poLines"; New collection:C1472(); \
			"lots"; New collection:C1472()\
			)
		
		If (BLOB size:C605([ARCHIVES]POLineItems)>0)
			GET_VAR_FROM_BLOB(->[ARCHIVES]POLineItems; ->AInvItemNum; ->AInvPO_ItemPartNum; ->AInvPO_itemOrderDate; ->AInvPO_itemDesc; ->AInvPO_itemQty; ->AInvPO_UnitPrice; ->AInvPO_itemTaxable; ->AInvPO_itemTotal; ->AInvPO_itemID; ->AInvPO_itemSalesTax)
			
			If (Size of array:C274(AInvPO_itemID)>0)
				For ($i; 1; Size of array:C274(AInvPO_itemID))
					
					//If (Size of array(AInvPO_itemDesc)<$i)
					//INSERT IN ARRAY(AInvPO_itemDesc; $i)
					//End if 
					
					$record.poLines.push(New object:C1471(\
						"description"; AInvPO_itemDesc{$i}; \
						"seqNum"; AInvPO_itemID{$i}\
						))
				End for 
			End if 
		End if 
		
		QUERY:C277([Lotinfo]; [Lotinfo]ErpJobNumber=[ARCHIVES]ErpJobNumber)
		
		If ([Lotinfo]Lotnum#"206735")
			//TRACE
		End if 
		
		While (Not:C34(End selection:C36([Lotinfo])))
			
			$steps:=New collection:C1472()
			
			QUERY:C277([LotSteps]; [LotSteps]Lotnum=[Lotinfo]Lotnum)
			ORDER BY:C49([LotSteps]; [LotSteps]Seq_Number; >)
			
			While (Not:C34(End selection:C36([LotSteps])))
				$tools:=New object:C1471("items"; New collection:C1472([LotSteps]Tool1; [LotSteps]Tool2; [LotSteps]Tool3; [LotSteps]Tool4; [LotSteps]Tool5; [LotSteps]Tool6; [LotSteps]Tool7; [LotSteps]Tool8))
				$steps.push(New object:C1471(\
					"order"; $steps.length+1; \
					"description"; [LotSteps]StepDesc; \
					"lotSpecs"; [LotSteps]ControlSpec; \
					"specRevision"; [LotSteps]ControlSpec_Rev; \
					"alert"; [LotSteps]Step_Alert; \
					"qtyIn"; [LotSteps]QtyIn; \
					"qtyOut"; [LotSteps]QtyOut; \
					"dateIn"; [LotSteps]DateIn; \
					"dateOut"; [LotSteps]DateOut; \
					"timeIn"; [LotSteps]Timein; \
					"timeOut"; [LotSteps]TimeOut; \
					"rejects"; [LotSteps]Rejects; \
					"good"; [LotSteps]; \
					"discard"; [LotSteps]Discard; \
					"type"; [LotSteps]Step_Type; \
					"outOperator"; [LotSteps]Operator; \
					"inOperator"; [LotSteps]IN_Oper; \
					"actualHours"; [LotSteps]ActualHours; \
					"plannedHours"; [LotSteps]Planned_hrs; \
					"areas"; [LotSteps]Step_Area; \
					"tools"; $tools\
					))
				
				NEXT RECORD:C51([LotSteps])
			End while 
			
			//If ([Lotinfo]Lotnum#"206735")
			//TRACE
			//End if 
			
			$record.lots.push(New object:C1471(\
				"lotNum"; [Lotinfo]Lotnum; \
				"jobNum"; [Lotinfo]ErpJobNumber; \
				"customer"; [Lotinfo]Customer; \
				"poNumber"; [Lotinfo]PO_num; \
				"dateIn"; [Lotinfo]Datein; \
				"dateOut"; [Lotinfo]Dateout; \
				"process"; [Lotinfo]Process; \
				"device"; [Lotinfo]Device; \
				"altLotNumber"; [Lotinfo]AltDevNum; \
				"deviceTableLink"; [Lotinfo]LinkToDeviceTable; \
				"onHold"; [Lotinfo]Hold; \
				"holdDate"; [Lotinfo]Hold_date; \
				"holdTime"; [Lotinfo]Hold_time; \
				"commit"; [Lotinfo]ExpectedOutDate; \
				"reCommit"; [Lotinfo]Recommit_date; \
				"original"; [Lotinfo]Customercount; \
				"progressive"; [Lotinfo]Progress_count; \
				"ourCount"; [Lotinfo]Our_count; \
				"totalTested"; [Lotinfo]TotalTestedOrTotalPulls; \
				"az"; [Lotinfo]Pyield; \
				"et"; [Lotinfo]Yield; \
				"OQADone"; [Lotinfo]OQAdone; \
				"OQADate"; [Lotinfo]OQADate; \
				"OQASimpleSize"; [Lotinfo]OQASamplesize; \
				"releaseNumber"; 0; \
				"trackingNumber"; [Lotinfo]ShipTrackingNumber; \
				"readyToShipDate"; [Lotinfo]ReadyToShipdate; \
				"shippingMemo"; [Lotinfo]ShippingMemo; \
				"currentOrNextArea"; [Lotinfo]CurrentOrNextArea; \
				"location"; [Lotinfo]Location; \
				"comment"; [Lotinfo]Lot_comment; \
				"status"; [Lotinfo]TravelerApprovalStatus; \
				"steps"; $steps\
				))
			
			NEXT RECORD:C51([Lotinfo])
		End while 
		
		
		
		$records.push($record)
		NEXT RECORD:C51([ARCHIVES])
	End while 
	
	TEXT TO DOCUMENT:C1237("archived_jobs_export.json"; JSON Stringify:C1217($records))
	
	SHOW ON DISK:C922("archived_jobs_export.json")
End if 

If (False:C215)  //export
	$records:=New collection:C1472()
	
	ALL RECORDS:C47([Inventory:126])
	
	While (Not:C34(End selection:C36([Inventory:126])))
		$record:=New object:C1471(\
			"AvailableQty"; [Inventory:126]availableQty:19; \
			"originalQty"; [Inventory]Original_Qty; \
			"customerSpecific"; [Inventory:126]customerSpecific:3; \
			"stockNum"; [Inventory]Stock_Num; \
			"partNum"; [Inventory]Part_Number; \
			"vendor"; [Inventory:126]vendor:5; \
			"description"; [Inventory:126]description:6; \
			"classification"; [Inventory:126]classification:7; \
			"lotNumber"; [Inventory]LotNumber; \
			"stockNum"; [Inventory]Stock_Num; \
			"dateIn"; [Inventory]Date_in; \
			"expirationDate"; [Inventory]Expiration_Date; \
			"qtyInStock"; [Inventory]Qty_in_Stock; \
			"unitCost"; [Inventory]Unit_Cost; \
			"inventoryUnits"; [Inventory:126]units:28; \
			"currency"; [Inventory:126]currency:16; \
			"binLocation"; [Inventory]Bin_Location; \
			"recdBy"; [Inventory]Recd_by; \
			"division"; [Inventory:126]division:23; \
			"totalCost"; [Inventory]Current_Actual_Value; \
			"property"; [Inventory]Property; \
			"pulls"; New collection:C1472()\
			)
		
		QUERY:C277([Inv_Usage_Many]; [Inv_Usage_Many]Stock_num=[Inventory]Stock_Num)
		
		While (Not:C34(End selection:C36([Inv_Usage_Many])))
			$record.pulls.push(New object:C1471(\
				"partNum"; [Inv_Usage_Many]Part_num; \
				"qty"; [Inv_Usage_Many]Qty; \
				"cost"; [Inv_Usage_Many]Cost; \
				"datePulled"; [Inv_Usage_Many]Date_pulled; \
				"jobNumber"; [Inv_Usage_Many]ErpJobNumber; \
				"uniqueID"; [Inv_Usage_Many]UniqueID; \
				"pulledBy"; [Inv_Usage_Many]Pulled_by; \
				"division"; [Inv_Usage_Many]Division; \
				"docsInDocServer"; [Inv_Usage_Many]DocumentsinDocServer; \
				"currency"; [Inv_Usage_Many]Currency; \
				"units"; [Inv_Usage_Many]Units; \
				"pullMode"; [Inv_Usage_Many]PullMode; \
				"lotNumber"; [Inv_Usage_Many]LotNumber; \
				"property"; [Inv_Usage_Many]property ; \
				"jobInvoiceDate"; [Inv_Usage_Many]JobInvoiceDate\
				))
			
			NEXT RECORD:C51([Inv_Usage_Many])
		End while 
		
		
		$records.push($record)
		NEXT RECORD:C51([Inventory:126])
	End while 
	
	TEXT TO DOCUMENT:C1237("inventory_export.json"; JSON Stringify:C1217($records))
	
	SHOW ON DISK:C922("inventory_export.json")
End if 

If (False:C215)  // export stepTemplates
	ALL RECORDS:C47([Template_definitions])
	
	$records:=New collection:C1472()
	
	While (Not:C34(End selection:C36([Template_definitions])))
		$record:=New object:C1471(\
			"name"; [Template_definitions]Name; \
			"operation"; [Template_definitions]Operation; \
			"division"; [Template_definitions]Division; \
			"status"; False:C215; \
			"binning"; [Template_definitions]IsBinningRequired; \
			"smallLayout"; [Template_definitions]S_layout; \
			"largeLayout"; [Template_definitions]L_layout; \
			"comment1"; [Template_definitions]Comment1Fmt; \
			"comment2"; [Template_definitions]Comment2Fmt; \
			"steps"; New collection:C1472()\
			)
		
		$records.push($record)
		NEXT RECORD:C51([Template_definitions])
	End while 
	
	TEXT TO DOCUMENT:C1237("step_template_export.json"; JSON Stringify:C1217($records))
	
	SHOW ON DISK:C922("step_template_export.json")
End if 

If (False:C215)  // export tools
	QUERY:C277([Save_lists]; [Save_lists]List_name="z@")
	
	$records:=New collection:C1472()
	
	While (Not:C34(End selection:C36([Save_lists])))
		$record:=New object:C1471(\
			"name"; [Save_lists]Description; \
			"date"; Date:C102(GetDateTimeValueCompact([Save_lists]DateTimeStamp; "DateOnly")); \
			"type"; [Save_lists]ListType; \
			"tools"; New collection:C1472()\
			)
		
		$listRef:=BLOB to list:C557([Save_lists]l_blob)
		
		
		For ($i; 1; Count list items:C380($listRef))
			GET LIST ITEM:C378($listRef; $i; $itemRef; $itemText)
			
			$record.tools.push($itemText)
		End for 
		
		If ($record.tools.length>0)
			$records.push($record)
		End if 
		NEXT RECORD:C51([Save_lists])
	End while 
	
	TEXT TO DOCUMENT:C1237("tools_export.json"; JSON Stringify:C1217($records))
	
	SHOW ON DISK:C922("tools_export.json")
End if 

If (False:C215)  // export certifications
	$listRef:=Load list:C383("Certification list")
	
	$records:=New collection:C1472()
	
	For ($i; 1; Count list items:C380($listRef))
		GET LIST ITEM:C378($listRef; $i; $itemRef; $itemText)
		
		If ($itemText#"Cert@")
			$records.push(New object:C1471(\
				"ref"; $itemRef; \
				"name"; $itemText\
				))
		End if 
	End for 
	
	TEXT TO DOCUMENT:C1237("certifications_export.json"; JSON Stringify:C1217($records))
	
	SHOW ON DISK:C922("certifications_export.json")
End if 
ALERT:C41("END!")