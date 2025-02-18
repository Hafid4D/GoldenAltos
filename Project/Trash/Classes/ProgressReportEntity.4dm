Class extends Entity


Function get weekWithDetail()->$detail : Text
	var $monday : Date
	
	$detail:=This:C1470.week
	$monday:=cs:C1710.sfw_stmp.me.getMondayOfAWeek(Num:C11(Substring:C12(This:C1470.week; 1; 4)); Num:C11(Substring:C12(This:C1470.week; 6)))
	$detail+="\r"
	$detail+=String:C10($monday; Internal date short:K1:7)+" -> "+String:C10($monday+6; Internal date short:K1:7)