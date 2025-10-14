

Case of 
		
		
	: (Form event code:C388=On Clicked:K2:4)
		
		If (Form:C1466.currentStep#Null:C1517)
			If (Form:C1466.currentStep.isApproved)
				Form:C1466.currentStep.approver:=ds:C1482.sfw_User.query("login = :1"; Current user:C182).first().staffs[0].code
				Form:C1466.currentStep.approvalDate:=Current date:C33(*)
				
			Else 
				Form:C1466.currentStep.approver:=""
				Form:C1466.currentStep.approvalDate:=Date:C102(!00-00-00!)
				
			End if 
		End if 
		
		//cs.panel_punchOut.me._activate_save_cancel_button()
		
End case 