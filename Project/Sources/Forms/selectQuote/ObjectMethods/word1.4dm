
Case of 
	: (FORM Event:C1606.code=On Data Change:K2:15)
		If (Form:C1466.words#"")
			
			Form:C1466.lb_items:=Form:C1466.current_item.query("code = :1"; "@"+Form:C1466.words+"@")
		Else 
			Form:C1466.lb_items:=Form:C1466.current_item
			
		End if 
		
End case 
