Case of 
	: (FORM Event:C1606.code=On Load:K2:1)
		OBJECT SET VISIBLE:C603(*; "sf_quotesSearch"; False:C215)
		If (Not:C34(Undefined:C82(Form:C1466.windowTitle)))
			SET WINDOW TITLE:C213(Form:C1466.windowTitle)
			OBJECT SET TITLE:C194(*; "lbl_title"; Form:C1466.windowTitle)
		End if 
End case 