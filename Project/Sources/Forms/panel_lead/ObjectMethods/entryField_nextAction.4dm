Case of 
	: (FORM Event:C1606.code=On Clicked:K2:4)
		If (Form:C1466.current_item.nextStep=Null:C1517)
			Form:C1466.current_item.nextStep:=ds:C1482.LeadNextStep.new()
		End if 
	: (FORM Event:C1606.code=On Data Change:K2:15)
		$res:=Form:C1466.current_item.nextStep.save()
		cs:C1710.panel_lead.me._activate_save_cancel_button()
End case 