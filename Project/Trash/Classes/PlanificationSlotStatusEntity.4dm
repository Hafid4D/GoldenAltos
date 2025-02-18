Class extends Entity

local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	
	$nameInWindowTitle:=This:C1470.name
	
	
local Function get colorPicture()->$img : Picture
	$img:=cs:C1710.sfw_htmlColor.me.getColorPictureByColor(This:C1470.color)