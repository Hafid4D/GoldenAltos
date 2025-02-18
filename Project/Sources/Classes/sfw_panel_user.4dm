singleton Class constructor
	//It's a singleton class
	
Function formMethod()
	//This function manages the main logic for updating and refreshing the form
	Form:C1466.sfw.panelFormMethod()  //The main body of the form method and basic sfw functionalities 
	If (Form:C1466.sfw.updateOfPanelNeeded())  //The current item is changed or reloaded, so it's necessary ti refresh 
		Form:C1466.lb_inscriptions:=ds:C1482.sfw_UserInscription.query("UUID_User = :1"; Form:C1466.current_item.UUID)
	End if 
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())  //a page is displayed so it's time to load the sources of data to display
		Case of 
			: (FORM Get current page:C276(*)=1)
				// add load functions
		End case 
	End if 
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())  //It's time to resize the object or set visible
		This:C1470.redrawAndSetVisible()
	End if 
	
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.canValidate:=(Form:C1466.current_item.firstName#"") && (Form:C1466.current_item.lastName#"")
		If (Form:C1466.current_item.login="") & (Form:C1466.canValidate)
			Form:C1466.current_item.setLogin()
		End if 
		
	End if 
	
	//Function drawPup_XXX()
	////This function updates the dropdown by displaying the name
	//Form.sfw.drawButtonPup("pup_xxx"; $xxxName; "xxxx.png"; (Form.current_item.xxxx=Null))
	
	
	//Function pup_XXX()
	////Create pop up menu
	//If (Form.sfw.checkIsInModification())
	//End if 
	//This.drawPup_XXX()
	
	
Function redrawAndSetVisible()
	//Adjusts the layout and visibility of form elements based on the current page and modification state
	OBJECT SET ENABLED:C1123(*; "cb_asDesigner"; Form:C1466.sfw.checkIsInModification())
	OBJECT SET ENABLED:C1123(*; "cb_isInactive"; Form:C1466.sfw.checkIsInModification())
	OBJECT SET ENABLED:C1123(*; "btn_reset"; Form:C1466.sfw.checkIsInModification() && Not:C34(Form:C1466.situation.mode="add") && (Not:C34(Form:C1466.current_item.isInactive)))
	Form:C1466.sfw.redrawButtons()
	
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
	
	
	
	
	//Function loadXXX()
	////Loads and initializes a list
	
Function bActionInscriptions()
	var $eProfile : cs:C1710.sfw_UserProfileEntity
	var $eInscription : cs:C1710.sfw_UserInscriptionEntity
	$menus:=New collection:C1472()
	$menu:=Create menu:C408
	$menus.push($menu)
	
	If (Form:C1466.sfw.checkIsInModification())
		$subMenuProfiles:=Create menu:C408
		$menus.push($subMenuProfiles)
		$uuids:=Form:C1466.lb_inscriptions.extract("UUID_UserProfile")
		$esProfiles:=ds:C1482.sfw_UserProfile.query("not(UUID in :1) order by name"; $uuids)
		For each ($eProfile; $esProfiles)
			APPEND MENU ITEM:C411($subMenuProfiles; $eProfile.name; *)
			SET MENU ITEM PARAMETER:C1004($subMenuProfiles; -1; "Profile:"+$eProfile.UUID)
		End for each 
		If ($esProfiles.length#0)
			APPEND MENU ITEM:C411($menu; "Add a profile"; $subMenuProfiles; *)  //XLIFF
		Else 
			APPEND MENU ITEM:C411($menu; "Add a profile"; *)  //XLIFF
			DISABLE MENU ITEM:C150($menu; -1)
		End if 
	Else 
		APPEND MENU ITEM:C411($menu; "Add a profile"; *)  //XLIFF
		DISABLE MENU ITEM:C150($menu; -1)
	End if 
	If (Form:C1466.inscription#Null:C1517)
		APPEND MENU ITEM:C411($menu; "Delete the profil \""+Form:C1466.inscription.userProfile.name+"\""; *)
		If (Form:C1466.sfw.checkIsInModification()) && (Form:C1466.inscription.moreData.autoCreation=Null:C1517)
			SET MENU ITEM PARAMETER:C1004($menu; -1; "Delete:"+Form:C1466.inscription.UUID)
		Else 
			DISABLE MENU ITEM:C150($menu; -1)
		End if 
	Else 
		APPEND MENU ITEM:C411($menu; "Delete the profil"; *)
		DISABLE MENU ITEM:C150($menu; -1)
	End if 
	$choose:=Dynamic pop up menu:C1006($menu)
	For each ($menu; $menus)
		RELEASE MENU:C978($menu)
	End for each 
	
	Case of 
		: ($choose="Profile:@")
			$UUIDProfile:=Split string:C1554($choose; ":").pop()
			$eInscription:=ds:C1482.sfw_UserInscription.new()
			$eInscription.UUID:=Generate UUID:C1066
			$eInscription.UUID_User:=Form:C1466.current_item.UUID
			$eInscription.UUID_UserProfile:=$UUIDProfile
			$eInscription.UUID_whoHasGiven:=cs:C1710.sfw_userManager.me.info.UUID
			$eInscription.stmp_given:=cs:C1710.sfw_stmp.me.now()
			$eInscription.moreData:=New object:C1471
			$info:=$eInscription.save()
			If ($info.success)
				Form:C1466.lb_inscriptions:=ds:C1482.sfw_UserInscription.query("UUID_User = :1"; Form:C1466.current_item.UUID)
				Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
			End if 
			
		: ($choose="Delete:@")
			$UUIDInscription:=Split string:C1554($choose; ":").pop()
			$eInscription:=ds:C1482.sfw_UserInscription.get($UUIDInscription)
			If ($eInscription#Null:C1517)
				$info:=$eInscription.drop()
				If ($info.success)
					Form:C1466.lb_inscriptions:=ds:C1482.sfw_UserInscription.query("UUID_User = :1"; Form:C1466.current_item.UUID)
					Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
				End if 
			End if 
			
	End case 
	