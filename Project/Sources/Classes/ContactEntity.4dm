Class extends Entity


Function get fullName()->$fullName : Text
	$fullName:=This:C1470.firstName+" "+This:C1470.lastName
	
	
local Function rebuildAddress()->$address : Object
	
	Case of 
		: (Form:C1466.addressBilling=1)
			$type:="billing"
		: (Form:C1466.addressShipping=1)
			$type:="shipping"
	End case 
	
	If (Form:C1466.current_item#Null:C1517)
		
		If (Form:C1466.current_item.title#"Status") && (Form:C1466.current_item.title#"AP")
			If (OB Is defined:C1231(Form:C1466.current_item.contactDetails; "addresses"))
				$address:=Form:C1466.current_item.contactDetails.addresses.query("type = :1"; "main").first()
			End if 
		End if 
		Form:C1466.subFormAddress.address:=$address
		
	End if 
	Form:C1466.subFormAddress:=Form:C1466.subFormAddress
	
	
	
local Function rebuidComunications->$contacts : Collection
	
	
	If (OB Is defined:C1231(Form:C1466.current_item.contactDetails; "addresses"))
		$communications:=Form:C1466.current_item.contactDetails.communications
	Else 
		$communications:=New collection:C1472()
	End if 
	$contacts:=New collection:C1472()
	
	If ($communications#Null:C1517)
		
		For ($i; 0; $communications.length-1)
			
			OB GET PROPERTY NAMES:C1232($communications[$i]; arrNames; arrTypes)
			For ($j; 1; Size of array:C274(arrNames))
				$object:=New object:C1471
				$Object.name:=arrNames{$j}
				$Object.value:=OB Get:C1224($communications[$i]; $Object.name)
				$contacts.push($Object)
			End for 
			
		End for 
		
	End if 
	