Class extends Entity


Function summaryTimesheets($year : Integer; $month : Integer)->$timesheets : Object
	$timesheets:={timeSpent: 0; detail: ""}
	$monthCumuls:=This:C1470.monthCumuls.query("year == :1 and month == :2"; $year; $month)
	If ($monthCumuls.length#0)
		$timesheets.timeSpent:=$monthCumuls.sum("nbDays")
		For each ($monthCumul; $monthCumuls)
			$timesheets.detail+=$monthCumul.staff.fullName+": "+String:C10($monthCumul.nbDays)+" days -- "
		End for each 
		$timesheets.detail:=Split string:C1554($timesheets.detail; " -- "; sk ignore empty strings:K86:1+sk trim spaces:K86:2).join(" -- ")
	End if 
	
Function cumul($year : Integer; $month : Integer)->$cumul : Integer
	var $lastAccouting : cs:C1710.AccountingEntity
	If (True:C214)
		
		$currentAccountingDate:=Add to date:C393(!00-00-00!; $year; $month; 1)
		$lastAccoutingDate:=Add to date:C393($currentAccountingDate; 0; -1; 0)
		$lastAccouting:=ds:C1482.Accounting.query("year == :1 and month == :2 and UUID_Consumption == :3"; Year of:C25($lastAccoutingDate); Month of:C24($lastAccoutingDate); This:C1470.UUID).first()
		If ($lastAccouting=Null:C1517)
			$cumul:=0
			
		Else 
			$cumul:=$lastAccouting.recognitions.cumul_time_spent
		End if 
		
		
	Else 
		$cumul:=This:C1470.monthCumuls.query("year < :1 or (year == :1 and month <= :2)"; $year; $month).sum("nbDays")
	End if 