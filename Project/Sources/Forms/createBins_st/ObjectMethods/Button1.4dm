Case of 
	: (Form:C1466.binDefinition.num=0)
		ALERT:C41("Select a bin number !")
		
	: (Form:C1466.binDefinition.definition="")
		ALERT:C41("Enter a bin definition !")
		
	: (Form:C1466.binType.index=-1)
		ALERT:C41("Select a bin type !")
		
		
	Else 
		Form:C1466.binDefinition.num:=Form:C1466.bin.value
		Form:C1466.binDefinition.type:=Form:C1466.binType.value
		ACCEPT:C269
End case 