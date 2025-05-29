singleton Class constructor
	//It's a singleton class
	
Function _activate_save_cancel_button()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	
Function formMethod()
	//This function manages the main logic for updating and refreshing the form
	Form:C1466.sfw.panelFormMethod()  //The main body of the form method and basic sfw functionalities 
	If (Form:C1466.sfw.updateOfPanelNeeded())  //The current item is changed or reloaded, so it's necessary ti refresh 
		
		If (Form:C1466.startDate=Null:C1517)
			Form:C1466.startDate:=Current date:C33()
		End if 
		If (Form:C1466.endDate=Null:C1517)
			Form:C1466.endDate:=Current date:C33()
		End if 
		If (Undefined:C82(Form:C1466.interval))
			Form:C1466.interval:="0"
		End if 
		
		This:C1470.LoadAllTabs()
		This:C1470.calendar_init()
	End if 
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())  //a page is displayed so it's time to load the sources of data to display
		Case of 
			: (FORM Get current page:C276(*)=1)
				
				
			: (FORM Get current page:C276(*)=2)
				This:C1470.loadRepairLog()
				
				
		End case 
	End if 
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())  //It's time to resize the object or set visible
		This:C1470.redrawAndSetVisible()
	End if 
	
	
	
	
Function drawPup_XXX()
	//This function updates the dropdown by displaying the name
	Form:C1466.sfw.drawButtonPup("pup_xxx"; $xxxName; "xxxx.png"; (Form:C1466.current_item.xxxx=Null:C1517))
	
	
Function pup_XXX()
	//Create pop up menu
	
	
Function redrawAndSetVisible()
	//Adjusts the layout and visibility of form elements based on the current page and modification state
	This:C1470.drawPup_EquipmentType()
	This:C1470.drawPup_EquipmentLocation()
	This:C1470.drawPup_Division()
	
	Use (Form:C1466.sfw.entry.panel.pages)
		Form:C1466.sfw.entry.panel.pages[1].label:="Repair Log ("+String:C10(Form:C1466.lb_repairLog.length)+")"
		
	End use 
	Form:C1466.sfw.drawHTab()
	OBJECT SET TITLE:C194(*; "pup_endDate"; String:C10(Form:C1466.endDate))
	OBJECT SET TITLE:C194(*; "pup_startDate"; String:C10(Form:C1466.startDate))
	
	
