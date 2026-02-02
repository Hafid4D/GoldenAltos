

Case of 
		
	: (Form event code:C388=On Load:K2:1)
		
		OBJECT SET VISIBLE:C603(*; "fieldInputGroup"; False:C215)
		
		Form:C1466.pup_fields:=New object:C1471
		Form:C1466.pup_fields.values:=New collection:C1472
		Form:C1466.pup_fields.values:=Form:C1466.fieldsNames
		Form:C1466.pup_fields.index:=-1
		Form:C1466.pup_fields.currentValue:=Form:C1466.pup_fields.values[0]
		
	Else 
		
End case 