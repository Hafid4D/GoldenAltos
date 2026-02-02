


Case of 
		
	: (Form event code:C388=On Clicked:K2:4)
		
		
		var $esUsers : cs:C1710.sfw_UserSelection
		var $eUser : cs:C1710.sfw_UserEntity
		
		$barcodeData:=_ga_communicateWithScanner()
		
		//If (OK=1)
		//$barcodeData:=$form.barcodeData
		Form:C1466.userEntity:=ds:C1482.sfw_User.query("login = :1"; $barcodeData).first()
		
		If (Form:C1466.userEntity#Null:C1517)
			Form:C1466.user:=Form:C1466.userEntity.login
		Else 
			Form:C1466.user:=""
		End if 
		
		Form:C1466.pup_users.currentValue:=Form:C1466.user
		
		$esUsers:=ds:C1482.sfw_User.query("login = :1"; Form:C1466.pup_users.currentValue)
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
		
		//End if 
		
	Else 
		
End case 

