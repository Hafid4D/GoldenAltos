Case of 
	: (FORM Event:C1606.code=On Double Clicked:K2:5)
		$item:=Selected list items:C379(Form:C1466.hList)
		
		If ($vlItemPos#0)
			GET LIST ITEM:C378(Form:C1466.hList; $item; $ref; $text; $subList; $subExpanded)
			
			If ($subList=0)
				$po:=Form:C1466.lb_items.query("id = :1"; ($ref-Form:C1466.lb_items.length)).first()
				$poLine:=$po.subs.query("id = :1"; $ref).first()
				
				$poLine_es:=ds:C1482.PurchaseOrderLine.query("UUID = :1"; $poLine.uuid)
				
				If ($poLine_es.length>0)
					Form:C1466.poLine:=$poLine_es[0]
					
					ACCEPT:C269
				End if 
			End if 
		End if 
End case 