

Case of 
		
	: (Form event code:C388=On Load:K2:1)
		
		//var hlList; $hSousListe; $vlDépartement; $vlEmployé; $vlDépartementID : Integer
		
		//var $teams : cs.TeamSelection
		//var $staffs : cs.StaffEntity
		//var $hListItems : Collection
		//var $hSousListItems; $memberShips; $teamMembers : Collection
		
		//$memberShips:=New collection()
		//$hListItems:=New collection()
		//$hSousListItems:=New collection()
		//$teamMembers:=New collection()
		
		//$teams:=ds.Team.all()
		//$hListItems:=ds.Team.all().toCollection().extract("name")
		//hListItems:=New collection()
		
		//For each ($team; $teams)
		//$memberShips:=$team.memberships.extract("UUID_Staff")
		//$staffs:=ds.Staff.query("UUID in :1"; $memberShips)
		//$teamMembers:=New collection()
		//For each ($staff; $staffs)
		//$obj:=New object("selected"; False; "staffName"; String($staff.firstName+" "+$staff.lastName))
		//$teamMembers.push($obj)
		
		//End for each 
		//$hSousListItems.push($teamMembers)
		//End for each 
		
		//hSousListItems:=$hSousListItems
		
		//For ($i; 0; $hListItems.length-1)
		//$obj:=New object("selected"; False; "teamName"; $hListItems[$i]; "members"; hSousListItems[$i])
		//hListItems.push($obj)
		//End for 
		
		
		
	: (Form event code:C388=On Clicked:K2:4)
		
		
	Else 
		
End case 
