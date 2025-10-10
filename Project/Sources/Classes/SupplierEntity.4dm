Class extends Entity


local Function get nextAuditDate()->$nextAuditDate : Date
	$nextAuditDate:=cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpNextAudit; True:C214)
	
local Function set nextAuditDate($nextAuditDate : Date)
	This:C1470.stmpNextAudit:=cs:C1710.sfw_stmp.me.build($nextAuditDate)
	
	
local Function get lastAuditDate()->$lastAuditDate : Date
	$lastAuditDate:=cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpLastAudit; True:C214)
	
local Function set lastAuditDate($lastAuditDate : Date)
	This:C1470.stmpLastAudit:=cs:C1710.sfw_stmp.me.build($lastAuditDate)
	
	
local Function drowPup($dataClass; $queryField; $queryValue; $pupName)
	
	$entity:=ds:C1482[$dataClass].query($queryField+" =:1"; Form:C1466.current_item[$queryValue]).first() || New object:C1471()
	$name:=$entity.name
	If ($name=Null:C1517)
		$name:=""
	End if 
	If (Not:C34(Undefined:C82($entity.color)))
		$color:=cs:C1710.sfw_htmlColor.me.getName($entity.color)
		$pathIcon:=($color#"") ? "sfw/colors/"+$color+"-circle.png" : "sfw/image/skin/rainbow/icon/spacer-1x24.png"
	Else 
		$pathIcon:=""
	End if 
	Form:C1466.sfw.drawButtonPup($pupName; $name; $pathIcon; ($entity=Null:C1517))
	
	
local Function pup($cacheCollection; $dataClass; $queryField; $queryValue)
	
	If (Form:C1466.sfw.checkIsInModification())
		$menu:=Create menu:C408
		If (Storage:C1525.cache=Null:C1517) || (Storage:C1525.cache[$cacheCollection]=Null:C1517)
			ds:C1482[$dataClass].cacheLoad()
		End if 
		
		For each ($eEntity; Storage:C1525.cache[$cacheCollection])
			APPEND MENU ITEM:C411($menu; $eEntity.name; *)
			SET MENU ITEM PARAMETER:C1004($menu; -1; $eEntity.UUID)
			If ($queryField="UUID")  //# TO BE REMOVED
				
				If ($eEntity[$queryField]=Form:C1466.current_item[$queryValue])
					SET MENU ITEM MARK:C208($menu; -1; Char:C90(18))
					If (Is Windows:C1573)
						SET MENU ITEM STYLE:C425($menu; -1; Bold:K14:2)
					End if 
				End if 
			Else 
				
				If (Num:C11($eEntity[$queryField])=Form:C1466.current_item[$queryValue])
					SET MENU ITEM MARK:C208($menu; -1; Char:C90(18))
					If (Is Windows:C1573)
						SET MENU ITEM STYLE:C425($menu; -1; Bold:K14:2)
					End if 
				End if 
				
			End if 
			
		End for each 
		$choose:=Dynamic pop up menu:C1006($menu)
		RELEASE MENU:C978($menu)
		
		Case of 
			: ($choose#"")
				$eEntity:=ds:C1482[$dataClass].get($choose)
				Form:C1466.current_item[$queryValue]:=$eEntity[$queryField]
		End case 
		
	End if 
	
	
local Function rebuildAddress()->$address : Object
	
	Case of 
		: (Form:C1466.mainAddress=1)
			$type:="main"
		: (Form:C1466.remitAddress=1)
			$type:="remit"
	End case 
	
	If (Form:C1466.current_item.contactDetails#Null:C1517) && (Form:C1466.current_item.contactDetails.addresses#Null:C1517)
		$address:=Form:C1466.current_item.contactDetails.addresses.query("type =:1"; $type).first()
		Form:C1466.subFormAddress.address:=$address
	End if 
	Form:C1466.subFormAddress:=Form:C1466.subFormAddress
	
	
local Function rebuildContact()->$contacts : Collection
	var $communication : cs:C1710.ContactEntity
	Case of 
		: (Form:C1466.primaryContact=1)
			$type:="Primary"
		: (Form:C1466.secondaryContact=1)
			$type:="Secondary"
	End case 
	$contacts:=New collection:C1472()
	$communication:=ds:C1482.Contact.query("UUID_Company =:1"; Form:C1466.current_item.UUID).query("title=:1"; $type).first()
	If ($communication#Null:C1517)
		$communications:=$communication.contactDetails.communications
		For ($i; 0; $communications.length-1)
			
			$object:=New object:C1471
			$Object.name:=$communications[$i].type
			$Object.value:=$communications[$i].contact
			$Object.comment:=$communications[$i].comment
			$contacts.push($Object)
			
		End for 
		
	End if 
	Form:C1466.lb_contact:=$contacts
	
	
	
	//mark:-Callbacks
	
local Function beforeSave()
	
	If (Form:C1466.current_item.nextAuditDate#!00-00-00!) & (Form:C1466.current_item.nextAuditDate<=Current date:C33(*)) & (Form:C1466.current_item.critical=True:C214) & (Form:C1466.current_item.critical#Form:C1466.current_clone.critical)
		
		$context:=New object:C1471
		$context.target:=Form:C1466.current_item.UUID
		$context.targetDataclass:="Supplier"
		$context.name:=Form:C1466.current_item.name
		
		$profiles:=New collection:C1472("qm"; "qs"; "pm"; "ps"; "vp"; "gm")
		$staff:=ds:C1482.Staff.query("user.userInscriptions.userProfile.ident in :1 | memberships.team.name =:2"; $profiles; "Facilities")
		
		$users:=$staff.extract("user").extract("UUID").distinct()
		cs:C1710.sfw_notificationManager.me.notify("CriticalSuppliersWithOverdueAudits"; $users; $context)
		
	End if 
	
	
local Function afterCreation()
	This:C1470._initAddress()
	This:C1470._initattachedDocuments()
	
local Function loadAfterCreation()
	// This callback is called after creating the new item but before displaying the panel.
	This:C1470._initAddress()
	This:C1470._initattachedDocuments()
	
local Function itemLoad()
	// This callback is called when the item is selected in the itemList
	This:C1470._initAddress()
	This:C1470._initattachedDocuments()
	
	
local Function isDeletable()->$isDeletable : Boolean
	// This callback must return false to inactivate the deletion mode for the current item.
	$isDeletable:=True:C214
	
	
	//mark:-Sub functions
	
local Function _initattachedDocuments()
	
	If (This:C1470.attachedDocuments.documents=Null:C1517)
		
		This:C1470.attachedDocuments.documents:=New collection:C1472()
		
	End if 
	
	
	If (ds:C1482.Contact.query("UUID_Company=:1"; This:C1470.UUID).extract("title").indexOf("Primary")=-1)
		var $apContact : cs:C1710.ContactEntity
		$apContact:=ds:C1482.Contact.new()
		$apContact.title:="Primary"
		$apContact.UUID_Company:=This:C1470.UUID
		
		$apContact.contactDetails:=New object:C1471
		
		$apContact.contactDetails.addresses:=New collection:C1472
		
		$mainAddress:=$apContact.contactDetails.addresses.query("type = :1"; "main").first()
		If ($mainAddress=Null:C1517)
			$mainAddress:=New object:C1471
			$mainAddress.type:="main"
			$mainAddress.detail:=New object:C1471
			$mainAddress.detail.country:="US"
			$apContact.contactDetails.addresses.push($mainAddress)
		End if 
		
		$apContact.contactDetails.communications:=New collection:C1472
		
		$apContact.save()
	End if 
	
	If (ds:C1482.Contact.query("UUID_Company=:1"; This:C1470.UUID).extract("title").indexOf("Secondary")=-1)
		var $statusContact : cs:C1710.ContactEntity
		$statusContact:=ds:C1482.Contact.new()
		$statusContact.title:="Secondary"
		$statusContact.UUID_Company:=This:C1470.UUID
		
		$statusContact.contactDetails:=New object:C1471
		
		$statusContact.contactDetails.addresses:=New collection:C1472
		
		$mainAddress:=$statusContact.contactDetails.addresses.query("type = :1"; "main").first()
		If ($mainAddress=Null:C1517)
			$mainAddress:=New object:C1471
			$mainAddress.type:="main"
			$mainAddress.detail:=New object:C1471
			$mainAddress.detail.country:="US"
			$statusContact.contactDetails.addresses.push($mainAddress)
		End if 
		
		$statusContact.contactDetails.communications:=New collection:C1472
		
		$statusContact.save()
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
		$mainAddress.detail.country:=cs:C1710.sfw_definition.me.globalParameters.address.defaultCountry
		This:C1470.contactDetails.addresses.push($mainAddress)
	End if 
	
	$secondaryAddress:=This:C1470.contactDetails.addresses.query("type = :1"; "remit").first()
	If ($secondaryAddress=Null:C1517)
		$secondaryAddress:=New object:C1471
		$secondaryAddress.type:="remit"
		$secondaryAddress.detail:=New object:C1471
		$secondaryAddress.detail.country:=cs:C1710.sfw_definition.me.globalParameters.address.defaultCountry
		This:C1470.contactDetails.addresses.push($secondaryAddress)
	End if 
	
	
	