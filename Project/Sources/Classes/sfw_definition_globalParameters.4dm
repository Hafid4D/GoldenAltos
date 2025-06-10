
Class constructor
	
	This:C1470._defaultGlobal_parameters()
	
Function _defaultGlobal_parameters()  // default parameters if application_definition does not exist
	
	This:C1470.toolbar:=New object:C1471("visionsLogo"; "/RESOURCES/image/logo/SFW-logo-100x25.png")  //; "visionsLogoLocal"; "/RESOURCES/image/logo/Kairos-logo-local-100x25.png")
	This:C1470.toolbar.entryIconsResize:=True:C214
	
	This:C1470.panel:=New object:C1471("defaultLogo"; "/RESOURCES/image/logo/SFW-512x452.png")  //; "defaultLogoLocal"; "/RESOURCES/image/logo/Kairos-local-512x452.png")
	This:C1470.mainInterface:=New object:C1471("disableContectualMenuLbItems"; False:C215; "disableDoubleClickLbItems"; False:C215; "window"; New object:C1471)
	This:C1470.mainInterface:=New object:C1471("width"; 1379; "height"; 650)
	
	
	This:C1470.users:=New object:C1471("passwordLength"; 12)
	//This.users.linkedDataclass:="Staff"
	//This.users.linkedPathToNameFormUserEntity:="staffs.first().fullName"
	This:C1470.folders:=New object:C1471("projectResources"; "sfw")
	This:C1470.address:=New object:C1471("defaultCountry"; "fr")
	This:C1470.preferedCountriesInPup:=New collection:C1472("fr"; "us")
	This:C1470.notifications:=New object:C1471("activate"; False:C215)
	
	If (Application type:C494#4D Remote mode:K5:5)
		This:C1470.documentsStorageOnServer:=New object:C1471
		This:C1470.documentsStorageOnServer.folder:=Folder:C1567(Folder:C1567(fk data folder:K87:12).platformPath; fk platform path:K87:2).parent.folder("DocumentData")
	End if 