Class extends Entity


local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	
	$nameInWindowTitle:=This:C1470.name
	
	
Function get nbStaff()->$nb : Integer
	
	$nb:=This:C1470.staffs.length