

Case of 
		
		
	: (Form event code:C388=On Clicked:K2:4)
		
		If (Form:C1466.current_item.isApproved)
			$notApprovedDocuments:=Form:C1466.current_item.documents.documentsCollection.query("isApproved =:1"; False:C215)
			If ($notApprovedDocuments.length=0)
				Form:C1466.current_item.approver:=ds:C1482.sfw_User.query("login = :1"; Current user:C182).first().staffs[0].code
				Form:C1466.current_item.approvalDate:=Current date:C33(*)
			Else 
				cs:C1710.sfw_dialog.me.alert(ds:C1482.sfw_readXliff(""; "There is "+String:C10($notApprovedDocuments.length)+" document that has not been approved yet!"))
				Form:C1466.current_item.isApproved:=False:C215
			End if 
		Else 
			Form:C1466.current_item.approver:=""
			Form:C1466.current_item.approvalDate:=Date:C102(!00-00-00!)
			
		End if 
		
End case 