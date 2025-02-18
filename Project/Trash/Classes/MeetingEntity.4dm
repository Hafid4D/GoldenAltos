Class extends Entity


local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=This:C1470.name
	
local Function get nameInWizard()->$name : Text
	$name:="📅 "+This:C1470.name+" - "+String:C10(cs:C1710.sfw_stmp.me.getTime(This:C1470.stmpStart); HH MM:K7:2)
	
local Function get dateStart()->$startDate : Date
	$startDate:=cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpStart; True:C214)
	
local Function set dateStart($startDate : Date)
	This:C1470.stmpStart:=cs:C1710.sfw_stmp.me.build($startDate; This:C1470.timeStart || ?00:00:00?)
	
Function query dateStart($event : Object)->$result : Object
	$result:=cs:C1710.sfw_stmp.me.queryFunction("stmpStart"; $event)
	
	
Function get timeStart()->$time : Time
	If (This:C1470.stmpStart#0)
		$time:=cs:C1710.sfw_stmp.me.getTime(This:C1470.stmpStart)
	End if 
	
Function get timeStartText()->$time : Text
	If (This:C1470.stmpStart#0)
		$time:=String:C10(cs:C1710.sfw_stmp.me.getTime(This:C1470.stmpStart); HH MM:K7:2)
	End if 
	
Function set timeStart($starttime : Time)
	This:C1470.stmpStart:=cs:C1710.sfw_stmp.me.build(This:C1470.dateStart || Current date:C33; $starttime)
	
Function get durationWork()->$time : Text
	If (This:C1470.stmpDuration#0)
		$time:=String:C10(cs:C1710.sfw_stmp.me.getTime(This:C1470.stmpDuration); HH MM:K7:2)
	End if 
	
Function get timeDuration()->$duration : Time
	$duration:=cs:C1710.sfw_stmp.me.getTime(This:C1470.stmpDuration)
	If ($duration=?00:00:00?)
		$duration:=?00:15:00?
		This:C1470.stmpDuration:=$duration
	End if 
	
Function set timeDuration($duration : Time)
	This:C1470.stmpDuration:=$duration
	
	
	
local Function loadAfterCreation()
	// This callback is called after creating the new item but before displaying the panel.
	This:C1470.stmpStart:=cs:C1710.sfw_stmp.me.build(Current date:C33; ?09:00:00?)
	This:C1470.stmpDuration:=3600  //1h
	This:C1470.dateStart:=Current date:C33
	This:C1470.timeStart:=?09:00:00?
	This:C1470.timeDuration:=?01:00:00?
	
	
	
	
local Function beforeSave()
	// This callback is called before saving the current item
	var $eAttendee : cs:C1710.AttendeeEntity
	var $ePlanificationSlot : cs:C1710.PlanificationSlotEntity
	
	$touchedAttributes:=Form:C1466.current_item.touchedAttributes()
	If ($touchedAttributes.indexOf("timeStart")>=0) || ($touchedAttributes.indexOf("timeDuration")>=0) || ($touchedAttributes.indexOf("dateStart")>=0)
		For each ($eAttendee; ds:C1482.Attendee.query("UUID_Meeting = :1"; Form:C1466.current_item.UUID))
			$ePlanificationSlot:=ds:C1482.PlanificationSlot.query("UUID_Staff = :1 and UUID_Meeting = :2"; $eAttendee.UUID_Staff; Form:C1466.current_item.UUID).first()
			If ($ePlanificationSlot#Null:C1517)
				If ($ePlanificationSlot.stmpStart#Form:C1466.current_item.stmpStart)
					$ePlanificationSlot.stmpStart:=Form:C1466.current_item.stmpStart
				End if 
				If ($ePlanificationSlot.stmpDuration#Form:C1466.current_item.stmpDuration)
					$ePlanificationSlot.stmpDuration:=Form:C1466.current_item.stmpDuration
				End if 
				If ($ePlanificationSlot.touched())
					$info:=$ePlanificationSlot.save()
				End if 
			End if 
		End for each 
	End if 
	
	
local Function isDeletable()->$isDeletable : Boolean
	// This callback must return false to inactivate the deletion mode for the current item.
	var $esMeetingTimes : cs:C1710.MeetingTimeSelection
	$esMeetingTimes:=ds:C1482.MeetingTime.query("attendee.UUID_Meeting = :1"; Form:C1466.current_item.UUID)
	$isDeletable:=($esMeetingTimes.length=0)
	
local Function beforeDelete()
	// This callback is executed before the deletion of the current item.
	var $esAttendees : cs:C1710.AttendeeSelection
	var $esPlanificationSlots:=cs:C1710.PlanificationSlotSelection
	
	$esAttendees:=ds:C1482.Attendee.query("UUID_Meeting = :1"; Form:C1466.current_item.UUID)
	$info:=$esAttendees.drop()
	$esPlanificationSlots:=ds:C1482.PlanificationSlot.query("UUID_Meeting = :1"; Form:C1466.current_item.UUID)
	$info:=$esPlanificationSlots.drop()
	