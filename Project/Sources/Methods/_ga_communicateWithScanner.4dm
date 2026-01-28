//%attributes = {}

$form:=$1
$OK:=_ga_openScannerSerialPort

If ($OK=1)
	$userFined:=False:C215
	While ($form.user="") | ($userFined=False:C215)
		
		RECEIVE BUFFER:C172($data)
		
		If (Length:C16($data)>0)
			
			Case of 
					
				: (Substring:C12($data; 23)="==")
					
					$data:=Uppercase:C13(_ga_UUID22To32($data))
					$form.userEntity:=ds:C1482.sfw_User.query("UUID = :1"; $data).first()
					
				Else 
					
					$form.userEntity:=ds:C1482.sfw_User.query("login = :1"; $data).first()
					
			End case 
			
			If ($form.userEntity#Null:C1517)
				$form.user:=$form.userEntity.login
				SET TIMER:C645(0)
				SET CHANNEL:C77(11)
				$userFined:=True:C214
			Else 
				$form.user:=""
				$userFined:=False:C215
				// SET TIMER(30)
			End if 
			
		End if 
		
	End while 
	
Else 
	
	SET TIMER:C645(30)
	$form.failedConnect:=$form.failedConnect+1
	If ($form.failedConnect>5)
		ALERT:C41("Erreur : failed to Connect to the Scanner!Restart the app.")
		SET TIMER:C645(0)
	End if 
	
	//ALERT("Erreur : failed Set channel!")
End if 

Use ($2)
	$2.result:=OB Copy:C1225($form; ck shared:K85:29)  // On stocke la valeur ici
End use 
