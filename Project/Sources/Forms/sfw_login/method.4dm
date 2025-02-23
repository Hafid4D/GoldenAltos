Case of 
	: (FORM Event:C1606.code=On Load:K2:1)
		var $logo : Picture
		var $logoFile : 4D:C1709.File
		
		Case of 
			: (Application type:C494=4D Remote mode:K5:5)
				$logoFile:=File:C1566(cs:C1710.sfw_definition.me.globalParameters.panel.defaultLogo; fk posix path:K87:1)
			: (cs:C1710.sfw_definition.me.globalParameters.panel.defaultLogoLocal#Null:C1517)
				$logoFile:=File:C1566(cs:C1710.sfw_definition.me.globalParameters.panel.defaultLogoLocal; fk posix path:K87:1)
			Else 
				$logoFile:=File:C1566(cs:C1710.sfw_definition.me.globalParameters.panel.defaultLogo; fk posix path:K87:1)
		End case 
		
		
		If (Application type:C494=4D Remote mode:K5:5) && (cs:C1710.sfw_definition.me.globalParameters.panel.defaultLogoRemote#Null:C1517)
		Else 
		End if 
		If ($logoFile.exists)
			READ PICTURE FILE:C678($logoFile.platformPath; $logo)
		End if 
		Form:C1466.logo:=$logo
		
		Form:C1466.pup_users:=New object:C1471
		Form:C1466.pup_users.values:=New collection:C1472
		Form:C1466.pup_users.values:=Form:C1466.users.distinct("login")
		Form:C1466.pup_users.index:=-1
		Form:C1466.pup_users.currentValue:=ds:C1482.sfw_readXliff("user.login.select")
		Form:C1466.password:=""
		OBJECT SET FONT:C164(*; "input_password"; "%password")
		
		
End case 
OBJECT SET ENABLED:C1123(*; "btn_login"; (Form:C1466.password#"") && (Form:C1466.pup_users.index>=0))
