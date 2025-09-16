
If (Form:C1466.situation.mode="add")
	//Case of 
	
	//: (Form.companyType="Supplier")
	cs:C1710.panel_contact.me.pup_company()
	
	//: (Form.companyType="Customer")
	//cs.panel_contact.me.pup_Customer()
	//End case 
	
End if 
