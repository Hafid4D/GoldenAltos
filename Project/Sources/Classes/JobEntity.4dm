Class extends Entity


local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=String:C10(This:C1470.jobNumber)
	
	
local Function loadAfterCreation()
	// This callback is called after creating the new item but before displaying the panel.
	This:C1470.jobNumber:=ds:C1482.Job.all().max("jobNumber")+1
	
local Function rebuildAddress()->$address : Object
	Case of 
		: (Form:C1466.addressBilling=1)
			$type:="billing"
		: (Form:C1466.addressShipping=1)
			$type:="shipping"
	End case 
	
	If (This:C1470.address.addresses#Null:C1517) && (This:C1470.address.addresses#Null:C1517)
		$address:=This:C1470.address.addresses.query("type = :1"; $type).first()
	End if 
	
	