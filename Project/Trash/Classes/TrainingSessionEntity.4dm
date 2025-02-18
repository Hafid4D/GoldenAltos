Class extends Entity

local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=This:C1470.training.name+" "+String:C10(This:C1470.dateStart)
	
	
Function get mainTrainer()->$mainTrainer : Text
	var $esTrainers : cs:C1710.TrainerSelection
	var $eMainTrainer : cs:C1710.TrainerEntity
	
	$esTrainers:=This:C1470.trainers
	If ($esTrainers.length=0)
		$mainTrainer:="-"
	Else 
		$eMainTrainer:=$esTrainers.query("main = :1"; True:C214).first()
		If ($eMainTrainer#Null:C1517)
			$mainTrainer:=$eMainTrainer.staff.fullName
		Else 
			$mainTrainer:=$esTrainers.extract("fullName").join(", ")
		End if 
	End if 
	
	
Function get dateStart()->$startDate : Date
	$startDate:=cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpStart; True:C214)
	
Function set dateStart($startDate : Date)
	This:C1470.stmpStart:=cs:C1710.sfw_stmp.me.build($startDate; This:C1470.timeStart)
	
Function query dateStart($event : Object)->$result : Object
	$result:=cs:C1710.sfw_stmp.me.queryFunction("stmpStart"; $event)
	
	
Function get timeStart()->$time : Time
	If (This:C1470.stmpStart#0)
		$time:=cs:C1710.sfw_stmp.me.getTime(This:C1470.stmpStart)
	End if 
	
Function set timeStart($starttime : Time)
	This:C1470.stmpStart:=cs:C1710.sfw_stmp.me.build(This:C1470.dateStart; $starttime)
	
	
Function get timeDuration()->$duration : Time
	$duration:=cs:C1710.sfw_stmp.me.getTime(This:C1470.stmpDuration)
	
Function set timeDuration($duration : Time)
	This:C1470.stmpDuration:=$duration
	
	
Function get durationAdministrative()->$time : Text
	If (This:C1470.stmpDuration#0)
		$time:=String:C10(cs:C1710.sfw_stmp.me.getTime(This:C1470.stmpDuration); HH MM:K7:2)
	End if 