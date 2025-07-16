Class extends Entity

Function get creationDate()->$creationDate : Text
	$creationDate:=String:C10(cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpCreation))
	
Function get followUPDate()->$followUPDate : Text
	$followUPDate:=String:C10(cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpFollowUp))