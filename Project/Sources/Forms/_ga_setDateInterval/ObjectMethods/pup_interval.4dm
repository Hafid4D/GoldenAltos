




Case of 
		
	: (Form event code:C388=On Load:K2:1)
		
		
	: (Form event code:C388=On Clicked:K2:4)
		
		
	: (Form event code:C388=On Data Change:K2:15)
		
		$date:=Date:C102(OBJECT Get title:C1068(*; "pup_endDate"))-Num:C11(Form:C1466.interval)
		OBJECT SET TITLE:C194(*; "pup_startDate"; String:C10($date))
		Form:C1466.startDate:=$date
End case 