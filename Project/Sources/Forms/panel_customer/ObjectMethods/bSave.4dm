

$communications:=Form:C1466.current_item.contactDetails.communications
If ($communications#Null:C1517)
	$contacts:=New collection:C1472()
	For ($i; 0; $communications.length-1)
		
		If ($communications[$i].type="AP Contact")
			$customer:=ds:C1482.Customer.query("UUID = :1"; Form:C1466.current_item.UUID).first()
			OB SET:C1220($customer.contactDetails.communications[$i].detail; Form:C1466.current_apContact.name; Form:C1466.current_apContact.value)
			$info:=$customer.save()
			
		End if 
	End for 
	
Else 
	
	
End if 