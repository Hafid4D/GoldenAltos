singleton Class constructor
	//It's a singleton class
	
Function formMethod()
	Form:C1466.sfw.panelFormMethod()
	If (Form:C1466.sfw.updateOfPanelNeeded())
		Form:C1466.lb_inscriptions:=ds:C1482.sfw_UserInscription.query("UUID_UserProfile = :1"; Form:C1466.current_item.UUID)
	End if 
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())
		Case of 
			: (FORM Get current page:C276(*)=1)
				// add load functions
		End case 
	End if 
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())
		This:C1470.redrawAndSetVisible()
	End if 
	
	
	
	
Function redrawAndSetVisible()
	
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($widthSubform; $heightSubform)
	$verticalMargin:=3
	
	Case of 
		: (FORM Get current page:C276(*)=1)  // team members
			OBJECT GET COORDINATES:C663(*; "bActionInscriptions"; $g; $h; $d; $b)
			$heightButton:=$b-$h
			OBJECT SET COORDINATES:C1248(*; "bActionInscriptions"; $g; $heightSubform-$verticalMargin-$heightButton; $d; $heightSubform-$verticalMargin)
			
			OBJECT GET COORDINATES:C663(*; "lb_inscriptions"; $g; $h; $d; $b)
			OBJECT SET COORDINATES:C1248(*; "lb_inscriptions"; $g; $h; $d; $heightSubform-$verticalMargin-$heightButton-$verticalMargin)
			OBJECT SET COORDINATES:C1248(*; "bkgd_lb_inscriptions"; $g; $h; $d; $heightSubform)
			
	End case 
	
	
	
Function bActionInscriptions()
	var $eUse : cs:C1710.sfw_UserEntity
	var $eInscription : cs:C1710.sfw_UserInscriptionEntity
	$menus:=New collection:C1472()
	$menu:=Create menu:C408
	$menus.push($menu)
	
	If (Form:C1466.sfw.checkIsInModification())
		$subMenuUsers:=Create menu:C408
		$menus.push($subMenuUsers)
		$uuids:=Form:C1466.lb_inscriptions.extract("UUID_User")
		$esUsers:=ds:C1482.sfw_User.query("not(UUID in :1) order by login"; $uuids)
		For each ($eUse; $esUsers)
			APPEND MENU ITEM:C411($subMenuUsers; $eUse.login; *)
			SET MENU ITEM PARAMETER:C1004($subMenuUsers; -1; "User:"+$eUse.UUID)
		End for each 
		If ($esUsers.length#0)
			APPEND MENU ITEM:C411($menu; ds:C1482.sfw_readXliff("profile.adduser"; "Add a user"); $subMenuUsers; *)
		Else 
			APPEND MENU ITEM:C411($menu; ds:C1482.sfw_readXliff("profile.adduser"; "Add a user"); *)
			DISABLE MENU ITEM:C150($menu; -1)
		End if 
	Else 
		APPEND MENU ITEM:C411($menu; ds:C1482.sfw_readXliff("profile.adduser"; "Add a user"); *)
		DISABLE MENU ITEM:C150($menu; -1)
	End if 
	If (Form:C1466.inscription#Null:C1517)
		APPEND MENU ITEM:C411($menu; ds:C1482.sfw_readXliff("profile.deleteuser"; "Delete the user")+" \""+Form:C1466.inscription.user.login+"\""; *)
		If (Form:C1466.sfw.checkIsInModification()) && (Form:C1466.inscription.moreData.autoCreation=Null:C1517)
			SET MENU ITEM PARAMETER:C1004($menu; -1; "Delete:"+Form:C1466.inscription.UUID)
		Else 
			DISABLE MENU ITEM:C150($menu; -1)
		End if 
	Else 
		APPEND MENU ITEM:C411($menu; ds:C1482.sfw_readXliff("profile.deleteuser"; "Delete the user"); *)
		DISABLE MENU ITEM:C150($menu; -1)
	End if 
	$choose:=Dynamic pop up menu:C1006($menu)
	For each ($menu; $menus)
		RELEASE MENU:C978($menu)
	End for each 
	
	Case of 
		: ($choose="User:@")
			$UUIDUser:=Split string:C1554($choose; ":").pop()
			$eInscription:=ds:C1482.sfw_UserInscription.new()
			$eInscription.UUID:=Generate UUID:C1066
			$eInscription.UUID_User:=$UUIDUser
			$eInscription.UUID_UserProfile:=Form:C1466.current_item.UUID
			$eInscription.UUID_whoHasGiven:=cs:C1710.sfw_userManager.me.info.UUID
			$eInscription.stmp_given:=cs:C1710.sfw_stmp.me.now()
			$eInscription.moreData:=New object:C1471
			$info:=$eInscription.save()
			If ($info.success)
				Form:C1466.lb_inscriptions:=ds:C1482.sfw_UserInscription.query("UUID_UserProfile = :1"; Form:C1466.current_item.UUID)
				Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
			End if 
			
		: ($choose="Delete:@")
			$UUIDInscription:=Split string:C1554($choose; ":").pop()
			$eInscription:=ds:C1482.sfw_UserInscription.get($UUIDInscription)
			If ($eInscription#Null:C1517)
				$info:=$eInscription.drop()
				If ($info.success)
					Form:C1466.lb_inscriptions:=ds:C1482.sfw_UserInscription.query("UUID_UserProfile = :1"; Form:C1466.current_item.UUID)
					Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
				End if 
			End if 
			
	End case 