Function drawPup_EquipmentType()
	If (Form:C1466.current_item#Null:C1517)
		$equipmentType:=ds:C1482.ToolType.query("UUID= :1"; Form:C1466.current_item.UUID_ToolType).first() || New object:C1471()
		$typeName:=$equipmentType.name
		If ($typeName=Null:C1517)
			$typeName:=""
		End if 
		$color:=""  //cs.sfw_htmlColor.me.getName($equipmentType.color)
		$pathIcon:=($color#"") ? "sfw/colors/"+$color+"-circle.png" : "sfw/image/skin/rainbow/icon/spacer-1x24.png"
		Form:C1466.sfw.drawButtonPup("pup_equipmentType"; $typeName; $pathIcon; ($equipmentType=Null:C1517))
	End if 
	
	
Function pup_type()
	//Create pop up menu
	If (Form:C1466.sfw.checkIsInModification())
		$menu:=Create menu:C408
		For each ($equipmentType; ds:C1482.ToolType.all())  // Storage.cache.equipmentTypes)
			APPEND MENU ITEM:C411($menu; $equipmentType.name; *)
			SET MENU ITEM PARAMETER:C1004($menu; -1; $equipmentType.UUID)
			If ($equipmentType.UUID=Form:C1466.current_item.UUID_ToolType)
				SET MENU ITEM MARK:C208($menu; -1; Char:C90(18))
				If (Is Windows:C1573)
					SET MENU ITEM STYLE:C425($menu; -1; Bold:K14:2)
				End if 
			End if 
		End for each 
		$choose:=Dynamic pop up menu:C1006($menu)
		RELEASE MENU:C978($menu)
		
		Case of 
			: ($choose#"")
				$equipmentType:=ds:C1482.ToolType.get($choose)
				Form:C1466.current_item.UUID_ToolType:=$equipmentType.UUID
		End case 
		
	End if 
	This:C1470.drawPup_EquipmentType()
	
	
Function drawPup_EquipmentLocation()
	If (Form:C1466.current_item#Null:C1517)
		$equipmentLocation:=ds:C1482.EquipmentLocation.query("locationID= :1"; Form:C1466.current_item.locationID).first() || New object:C1471()
		$locationName:=$equipmentLocation.name
		If ($locationName=Null:C1517)
			$locationName:=""
		End if 
		$color:=""
		$pathIcon:=($color#"") ? "sfw/colors/"+$color+"-circle.png" : "sfw/image/skin/rainbow/icon/spacer-1x24.png"
		Form:C1466.sfw.drawButtonPup("pup_equipmentLocation"; $locationName; $pathIcon; ($equipmentLocation=Null:C1517))
	End if 
	
	
Function pup_location()
	//Create pop up menu
	If (Form:C1466.sfw.checkIsInModification())
		$menu:=Create menu:C408
		If (Storage:C1525.cache=Null:C1517) || (Storage:C1525.cache.equipmentLocations=Null:C1517)
			ds:C1482.EquipmentLocation.cacheLoad()
		End if 
		
		For each ($equipmentLocation; Storage:C1525.cache.equipmentLocations)
			APPEND MENU ITEM:C411($menu; $equipmentLocation.name; *)
			SET MENU ITEM PARAMETER:C1004($menu; -1; $equipmentLocation.UUID)
			If ($equipmentLocation.locationID=Form:C1466.current_item.locationID)
				SET MENU ITEM MARK:C208($menu; -1; Char:C90(18))
				If (Is Windows:C1573)
					SET MENU ITEM STYLE:C425($menu; -1; Bold:K14:2)
				End if 
			End if 
		End for each 
		$choose:=Dynamic pop up menu:C1006($menu)
		RELEASE MENU:C978($menu)
		
		Case of 
			: ($choose#"")
				$equipmentLocation:=ds:C1482.EquipmentLocation.get($choose)
				Form:C1466.current_item.locationID:=$equipmentLocation.locationID
		End case 
		
	End if 
	This:C1470.drawPup_EquipmentLocation()
	
	
Function drawPup_Division()
	If (Form:C1466.current_item#Null:C1517)
		$equipmentDivision:=ds:C1482.Division.query("divisionID= :1"; Form:C1466.current_item.divisionID).first() || New object:C1471()
		$divisionName:=$equipmentDivision.name
		If ($divisionName=Null:C1517)
			$divisionName:=""
		End if 
		$color:=""
		$pathIcon:=($color#"") ? "sfw/colors/"+$color+"-circle.png" : "sfw/image/skin/rainbow/icon/spacer-1x24.png"
		Form:C1466.sfw.drawButtonPup("pup_equipmentDivision"; $divisionName; $pathIcon; ($equipmentDivision=Null:C1517))
	End if 
	
	
Function pup_division()
	//Create pop up menu
	If (Form:C1466.sfw.checkIsInModification())
		$menu:=Create menu:C408
		If (Storage:C1525.cache=Null:C1517) || (Storage:C1525.cache.divisions=Null:C1517)
			ds:C1482.Division.cacheLoad()
		End if 
		
		For each ($equipmentDivision; Storage:C1525.cache.divisions)
			APPEND MENU ITEM:C411($menu; $equipmentDivision.name; *)
			SET MENU ITEM PARAMETER:C1004($menu; -1; $equipmentDivision.UUID)
			If ($equipmentDivision.divisionID=Form:C1466.current_item.divisionID)
				SET MENU ITEM MARK:C208($menu; -1; Char:C90(18))
				If (Is Windows:C1573)
					SET MENU ITEM STYLE:C425($menu; -1; Bold:K14:2)
				End if 
			End if 
		End for each 
		$choose:=Dynamic pop up menu:C1006($menu)
		RELEASE MENU:C978($menu)
		
		Case of 
			: ($choose#"")
				$equipmentDivision:=ds:C1482.Division.get($choose)
				Form:C1466.current_item.divisionID:=$equipmentDivision.divisionID
		End case 
		
	End if 
	This:C1470.drawPup_Division()
	
	
Function loadRepairLog()
	
	If (Form:C1466.current_item#Null:C1517)
		
		//Form.lb_repairLog:=New collection()
		
		Form:C1466.lb_repairLog:=ds:C1482.Repair_Log.query("systemID =:1"; Form:C1466.current_item.assignedID).orderBy("systemID desc")
		
		
	End if 
	
	
Function LoadAllTabs()
	
	This:C1470.loadRepairLog()
	
	
	
	//Mark:-Calendar
	
	
Function displayDate()
	Form:C1466.calendar.display.year:=Year of:C25(Form:C1466.calendar.display.date)
	Form:C1466.calendar.display.month:=Month of:C24(Form:C1466.calendar.display.date)
	Form:C1466.calendar.display.day:=Day of:C23(Form:C1466.calendar.display.date)
	Form:C1466.planificationRanges:=Null:C1517
	//This.calendar_drawing()
	//This.pup_start_init()
	//This.pup_duration_init()
	//This.pup_end_init()
	//This.alerteTiming()
	
	//If (FORM Get current page=3)
	//This.pup_meetings_init_p3()
	//End if 
	
	
Function calendar_init()
	
	If (Form:C1466.months=Null:C1517)
		Form:C1466.months:=Split string:C1554(ds:C1482.sfw_readXliff("dateAndTime.months"; "January;Febuary;March;April;May;June;July;August;September;October;November;December"); ";")
		Form:C1466.days:=Split string:C1554(ds:C1482.sfw_readXliff("dateAndTime.days"; "Sunday;Monday;Tuesday;Wednesday;Thursday;Friday;Saturday"); ";")
	End if 
	
	
Function bPreviousMonth()
	Form:C1466.calendar.display.date:=Add to date:C393(Form:C1466.calendar.display.date; 0; -1; 0)
	This:C1470.displayDate()
	
Function bNextMonth()
	Form:C1466.calendar.display.date:=Add to date:C393(Form:C1466.calendar.display.date; 0; 1; 0)
	This:C1470.displayDate()
	
Function bToday()
	Form:C1466.calendar.display.date:=Current date:C33
	This:C1470.displayDate()
	
Function pup_displayYear()
	$refmenus:=New collection:C1472()
	$menu:=Create menu:C408
	$refmenus.push($menu)
	$yearToday:=Year of:C25(Current date:C33)
	For ($year; $yearToday-10; $yearToday)
		APPEND MENU ITEM:C411($menu; String:C10($year))
		$ref:=String:C10($year)
		SET MENU ITEM PARAMETER:C1004($menu; -1; $ref)
	End for 
	
	
	$ref:=Dynamic pop up menu:C1006($menu)
	
	For each ($menu; $refmenus)
		RELEASE MENU:C978($menu)
	End for each 
	
	Case of 
		: ($ref="")
		: ($ref#"")
			//Form.calendar.display.year:=Num($ref)
			Form:C1466.calendar.display.date:=Add to date:C393(!00-00-00!; Form:C1466.calendar.display.year; Form:C1466.calendar.display.month; Form:C1466.calendar.display.day)
			//This.displayDate()
	End case 
	
	
Function pup_displayMonth()
	$refmenus:=New collection:C1472()
	$menu:=Create menu:C408
	$refmenus.push($menu)
	$m:=0
	For each ($month; Form:C1466.months)
		$m:=$m+1
		APPEND MENU ITEM:C411($menu; $month; *)
		$ref:=String:C10($m; "00")
		SET MENU ITEM PARAMETER:C1004($menu; -1; $ref)
		If ($m%3=0)
			APPEND MENU ITEM:C411($menu; "-")
		End if 
	End for each 
	
	
	$ref:=Dynamic pop up menu:C1006($menu)
	
	For each ($menu; $refmenus)
		RELEASE MENU:C978($menu)
	End for each 
	
	Case of 
		: ($ref="")
		: ($ref#"")
			//Form.calendar.display.month:=Num($ref)
			//Form.calendar.display.date:=Add to date(!00-00-00!; Form.calendar.display.year; Form.calendar.display.month; Form.calendar.display.day)
			//This.displayDate()
	End case 
	
	
Function drawPup_days()
	If (Form:C1466.current_item#Null:C1517)
		$days:=New collection:C1472("1"; "2"; "3"; "4"; "5"; "6"; "7"; "8"; "9"; "10"; "11"; "12"; "13"; "14"; "15"; "16"; "17"; "18"; "19"; "20"; "21"; "22"; "23"; "24"; "25"; "26"; "27"; "28"; "29"; "30"; "31")
		$typeName:=$days
		If ($typeName=Null:C1517)
			$typeName:=""
		End if 
		$color:=""
		$pathIcon:=($color#"") ? "sfw/colors/"+$color+"-circle.png" : "sfw/image/skin/rainbow/icon/spacer-1x24.png"
		Form:C1466.sfw.drawButtonPup("Pup_displayDay"; $typeName; $pathIcon; ($days=Null:C1517))
	End if 
	
	
Function pup_days()
	//Create pop up menu
	If (Form:C1466.sfw.checkIsInModification())
		$menu:=Create menu:C408
		For each ($days; ds:C1482.ToolType.all())  // Storage.cache.equipmentTypes)
			APPEND MENU ITEM:C411($menu; $equipmentType.name; *)
			SET MENU ITEM PARAMETER:C1004($menu; -1; $equipmentType.UUID)
			If ($equipmentType.UUID=Form:C1466.current_item.UUID_ToolType)
				SET MENU ITEM MARK:C208($menu; -1; Char:C90(18))
				If (Is Windows:C1573)
					SET MENU ITEM STYLE:C425($menu; -1; Bold:K14:2)
				End if 
			End if 
		End for each 
		$choose:=Dynamic pop up menu:C1006($menu)
		RELEASE MENU:C978($menu)
		
		Case of 
			: ($choose#"")
				$equipmentType:=ds:C1482.ToolType.get($choose)
				Form:C1466.current_item.UUID_ToolType:=$equipmentType.UUID
		End case 
		
	End if 
	This:C1470.drawPup_days()
	
	
	
	
	
	
	
	
	