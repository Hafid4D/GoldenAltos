Class extends Entity

local Function rebuildAddress()->$address : Object
	
	Case of 
		: (Form:C1466.addressBilling=1)
			$type:="billing"
		: (Form:C1466.addressShipping=1)
			$type:="shipping"
	End case 
	
	If (Form:C1466.current_item.contactDetails#Null:C1517) && (Form:C1466.current_item.contactDetails.addresses#Null:C1517)
		$address:=Form:C1466.current_item.contactDetails.addresses.query("type = :1"; $type).first()
		Form:C1466.subFormAddress.address:=$address
	End if 
	Form:C1466.subFormAddress:=Form:C1466.subFormAddress
	
	
local Function rebuidComunications($contactType)->$contacts : Collection
	
	$communications:=Form:C1466.current_item.contactDetails.communications
	If ($communications#Null:C1517)
		$contacts:=New collection:C1472()
		For ($i; 0; $communications.length-1)
			
			If ($communications[$i].type=$contactType)
				OB GET PROPERTY NAMES:C1232($communications[$i].detail; arrNames; arrTypes)
				For ($j; 1; Size of array:C274(arrNames))
					$object:=New object:C1471
					$Object.name:=arrNames{$j}
					$Object.value:=OB Get:C1224($communications[$i].detail; $Object.name)
					$contacts.push($Object)
				End for 
				
			End if 
		End for 
		
	End if 
	
	
	