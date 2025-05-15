

Case of 
	: (FORM Event:C1606.code=On Data Change:K2:15)
		If (Form:C1466.words#"")
			Form:C1466.lb_items:=ds:C1482.Customer.query("name == :1"; "@"+Form:C1466.words+"@")
		Else 
			Form:C1466.lb_items:=ds:C1482.Customer.all()
		End if 
End case 
