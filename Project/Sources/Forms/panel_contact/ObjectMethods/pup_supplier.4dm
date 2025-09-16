
If (Form:C1466.situation.mode="add")
	Case of 
			
		: (Form:C1466.companyType="Supplier")
			cs:C1710.panel_contact.me.pup_supplier()
			
		: (Form:C1466.companyType="Customer")
			cs:C1710.panel_contact.me.pup_Customer()
	End case 
	
End if 

