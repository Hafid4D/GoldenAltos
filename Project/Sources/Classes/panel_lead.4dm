singleton Class constructor
	
	
Function formMethod()
	Form:C1466.sfw.panelFormMethod()  //The main body of the form method and basic sfw functionalities 
	If (Form:C1466.sfw.updateOfPanelNeeded())  //The current item is changed or reloaded, so it's necessary ti refresh 
		If (Form:C1466.current_item.dateCreation=!00-00-00!)
			Form:C1466.current_item.dateCreation:=Current date:C33()
		End if 
		
		If (Form:C1466.current_item.staff=Null:C1517)
			If (cs:C1710.sfw_userManager.me.info.UUID_Staff#Null:C1517)
				Form:C1466.current_item.staff:=ds:C1482.Staff.query("UUID = :1"; cs:C1710.sfw_userManager.me.info.UUID_Staff).first()
			Else 
				
			End if 
		End if 
		
		This:C1470.drawPup_serviceType()
		This:C1470.drawPup_stage()
		This:C1470.drawPup_priority()
		This:C1470.drawPup_customer()
		This:C1470.drawPup_staff()
	End if 
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())  //a page is displayed so it's time to load the sources of data to display
		Case of 
			: (FORM Get current page:C276(*)=1)
				// add load functions
		End case 
	End if 
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())
		This:C1470.redrawAndSetVisible()
	End if 
	
	
	
	//mark:dra and clic on popups
	
