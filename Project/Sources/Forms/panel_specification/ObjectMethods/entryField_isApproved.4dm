

Case of 
		
		
	: (Form event code:C388=On Clicked:K2:4)
		
		If (Form:C1466.current_item.isApproved)
			$notApprovedDocuments:=Form:C1466.current_item.documents.documentsCollection.query("isApproved =:1"; False:C215)
			If ($notApprovedDocuments.length=0)
				cs:C1710.Util_ScannerManager.me.UserApprovalByScanning("sfw_User")
				//Form.current_item.approver:=ds.sfw_User.query("login = :1"; Current user).first().staffs[0].code
				//Form.current_item.approvalDate:=Current date(*)
			Else 
				cs:C1710.sfw_dialog.me.alert(ds:C1482.sfw_readXliff(""; "There is "+String:C10($notApprovedDocuments.length)+" document that has not been approved yet!"))
				Form:C1466.current_item.isApproved:=False:C215
			End if 
		Else 
			Form:C1466.current_item.approver:=""
			Form:C1466.current_item.approvalDate:=Date:C102(!00-00-00!)
			
		End if 
		
End case 