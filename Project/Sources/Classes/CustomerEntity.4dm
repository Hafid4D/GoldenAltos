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
	
	$communications:=Form:C1466.current_item.contacts.query("title=:1"; $contactType).first().contactDetails.communications
	If ($communications#Null:C1517)
		$contacts:=New collection:C1472()
		For ($i; 0; $communications.length-1)
			
			$object:=New object:C1471
			$Object.name:=$communications[$i].type
			$Object.value:=$communications[$i].contact
			$Object.comment:=$communications[$i].comment
			$contacts.push($Object)
			
			
		End for 
		
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
	//If (This.contactDetails.communications=Null)
	//This.contactDetails.communications:=New collection
	//End if 
	
	If (ds:C1482.Contact.query("UUID_Customer=:1"; This:C1470.UUID).extract("title").indexOf("AP")=-1)
		var $apContact : cs:C1710.ContactEntity
		$apContact:=ds:C1482.Contact.new()
		$apContact.title:="AP"
		$apContact.UUID_Customer:=This:C1470.UUID
		
		$apContact.contactDetails:=New object:C1471
		
		$apContact.contactDetails.addresses:=New collection:C1472
		
		$mainAddress:=$apContact.contactDetails.addresses.query("type = :1"; "main").first()
		If ($mainAddress=Null:C1517)
			$mainAddress:=New object:C1471
			$mainAddress.type:="main"
			$mainAddress.detail:=New object:C1471
			$mainAddress.detail.country:="FR"
			$apContact.contactDetails.addresses.push($mainAddress)
		End if 
		
		$apContact.contactDetails.communications:=New collection:C1472
		
		$apContact.save()
	End if 
	
	If (ds:C1482.Contact.query("UUID_Customer=:1"; This:C1470.UUID).extract("title").indexOf("Status")=-1)
		var $statusContact : cs:C1710.ContactEntity
		$statusContact:=ds:C1482.Contact.new()
		$statusContact.title:="Status"
		$statusContact.UUID_Customer:=This:C1470.UUID
		
		$statusContact.contactDetails:=New object:C1471
		
		$statusContact.contactDetails.addresses:=New collection:C1472
		
		$mainAddress:=$statusContact.contactDetails.addresses.query("type = :1"; "main").first()
		If ($mainAddress=Null:C1517)
			$mainAddress:=New object:C1471
			$mainAddress.type:="main"
			$mainAddress.detail:=New object:C1471
			$mainAddress.detail.country:="FR"
			$statusContact.contactDetails.addresses.push($mainAddress)
		End if 
		
		$statusContact.contactDetails.communications:=New collection:C1472
		
		$statusContact.save()
	End if 
	
	
	
	//End if 
	
	
	
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
		$mainAddress.detail.country:=cs:C1710.sfw_definition.me.globalParameters.address.defaultCountry
		This:C1470.contactDetails.addresses.push($mainAddress)
	End if 
	
	$mainAddress:=This:C1470.contactDetails.addresses.query("type = :1"; "shipping").first()
	If ($mainAddress=Null:C1517)
		$mainAddress:=New object:C1471
		$mainAddress.type:="shipping"
		$mainAddress.detail:=New object:C1471
		$mainAddress.detail.country:=cs:C1710.sfw_definition.me.globalParameters.address.defaultCountry
		This:C1470.contactDetails.addresses.push($mainAddress)
	End if 
	
	
	