Class extends Entity


Function get status()->$status : Text
	
	$status:=This:C1470.planificationSlotStatus.name
	
	
Function get dateStart()->$startDate : Date
	$startDate:=cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpStart; True:C214)
	
Function set dateStart($startDate : Date)
	This:C1470.stmpStart:=cs:C1710.sfw_stmp.me.build($startDate)
	
Function query dateStart($event : Object)->$result : Object
	$result:=cs:C1710.sfw_stmp.me.queryFunction("stmpStart"; $event)
	
	
Function get timeStart()->$time : Time
	If (This:C1470.stmpStart#0)
		$time:=cs:C1710.sfw_stmp.me.getTime(This:C1470.stmpStart)
	End if 
	
Function set timeStart($starttime : Time)
	This:C1470.stmpStart:=cs:C1710.sfw_stmp.me.build(This:C1470.dateStart; $starttime)
	
Function get durationWork()->$time : Text
	If (This:C1470.stmpDuration#0)
		$time:=String:C10(cs:C1710.sfw_stmp.me.getTime(This:C1470.stmpDuration); HH MM:K7:2)
	End if 
	
Function get timeDuration()->$duration : Time
	$duration:=cs:C1710.sfw_stmp.me.getTime(This:C1470.stmpDuration)
	
Function set timeDuration($duration : Time)
	This:C1470.stmpDuration:=$duration
	
	
	
	
local Function isDeletable()->$isDeletable : Boolean
	// This callback must return false to inactivate the deletion mode for the current item.
	$isDeletable:=True:C214