Function drawPup_serviceType()
	If (Form:C1466.current_item#Null:C1517)
		$parts:=New collection:C1472(Form:C1466.current_item.serviceType.code; Form:C1466.current_item.serviceType.name)
		$serviceName:=$parts.join(" - "; ck ignore null or empty:K85:5)
		If ($serviceName="")
			$serviceName:="Service"
		End if 
		$color:=cs:C1710.sfw_htmlColor.me.getName(Form:C1466.current_item.serviceType.color)
		$pathIcon:=($color#"") ? "sfw/colors/"+$color+"-circle.png" : "sfw/image/skin/rainbow/icon/spacer-1x24.png"
		Form:C1466.sfw.drawButtonPup("pup_serviceType"; $serviceName; $pathIcon; (Form:C1466.current_item.serviceType=Null:C1517))
	End if 
	
	
Function pup_serviceType()
	var $eServiceType : cs:C1710.ServiceTypeEntity
	
	
	If (Form:C1466.sfw.checkIsInModification())
		$menu:=Create menu:C408
		If (Storage:C1525.cache=Null:C1517) || (Storage:C1525.cache.serviceType=Null:C1517)
			ds:C1482.ServiceType.cacheLoad()
		End if 
		
		For each ($serviceType; Storage:C1525.cache.serviceType)
			APPEND MENU ITEM:C411($menu; $serviceType.code+" - "+$serviceType.name; *)
			SET MENU ITEM PARAMETER:C1004($menu; -1; $serviceType.UUID)
			If ($serviceType.UUID=Form:C1466.current_item.UUID_ServiceType)
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
				$eServiceType:=ds:C1482.ServiceType.get($choose)
				Form:C1466.current_item.UUID_ServiceType:=$eServiceType.UUID
		End case 
	End if 
	This:C1470.drawPup_serviceType()
	
	
Function drawPup_stage()
	If (Form:C1466.current_item#Null:C1517)
		$leadStage:=ds:C1482.LeadStage.query("stageID= :1"; Form:C1466.current_item.currentStageID).first() || New object:C1471()
		$parts:=New collection:C1472($leadStage.code; $leadStage.name)
		$stageName:=$parts.join(" - "; ck ignore null or empty:K85:5)
		If ($stageName="")
			$stageName:="Stage"
		End if 
		$color:=cs:C1710.sfw_htmlColor.me.getName($leadStage.color)
		$pathIcon:=($color#"") ? "sfw/colors/"+$color+"-circle.png" : "sfw/image/skin/rainbow/icon/spacer-1x24.png"
		Form:C1466.sfw.drawButtonPup("pup_stage"; $stageName; $pathIcon; ($leadStage=Null:C1517))
	End if 
	
	
Function pup_stage()
	var $eLeadStage : cs:C1710.LeadStageEntity
	
	
	If (Form:C1466.sfw.checkIsInModification())
		$menu:=Create menu:C408
		If (Storage:C1525.cache=Null:C1517) || (Storage:C1525.cache.leadStage=Null:C1517)
			ds:C1482.LeadStage.cacheLoad()
		End if 
		
		For each ($eLeadStage; Storage:C1525.cache.leadStage)
			APPEND MENU ITEM:C411($menu; $eLeadStage.code+" - "+$eLeadStage.name; *)
			SET MENU ITEM PARAMETER:C1004($menu; -1; $eLeadStage.UUID)
			If ($eLeadStage.stageID=Form:C1466.current_item.currentStageID)
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
				$eLeadStage:=ds:C1482.LeadStage.get($choose)
				Form:C1466.current_item.currentStageID:=$eLeadStage.stageID
		End case 
	End if 
	This:C1470.drawPup_stage()
	
	
	
	
Function drawPup_priority()
	If (Form:C1466.current_item#Null:C1517)
		$leadPriority:=ds:C1482.LeadPriority.query("levelID= :1"; Form:C1466.current_item.priorityLevelID).first() || New object:C1471()
		$parts:=New collection:C1472($leadPriority.code; $leadPriority.name)
		$priorityName:=$parts.join(" - "; ck ignore null or empty:K85:5)
		If ($priorityName="")
			$priorityName:="Priority"
		End if 
		$color:=cs:C1710.sfw_htmlColor.me.getName($leadPriority.color)
		$pathIcon:=($color#"") ? "sfw/colors/"+$color+"-circle.png" : "sfw/image/skin/rainbow/icon/spacer-1x24.png"
		Form:C1466.sfw.drawButtonPup("pup_priority"; $priorityName; $pathIcon; ($leadPriority=Null:C1517))
	End if 
	
Function pup_priority()
	var $eLeadPriority : cs:C1710.LeadPriorityEntity
	
	
	If (Form:C1466.sfw.checkIsInModification())
		$menu:=Create menu:C408
		If (Storage:C1525.cache=Null:C1517) || (Storage:C1525.cache.leadPriority=Null:C1517)
			ds:C1482.LeadPriority.cacheLoad()
		End if 
		
		For each ($eLeadPriority; Storage:C1525.cache.leadPriority)
			APPEND MENU ITEM:C411($menu; $eLeadPriority.code+" - "+$eLeadPriority.name; *)
			SET MENU ITEM PARAMETER:C1004($menu; -1; $eLeadPriority.UUID)
			If ($eLeadPriority.levelID=Form:C1466.current_item.priorityLevelID)
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
				$eLeadPriority:=ds:C1482.LeadPriority.get($choose)
				Form:C1466.current_item.priorityLevelID:=$eLeadPriority.levelID
		End case 
	End if 
	This:C1470.drawPup_priority()
	
	
	
	
Function redrawAndSetVisible()
	This:C1470.drawPup_serviceType()
	This:C1470.drawPup_stage()
	This:C1470.drawPup_priority()
	This:C1470.drawPup_customer()
	This:C1470.drawPup_staff()
	
Function btnOpenCustomer()
	$entity:=Form:C1466.current_item.customer
	Form:C1466.sfw.openInANewWindow($entity; "customerService"; "customer")
	
Function btnOpenStaff()
	$entity:=Form:C1466.current_item.staff
	Form:C1466.sfw.openInANewWindow($entity; "qualityAssistance"; "staff")
	
	
Function btnCreateCustomer()
	//$entry:=cs.sfw_definition.me.entries.query("ident = :1 "; "customer").first()
	//$vision:=cs.sfw_definition.me.visions.query("ident = :1 "; "customerService").first()
	//$formData:=New object()
	//$formData.sfw:=cs.sfw_main.new()
	//$formData.sfw.entry:=$entry
	//$formData.sfw.vision:=$vision
	//Form.sfw.openForm($formData)
	Form:C1466.sfw.openCreateWindow("customerService"; "customer")
	
	
Function drawPup_customer()
	If (Form:C1466.current_item#Null:C1517)
		$name:=Form:C1466.current_item.customer.name || "Customer"
		Form:C1466.sfw.drawButtonPup("pup_customer"; $name; "sfw/image/skin/rainbow/icon/spacer-1x24.png"; (Form:C1466.current_item.customer=Null:C1517))
	End if 
	
	
Function selectCustomer()
	If (Form:C1466.sfw.checkIsInModification())
		Case of 
			: (FORM Event:C1606.code=On Getting Focus:K2:7) | (FORM Event:C1606.code=On Clicked:K2:4)
				
				OBJECT GET COORDINATES:C663(*; "pup_customer"; $l; $t; $r; $b)
				CONVERT COORDINATES:C1365($l; $b; XY Current form:K27:5; XY Main window:K27:8)
				$form:=New object:C1471()
				$form.lb_items:=ds:C1482.Customer.all()
				$form.oo:=""
				
				$winRef:=Open form window:C675("selectCustomer"; Pop up form window:K39:11; $l; $b+1)
				DIALOG:C40("selectCustomer"; $form)
				CLOSE WINDOW:C154($winRef)
				If (ok=1)
					Form:C1466.current_item.UUID_Customer:=$form.item.UUID
					Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
				End if 
		End case 
	End if 
	This:C1470.drawPup_customer()
	
	
Function drawPup_staff()
	If (Form:C1466.current_item#Null:C1517)
		$staffName:=Form:C1466.current_item.staff.fullName || "Staff"
		Form:C1466.sfw.drawButtonPup("pup_staff"; $staffName; "sfw/image/skin/rainbow/icon/spacer-1x24.png"; (Form:C1466.current_item.staff=Null:C1517))
	End if 
	
Function selectStaff()
	If (Form:C1466.sfw.checkIsInModification())
		Case of 
			: (FORM Event:C1606.code=On Getting Focus:K2:7) | (FORM Event:C1606.code=On Clicked:K2:4)
				
				OBJECT GET COORDINATES:C663(*; "pup_staff"; $l; $t; $r; $b)
				CONVERT COORDINATES:C1365($l; $b; XY Current form:K27:5; XY Main window:K27:8)
				$form:=New object:C1471()
				$form.lb_items:=ds:C1482.Staff.all()
				$form.oo:=""
				
				$winRef:=Open form window:C675("selectStaff"; Pop up form window:K39:11; $l; $b+1)
				DIALOG:C40("selectStaff"; $form)
				CLOSE WINDOW:C154($winRef)
				
				If (ok=1)
					Form:C1466.current_item.UUID_Staff:=$form.item.UUID
					Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
				End if 
				
		End case 
	End if 
	This:C1470.drawPup_staff()
	
	
Function btnDatePicker()
	If (Form:C1466.sfw.checkIsInModification())
		OBJECT GET COORDINATES:C663(*; "btnDatePicker"; $x1; $y1; $x2; $y2)
		$test:=DatePicker Display Dialog($x1+500; $y1+100)
		If ($test#!00-00-00!)
			Form:C1466.current_item.dateCreation:=$test
		End if 
	End if 
	