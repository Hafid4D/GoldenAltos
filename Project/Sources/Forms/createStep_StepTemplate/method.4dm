Case of 
	: (FORM Event:C1606.code=On Load:K2:1)
		OBJECT SET VISIBLE:C603(*; "sf_templateSearch"; False:C215)
		
		If (Not:C34(Undefined:C82(Form:C1466.title)))
			SET WINDOW TITLE:C213(Form:C1466.title)
			OBJECT SET TITLE:C194(*; "lbl_title"; Form:C1466.title)
		End if 
End case 