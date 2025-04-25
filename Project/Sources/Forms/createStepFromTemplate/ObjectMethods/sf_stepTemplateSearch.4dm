Case of 
	: (FORM Event:C1606.code=-2000)
		//TRACE
		OBJECT SET VISIBLE:C603(*; "sf_stepTemplateSearch"; False:C215)
		
		If (Form:C1466.sf_templateSearch.selectedItem#Null:C1517)
			
		End if 
		
	: (FORM Event:C1606.code=-3000)
		OBJECT SET VISIBLE:C603(*; "sf_stepTemplateSearch"; False:C215)
		OBJECT SET SUBFORM:C1138(*; "sf_stepTemplateSearch"; "")
End case 