

Case of 
		
		
	: (Form event code:C388=On Clicked:K2:4)
		
		Case of 
			: (ds:C1482.Staff.query("code =:1"; Form:C1466.details.approvedBy).first()=Null:C1517)
				cs:C1710.sfw_dialog.me.alert(ds:C1482.sfw_readXliff("Emplyee Code Error"; "There is no GA Staff member with this Emplyee code!"))
				
			: (Form:C1466.details.approvalDate=Date:C102(!00-00-00!))
				cs:C1710.sfw_dialog.me.alert(ds:C1482.sfw_readXliff(""; "The approval date is Null!"))
				
				
			Else 
				
				ACCEPT:C269
		End case 
		
		
	Else 
		
		
End case 