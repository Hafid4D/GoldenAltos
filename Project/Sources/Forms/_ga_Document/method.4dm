

Case of 
		
	: (Form event code:C388=On Load:K2:1)
		
		If (Form:C1466.details.operation="modify")
			
			OBJECT SET VISIBLE:C603(*; "bUpload"; False:C215)
			
		End if 
		
		
	Else 
		
		
		
End case 