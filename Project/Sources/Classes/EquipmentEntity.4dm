Class extends Entity




//mark:-Callbacks

local Function afterCreation()
	This:C1470._initReports()
	
	
local Function loadAfterCreation()
	// This callback is called after creating the new item but before displaying the panel.
	This:C1470._initReports()
	
	
local Function itemLoad()
	// This callback is called when the item is selected in the itemList
	This:C1470._initReports()
	
	
	
local Function isDeletable()->$isDeletable : Boolean
	// This callback must return false to inactivate the deletion mode for the current item.
	$isDeletable:=True:C214
	
	
local Function _initReports()
	
	If (This:C1470.reports.documents=Null:C1517)
		
		This:C1470.reports.documents:=New collection:C1472()
	End if 
	
	