Class extends Entity

local Function get meta()->$meta : Object
	
	$meta:=New object:C1471
	If (This:C1470.dateOff<Current date:C33)
		$meta.stroke:="grey"
	End if 
	
	
local Function get type()->$label : Text
	
	Case of 
		: (This:C1470.typeID=1)
			$label:="French Bank Holiday"
		: (This:C1470.typeID=2)
			$label:="US Bank Holiday"
		: (This:C1470.typeID=3)
			$label:="Moroccan Bank Holiday"
		: (This:C1470.typeID=4)
			$label:="Moroccan uncertain days off"
	End case 