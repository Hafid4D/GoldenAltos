Class extends Entity

// Purpose: Entity helpers for RejectCriteriaItem (list color picto, window title).
// created by 4D/PS [2026-may-19]

local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=This:C1470.name
	
	
local Function get colorPicto()->$picto : Picture
	
	$color:=cs:C1710.sfw_htmlColor.me.getName(This:C1470.color)
	If ($color#"")
		READ PICTURE FILE:C678(Folder:C1567(fk resources folder:K87:11).file("sfw/colors/"+$color+".png").platformPath; $picto)
	End if 
	
	
local Function loadAfterCreation()
	// This callback is called after creating the new item but before displaying the panel.
	This:C1470.levelID:=ds:C1482.RejectCriteriaItem.all().max("levelID")+1
	
	