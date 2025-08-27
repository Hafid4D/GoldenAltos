

Case of 
	: (FORM Event:C1606.code=On Data Change:K2:15)
		
		CLEAR LIST:C377(Form:C1466.hList)
		
		Form:C1466.hList:=New list:C375
		
		If (Form:C1466.words#"")
			$data:=ds:C1482.PurchaseOrder.query("poNumber = :1"; "@"+Form:C1466.words+"@").orderBy("poNumber")
		Else 
			$data:=ds:C1482.PurchaseOrder.all().orderBy("poNumber")
		End if 
		
		Form:C1466.lb_items:=New collection:C1472()
		
		$count:=$data.length
		
		For each ($po_e; $data)
			
			$subList:=New list:C375
			
			$po:=New object:C1471(\
				"uuid"; $po_e.UUID; \
				"poNumber"; $po_e.poNumber; \
				"id"; Form:C1466.lb_items.length+1; \
				"subs"; New collection:C1472()\
				)
			
			For each ($line; $po_e.lineItems)
				$id:=$count+$po.subs.length+$po.id
				
				$po.subs.push(New object:C1471(\
					"uuid"; $line.UUID; \
					"description"; $line.description; \
					"id"; $id\
					))
				
				APPEND TO LIST:C376($subList; $line.description; $id)
			End for each 
			
			APPEND TO LIST:C376(Form:C1466.hList; $po.poNumber; $po.id; $subList; False:C215)
			
			Form:C1466.lb_items.push($po)
		End for each 
End case 
