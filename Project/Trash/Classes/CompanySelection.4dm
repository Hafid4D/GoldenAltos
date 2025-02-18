Class extends EntitySelection



Function projectionToStaffs()->$esStaffs : cs:C1710.StaffSelection
	$esStaffs:=This:C1470.departments.staffs
	
	
Function projectionToManagers()->$esManagers : cs:C1710.StaffSelection
	$esStaffs:=This:C1470.departments.manager
	
	