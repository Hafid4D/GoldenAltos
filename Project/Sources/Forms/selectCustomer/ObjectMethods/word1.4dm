
Case of 
	: (FORM Event:C1606.code=On Data Change:K2:15)
		If (Form:C1466.words#"")
			$words:=Split string:C1554(Form:C1466.words; " "; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
			If ($words.length=1)
				Form:C1466.lb_items:=ds:C1482.Customer.query("name == :1 or code == :1"; "@"+$words[0]+"@")
				//Else 
				//Form.lb_items:=ds.Staff.query("firstName == :1 or lastName == :1 or firstName == :2 or lastName == :2"; "@"+$words[0]+"@"; "@"+$words[1]+"@")
			End if 
			
		Else 
			Form:C1466.lb_items:=ds:C1482.Customer.all()
			
		End if 
End case 
