

Case of 
		
		
	: (Form event code:C388=On Clicked:K2:4)
		
		If (Form:C1466.details.isApproved)
			Form:C1466.details.approvedBy:=ds:C1482.sfw_User.query("login = :1"; Current user:C182).first().staffs[0].code
			
		Else 
			Form:C1466.details.approvedBy:=""
			Form:C1466.details.approvalDate:=Date:C102(!00-00-00!)
		End if 
		
End case 

