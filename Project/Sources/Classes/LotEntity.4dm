Class extends Entity

local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=This:C1470.lotNumber
	
local Function loadAfterCreation()
	// This callback is called after creating the new item but before displaying the panel.
	This:C1470.lotNumber:=""
	
	For each ($lot; ds:C1482.Lot.all().orderBy("lotNumber desc")) Until (This:C1470.lotNumber#"")
		
		If (Num:C11($lot.lotNumber)#0)
			This:C1470.lotNumber:=String:C10(Num:C11($lot.lotNumber)+1)
		End if 
		
	End for each 
	