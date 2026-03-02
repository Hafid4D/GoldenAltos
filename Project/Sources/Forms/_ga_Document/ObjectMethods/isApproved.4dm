

Case of 
		
		
	: (Form event code:C388=On Clicked:K2:4)
		cs:C1710.Util_ScannerManager.me.UserApprovalByScanning("sfw_User")
		//If (Form.details.isApproved)
		//Form.details.approvedBy:=ds.sfw_User.query("login = :1"; Current user).first().staffs[0].code
		//Form.details.approvalDate:=Current date(*)
		//Else 
		//Form.details.approvedBy:=""
		//Form.details.approvalDate:=Date(!00-00-00!)
		//End if 
		
End case 

