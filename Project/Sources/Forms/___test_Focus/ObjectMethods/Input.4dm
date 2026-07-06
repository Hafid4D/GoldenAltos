

Case of 
		
	: (Form event code:C388=On Losing Focus:K2:8)
		If (OBJECT Get title:C1068(Self:C308->)#"medard")
			ALERT:C41("wRONG DATA")
			
			GOTO OBJECT:C206(Self:C308->)
		End if 
End case 