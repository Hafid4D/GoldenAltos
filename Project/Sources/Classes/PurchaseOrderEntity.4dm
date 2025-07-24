Class extends Entity




//mark:-Callbacks

local Function afterCreation()
	
	
local Function loadAfterCreation()
	// This callback is called after creating the new item but before displaying the panel.
	This:C1470._initPoNumber()
	
local Function _initPoNumber()
	If (This:C1470.poNumber=0)
		This:C1470.poNumber:=ds:C1482.PurchaseOrder.all().max("poNumber")+1
	End if 