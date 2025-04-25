property globalParameters : Object
property visions : Collection
property entries : Collection

Class constructor
	var $vision : cs:C1710.sfw_definitionVision
	var $entry : cs:C1710.sfw_definitionEntry
	
	This:C1470.visions:=New collection:C1472
	This:C1470.entries:=New collection:C1472
	
	
	//Mark: vision : Administration
	
	$vision:=cs:C1710.sfw_definitionVision.new("line"; "-")
	$vision.setDisplayOrder(-1002)
	This:C1470._push_vision($vision)
	
	$vision:=cs:C1710.sfw_definitionVision.new("administration"; "Administration")
	$vision.setXliffLabel("vision.administration")  //XLIFF
	$vision.setToolbarBackgroundColor("Gray")
	$vision.setDisplayOrder(-1003)
	$vision.setAllowedProfiles("admin")
	$vision.setIcon("sfw/vision/administration-24x24.png")
	This:C1470._push_vision($vision)
	
	$vision:=cs:C1710.sfw_definitionVision.new("userManagement"; "User management")
	$vision.setToolbarBackgroundColor("tan")
	$vision.setXliffLabel("vision.userManagement")  //XLIFF
	$vision.setDisplayOrder(-1004)
	$vision.setIcon("sfw/vision/user-24x24.png")
	This:C1470._push_vision($vision)
	
	If (OB Entries:C1720(ds:C1482).indices("key = :1"; "dfd_@").length>0)
		$vision:=cs:C1710.sfw_definitionVision.new("dfd"; "Dynamic Documents")
		$vision.setToolbarBackgroundColor("CornflowerBlue")
		$vision.setXliffLabel("vision.dfd")  //XLIFF
		$vision.setDisplayOrder(-1005)
		$vision.setIcon("dfd/image/vision/dfd-24x24.png")
		This:C1470._push_vision($vision)
	End if 
	
	For each ($dataclassName; ds:C1482)
		If (ds:C1482[$dataclassName].entryDefinition#Null:C1517)
			$entry:=ds:C1482[$dataclassName].entryDefinition()
			This:C1470._push_entry($entry)
		End if 
	End for each 
	
	//Mark: entry : scheduler
	$entry:=cs:C1710.sfw_definitionEntry.new("scheduler"; "administration"; "Scheduler")
	$entry.setIcon("sfw/entry/scheduler-50x50.png")
	$entry.setWizard("sfw_wizard_scheduler"; "palette")
	This:C1470._push_entry($entry)
	
	
Function _global_parameters()  // default parameters if application_definition does not exist
	This:C1470.globalParameters:=New object:C1471
	This:C1470.globalParameters.toolbar:=New object:C1471("visionsLogo"; "/RESOURCES/image/logo/SFW-logo-100x25.png")  //; "visionsLogoLocal"; "/RESOURCES/image/logo/Kairos-logo-local-100x25.png")
	This:C1470.globalParameters.toolbar.entryIconsResize:=True:C214
	
	This:C1470.globalParameters.panel:=New object:C1471("defaultLogo"; "/RESOURCES/image/logo/SFW-512x452.png")  //; "defaultLogoLocal"; "/RESOURCES/image/logo/Kairos-local-512x452.png")
	This:C1470.globalParameters.mainInterface:=New object:C1471("disableContectualMenuLbItems"; False:C215; "disableDoubleClickLbItems"; False:C215; "window"; New object:C1471)
	This:C1470.globalParameters.mainInterface:=New object:C1471("width"; 1379; "height"; 650)
	
	
	This:C1470.globalParameters.users:=New object:C1471("passwordLength"; 12)
	//This.globalParameters.users.linkedDataclass:="Staff"
	//This.globalParameters.users.linkedPathToNameFormUserEntity:="staffs.first().fullName"
	This:C1470.globalParameters.folders:=New object:C1471("projectResources"; "sfw")
	This:C1470.globalParameters.address:=New object:C1471("defaultCountry"; "fr")
	This:C1470.globalParameters.preferedCountriesInPup:=New collection:C1472("fr"; "us")
	This:C1470.globalParameters.notifications:=New object:C1471("activate"; False:C215)
	
	If (Application type:C494=4D Server:K5:6)
		This:C1470.globalParameters.documentsStorageOnServer:=New object:C1471
		This:C1470.globalParameters.documentsStorageOnServer.folder:=Folder:C1567(Folder:C1567(fk data folder:K87:12).platformPath).parent.folder("DocumentData")
	End if 
	
	
	//Mark:-Internal tool functions
Function _push_vision($vision : cs:C1710.sfw_definitionVision)
	
	This:C1470.visions.push(OB Copy:C1225($vision; ck shared:K85:29; This:C1470.visions))
	
Function _push_entry($entry : cs:C1710.sfw_definitionEntry)
	
	This:C1470.entries.push(OB Copy:C1225($entry; ck shared:K85:29; This:C1470.entries))
	