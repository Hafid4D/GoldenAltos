

If (Form:C1466.current_apContact#Null:C1517)
	cs:C1710.panel_customer.me.saveAPContact()
	cs:C1710.panel_customer.me._activate_save_cancel_button()
Else 
	
	OBJECT SET VISIBLE:C603(*; "label_apContact@"; False:C215)
	OBJECT SET VISIBLE:C603(*; "entryField_apContact@"; False:C215)
End if 
