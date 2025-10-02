
Case of 
		
	: (Form event code:C388=On Load:K2:1)
		
		Form:C1466.hasAuthorizationToApprove:=False:C215
		$hasAuthorizedProfile:=False:C215
		$isFromAuthorizedTeam:=False:C215
		
		If (Form:C1466.approverProfile#Null:C1517)
			$hasAuthorizedProfile:=cs:C1710.sfw_userManager.me.authorizedProfiles.find(Formula:C1597((Value type:C1509($1.value)=Is text:K8:3) && (Form:C1466.approverProfile.indexOf($1.value)#-1)))#Null:C1517
			
		End if 
		
		If (Form:C1466.approverTeam#Null:C1517)
			$isFromAuthorizedTeam:=ds:C1482.Staff.query("UUID_User = :1 & memberships.team.name in :2"; cs:C1710.sfw_userManager.me.info.UUID; Form:C1466.approverTeam)#Null:C1517
			
		End if 
		Form:C1466.hasAuthorizationToApprove:=($hasAuthorizedProfile | $isFromAuthorizedTeam)
		
		OBJECT SET ENABLED:C1123(*; "isApproved"; Form:C1466.hasAuthorizationToApprove)
		OBJECT SET ENABLED:C1123(*; "approvedBy"; False:C215)
		OBJECT SET ENABLED:C1123(*; "approvalDate"; Form:C1466.hasAuthorizationToApprove)
		OBJECT SET VISIBLE:C603(*; "PopupDate"; Form:C1466.hasAuthorizationToApprove)
		
		
	Else 
		
		
End case 