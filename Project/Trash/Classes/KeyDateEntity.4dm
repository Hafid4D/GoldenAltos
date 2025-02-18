Class extends Entity


Function get date()->$date : Date
	
	If (This:C1470.stmp=0)
		$date:=!00-00-00!
	Else 
		$date:=cs:C1710.sfw_stmp.me.getDate(This:C1470.stmp)
	End if 
	
Function set date($date : Date)
	
	This:C1470.stmp:=cs:C1710.sfw_stmp.me.build($date; ?00:00:00?)
	