Class extends Entity




//mark:-Callbacks


local Function get nextCalDate()->$nextCalDate : Date
	$nextCalDate:=cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpNextCal; True:C214)
	
local Function set nextCalDate($nextCalDate : Date)
	This:C1470.stmpNextCal:=cs:C1710.sfw_stmp.me.build($nextCalDate)
	
local Function get lastCalDate()->$lastCalDate : Date
	$lastCalDate:=cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpLastCal; True:C214)
	
local Function set lastCalDate($lastCalDate : Date)
	This:C1470.stmpLastCal:=cs:C1710.sfw_stmp.me.build($lastCalDate)
	
local Function get lastPMDate()->$lastPMDate : Date
	$lastPMDate:=cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpLastPM; True:C214)
	
local Function set lastPMDate($lastPMDate : Date)
	This:C1470.stmpLastPM:=cs:C1710.sfw_stmp.me.build($lastPMDate)
	
local Function get nextPMDate()->$nextPMDate : Date
	$nextPMDate:=cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpNextPM; True:C214)
	
local Function set nextPMDate($nextPMDate : Date)
	This:C1470.stmpNextPM:=cs:C1710.sfw_stmp.me.build($nextPMDate)
	
	
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
	
	