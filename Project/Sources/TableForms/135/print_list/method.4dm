Case of 
	: (FORM Event:C1606.code=On Load:K2:1)
		//Form.order:=0
		//Form.printedBy:=cs.sfw_userManager.me.info.name
		//Form.printedDate:=Current date()
		
		
	: (FORM Event:C1606.code=On Printing Detail:K2:18)
		If (Undefined:C82(Form:C1466.order))
			Form:C1466.order:=1
		Else 
			Form:C1466.order:=Form:C1466.order+1
		End if 
		
	: (FORM Event:C1606.code=On Printing Footer:K2:20)
		Form:C1466.printedBy:=cs:C1710.sfw_userManager.me.info.name
		Form:C1466.printedDate:=Current date:C33()
End case 