Class extends Entity



local Function get colorPicto()->$picto : Picture
	
	$color:=cs:C1710.sfw_htmlColor.me.getName(This:C1470.color)
	READ PICTURE FILE:C678(Folder:C1567(fk resources folder:K87:11).file("sfw/colors/"+$color+".png").platformPath; $picto)
	
	
local Function get numAndName()->$numAndName : Text
	
	$numAndName:="["+String:C10(This:C1470.statusID)+"] "+This:C1470.name
	
	
local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	// With this callback you return the name to displayed in the title of the window for the current item
	$nameInWindowTitle:=This:C1470.name
	
	
Function get projects()->$esProjects : cs:C1710.ProjectSelection
	
	$esProjects:=ds:C1482.Project.query("currentStatusID = :1"; This:C1470.statusID)