singleton Class constructor
	//It's a singleton class
	
Function _activate_save_cancel_button()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	
Function formMethod()
	//This function manages the main logic for updating and refreshing the form
	Form:C1466.sfw.panelFormMethod()  //The main body of the form method and basic sfw functionalities 
	If (Form:C1466.sfw.updateOfPanelNeeded())  //The current item is changed or reloaded, so it's necessary ti refresh 
		
		If (Form:C1466.situation.mode="add")
			OBJECT SET VISIBLE:C603(*; "pup_equipmentId"; True:C214)
		Else 
			OBJECT SET VISIBLE:C603(*; "pup_equipmentId"; False:C215)
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
	This:C1470.drawPup_EquipmentId()
	OBJECT SET VISIBLE:C603(*; "PopupDa@"; Form:C1466.sfw.checkIsInModification())
	If (Form:C1466.situation.mode#"add")
		OBJECT SET ENTERABLE:C238(*; "entryField_systemID"; False:C215)
	End if 
	
	
Function drawPup_XXX()
	//This function updates the dropdown by displaying the name
	Form:C1466.sfw.drawButtonPup("pup_xxx"; $xxxName; "xxxx.png"; (Form:C1466.current_item.xxxx=Null:C1517))
	
	
Function pup_XXX()
	//Create pop up menu
	
	
Function drawPup_EquipmentId()
	If (Form:C1466.current_item#Null:C1517)
		$equipmentId:=Form:C1466.current_item.equipment  //ds.Equipment.query("assignedID= :1"; Form.current_item.systemID).first() || New object()
		$typeName:=$equipmentId.assignedID
		If ($typeName=Null:C1517)
			$typeName:=""
		End if 
		$color:=""  //cs.sfw_htmlColor.me.getName($equipmentId.color)
		$pathIcon:=""  //($color#"") ? "sfw/colors/"+$color+"-circle.png" : "sfw/image/skin/rainbow/icon/spacer-1x24.png"
		Form:C1466.sfw.drawButtonPup("pup_equipmentId"; $typeName; $pathIcon; ($equipmentId=Null:C1517))
	End if 
	
	
Function pup_equipId()
	//Create pop up menu
	If (Form:C1466.sfw.checkIsInModification())
		$menu:=Create menu:C408
		For each ($equipmentId; ds:C1482.Equipment.all())  // Storage.cache.equipmentTypes)
			APPEND MENU ITEM:C411($menu; $equipmentId.assignedID; *)
			SET MENU ITEM PARAMETER:C1004($menu; -1; $equipmentId.UUID)
			If ($equipmentId.assignedID=Form:C1466.current_item.systemID)
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
				$equipmentId:=ds:C1482.Equipment.get($choose)
				Form:C1466.current_item.systemID:=$equipmentId.assignedID
		End case 
		
	End if 
	This:C1470.drawPup_EquipmentId()
	
	
	
Function drawPup_fixOperator()
	If (Form:C1466.current_item#Null:C1517)
		$fixOperator:=ds:C1482.Staff.query("code= :1"; Form:C1466.current_item.fixedBy).first() || New object:C1471()
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
/*
$menu:=Create menu
If (Storage.cache=Null) || (Storage.cache.staffs=Null)
ds.Staff.cacheLoad()
End if 
		
For each ($fixOperator; Storage.cache.staffs)
APPEND MENU ITEM($menu; $fixOperator.code; *)
SET MENU ITEM PARAMETER($menu; -1; $fixOperator.code)
If ($fixOperator.code=Form.current_item.fixedBy)
SET MENU ITEM MARK($menu; -1; Char(18))
If (Is Windows)
SET MENU ITEM STYLE($menu; -1; Bold)
End if 
End if 
End for each 
$choose:=Dynamic pop up menu($menu)
RELEASE MENU($menu)
		
Case of 
: ($choose#"")
$fixOperator:=ds.Employee.get($choose)
Form.current_item.fixedBy:=$fixOperator.code
End case 
		
*/
		
		OBJECT GET COORDINATES:C663(*; "pup_fixOperator"; $l; $t; $r; $b)
		CONVERT COORDINATES:C1365($l; $b; XY Current form:K27:5; XY Main window:K27:8)
		
		$form:=New object:C1471(\
			"colName"; "code"; \
			"lb_items"; ds:C1482.Staff.all(); \
			"allData"; ds:C1482.Staff.all(); \
			"dataclass"; "Staff"\
			)
		
		$winRef:=Open form window:C675("selectNto1"; Pop up form window:K39:11; $l; $b)
		DIALOG:C40("selectNto1"; $form)
		CLOSE WINDOW:C154($winRef)
		
		If (ok=1)
			Form:C1466.current_item.fixedBy:=$form.item.code
			cs:C1710.panel_repairLog.me._activate_save_cancel_button()
		End if 
	End if 
	
	This:C1470.drawPup_fixOperator()
	
	
Function drawPup_reportOperator()
	If (Form:C1466.current_item#Null:C1517)
		$reportOperator:=ds:C1482.Staff.query("code= :1"; Form:C1466.current_item.reportedBy).first() || New object:C1471()
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
/*
$menu:=Create menu
If (Storage.cache=Null) || (Storage.cache.staffs=Null)
ds.Staff.cacheLoad()
End if 
		
For each ($reportOperator; Storage.cache.staffs)
APPEND MENU ITEM($menu; $reportOperator.code; *)
SET MENU ITEM PARAMETER($menu; -1; $reportOperator.code)
If ($reportOperator.code=Form.current_item.fixedBy)
SET MENU ITEM MARK($menu; -1; Char(18))
If (Is Windows)
SET MENU ITEM STYLE($menu; -1; Bold)
End if 
End if 
End for each 
$choose:=Dynamic pop up menu($menu)
RELEASE MENU($menu)
		
Case of 
: ($choose#"")
$reportOperator:=ds.Employee.get($choose)
Form.current_item.reportedBy:=$reportOperator.code
End case 
*/
		OBJECT GET COORDINATES:C663(*; "pup_reportOperator"; $l; $t; $r; $b)
		CONVERT COORDINATES:C1365($l; $b; XY Current form:K27:5; XY Main window:K27:8)
		
		$form:=New object:C1471(\
			"colName"; "code"; \
			"lb_items"; ds:C1482.Staff.all(); \
			"allData"; ds:C1482.Staff.all(); \
			"dataclass"; "Staff"\
			)
		
		$winRef:=Open form window:C675("selectNto1"; Pop up form window:K39:11; $l; $b)
		DIALOG:C40("selectNto1"; $form)
		CLOSE WINDOW:C154($winRef)
		
		If (ok=1)
			Form:C1466.current_item.reportedBy:=$form.item.code
			cs:C1710.panel_repairLog.me._activate_save_cancel_button()
		End if 
	End if 
	
	This:C1470.drawPup_reportOperator()
	
	
Function btnOpenOperator($operatorType)
	
	Case of 
			
		: ($operatorType="fixedBy")
			$es:=ds:C1482.Staff.query("code = :1"; Form:C1466.current_item.fixedBy)
			
		: ($operatorType="reportedBy")
			$es:=ds:C1482.Staff.query("code = :1"; Form:C1466.current_item.reportedBy)
			
	End case 
	
	If ($es.length>0)
		Form:C1466.sfw.openInANewWindow($es[0]; "qualityAssistance"; "staff")
	End if 
	