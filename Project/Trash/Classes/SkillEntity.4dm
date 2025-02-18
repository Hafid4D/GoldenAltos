Class extends Entity


local Function get dateStartSkill()->$dateStart : Date
	$dateStart:=cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpStartSkill; True:C214)
	
local Function set dateStartSkill($dateStart : Date)
	This:C1470.stmpStartSkill:=cs:C1710.sfw_stmp.me.build($dateStart)
	
local Function get dateEndSkill()->$dateEnd : Date
	$dateEnd:=cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpEndSkill; True:C214)
	
local Function set dateEndSkill($dateEnd : Date)
	This:C1470.stmpEndSkill:=cs:C1710.sfw_stmp.me.build($dateEnd)
	