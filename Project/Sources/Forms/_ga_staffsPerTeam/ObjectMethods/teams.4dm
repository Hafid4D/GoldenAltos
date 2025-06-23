


Case of 
		
		
	: (Form event code:C388=On Selection Change:K2:29)
		
		If (Form:C1466.currentTeam.selected=True:C214)
			For ($j; 0; Form:C1466.currentTeam.members.length-1)
				
				Form:C1466.currentTeam.members[$j].selected:=True:C214
			End for 
			OBJECT SET ENTERABLE:C238(*; "membersChecBox"; False:C215)
			
		End if 
		Form:C1466.currentTeam.members:=Form:C1466.currentTeam.members
		
	Else 
		
End case 