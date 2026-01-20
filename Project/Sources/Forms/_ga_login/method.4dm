

Case of 
	: (FORM Event:C1606.code=On Load:K2:1)
		var $logo : Picture
		var $logoFile : 4D:C1709.File
		var $path : Text
		var $failConnect : Integer
		
		Case of 
			: (Application type:C494=4D Remote mode:K5:5)
				$path:=(cs:C1710.sfw_definition.me.globalParameters.login.defaultLogo) ? cs:C1710.sfw_definition.me.globalParameters.login.defaultLogo : cs:C1710.sfw_definition.me.globalParameters.panel.defaultLogo
				
			: (cs:C1710.sfw_definition.me.globalParameters.panel.defaultLogoLocal#Null:C1517) || (cs:C1710.sfw_definition.me.globalParameters.login.defaultLogoLocal#Null:C1517)
				$path:=(cs:C1710.sfw_definition.me.globalParameters.login.defaultLogoLocal) ? cs:C1710.sfw_definition.me.globalParameters.login.defaultLogoLocal : cs:C1710.sfw_definition.me.globalParameters.panel.defaultLogoLocal
				
			Else 
				$path:=(cs:C1710.sfw_definition.me.globalParameters.login.defaultLogo) ? cs:C1710.sfw_definition.me.globalParameters.login.defaultLogo : cs:C1710.sfw_definition.me.globalParameters.panel.defaultLogo
		End case 
		
		$logoFile:=File:C1566($path; fk posix path:K87:1)
		
		If ($logoFile.exists)
			READ PICTURE FILE:C678($logoFile.platformPath; $logo)
		End if 
		Form:C1466.logo:=$logo
		
		Form:C1466.failedConnect:=$failConnect
		Form:C1466.user:=""
		Form:C1466.password:=""
		OBJECT SET FONT:C164(*; "input_password"; "%password")
		
		Form:C1466.storeAccess:=False:C215
		
		OBJECT SET ENABLED:C1123(*; "input_user"; False:C215)
		OBJECT SET ENABLED:C1123(*; "btn_login"; (Form:C1466.password#"") && (Form:C1466.user#""))  // (Form.pup_users.index>=0))
		OBJECT SET ENABLED:C1123(*; "input_password"; (Form:C1466.user#""))  //(Form.pup_users.index>=0)
		
		SET TIMER:C645(1)
		
	: (Form event code:C388=On Timer:K2:25)
		
		If (Form:C1466.user="")
			
			$OK:=_ga_openScannerSerialPort
			
			If ($OK=1)
				
				While (Form:C1466.user="")
					
					RECEIVE BUFFER:C172($data)
					
					If (Length:C16($data)>0)
						
						Case of 
								
							: (Substring:C12($data; 23)="==")
								
								$data:=Uppercase:C13(_ga_UUID22To32($data))
								Form:C1466.userEntity:=ds:C1482.sfw_User.query("UUID = :1"; $data).first()
								
							Else 
								
								Form:C1466.userEntity:=ds:C1482.sfw_User.query("login = :1"; $data).first()
								
						End case 
						
						If (Form:C1466.userEntity#Null:C1517)
							Form:C1466.user:=Form:C1466.userEntity.login
							SET TIMER:C645(0)
							SET CHANNEL:C77(11)
						Else 
							Form:C1466.user:=""
							SET TIMEOUT:C268(30)
						End if 
						
					End if 
					
				End while 
				
			Else 
				
				SET TIMEOUT:C268(30)
				Form:C1466.failedConnect:=Form:C1466.failedConnect+1
				If (Form:C1466.failedConnect>0)
					ALERT:C41("Erreur : failed to Connect to the Scanner!Restart the app.")
					SET TIMER:C645(0)
				End if 
				
				//ALERT("Erreur : failed Set channel!")
			End if 
			
			
			
		End if 
		//SET TIMER(0)
End case 

OBJECT SET ENABLED:C1123(*; "input_user"; False:C215)
OBJECT SET ENABLED:C1123(*; "btn_login"; (Form:C1466.password#"") && (Form:C1466.user#""))  // (Form.pup_users.index>=0))
OBJECT SET ENABLED:C1123(*; "input_password"; (Form:C1466.user#""))  //(Form.pup_users.index>=0)




