

If (Form:C1466.current_contact#Null:C1517)
	
	If (Form:C1466.current_contact.name#"") || (Form:C1466.current_contact.value#"")
		cs:C1710.panel_contact.me.saveContact()
		cs:C1710.panel_contact.me._activate_save_cancel_button()
		
	Else 
		
		cs:C1710.sfw_dialog.me.alert("Empty values are not allowed. Please enter valid values")
		
	End if 
End if 
