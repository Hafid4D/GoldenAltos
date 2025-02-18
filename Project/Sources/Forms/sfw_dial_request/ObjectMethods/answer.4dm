If (Form:C1466.trimSpace)
	Form:C1466.answer:=cs:C1710.sfw_string.me.trimSpace(Form:C1466.answer)
End if 
If (FORM Event:C1606.code=On Losing Focus:K2:8)
	POST KEY:C465(Carriage return:K15:38)
End if 