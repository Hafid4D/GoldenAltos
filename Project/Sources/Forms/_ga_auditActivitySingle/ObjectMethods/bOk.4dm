Case of 
	: (Form:C1466.auditor="")
		ALERT:C41("Auditor can not be empty !")
		
	: (Form:C1466.time="")
		
		
	: (Form:C1466.process="")
		ALERT:C41("choose a process type!")
		
	Else 
		ACCEPT:C269
End case 