singleton Class constructor
	//It's a singleton class
	
Function _activate_save_cancel_button()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	
Function formMethod()
	//This function manages the main logic for updating and refreshing the form
	Form:C1466.sfw.panelFormMethod()  //The main body of the form method and basic sfw functionalities 
	If (Form:C1466.sfw.updateOfPanelNeeded())  //The current item is changed or reloaded, so it's necessary ti refresh 
		
		If (Form:C1466.situation.mode="add")
			OBJECT SET ENTERABLE:C238(*; "pup_equipmentId"; True:C214)
		Else 
			OBJECT SET ENTERABLE:C238(*; "pup_equipmentId"; False:C215)
		End if 
	End if 
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())  //a page is displayed so it's time to load the sources of data to display
		Case of 
			: (FORM Get current page:C276(*)=1)
				
				
				
		End case 
	End if 
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())  //It's time to resize the object or set visible
		This:C1470.redrawAndSetVisible()
	End if 
	
	
Function redrawAndSetVisible()
	//Adjusts the layout and visibility of form elements based on the current page and modification state
	This:C1470.drawPup_fixOperator()
	This:C1470.drawPup_reportOperator()
	This:C1470.drawPup_downTimePicker()
	This:C1470.drawPup_upTimePicker()
	
	OBJECT SET ENTERABLE:C238(*; "entryField_systemID"; False:C215)
	OBJECT SET VISIBLE:C603(*; "PopupDa@"; Form:C1466.sfw.checkIsInModification())
	OBJECT SET VISIBLE:C603(*; "TimePicker@"; Form:C1466.sfw.checkIsInModification())
	
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($widthSubform; $heightSubform)
	
	Case of 
			
		: (FORM Get current page:C276(*)=1)
			
			OBJECT GET COORDINATES:C663(*; "entryField_problem"; $g; $h; $d; $b)
			OBJECT SET COORDINATES:C1248(*; "entryField_problem"; $g; $h; $widthSubform-10; $b)
			
			OBJECT GET COORDINATES:C663(*; "entryField_fix"; $g; $h; $d; $b)
			OBJECT SET COORDINATES:C1248(*; "entryField_fix"; $g; $h; $widthSubform-10; $heightSubform-10)
			
			OBJECT GET COORDINATES:C663(*; "entryField_status"; $g; $h; $d; $b)
			OBJECT SET COORDINATES:C1248(*; "entryField_status"; $g; $h; $d; $heightSubform-10)
			
	End case 
	
	If (Form:C1466.sfw.checkIsInModification())
		OBJECT SET ENABLED:C1123(*; "entryField_approvedBy"; False:C215)
		$eUser:=cs:C1710.sfw_UserEntity
		
		$eUser:=ds:C1482.sfw_User.query("login = :1"; Current user:C182).first()
		
		If ($eUser#Null:C1517)
			
			$approverProfile:=New collection:C1472("qs"; "pm")
			$hasAuthorizedProfile:=$eUser.userInscriptions.extract("userProfile").query("ident in :1"; $approverProfile).length>0
			
			$isFromAuthorizedTeam:=$eUser.staffs.query("fullName =:1"; Current user:C182).memberships.query("team.name =:1"; "Facilities").length>0
			
			$hasAuthorizationToApprove:=($hasAuthorizedProfile | $isFromAuthorizedTeam)
			OBJECT SET ENABLED:C1123(*; "pup_reportOperator"; $hasAuthorizationToApprove)
			
			$isFromAuthorizedTeam:=$eUser.staffs.query("fullName =:1"; Current user:C182).memberships.query("team.name =:1"; "Facilities").length>0
			OBJECT SET ENABLED:C1123(*; "pup_fixOperator"; $isFromAuthorizedTeam)
			
			$isFromAuthorizedTeam:=$eUser.staffs.query("fullName =:1"; Current user:C182).memberships.query("team.name =:1"; "Facilities").length>0
			OBJECT SET ENABLED:C1123(*; "entryField_isApproved"; $hasAuthorizedProfile)
			OBJECT SET ENABLED:C1123(*; "entryField_approvalDate"; $hasAuthorizedProfile)
			
			OBJECT SET VISIBLE:C603(*; "PopupDate"; $hasAuthorizedProfile)
			
			
		End if 
		
	End if 
	
	Form:C1466.sfw.drawHTab()
	
	
Function drawPup_XXX()
	//This function updates the dropdown by displaying the name
	Form:C1466.sfw.drawButtonPup("pup_xxx"; $xxxName; "xxxx.png"; (Form:C1466.current_item.xxxx=Null:C1517))
	
	
Function drawPup_fixOperator()
	If (Form:C1466.current_item#Null:C1517)
		$fixOperator:=ds:C1482.Staff.query("UUID= :1"; Form:C1466.current_item.operators.fixedBy).first() || New object:C1471()
		$operatorCode:=$fixOperator.code
		If ($operatorCode=Null:C1517)
			$operatorCode:=""
		End if 
		$color:=""
		$pathIcon:=($color#"") ? "sfw/colors/"+$color+"-circle.png" : "sfw/image/skin/rainbow/icon/spacer-1x24.png"
		Form:C1466.sfw.drawButtonPup("pup_fixOperator"; $operatorCode; $pathIcon; ($fixOperator=Null:C1517))
	End if 
	
	
Function pup_fixOperator()
	//Create pop up menu
	
	If (Form:C1466.sfw.checkIsInModification())
		
		OBJECT GET COORDINATES:C663(*; "pup_fixOperator"; $l; $t; $r; $b)
		CONVERT COORDINATES:C1365($l; $b; XY Current form:K27:5; XY Main window:K27:8)
		
		$form:=New object:C1471(\
			"colName"; "code"; \
			"allData"; ds:C1482.Staff.all(); \
			"dataclass"; "Staff"\
			)
		
		$winRef:=Open form window:C675("selectNto1"; Pop up form window:K39:11; $l; $b)
		DIALOG:C40("selectNto1"; $form)
		CLOSE WINDOW:C154($winRef)
		
		If (ok=1)
			Form:C1466.current_item.operators.fixedBy:=$form.item.UUID
			cs:C1710.panel_repairLog.me._activate_save_cancel_button()
		End if 
	End if 
	
	This:C1470.drawPup_fixOperator()
	
	
Function drawPup_reportOperator()
	If (Form:C1466.current_item#Null:C1517)
		$reportOperator:=ds:C1482.Staff.query("UUID= :1"; Form:C1466.current_item.operators.reportedBy).first() || New object:C1471()
		$operatorCode:=$reportOperator.code
		If ($operatorCode=Null:C1517)
			$operatorCode:=""
		End if 
		$color:=""
		$pathIcon:=($color#"") ? "sfw/colors/"+$color+"-circle.png" : "sfw/image/skin/rainbow/icon/spacer-1x24.png"
		Form:C1466.sfw.drawButtonPup("pup_reportOperator"; $operatorCode; $pathIcon; ($reportOperator=Null:C1517))
	End if 
	
	
Function pup_reportOperator()
	//Create pop up menu
	If (Form:C1466.sfw.checkIsInModification())
		
		OBJECT GET COORDINATES:C663(*; "pup_reportOperator"; $l; $t; $r; $b)
		CONVERT COORDINATES:C1365($l; $b; XY Current form:K27:5; XY Main window:K27:8)
		
		$form:=New object:C1471(\
			"colName"; "code"; \
			"allData"; ds:C1482.Staff.all(); \
			"dataclass"; "Staff"\
			)
		
		$winRef:=Open form window:C675("selectNto1"; Pop up form window:K39:11; $l; $b)
		DIALOG:C40("selectNto1"; $form)
		CLOSE WINDOW:C154($winRef)
		
		If (ok=1)
			Form:C1466.current_item.operators.reportedBy:=$form.item.UUID
			cs:C1710.panel_repairLog.me._activate_save_cancel_button()
		End if 
	End if 
	
	This:C1470.drawPup_reportOperator()
	
	
Function btnOpenOperator($operatorType)
	
	Case of 
			
		: ($operatorType="fixedBy")
			$es:=ds:C1482.Staff.query("UUID = :1"; Form:C1466.current_item.operators.fixedBy)
			
		: ($operatorType="reportedBy")
			$es:=ds:C1482.Staff.query("UUID = :1"; Form:C1466.current_item.operators.reportedBy)
			
	End case 
	
	If ($es.length>0)
		Form:C1466.sfw.openInANewWindow($es[0]; "qualityAssurance"; "staff")
	End if 
	
	
Function btnOpenEquipment()
	
	$es:=ds:C1482.Equipment.query("UUID = :1"; Form:C1466.current_item.UUID_Equipment)
	
	If ($es.length>0)
		Form:C1466.sfw.openInANewWindow($es[0]; "qualityAssurance"; "equipment")
	End if 
	
	
	
Function pup_downTimePicker()
	If (Form:C1466.sfw.checkIsInModification())
		$form:=New object:C1471
		
		//$form.hour:=String(cs.sfw_stmp.me.getHour(Form.current_item.downAt))
		//$form.minute:=String(cs.sfw_stmp.me.getNbMinutes(Form.current_item.downAt)%60)
		
		$form.timeStamp:=Form:C1466.current_item.downAt
		OBJECT GET COORDINATES:C663(Self:C308->; $left; $top; $rigth; $bottom)
		
		CONVERT COORDINATES:C1365($left; $bottom; XY Current form:K27:5; XY Main window:K27:8)
		Open window:C153($left; $bottom+30; $left+237; $bottom+206; Movable dialog box:K34:7; "Enter Time")
		DIALOG:C40("_ga_TimePicker"; $form)
		
		If (OK=1)
			Form:C1466.current_item.downAt:=$form.timeStamp
			cs:C1710.panel_repairLog.me._activate_save_cancel_button()
		End if 
		
	End if 
	
	This:C1470.drawPup_downTimePicker()
	
	
	
Function drawPup_downTimePicker()
	If (Form:C1466.current_item#Null:C1517)
		
		$time:=Time string:C180(Form:C1466.current_item.downAt)
		$hour:=cs:C1710.sfw_stmp.me.getHour(Form:C1466.current_item.downAt)
		
		$when:=$hour>12 ? "PM" : "AM"
		
		Form:C1466.downAt:=Form:C1466.current_item.downAt=0 ? $time : $time+" "+$when
		
	End if 
	
	
Function pup_upTimePicker()
	If (Form:C1466.sfw.checkIsInModification())
		$form:=New object:C1471
		
		//$form.hour:=String(cs.sfw_stmp.me.getHour(Form.current_item.upAt))
		//$form.minute:=String(cs.sfw_stmp.me.getNbMinutes(Form.current_item.upAt)%60)
		
		$form.timeStamp:=Form:C1466.current_item.upAt
		OBJECT GET COORDINATES:C663(Self:C308->; $left; $top; $rigth; $bottom)
		
		CONVERT COORDINATES:C1365($left; $bottom; XY Current form:K27:5; XY Main window:K27:8)
		Open window:C153($left; $bottom+30; $left+237; $bottom+206; Movable dialog box:K34:7; "Enter Time")
		DIALOG:C40("_ga_TimePicker"; $form)
		
		If (OK=1)
			
			Form:C1466.current_item.upAt:=$form.timeStamp
			$time:=Time string:C180($form.timeStamp)
			
			cs:C1710.panel_repairLog.me._activate_save_cancel_button()
		End if 
		
	End if 
	
	This:C1470.drawPup_upTimePicker()
	
	
	
Function drawPup_upTimePicker()
	If (Form:C1466.current_item#Null:C1517)
		
		$time:=Time string:C180(Form:C1466.current_item.upAt)
		$hour:=cs:C1710.sfw_stmp.me.getHour(Form:C1466.current_item.upAt)
		
		$when:=$hour>12 ? "PM" : "AM"
		
		Form:C1466.upAt:=Form:C1466.current_item.upAt=0 ? $time : $time+" "+$when
		
	End if 
	
	