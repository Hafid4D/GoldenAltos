Class extends Entity


Function get fullName()->$fullName : Text
	$fullName:=This:C1470.firstName+" "+This:C1470.lastName
	
	
local Function rebuildAddress($type : Text)->$address : Object
	$type:=String:C10($type)="" ? "main" : $type
	If (This:C1470.contactDetails#Null:C1517) && (This:C1470.contactDetails.addresses#Null:C1517)
		$addresses:=This:C1470.contactDetails.addresses.query("type = :1"; $type)
		If ($addresses.length#0)
			$address:=$addresses[0]
		End if 
	End if 
	
	
local Function rebuidComunications->$communications : Collection
	
	If (This:C1470.contactDetails#Null:C1517) && (This:C1470.contactDetails.communications#Null:C1517)
		$communications:=This:C1470.contactDetails.communications
	Else 
		$communications:=New collection:C1472()
	End if 
	
	
	//$contacts:=New collection()
	
	
	
	//If (True)
	
	//If (Form#Null) && (Form.communicationTypes=Null)
	//$file:=Folder(fk resources folder).file("sfw/communication/communicationTypes.json")
	//If ($file.exists)
	//$json:=$file.getText()
	//Form.communicationTypes:=JSON Parse($json)
	//For each ($type; Form.communicationTypes)
	//$file:=Folder(fk resources folder).file("sfw/communication/"+$type.icon)
	//$blob:=$file.getContent()
	//BLOB TO PICTURE($blob; $pict; ".png")
	//$type.displayedIcon:=$pict
	//End for each 
	
	//End if 
	//End if 
	
	//For each ($mean; $communications)
	//$item:=New object
	//$item.contact:=$mean.contact
	//$item.comment:=$mean.comment
	//$item.type:=$mean.type || "phone"
	//$indices:=Form.communicationTypes.indices("type = :1"; $item.type)
	//If ($indices.length>0)
	//$item.displayedType:=Form.communicationTypes[$indices[0]].label
	//$item.displayedIcon:=Form.communicationTypes[$indices[0]].displayedIcon
	
	//Else 
	//$item.displayedType:=_Capitalize_text($mean.type)
	//End if 
	//$contacts.push($item)
	//End for each 
	
	//Else 
	
	
	
	//If ($communications#Null)
	
	//For ($i; 0; $communications.length-1)
	
	//OB GET PROPERTY NAMES($communications[$i]; arrNames; arrTypes)
	//For ($j; 1; Size of array(arrNames))
	//$object:=New object
	//$Object.name:=arrNames{$j}
	//$Object.value:=OB Get($communications[$i]; $Object.name)
	//$contacts.push($Object)
	//End for 
	
	//End for 
	
	//End if 
	
	//End if 
	
	
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
	
	
	
	
	