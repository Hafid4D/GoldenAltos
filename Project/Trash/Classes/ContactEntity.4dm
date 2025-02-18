Class extends Entity


Function get fullName()->$fullName : Text
	
	$fullName:=[This:C1470.firstName; This:C1470.lastName].join(" "; ck ignore null or empty:K85:5) || ""
	
	
local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	
	$nameInWindowTitle:=This:C1470.fullName || ""
	
local Function get nameInWizard()->$nameInWizard : Text
	
	$nameInWizard:="🙍🏻‍♂️ "+(This:C1470.fullName || "")
	
	
local Function rebuildAddress()
	
	Form:C1466.subFormAddress:=New object:C1471
	Form:C1466.subFormAddress.situation:=Form:C1466.situation
	Case of 
		: (Form:C1466.addressPersonnal=1)
			$mainAddress:=Form:C1466.current_item.contactDetails.addresses.query("type = :1"; "main").first()
			Form:C1466.subFormAddress.address:=$mainAddress
		: (Form:C1466.addressCustomer=1)
			$mainAddress:=Form:C1466.current_item.customer.contactDetails.addresses.query("type = :1"; "main").first()
			Form:C1466.subFormAddress.address:=$mainAddress
			Form:C1466.subFormAddress.readOnly:=True:C214
	End case 
	Form:C1466.subFormAddress:=Form:C1466.subFormAddress
	
	
	
	
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
	$mainAddress:=This:C1470.contactDetails.addresses.query("type = :1"; "main").first()
	If ($mainAddress=Null:C1517)
		$mainAddress:=New object:C1471
		$mainAddress.type:="main"
		$mainAddress.detail:=New object:C1471
		$mainAddress.detail.country:="FR"
		This:C1470.contactDetails.addresses.push($mainAddress)
	End if 