


Case of 
		
	: (Form event code:C388=On Clicked:K2:4)
		
		var $esUsers : cs:C1710.sfw_UserSelection
		var $eUser : cs:C1710.sfw_UserEntity
		
		$barcodeData:=_ga_communicateWithScanner()
		
		$esUsers:=ds:C1482.sfw_User.query("moreData.barcodeData = :1"; $barcodeData)
		
		If ($esUsers.length=1)
			$eUser:=$esUsers.first()
			
			If (Bool:C1537($eUser.accesses.asDesigner))
				CHANGE CURRENT USER:C289("Designer"; "")  //cs.sfw_definition.me.globalParameters.users.designerPassword)
			End if 
			SET USER ALIAS:C1666(Form:C1466.pup_users.currentValue)
			Form:C1466.currentUser:=$eUser
			cs:C1710.sfw_userManager.me.defineUser()
			ACCEPT:C269
			
		Else 
			Form:C1466.error:="Unknown user"
		End if 
		
	Else 
		
End case 

