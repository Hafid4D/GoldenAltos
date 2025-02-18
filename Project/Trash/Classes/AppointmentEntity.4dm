Class extends Entity


Function getDate()->$date : Date
	$date_reference:=Add to date:C393(!00-00-00!; 2003; 1; 1)
	$nbjours:=Int:C8(This:C1470.startStmp/(3600*24))
	$date:=$date_reference+$nbjours
	
Function getTime()->$time : Time
	$seconde:=This:C1470.startStmp%60
	$Minute:=(Int:C8(This:C1470.startStmp/60))%60
	$heure:=(Int:C8(This:C1470.startStmp/3600))%24
	$time:=Time:C179(String:C10($heure; "00")+":"+String:C10($minute; "00")+":"+String:C10($seconde; "00"))
	
Function getDateText()->$date : Text
	$date_reference:=Add to date:C393(!00-00-00!; 2003; 1; 1)
	$nbjours:=Int:C8(This:C1470.startStmp/(3600*24))
	$date:=String:C10($date_reference+$nbjours; Internal date abbreviated:K1:6)
	
Function getTimeText()->$range : Text
	$range:=String:C10(This:C1470.getTime(); HH MM:K7:2)
	
Function getTimeRange()->$range : Text
	$time:=This:C1470.getTime()
	$range:=String:C10($time; HH MM:K7:2)+" - "+String:C10(Time:C179($time+This:C1470.duration); HH MM:K7:2)
	
Function getStatus()->$status : Text
	$status:=ds:C1482.sfw_readXliff("chrono.status_"+String:C10(This:C1470.idStatus))
	
exposed Function getAppointmentObject()->$appointment : Object
	$appointment:=This:C1470.toObject("medicalStaff.UUID, medicalStaff.firstName, medicalStaff.lastName, consultationKind.name, medicalHouse.name, medicalHouse.address")
	$appointment.time:=This:C1470.getTimeRange()
	$appointment.date:=This:C1470.getDateText()
	$appointment.status:=This:C1470.getStatus()
	
	
	