Case of 
		
	: (Form event code:C388=On Load:K2:1)
		// Allow editing of qty fields when this form is used as subform
		OBJECT SET ENTERABLE:C238(*; "entryField_qty@"; True:C214)
		//OBJECT SET FOCUSABLE(*; "entryField_qty@"; True)
		
End case 