
Case of 
		
	: (Form event code:C388=On Load:K2:1)
		
		$eUser:=cs:C1710.sfw_UserEntity
		
		$eUser:=ds:C1482.sfw_User.query("login = :1"; Current user:C182).first()
		
		Form:C1466.hasAuthorizationToApprove:=False:C215
		
		If ($eUser#Null:C1517)
			$hasAuthorizedProfile:=$eUser.userInscriptions.extract("userProfile").query("ident in :1"; Form:C1466.approverProfile).length>0
			
			$isFromAuthorizedTeam:=$eUser.staffs.query("fullName =:1"; Current user:C182).memberships.query("team.name in :1"; Form:C1466.approverTeam).length>0
			
			Form:C1466.hasAuthorizationToApprove:=($hasAuthorizedProfile | $isFromAuthorizedTeam)
			
			
			OBJECT SET ENABLED:C1123(*; "isApproved"; Form:C1466.hasAuthorizationToApprove)
			OBJECT SET ENABLED:C1123(*; "approvedBy"; Form:C1466.hasAuthorizationToApprove)
			OBJECT SET ENABLED:C1123(*; "approvalDate"; Form:C1466.hasAuthorizationToApprove)
			OBJECT SET ENABLED:C1123(*; "PopupDate"; Form:C1466.hasAuthorizationToApprove)
			
		Else 
			
		End if 
		
	Else 
		
		
End case 