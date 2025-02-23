Case of 
	: (FORM Event:C1606.code=On Clicked:K2:4)
		
		$ok:=cs:C1710.sfw_dialog.me.confirm(ds:C1482.sfw_readXliff("user.entry.confirm.resetPassword"))
		If ($ok)
			$password:=Form:C1466.current_item.generateTemporaryPassword()
			$ok:=cs:C1710.sfw_dialog.me.confirm("Would you like to copy the temporary password in the pasteboard?")
			If ($ok)
				SET TEXT TO PASTEBOARD:C523($password)
			End if 
			Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
		End if 
		
End case 

