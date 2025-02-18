Class extends EntitySelection


Function filterByDay($day : Date)->$filteredEntitySelection : cs:C1710.AppointmentSelection
	
	var $from; $to : Integer
	
	$from:=cs:C1710.sfw_stmp.me.build($day; ?00:00:00?)
	$to:=$from+86400
	$filteredEntitySelection:=This:C1470.query("startStmp >= :1 & startStmp < :2"; $from; $to)
	
	