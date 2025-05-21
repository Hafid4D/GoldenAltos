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
	
	If (OB Is defined:C1231(Form:C1466.current_item.contactDetails; "communications"))
		$communications:=Form:C1466.current_item.contactDetails.communications
	Else 
		$communications:=New collection:C1472()
	End if 
	$contacts:=New collection:C1472()
	
	If (True:C214)
		
		If (Form:C1466#Null:C1517) && (Form:C1466.communicationTypes=Null:C1517)
			$file:=Folder:C1567(fk resources folder:K87:11).file("sfw/communication/communicationTypes.json")
			If ($file.exists)
				$json:=$file.getText()
				Form:C1466.communicationTypes:=JSON Parse:C1218($json)
				For each ($type; Form:C1466.communicationTypes)
					$file:=Folder:C1567(fk resources folder:K87:11).file("sfw/communication/"+$type.icon)
					$blob:=$file.getContent()
					BLOB TO PICTURE:C682($blob; $pict; ".png")
					$type.displayedIcon:=$pict
				End for each 
				
			End if 
		End if 
		
		For each ($mean; $communications)
			$item:=New object:C1471
			$item.contact:=$mean.contact
			$item.comment:=$mean.comment
			$item.type:=$mean.type || "phone"
			$indices:=Form:C1466.communicationTypes.indices("type = :1"; $item.type)
			If ($indices.length>0)
				$item.displayedType:=Form:C1466.communicationTypes[$indices[0]].label
				$item.displayedIcon:=Form:C1466.communicationTypes[$indices[0]].displayedIcon
				
			Else 
				$item.displayedType:=_capitalize_text($mean.type)
			End if 
			$contacts.push($item)
		End for each 
		
	Else 
		
		
		
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
	//If (This.contactDetails.communications.length=0)
	//$comm:=New object()
	//$comm.phone:=""
	//$comm.fax:=""
	//$comm.mobile:=""
	//$comm.email:=""
	//$comm.email_cc:=""
	//This.contactDetails.communications.push($comm)
	//End if 
	
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
	
	
	
	
	