Class extends Entity



local Function get colorPicto()->$picto : Picture
	
	$color:=cs:C1710.sfw_htmlColor.me.getName(This:C1470.color)
	READ PICTURE FILE:C678(Folder:C1567(fk resources folder:K87:11).file("sfw/colors/"+$color+".png").platformPath; $picto)
	
	
local Function get logo()->$logo : Picture
	$logoFile:=File:C1566("/RESOURCES/kairos/image/technologies/"+This:C1470.code+".png"; fk posix path:K87:1)
	If ($logoFile.exists)
		READ PICTURE FILE:C678($logoFile.platformPath; $logo)
	End if 