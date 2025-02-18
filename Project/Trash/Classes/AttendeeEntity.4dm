Class extends Entity


Function get planificationSlotStatus()->$status : Text
	var $ePlanificationSlot : cs:C1710.PlanificationSlotEntity
	
	$status:="not planified"
	$ePlanificationSlot:=ds:C1482.PlanificationSlot.query("UUID_Meeting = :1 and UUID_Staff = :2"; This:C1470.UUID_Meeting; This:C1470.UUID_Staff).first()
	If ($ePlanificationSlot#Null:C1517)
		$status:=$ePlanificationSlot.status
	End if 
	
	
Function get meetingTimeResume()->$resume : Text
	var $esMeetingTimes : cs:C1710.MeetingTimeSelection
	
	$resume:=""
	$esMeetingTimes:=ds:C1482.MeetingTime.query("UUID_Attendee = :1"; This:C1470.UUID)
	If ($esMeetingTimes.length>0)
		$resume:=String:C10($esMeetingTimes.sum("stmpDuration")/3600; "##0.00 h")
	End if 
	
	