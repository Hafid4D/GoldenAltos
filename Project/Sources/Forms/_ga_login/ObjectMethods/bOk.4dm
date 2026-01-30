
var $esUsers : cs:C1710.sfw_UserSelection
var $eUser : cs:C1710.sfw_UserEntity

$esUsers:=ds:C1482.sfw_User.query("login = :1"; Form:C1466.user)
If ($esUsers.length=1)
	$eUser:=$esUsers.first()
	//If (Verify password hash(Form.password; String($eUser.accesses.password.hash)))
	If (Bool:C1537($eUser.accesses.asDesigner))
		CHANGE CURRENT USER:C289("Designer"; "")  //cs.sfw_definition.me.globalParameters.users.designerPassword)
	End if 
	SET USER ALIAS:C1666(Form:C1466.user)
	Form:C1466.currentUser:=$eUser
	cs:C1710.sfw_userManager.me.defineUser()
	ACCEPT:C269
	//Else 
	//Form.error:=Localized string("user.login.message.error")
	//End if 
	
Else 
	Form:C1466.error:="Unknown user"
End if 
GOTO OBJECT:C206(*; "input_password")



