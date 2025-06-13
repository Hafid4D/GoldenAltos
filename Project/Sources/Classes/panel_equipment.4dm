singleton Class constructor
	//It's a singleton class
	
Function _activate_save_cancel_button()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	
	
Function formMethod()
	//This function manages the main logic for updating and refreshing the form
	Form:C1466.sfw.panelFormMethod()  //The main body of the form method and basic sfw functionalities 
	If (Form:C1466.sfw.updateOfPanelNeeded())  //The current item is changed or reloaded, so it's necessary ti refresh 
		If (Form:C1466.current_item#Null:C1517)
			OBJECT SET TITLE:C194(*; "statusHistory"; String:C10(Form:C1466.current_item.statusHistory))
		End if 
		This:C1470.LoadAllTabs()
	End if 
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())  //a page is displayed so it's time to load the sources of data to display
		Case of 
			: (FORM Get current page:C276(*)=1)
				
				
			: (FORM Get current page:C276(*)=2)
				This:C1470.loadRepairLog()
				
			: (FORM Get current page:C276(*)=3)
				This:C1470.loadDocuments()
				
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
	If (Form:C1466.current_item#Null:C1517)
		OBJECT SET TITLE:C194(*; "statusHistory"; String:C10(Form:C1466.current_item.statusHistory))
	End if 
	
	Use (Form:C1466.sfw.entry.panel.pages)
		Form:C1466.sfw.entry.panel.pages[1].label:="Repair Log ("+String:C10(Form:C1466.lb_repairLog.length)+")"
		Form:C1466.sfw.entry.panel.pages[2].label:="Documents ("+String:C10(Form:C1466.lb_documents.length)+")"
		
	End use 
	OBJECT SET VISIBLE:C603(*; "PopupDa@"; Form:C1466.sfw.checkIsInModification())
	Form:C1466.sfw.drawHTab()
	
	
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
		
		Form:C1466.lb_repairLog:=ds:C1482.RepairLog.query("systemID =:1"; Form:C1466.current_item.assignedID).orderBy("systemID desc")
		
	End if 
	
	
Function loadDocuments()
	
	If (Form:C1466.current_item#Null:C1517)
		
		Form:C1466.lb_documents:=Form:C1466.current_item.reports.documents.map(Formula:C1597(_ga_getDateTime))
		
		//Form.lb_documents:=ds.Document.query("foreignKey=:1 & tableNumber=:2"; Form.current_item.UUID; Table(->[Equipment])).orderBy("code desc").toCollection().map(Formula(_ga_getDateTime)
	End if 
	
	
Function LoadAllTabs()
	
	This:C1470.loadRepairLog()
	This:C1470.loadDocuments()
	
	
Function linkOpenLot($entity : 4D:C1709.Entity; $visionIdent : Text; $entryIdent : Text)
	If ($entity#Null:C1517)
		
		$formData:=New object:C1471()
		$formData.sfw:=cs:C1710.sfw_item.new()
		$formData.window:=New object:C1471
		GET WINDOW RECT:C443($left; $top; $right; $bottom)
		$formData.window.left:=$left+50
		$formData.window.top:=$top+50
		$formData.sfw.vision:=cs:C1710.sfw_definition.me.visions.query("ident = :1"; $visionIdent).first()
		$formData.sfw.entry:=cs:C1710.sfw_definition.me.entries.query("ident = :1"; $entryIdent).first()
		$formData.current_item:=$entity
		$formData.sfw.openForm($formData)
		
	End if 
	
Function bActionRepairLog()
	
	$refMenu:=Create menu:C408
	APPEND MENU ITEM:C411($refMenu; "Open in new window"; *)
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "openInWindow")
	If (Form:C1466.selectedRepaiLog=Null:C1517) | (Undefined:C82(Form:C1466.selectedRepaiLog))
		DISABLE MENU ITEM:C150($refMenu; -1)
	End if 
	
	$choice:=Dynamic pop up menu:C1006($refMenu)
	RELEASE MENU:C978($refMenu)
	Case of 
		: ($choice="openInWindow")
			Form:C1466.sfw.openInANewWindow(Form:C1466.current_item.repairLogs.query("UUID=:1"; Form:C1466.selectedRepaiLog.UUID).first(); "qualityAssistance"; "repairLog")
	End case 
	
	
	
Function bActionDocument()
	
	$refMenu:=Create menu:C408
	APPEND MENU ITEM:C411($refMenu; "View report"; *)
	SET MENU ITEM PARAMETER:C1004($refMenu; 1; "--view")
	If (Form:C1466.selectedDocument=Null:C1517) | (Undefined:C82(Form:C1466.selectedDocument))
		DISABLE MENU ITEM:C150($refMenu; 1)
	End if 
	
	APPEND MENU ITEM:C411($refMenu; "add report"; *)
	SET MENU ITEM PARAMETER:C1004($refMenu; 2; "--add")
	If (sfw_checkIsInModification=False:C215)
		DISABLE MENU ITEM:C150($refMenu; 2)
	End if 
	
	APPEND MENU ITEM:C411($refMenu; "modify report"; *)
	SET MENU ITEM PARAMETER:C1004($refMenu; 3; "--modify")
	If (sfw_checkIsInModification=False:C215) | (Form:C1466.selectedDocument=Null:C1517) | Undefined:C82(Form:C1466.selectedDocument)
		DISABLE MENU ITEM:C150($refMenu; 3)
	End if 
	
	APPEND MENU ITEM:C411($refMenu; "delete report"; *)
	SET MENU ITEM PARAMETER:C1004($refMenu; 4; "--delete")
	If (sfw_checkIsInModification=False:C215) | (Form:C1466.selectedDocument=Null:C1517) | Undefined:C82(Form:C1466.selectedDocument)
		DISABLE MENU ITEM:C150($refMenu; 4)
	End if 
	
	$choice:=Dynamic pop up menu:C1006($refMenu)
	RELEASE MENU:C978($refMenu)
	Case of 
		: ($choice="--view")
			
			$LocalFile:=Temporary folder:C486+Folder separator:K24:12+Form:C1466.selectedDocument.sourcePath
			BLOB TO DOCUMENT:C526($LocalFile; Form:C1466.selectedDocument.blob)
			OPEN URL:C673($LocalFile; *)
			
			
		: ($choice="--add")
			
			$details:=New object:C1471
			OB SET:C1220($details; "code"; ""; \
				"dateTimeStamp"; _ga_setDateTimeStamp(Current date:C33(*); Current time:C178(*)); \
				"creationDateTimeStamp"; _ga_setDateTimeStamp(Current date:C33(*); Current time:C178(*)); \
				"documentPath"; ""; \
				"sourcePath"; ""; \
				"description"; ""; \
				"approvalDate"; Date:C102(!00-00-00!); \
				"approvedBy"; ""; \
				"isApproved"; False:C215)
			
			
			$form:=New object:C1471("details"; $details)  // Form.selectedDocument)
			
			$form.operation:="create"
			
			$winRef:=Open form window:C675("_ga_document"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4)
			DIALOG:C40("_ga_document"; $form)
			If (OK=1)
				Form:C1466.current_item.reports.documents.push($form.details)
			End if 
			
			
		: ($choice="--modify")
			
			$form:=New object:C1471("details"; Form:C1466.current_item.reports.documents[Form:C1466.selectedDocumentPos-1])  // Form.selectedDocument)
			
			$form.operation:="modify"
			
			$winRef:=Open form window:C675("_ga_document"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4)
			DIALOG:C40("_ga_document"; $form)
			
			
		: ($choice="--delete")
			
			$ok:=cs:C1710.sfw_dialog.me.confirm("Do you really want to delete this document? "; "Delete"; "CANCEL")
			If ($ok)
				
				Form:C1466.current_item.reports.documents.remove(Form:C1466.selectedDocumentPos-1)
				
				
			End if 
			
			This:C1470.loadDocuments()
	End case 
	
	
	
	
	
	
	
	
	