Class extends Entity

local Function rebuildAddress()->$address : Object
	
	$address:=New object:C1471()
	
	Case of 
		: (Form:C1466.addressBilling=1)
			$type:="billing"
		: (Form:C1466.addressShipping=1)
			$type:="shipping"
	End case 
	
	$address:=Form:C1466.current_item.contactDetails.addresses.query("type = :1"; $type).first()