Class extends Entity


local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=This:C1470.attendee.meeting.name
	
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
	
Function get timeDuration()->$starttime : Time
	$startTime:=cs:C1710.sfw_stmp.me.getTime(This:C1470.stmpDuration)
	
Function set timeDuration($starttime : Time)
	This:C1470.stmpDuration:=cs:C1710.sfw_stmp.me.build(This:C1470.dateStart; $starttime)
	
	
Function get durationMeeting()->$time : Text
	If (This:C1470.stmpDuration#0)
		$time:=String:C10(cs:C1710.sfw_stmp.me.getTime(This:C1470.stmpDuration); HH MM:K7:2)
	End if 
	