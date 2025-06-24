If (FORM Event:C1606.code=On Load:K2:1) | (FORM Event:C1606.code=On Clicked:K2:4)
	If (Form:C1466#Null:C1517)
		OBJECT SET ENTERABLE:C238(*; "entryField_othersText"; Form:C1466.correctiveActionReport.others)
	End if 
End if 