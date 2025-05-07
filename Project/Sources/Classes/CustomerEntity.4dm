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
	
	
	If (True:C214)
		
		
		$communications:=Form:C1466.current_item.contactDetails.communications.query("type = :1"; $contactType).first()
		If ($communications#Null:C1517)
			$contacts:=New collection:C1472()
			//For ($i; 0; $communications.length-1)
			
			OB GET PROPERTY NAMES:C1232($communications.detail; arrNames; arrTypes)
			For ($j; 1; Size of array:C274(arrNames))
				$object:=New object:C1471
				$Object.name:=arrNames{$j}
				$Object.value:=OB Get:C1224($communications.detail; $Object.name)
				$contacts.push($Object)
			End for 
			
			//End for 
			
		End if 
		
		
	Else 
		
		$communications:=Form:C1466.current_item.contacts.query("title=:1"; $contactType).first().contactDetails.communications
		If ($communications#Null:C1517)
			$contacts:=New collection:C1472()
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
	End if 
	
	
	//mark:-Callbacks
	
local Function afterCreation()
	This:C1470._initAddress()
	This:C1470._initCommunication()
	
local Function loadAfterCreation()
	// This callback is called after creating the new item but before displaying the panel.
	This:C1470._initAddress()
	This:C1470._initCommunication()
	
local Function itemLoad()
	// This callback is called when the item is selected in the itemList
	This:C1470._initAddress()
	This:C1470._initCommunication()
	
	
local Function isDeletable()->$isDeletable : Boolean
	// This callback must return false to inactivate the deletion mode for the current item.
	$isDeletable:=True:C214
	
	
	//mark:-Sub functions
local Function _initCommunication()
	If (This:C1470.contactDetails.communications=Null:C1517)
		This:C1470.contactDetails.communications:=New collection:C1472
	End if 
	
	
local Function _initAddress()
	// This callback is called when the item is selected in the itemList
	If (This:C1470.contactDetails=Null:C1517)
		This:C1470.contactDetails:=New object:C1471
	End if 
	If (This:C1470.contactDetails.addresses=Null:C1517)
		This:C1470.contactDetails.addresses:=New collection:C1472
	End if 
	$mainAddress:=This:C1470.contactDetails.addresses.query("type = :1"; "billing").first()
	If ($mainAddress=Null:C1517)
		$mainAddress:=New object:C1471
		$mainAddress.type:="billing"
		$mainAddress.detail:=New object:C1471
		$mainAddress.detail.country:="FR"
		This:C1470.contactDetails.addresses.push($mainAddress)
	End if 
	
	$mainAddress:=This:C1470.contactDetails.addresses.query("type = :1"; "shipping").first()
	If ($mainAddress=Null:C1517)
		$mainAddress:=New object:C1471
		$mainAddress.type:="shipping"
		$mainAddress.detail:=New object:C1471
		$mainAddress.detail.country:="FR"
		This:C1470.contactDetails.addresses.push($mainAddress)
	End if 
	
	
	