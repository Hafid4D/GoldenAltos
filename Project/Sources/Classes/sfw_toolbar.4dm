Class extends sfw

Class constructor()
	Super:C1705()
	
	
	
Function formMethod()
	
	var $framework : cs:C1710.sfw_toolbar
	
	$framework:=Form:C1466.sfw
	
	Case of 
		: (FORM Event:C1606.code=On Load:K2:1)
			Case of 
				: (Application type:C494=4D Remote mode:K5:5)
					$format:=";path:"+cs:C1710.sfw_definition.me.globalParameters.toolbar.visionsLogo+";;4;1;1;4;0;0;0;0;0;1;1"
				: (cs:C1710.sfw_definition.me.globalParameters.toolbar.visionsLogoLocal#Null:C1517)
					$format:=";path:"+cs:C1710.sfw_definition.me.globalParameters.toolbar.visionsLogoLocal+";;4;1;1;4;0;0;0;0;0;1;1"
				Else 
					$format:=";path:"+cs:C1710.sfw_definition.me.globalParameters.toolbar.visionsLogo+";;4;1;1;4;0;0;0;0;0;1;1"
			End case 
			
			OBJECT SET FORMAT:C236(*; "pup_visions"; $format)
			$framework.drawToolbar($framework.vision.ident)
			
		: (FORM Event:C1606.code=On Clicked:K2:4)
			Case of 
				: (String:C10(FORM Event:C1606.objectName)="bToolbar_@")
					$framework.pushEntryButton()
					
				: (String:C10(FORM Event:C1606.objectName)="bCurrentUSer")
					$framework.pushCurrentUserButton()
					
				: (String:C10(FORM Event:C1606.objectName)="bNotifications")
					$framework.pushCurrentNotification()
					
			End case 
			
		: (FORM Event:C1606.code=On Mouse Enter:K2:33) && (String:C10(FORM Event:C1606.objectName)="bToolbar_@") && (False:C215)
			Form:C1466.tb_pupwindow:=Form:C1466.tb_pupwindow || 0
			If (Form:C1466.tb_currentObjectName#FORM Event:C1606.objectName)
				CALL FORM:C1391(Form:C1466.tb_pupwindow; "sfw_toolbar_closeTBPup")
				Form:C1466.tb_currentObjectName:=FORM Event:C1606.objectName
				OBJECT GET COORDINATES:C663(*; FORM Event:C1606.objectName; $g; $h; $d; $b)
				CONVERT COORDINATES:C1365($g; $b; XY Current form:K27:5; XY Main window:K27:8)
				$gap:=3
				Form:C1466.tb_pupwindow:=Open form window:C675("sfw_entryTBPup"; Pop up form window:K39:11; $g; $b+$gap)
				DIALOG:C40("sfw_entryTBPup"; Form:C1466; *)
			End if 
			
		: (FORM Event:C1606.code=On Mouse Leave:K2:34) && (False:C215)
			Form:C1466.tb_pupwindow:=Form:C1466.tb_pupwindow || 0
			CALL FORM:C1391(Form:C1466.tb_pupwindow; "sfw_toolbar_closeTBPup")
			
	End case 
	
	
Function init()
	
	var $color : Text
	
	$color:=This:C1470.vision.toolbar.color
	This:C1470.changeTopBarColor($color)
	
	
Function drawToolbar($identVision : Text)
	var $color : Text
	var $entry : Object
	var $i : Integer
	var $iconNum : Integer
	var $format : Text
	
	Form:C1466.currentTB:=$identVision
	
	Form:C1466.vision:=cs:C1710.sfw_definition.me.visions.query("ident = :1"; $identVision).orderBy("displayOrder desc")[0]
	
	$color:=Form:C1466.vision.toolbar.color
	
	OBJECT SET RGB COLORS:C628(*; "bkgd_toolbar"; $color; $color)
	
	Form:C1466.entries:=cs:C1710.sfw_definition.me.entries.query("visions[] = :1"; $identVision)
	
	$format:=OBJECT Get format:C894(*; "bToolbar_1")
	$iconNum:=1
	Form:C1466.toolBarEntries:=New collection:C1472
	$authorizedProfiles:=cs:C1710.sfw_userManager.me.authorizedProfiles
	For each ($entry; Form:C1466.entries.query("toolBarGroup = null").orderBy("displayOrder desc"))
		If ($entry.allowedProfiles#Null:C1517) && ($entry.allowedProfiles.length>0)
			$displayEntry:=False:C215
			For each ($authorizedProfile; $authorizedProfiles)
				$displayEntry:=$displayEntry || ($entry.allowedProfiles.indexOf($authorizedProfile)#-1)
			End for each 
		Else 
			$displayEntry:=True:C214
		End if 
		If ($displayEntry)
			OBJECT SET FORMAT:C236(*; "bToolbar_"+String:C10($iconNum); ds:C1482.sfw_readXliff($entry.xliff; $entry.toolbarLabel)+";#"+$entry.icon+";0;4;1;1;0;0;0;0;0;0;1;0")
			OBJECT SET VISIBLE:C603(*; "bToolbar_"+String:C10($iconNum); True:C214)
			OBJECT SET HELP TIP:C1181(*; "bToolbar_"+String:C10($iconNum); ds:C1482.sfw_readXliff($entry.xliff; $entry.label))
			$iconNum:=$iconNum+1
			Form:C1466.toolBarEntries.push($entry)
		End if 
	End for each 
	Form:C1466.toolBarGroups:=New collection:C1472
	For each ($entry; Form:C1466.entries.query("toolBarGroup # null").orderBy("toolbar.displayOrder desc, displayOrder desc"))
		If ($entry.allowedProfiles#Null:C1517) && ($entry.allowedProfiles.length>0)
			$displayEntry:=False:C215
			For each ($authorizedProfile; $authorizedProfiles)
				$displayEntry:=$displayEntry || ($entry.allowedProfiles.indexOf($authorizedProfile)#-1)
			End for each 
		Else 
			$displayEntry:=True:C214
		End if 
		If ($displayEntry)
			$identGroup:=$entry.toolBarGroup.ident
			$indices:=Form:C1466.toolBarGroups.query("ident = :1"; $identGroup)
			If ($indices.length=0)
				$group:=$entry.toolBarGroup
				Form:C1466.toolBarGroups.push($group)
				OBJECT SET FORMAT:C236(*; "bToolbar_"+String:C10($iconNum); ds:C1482.sfw_readXliff($group.xliff; $group.label)+";#"+$group.icon+";0;4;1;1;0;0;0;0;1;0;1;0")
				OBJECT SET VISIBLE:C603(*; "bToolbar_"+String:C10($iconNum); True:C214)
				OBJECT SET HELP TIP:C1181(*; "bToolbar_"+String:C10($iconNum); ds:C1482.sfw_readXliff($group.xliff; $group.label))
				$iconNum:=$iconNum+1
			End if 
		End if 
	End for each 
	For ($i; $iconNum; 16)
		OBJECT SET VISIBLE:C603(*; "bToolbar_"+String:C10($i); False:C215)
	End for 
	
	
	$format:=OBJECT Get format:C894(*; "pup_visions")
	Case of 
		: (Storage:C1525.sfwDefinition.extras=Null:C1517)
		: (Storage:C1525.sfwDefinition.extras.sfw_toolbar=Null:C1517)
		Else 
			$file:=String:C10(Storage:C1525.sfwDefinition.extras.sfw_toolbar.file)
			$format:=";path:/RESOURCES/"+$file+";;4;1;1;4;0;0;0;0;0;1"
			OBJECT SET FORMAT:C236(*; "pup_visions"; $format)
	End case 
	
	$lprog:=Get database localization:C1009(Current localization:K5:22)
	Case of 
		: ($lprog="EN")
			$iconFlag:="GB"
		Else 
			$iconFlag:=$lprog
	End case 
	$formatLangage:=";#image/flags/tiny/"+$iconFlag+".png;0;0;0;1;3;0;0;0;1;0;1"
	OBJECT SET FORMAT:C236(*; "bLangage"; $formatLangage)
	
	If (String:C10(This:C1470.searchbox)#"")
		This:C1470.launchGlobalSearch()
	End if 
	
	$name:=cs:C1710.sfw_userManager.me.info.login
	OBJECT SET TITLE:C194(*; "bCurrentUSer"; $name)
	
	This:C1470.displayNotification()
	This:C1470.displayToDoList()
	
Function displayNotification()
	If (Bool:C1537(cs:C1710.sfw_definition.me.globalParameters.notifications.activate))
		cs:C1710.sfw_notificationManager.me.setToolbarWindowRef(Current form window:C827)
		Form:C1466.notificationsCount:=cs:C1710.sfw_notificationManager.me.getNbNotifications()
		OBJECT SET VISIBLE:C603(*; "bNotifications"; True:C214)
		OBJECT SET VISIBLE:C603(*; "counterNotifications"; (Form:C1466.notificationsCount#"0"))
		OBJECT SET VISIBLE:C603(*; "bkgdNotifications"; (Form:C1466.notificationsCount#"0"))
	Else 
		OBJECT SET VISIBLE:C603(*; "@Notifications"; False:C215)
	End if 
	
Function displayToDoList()
	OBJECT SET VISIBLE:C603(*; "@ToDoList"; False:C215)
	OBJECT SET VISIBLE:C603(*; "bToDoList"; True:C214)
	
	
Function pushEntryButton()
	
	var $formData : Object
	var $formEvent : Object
	var $iconNum : Integer
	var $refWindow : Integer
	
	
	If (Not:C34(Is compiled mode:C492))
		$identVision:=Form:C1466.vision.ident
		Form:C1466.vision:=cs:C1710.sfw_definition.me.visions.query("ident = :1"; $identVision).orderBy("displayOrder desc")[0]
		Form:C1466.entries:=cs:C1710.sfw_definition.me.entries.query("visions[] = :1"; $identVision).orderBy("displayOrder desc")
	End if 
	
	$formEvent:=FORM Event:C1606
	$iconNum:=Num:C11(Substring:C12($formEvent.objectName; 10))
	
	$launch:=True:C214
	
	If ($iconNum<=Form:C1466.toolBarEntries.length)
		$entry:=Form:C1466.entries.query("toolBarGroup = null").orderBy("displayOrder desc")[$iconNum-1]
		
		$windows:=cs:C1710.sfw_window.me.windows.query("process.name = :1"; $entry.ident).orderBy("title")
		If (cs:C1710.sfw_userManager.me.info.UUID=("00"*16))
			$favorites:=ds:C1482.sfw_Favorite.query("entryIdent = :1"; $entry.ident)
		Else 
			$favorites:=ds:C1482.sfw_Favorite.query("entryIdent = :1 and UUID_User = :2"; $entry.ident; cs:C1710.sfw_userManager.me.info.UUID)
		End if 
		If ($windows.length>0) || ($favorites.length>0)
			$launch:=False:C215
			$refMenu:=Create menu:C408
			
			For each ($window; $windows)
				APPEND MENU ITEM:C411($refMenu; $window.title; *)
				SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--window:"+String:C10($window.reference))
				SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/sfw/image/picto/applications.png")
			End for each 
			APPEND MENU ITEM:C411($refMenu; "-")
			APPEND MENU ITEM:C411($refMenu; "New main window")  //XLIFF
			SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--newWindow")
			SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/sfw/image/picto/application-sidebar-list.png")
			
			If ($favorites.length>0)
				APPEND MENU ITEM:C411($refMenu; "-")
				APPEND MENU ITEM:C411($refMenu; "Favorites")  //XLIFF
				DISABLE MENU ITEM:C150($refMenu; -1)
				$favoritesItem:=ds:C1482[$entry.dataclass].query("UUID in :1 order by nameInWindowTitle"; $favorites.UUID_target)
				For each ($favorite; $favoritesItem)
					APPEND MENU ITEM:C411($refMenu; $favorite.nameInWindowTitle; *)
					SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--favorite:"+String:C10($favorite.UUID))
					SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/sfw/image/picto/star.png")
				End for each 
			End if 
			OBJECT GET COORDINATES:C663(*; $formEvent.objectName; $left; $top; $right; $bottom)
			
			$choice:=Dynamic pop up menu:C1006($refMenu; ""; $left; $bottom)
			RELEASE MENU:C978($refMenu)
			
			Case of 
				: ($choice="")
					$launch:=False:C215
					
				: ($choice="--newWindow")
					$launch:=True:C214
					
				: ($choice="--window:@")
					$refWindow:=Num:C11(Split string:C1554($choice; ":").pop())
					$window:=cs:C1710.sfw_window.me.windows.query("process.name = :1 & reference = :2"; $entry.ident; $refWindow).first()
					BRING TO FRONT:C326($window.process.number)
					SHOW PROCESS:C325($window.process.number)
					
				: ($choice="--favorite:@")
					$uuid:=Split string:C1554($choice; ":").pop()
					$visionIdent:=Form:C1466.vision.ident
					$entryIdent:=$entry.ident
					$formData:=New object:C1471()
					$formData.sfw:=cs:C1710.sfw_item.new()
					$formData.sfw.vision:=cs:C1710.sfw_definition.me.visions.query("ident = :1"; $visionIdent).first()
					$formData.sfw.entry:=cs:C1710.sfw_definition.me.entries.query("ident = :1"; $entryIdent).first()
					$formData.current_item:=ds:C1482[$entry.dataclass].get($uuid)
					$formData.sfw.openForm($formData)
			End case 
			
		End if 
		
	Else 
		$numGroup:=$iconNum-Form:C1466.toolBarEntries.length
		$group:=Form:C1466.toolBarGroups[$numGroup-1]
		This:C1470.refMenus:=New collection:C1472
		$refMenu:=Create menu:C408
		This:C1470.refMenus.push($refMenu)
		For each ($entry; Form:C1466.entries.query("toolBarGroup.ident = :1"; $group.ident).orderBy("displayOrder desc"))
			
			$windows:=cs:C1710.sfw_window.me.windows.query("process.name = :1"; $entry.ident).orderBy("title")
			If (cs:C1710.sfw_userManager.me.info.UUID=("00"*16))
				$favorites:=ds:C1482.sfw_Favorite.query("entryIdent = :1"; $entry.ident)
			Else 
				$favorites:=ds:C1482.sfw_Favorite.query("entryIdent = :1 and UUID_User = :2"; $entry.ident; cs:C1710.sfw_userManager.me.info.UUID)
			End if 
			If ($windows.length>0) || ($favorites.length>0)
				$refClassesMenu:=Create menu:C408
				This:C1470.refMenus.push($refClassesMenu)
				$launch:=False:C215
				
				For each ($window; $windows)
					APPEND MENU ITEM:C411($refClassesMenu; $window.title; *)
					SET MENU ITEM PARAMETER:C1004($refClassesMenu; -1; "--window:"+String:C10($window.reference))
					SET MENU ITEM ICON:C984($refClassesMenu; -1; "Path:/RESOURCES/sfw/image/picto/applications.png")
				End for each 
				
				APPEND MENU ITEM:C411($refClassesMenu; "-")
				APPEND MENU ITEM:C411($refClassesMenu; "New main window")  //XLIFF
				SET MENU ITEM PARAMETER:C1004($refClassesMenu; -1; "--newWindow:"+$entry.ident)
				SET MENU ITEM ICON:C984($refClassesMenu; -1; "Path:/RESOURCES/sfw/image/picto/application-sidebar-list.png")
				
				If ($favorites.length>0)
					APPEND MENU ITEM:C411($refClassesMenu; "-")
					APPEND MENU ITEM:C411($refClassesMenu; "Favorites")  //XLIFF
					DISABLE MENU ITEM:C150($refClassesMenu; -1)
					$favoritesItem:=ds:C1482[$entry.dataclass].query("UUID in :1 order by nameInWindowTitle"; $favorites.UUID_target)
					For each ($favorite; $favoritesItem)
						APPEND MENU ITEM:C411($refClassesMenu; $favorite.nameInWindowTitle; *)
						SET MENU ITEM PARAMETER:C1004($refClassesMenu; -1; "--favorite:"+String:C10($favorite.UUID)+":"+$entry.ident)
						SET MENU ITEM ICON:C984($refClassesMenu; -1; "Path:/RESOURCES/sfw/image/picto/star.png")
					End for each 
				End if 
				APPEND MENU ITEM:C411($refMenu; ds:C1482.sfw_readXliff($entry.xliff; $entry.toolbarLabel); $refClassesMenu; *)
			Else 
				APPEND MENU ITEM:C411($refMenu; ds:C1482.sfw_readXliff($entry.xliff; $entry.toolbarLabel); *)
				SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--newWindow:"+$entry.ident)
				
			End if 
			SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/"+$entry.icon)
		End for each 
		
		OBJECT GET COORDINATES:C663(*; $formEvent.objectName; $left; $top; $right; $bottom)
		
		$choice:=Dynamic pop up menu:C1006($refMenu; ""; $left; $bottom)
		For each ($refMenu; This:C1470.refMenus)
			RELEASE MENU:C978($refMenu)
		End for each 
		
		
		
		Case of 
			: ($choice="")
				$launch:=False:C215
			: ($choice="--newWindow:@")
				$ident:=Substring:C12($choice; 13)
				$launch:=True:C214
				$entry:=Form:C1466.entries.query("ident = :1"; $ident).first()
				
			: ($choice="--window:@")
				$refWindow:=Num:C11(Split string:C1554($choice; ":").pop())
				$window:=cs:C1710.sfw_window.me.windows.query("reference = :1"; $refWindow).first()
				BRING TO FRONT:C326($window.process.number)
				SHOW PROCESS:C325($window.process.number)
				
			: ($choice="--favorite:@")
				$parts:=Split string:C1554($choice; ":")
				$entryIdent:=$parts.pop()
				$uuid:=$parts.pop()
				$visionIdent:=Form:C1466.vision.ident
				$formData:=New object:C1471()
				$formData.sfw:=cs:C1710.sfw_item.new()
				$formData.sfw.vision:=cs:C1710.sfw_definition.me.visions.query("ident = :1"; $visionIdent).first()
				$formData.sfw.entry:=cs:C1710.sfw_definition.me.entries.query("ident = :1"; $entryIdent).first()
				$formData.current_item:=ds:C1482[$entry.dataclass].get($uuid)
				$formData.sfw.openForm($formData)
		End case 
	End if 
	
	If ($launch)
		$formData:=New object:C1471()
		
		Case of 
			: ($entry.wizard#Null:C1517)
				$formData.sfw:=cs:C1710.sfw_wizard.new()
			Else 
				$formData.sfw:=cs:C1710.sfw_main.new()
		End case 
		
		$formData.sfw.vision:=Form:C1466.vision
		$formData.sfw.entry:=$entry
		
		$formData.sfw.openForm($formData)
		
	Else 
		
	End if 
	
Function pushCurrentUserButton()
	This:C1470.refMenus:=New collection:C1472
	$refMenu:=Create menu:C408
	This:C1470.refMenus.push($refMenu)
	
	APPEND MENU ITEM:C411($refMenu; cs:C1710.sfw_userManager.me.info.login; *)
	DISABLE MENU ITEM:C150($refMenu; -1)
	APPEND MENU ITEM:C411($refMenu; "-")
	
	APPEND MENU ITEM:C411($refMenu; "Store access in preferences..."; *)  //XLIFF
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--storeAccess")
	APPEND MENU ITEM:C411($refMenu; "Change my password..."; *)  //XLIFF
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--changePassword")
	
	If (cs:C1710.sfw_userManager.me.info.asDesigner) && (Not:C34(Is compiled mode:C492))
		APPEND MENU ITEM:C411($refMenu; "-")
		APPEND MENU ITEM:C411($refMenu; "only for designer")
		DISABLE MENU ITEM:C150($refMenu; -1)
		
		$refClassesMenu:=Create menu:C408
		This:C1470.refMenus.push($refClassesMenu)
		
		$classNames:=OB Keys:C1719(cs:C1710).orderBy()
		$classNamesDisplayed:=New collection:C1472
		ARRAY TEXT:C222($_paths; 0)
		METHOD GET PATHS:C1163(Path class:K72:19; $_paths)
		
		$refSFWUSerClassesMenu:=Create menu:C408
		This:C1470.refMenus.push($refSFWUSerClassesMenu)
		For each ($className; $classNames)
			If ($className="sfw@")
				If (cs:C1710[$className].superclass.name="Object") || (cs:C1710[$className].superclass.name="sfw@")
					If (Find in array:C230($_paths; "[class]/"+$className)>0) && ($classNamesDisplayed.indexOf($className)=-1)
						$refMenuFunction:=This:C1470._menuFunction($className)
						APPEND MENU ITEM:C411($refSFWUSerClassesMenu; $className; $refMenuFunction; *)
						SET MENU ITEM PARAMETER:C1004($refSFWUSerClassesMenu; -1; "--class:"+$className)
						$classNamesDisplayed.push($className)
					End if 
				End if 
			End if 
		End for each 
		APPEND MENU ITEM:C411($refClassesMenu; "SFW user classes"; $refSFWUSerClassesMenu; *)  //XLIFF
		
		$refSFWDataclassesMenu:=Create menu:C408
		This:C1470.refMenus.push($refSFWDataclassesMenu)
		For each ($className; $classNames)
			If ($className="sfw@")
				If (cs:C1710[$className].superclass.name#"Object") && (cs:C1710[$className].superclass.name#"sfw@")
					If (Find in array:C230($_paths; "[class]/"+$className)>0) && ($classNamesDisplayed.indexOf($className)=-1)
						$refMenuFunction:=This:C1470._menuFunction($className)
						APPEND MENU ITEM:C411($refSFWDataclassesMenu; $className; $refMenuFunction; *)
						SET MENU ITEM PARAMETER:C1004($refSFWDataclassesMenu; -1; "--class:"+$className)
						$classNamesDisplayed.push($className)
					End if 
				End if 
			End if 
		End for each 
		APPEND MENU ITEM:C411($refClassesMenu; "SFW dataclasses"; $refSFWDataclassesMenu; *)  //XLIFF
		
		$refSFWDefinitionclassesMenu:=Create menu:C408
		This:C1470.refMenus.push($refSFWDefinitionclassesMenu)
		$className:=Storage:C1525.definitionClass.name
		$refMenuFunction:=This:C1470._menuFunction($className)
		APPEND MENU ITEM:C411($refSFWDefinitionclassesMenu; $className; $refMenuFunction; *)
		SET MENU ITEM PARAMETER:C1004($refSFWDefinitionclassesMenu; -1; "--class:"+$className)
		$classNamesDisplayed.push($className)
		APPEND MENU ITEM:C411($refClassesMenu; "Project definition class"; $refSFWDefinitionclassesMenu; *)  //XLIFF
		
		$refentryclassesMenu:=Create menu:C408
		This:C1470.refMenus.push($refSFWDataclassesMenu)
		$entries:=cs:C1710.sfw_definition.me.entries.orderBy("dataclass")
		For each ($entry; $entries)
			For each ($suffix; [""; "Entity"; "Selection"])
				$className:=String:C10($entry.dataclass)+$suffix
				If ($className#"") && (cs:C1710[$className]#Null:C1517)
					If (Find in array:C230($_paths; "[class]/"+$className)>0) && ($classNamesDisplayed.indexOf($className)=-1)
						$refMenuFunction:=This:C1470._menuFunction($className)
						APPEND MENU ITEM:C411($refentryclassesMenu; $className; $refMenuFunction; *)
						SET MENU ITEM PARAMETER:C1004($refentryclassesMenu; -1; "--class:"+$className)
						$classNamesDisplayed.push($className)
					End if 
				End if 
			End for each 
		End for each 
		APPEND MENU ITEM:C411($refClassesMenu; "Entry classes"; $refentryclassesMenu; *)  //XLIFF
		
		$refpanelclassesMenu:=Create menu:C408
		This:C1470.refMenus.push($refSFWDataclassesMenu)
		$entries:=cs:C1710.sfw_definition.me.entries.orderBy("panel.name")
		For each ($entry; $entries)
			$className:=String:C10($entry.panel.name)
			If ($className#"") && (cs:C1710[$className]#Null:C1517)
				If (Find in array:C230($_paths; "[class]/"+$className)>0) && ($classNamesDisplayed.indexOf($className)=-1)
					$refMenuFunction:=This:C1470._menuFunction($className)
					APPEND MENU ITEM:C411($refpanelclassesMenu; $className; $refMenuFunction; *)
					SET MENU ITEM PARAMETER:C1004($refpanelclassesMenu; -1; "--class:"+$className)
					$classNamesDisplayed.push($className)
				End if 
			End if 
		End for each 
		APPEND MENU ITEM:C411($refClassesMenu; "Panel classes"; $refpanelclassesMenu; *)  //XLIFF
		
		$refotherclassesMenu:=Create menu:C408
		This:C1470.refMenus.push($refSFWDataclassesMenu)
		For each ($className; $classNames)
			If ($classNamesDisplayed.indexOf($className)=-1)
				If (cs:C1710[$className].superclass.name#"Object") && (cs:C1710[$className].superclass.name#"sfw@")
					If (Find in array:C230($_paths; "[class]/"+$className)>0) && ($classNamesDisplayed.indexOf($className)=-1)
						$refMenuFunction:=This:C1470._menuFunction($className)
						APPEND MENU ITEM:C411($refotherclassesMenu; $className; $refMenuFunction; *)
						SET MENU ITEM PARAMETER:C1004($refotherclassesMenu; -1; "--class:"+$className)
						$classNamesDisplayed.push($className)
					End if 
				End if 
			End if 
		End for each 
		APPEND MENU ITEM:C411($refClassesMenu; "Other dataclasses"; $refotherclassesMenu; *)  //XLIFF
		
		$refotheruserclassesMenu:=Create menu:C408
		This:C1470.refMenus.push($refSFWDataclassesMenu)
		For each ($className; $classNames)
			If ($classNamesDisplayed.indexOf($className)=-1)
				If (cs:C1710[$className].superclass.name="Object")
					If (Find in array:C230($_paths; "[class]/"+$className)>0) && ($classNamesDisplayed.indexOf($className)=-1)
						$refMenuFunction:=This:C1470._menuFunction($className)
						APPEND MENU ITEM:C411($refotheruserclassesMenu; $className; $refMenuFunction; *)
						SET MENU ITEM PARAMETER:C1004($refotheruserclassesMenu; -1; "--class:"+$className)
						$classNamesDisplayed.push($className)
					End if 
				End if 
			End if 
		End for each 
		
		APPEND MENU ITEM:C411($refClassesMenu; "Other user classes"; $refotheruserclassesMenu; *)  //XLIFF
		APPEND MENU ITEM:C411($refMenu; "Classes"; $refClassesMenu; *)  //XLIFF
		
		APPEND MENU ITEM:C411($refMenu; "Test Microsoft Office 365 : send mail"; *)  //XLIFF
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--microsoftGraphSendMail")
		
		APPEND MENU ITEM:C411($refMenu; "-")
		$colorMenu:=cs:C1710.sfw_htmlColor.me.buildMenu(This:C1470.refMenus)
		
		APPEND MENU ITEM:C411($refMenu; "Colors"; $colorMenu; *)  //XLIFF
		
		
	End if 
	
	
	$choice:=Dynamic pop up menu:C1006($refMenu; ""; $left; $bottom)
	For each ($refMenu; This:C1470.refMenus)
		RELEASE MENU:C978($refMenu)
	End for each 
	This:C1470.refMenus:=New collection:C1472
	
	Case of 
		: ($choice="")
		: ($choice="--storeAccess")
			cs:C1710.sfw_userManager.me.storeAccess()
			
		: ($choice="--class:@")
			$class:=Substring:C12($choice; 9)
			METHOD GET PATHS:C1163(Path class:K72:19; $_paths)
			$classParts:=Split string:C1554($class; "/")
			If (Find in array:C230($_paths; "[class]/"+$classParts[0])>0)
				METHOD OPEN PATH:C1213("[class]/"+$class)
			End if 
			If ($classParts[0]=$class)
				ARRAY TEXT:C222($_forms; 0)
				FORM GET NAMES:C1167($_forms)
				$form:=$class
				If (Find in array:C230($_forms; $form)>0)
					FORM EDIT:C1749($form)
				End if 
			End if 
			
		: ($choice="--microsoftGraphSendMail")
			If (String:C10(cs:C1710.sfw_userManager.me.info.email)#"")
				
				$graphAPI:=cs:C1710.microsoftGraphAPI.new()
				$token:=$graphAPI.getToken()
				$OAuth2:=$graphAPI.oAuth2
				
				$email:=New object:C1471
				
				$recipients:=New collection:C1472
				$recipients.push({emailAddress: {address: cs:C1710.sfw_userManager.me.info.email}})
				
				$email.body:=New object:C1471()
				$email.body.content:="This is a mail test from Kairos Application"
				$email.body.contentType:="HTML"  // si HTML, mettre HTML
				$email.toRecipients:=$recipients
				$email.subject:="Kairos - Test email"
				
				$status:=$graphAPI.sendMail($email)
				If ($status.success=False:C215)
					cs:C1710.sfw_dialog.me.alert($status.statusText)
				Else 
					cs:C1710.sfw_dialog.me.info("The email has been sent!")
				End if 
			End if 
		: ($choice="--changePassword")
			var $eUser : cs:C1710.sfw_UserEntity
			$eUser:=ds:C1482.sfw_User.query("login = :1"; Current user:C182).first()
			If ($eUser#Null:C1517)
				$eUser.askForNewPassword()
			End if 
	End case 
	
	
Function _menuFunction($className : Text)->$refMenu : Text
	$refMenu:=Create menu:C408
	This:C1470.refMenus.push($refMenu)
	$memberFunctions:=OB Keys:C1719(cs:C1710[$className].__prototype).sort()
	APPEND MENU ITEM:C411($refMenu; $className; *)
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--class:"+$className)
	APPEND MENU ITEM:C411($refMenu; "-")
	For each ($memberFunction; $memberFunctions)
		APPEND MENU ITEM:C411($refMenu; $memberFunction; *)
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--class:"+$className+"/"+$memberFunction)
	End for each 
	
	
	
Function pushCurrentNotification()
	var $window : Object
	$window:=cs:C1710.sfw_window.me.windows.query("process.name = :1"; cs:C1710.sfw_notificationManager.me.notificationWorkerName).first()
	If ($window=Null:C1517)
		CALL WORKER:C1389(cs:C1710.sfw_notificationManager.me.notificationWorkerName; Formula:C1597(cs:C1710.sfw_notificationManager.me.openWizardNotifications()))
	End if 
	
Function launchGlobalSearch()
	
	var $refWindow : Integer
	
	If (Storage:C1525.windows=Null:C1517)
		Use (Storage:C1525)
			Storage:C1525.windows:=New shared object:C1526
		End use 
	End if 
	
	$refWindow:=Num:C11(Storage:C1525.windows.globalSearch)
	Case of 
			
		: ($refWindow=0) & (Form:C1466.sfw.searchbox#"")
			$formData:=New object:C1471
			$formData.sfw:=cs:C1710.sfw_globalSearch.new()
			$formData.sfw.searchbox:=Form:C1466.sfw.searchbox
			$formData.limit:=Null:C1517
			
			GET WINDOW RECT:C443($left; $top; $right; $bottom; Current form window:C827)
			$refWindow:=Open form window:C675("sfw_globalSearch"; Plain form window:K39:10; On the right:K39:3; $bottom+Menu bar height:C440)
			Use (Storage:C1525.windows)
				Storage:C1525.windows.globalSearch:=$refWindow
			End use 
			DIALOG:C40("sfw_globalSearch"; $formData; *)
			CALL FORM:C1391($refWindow; "sfw_globalSearchManager"; "search"; Form:C1466.sfw.searchbox; Form:C1466.vision; Form:C1466.entries)
		: ($refWindow=0) & (Form:C1466.sfw.searchbox="")
		: ($refWindow#0) & (Form:C1466.sfw.searchbox="")
			CALL FORM:C1391($refWindow; "sfw_globalSearchManager"; "close")
		Else 
			SHOW WINDOW:C435($refWindow)
			CALL FORM:C1391($refWindow; "sfw_globalSearchManager"; "search"; Form:C1466.sfw.searchbox; Form:C1466.vision; Form:C1466.entries)
	End case 
	
	
	
	
	