Class extends Entity

<<<<<<< HEAD
local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=String:C10(This:C1470.poNumber)
	
local Function rebuildAddress()->$address : Object
	Case of 
		: (Form:C1466.addressBilling=1)
			$type:="billing"
		: (Form:C1466.addressShipping=1)
			$type:="shipping"
	End case 
	
	If (This:C1470.address.addresses#Null:C1517) && (This:C1470.address.addresses#Null:C1517)
		$address:=This:C1470.address.addresses.query("type = :1"; $type).first()
	end if
local Function afterCreation()
	
	
local Function loadAfterCreation()
	// This callback is called after creating the new item but before displaying the panel.
	This:C1470._initPoNumber()
	
local Function _initPoNumber()
	If (This:C1470.poNumber=0)
		This:C1470.poNumber:=ds:C1482.PurchaseOrder.all().max("poNumber")+1
	End if 