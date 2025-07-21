Class extends Entity

local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=This:C1470.poNumber
	
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