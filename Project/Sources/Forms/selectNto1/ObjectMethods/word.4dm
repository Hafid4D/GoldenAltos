

Case of 
	: (FORM Event:C1606.code=On Data Change:K2:15)
		If (Form:C1466.words#"")
			Form:C1466.lb_items:=ds:C1482[Form:C1466.dataclass].query(Form:C1466.colName+" == :1"; "@"+Form:C1466.words+"@")
		Else 
			Form:C1466.lb_items:=ds:C1482[Form:C1466.dataclass].all()
		End if 
End case 
