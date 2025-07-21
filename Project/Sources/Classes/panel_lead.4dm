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
		
		This:C1470.drawPup_nextStep()
		
		This:C1470.drawPup_quote()
		This:C1470.drawPup_po()
		This:C1470.drawPup_job()
		
	End if 
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())  //a page is displayed so it's time to load the sources of data to display
		Case of 
			: (FORM Get current page:C276(*)=1)
				This:C1470.loadContacts()
				
			: (FORM Get current page:C276(*)=2)
				This:C1470.loadInteractions()
				
				
			: (FORM Get current page:C276(*)=3)
				This:C1470.loadJobs()
		End case 
	End if 
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())
		This:C1470.redrawAndSetVisible()
	End if 
	
	Case of 
		: (FORM Event:C1606.code=On Bound Variable Change:K2:52)
			This:C1470.drawPup_Interaction(["method"; "outcome"; "trigger"; "sales"; "contact"; "type"])
			This:C1470.display_interactionDetails()
			If (Form:C1466.current_interaction#Null:C1517)
				$index:=Form:C1466.current_interaction.indexOf()
				If ($index=-1)
					LISTBOX SELECT ROW:C912(*; "lb_interactions"; 0; lk remove from selection:K53:3)
				Else 
					LISTBOX SELECT ROW:C912(*; "lb_interactions"; $index+1; lk replace selection:K53:1)
				End if 
			Else 
				LISTBOX SELECT ROW:C912(*; "lb_interactions"; 0; lk remove from selection:K53:3)
			End if 
			
	End case 
	
Function loadInteractions()
	Form:C1466.lb_interactions:=Form:C1466.current_item.interactions.orderBy("number desc")
	
Function loadContacts()
	Form:C1466.lb_contacts:=Form:C1466.current_item.contacts()
	
Function loadJobs()
	Form:C1466.job:=Null:C1517
	Form:C1466.job_position:=0
	Form:C1466.lb_jobs:=New collection:C1472()
	Form:C1466.lb_jobs:=Form:C1466.current_item.customer.purchaseOrders.lineItems.job
	
	
	//mark:-draw and clic on popups
	//mark:Service type
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
	
Function display_interactionDetails()
	OBJECT SET VISIBLE:C603(*; "interaction@"; Form:C1466.current_interaction#Null:C1517)
	OBJECT SET VISIBLE:C603(*; "Inter_input@"; Form:C1466.current_interaction#Null:C1517)
	OBJECT SET VISIBLE:C603(*; "btnDatePickerCreate@"; Form:C1466.current_interaction#Null:C1517)
	
Function drawPup_Interaction($widgets : Collection)
	var $item : Object
	For each ($widget; $widgets)
		$widgetName:="pup_"+$widget
		
		If (Form:C1466.current_interaction#Null:C1517)
			$widgetCapitalized:=cs:C1710.sfw_string.me.stringCapitalize($widget)
			$defaultName:="Select "+$widget
			$uuid:="UUID_"+$widgetCapitalized
			$cacheAttr:="interaction"+$widgetCapitalized
			
			
			OBJECT SET VISIBLE:C603(*; $widgetName; True:C214)
			Case of 
				: ($widget="sales")
					$name:=Form:C1466.current_interaction.staff=Null:C1517 ? "Select "+$widget : Form:C1466.current_interaction.staff.fullName
					
					
				: ($widget="contact")
					$name:=Form:C1466.current_interaction.contact=Null:C1517 ? "Select "+$widget : Form:C1466.current_interaction.contact.fullName
					
				Else 
					$dc:="Interaction"+$widgetCapitalized
					If (Storage:C1525.cache=Null:C1517) || (Storage:C1525.cache[$cacheAttr]=Null:C1517)
						ds:C1482[$dc].cacheLoad()
					End if 
					$items:=Storage:C1525.cache[$cacheAttr].query("UUID == :1"; Form:C1466.current_interaction[$uuid])
					
					If ($items.length#0)
						$name:=$items[0].name
					Else 
						$name:=$defaultName
					End if 
			End case 
			
			
			Form:C1466.sfw.drawButtonPup($widgetName; $name; "sfw/image/skin/rainbow/icon/spacer-1x24.png"; ($items.length=0))
			
		Else 
			OBJECT SET VISIBLE:C603(*; $widgetName; False:C215)
		End if 
	End for each 
	
	
	
	
	
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
	
	//mark:Stage
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
	
	
	//mark:Priority
	
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
	
	//mark:Next Step
Function drawPup_nextStep()
	If (Form:C1466.current_item#Null:C1517)
		$leadNextStep:=Form:C1466.current_item.nextStep || New object:C1471()
		$parts:=New collection:C1472($leadNextStep.code; $leadNextStep.name)
		$leadNextStepName:=$parts.join(" - "; ck ignore null or empty:K85:5)
		If ($leadNextStepName="")
			$leadNextStepName:="Stage"
		End if 
		$color:=cs:C1710.sfw_htmlColor.me.getName($leadNextStep.color)
		$pathIcon:=($color#"") ? "sfw/colors/"+$color+"-circle.png" : "sfw/image/skin/rainbow/icon/spacer-1x24.png"
		Form:C1466.sfw.drawButtonPup("pup_nextStep"; $leadNextStepName; $pathIcon; ($leadNextStep=Null:C1517))
	End if 
	
	
Function pup_nextStep()
	var $eLeadNextStep : cs:C1710.LeadNextStepEntity
	
	
	If (Form:C1466.sfw.checkIsInModification())
		$menu:=Create menu:C408
		If (Storage:C1525.cache=Null:C1517) || (Storage:C1525.cache.leadNextStep=Null:C1517)
			ds:C1482.LeadNextStep.cacheLoad()
		End if 
		
		For each ($eLeadNextStep; Storage:C1525.cache.leadNextStep)
			APPEND MENU ITEM:C411($menu; $eLeadNextStep.code+" - "+$eLeadNextStep.name; *)
			SET MENU ITEM PARAMETER:C1004($menu; -1; $eLeadNextStep.UUID)
			If ($eLeadNextStep.nextStepID=Form:C1466.current_item.currentNextStep)
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
				//$eLeadNextStep:=ds.LeadNextStep.get($choose)
				Form:C1466.current_item.UUID_LeadNextStep:=$choose
		End case 
	End if 
	This:C1470.drawPup_nextStep()
	
	//mark:Customer
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
					Form:C1466.current_item.deal:=True:C214
					Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
					
					This:C1470._clearInfoAfterChangingCustomer()
					This:C1470.loadContacts()
				End if 
		End case 
	End if 
	This:C1470.drawPup_customer()
	
Function _clearInfoAfterChangingCustomer()
	Form:C1466.current_item.moreData:=New object:C1471()
	Form:C1466.current_item.UUID_Quote:=Null:C1517
	Form:C1466.current_item.UUID_PurchaseOrder:=Null:C1517
	Form:C1466.current_item.UUID_Job:=Null:C1517
	
	//mark:Staff
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
	
	//mark:quote
Function drawPup_quote()
	If (Form:C1466.current_item#Null:C1517)
		$quoteName:=Form:C1466.current_item.quote.code || "Select quote"
		Form:C1466.sfw.drawButtonPup("pup_quote"; $quoteName; "sfw/image/skin/rainbow/icon/spacer-1x24.png"; (Form:C1466.current_item.quote=Null:C1517))
	End if 
	
Function drawPup_method()
	If (Form:C1466.current_item#Null:C1517)
		$quoteName:=Form:C1466.current_item.quote.code || "Select quote"
		Form:C1466.sfw.drawButtonPup("pup_quote"; $quoteName; "sfw/image/skin/rainbow/icon/spacer-1x24.png"; (Form:C1466.current_item.quote=Null:C1517))
	End if 
	
	
Function selectQuote
	If (Form:C1466.sfw.checkIsInModification())
		Case of 
			: (FORM Event:C1606.code=On Getting Focus:K2:7) | (FORM Event:C1606.code=On Clicked:K2:4)
				
				OBJECT GET COORDINATES:C663(*; "pup_quote"; $l; $t; $r; $b)
				CONVERT COORDINATES:C1365($l; $b; XY Current form:K27:5; XY Main window:K27:8)
				$form:=New object:C1471()
				$form.lb_items:=Form:C1466.current_item.customer.contacts.quotes
				$form.current_item:=Form:C1466.current_item.customer.contacts.quotes
				$form.oo:=""
				
				$winRef:=Open form window:C675("selectQuote"; Pop up form window:K39:11; $l; $b+1)
				DIALOG:C40("selectQuote"; $form)
				CLOSE WINDOW:C154($winRef)
				
				If (ok=1)
					Form:C1466.current_item.UUID_Quote:=$form.item.UUID
					Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
				End if 
				
		End case 
	End if 
	This:C1470.drawPup_quote()
	
	
	//mark:PO
Function drawPup_po()
	var $poName : Text
	If (Form:C1466.current_item#Null:C1517)
		$poName:=String:C10(Form:C1466.current_item.purchaseOrder.poNumber) || "Select PO"
		Form:C1466.sfw.drawButtonPup("pup_po"; $poName; "sfw/image/skin/rainbow/icon/spacer-1x24.png"; (Form:C1466.current_item.purchaseOrder=Null:C1517))
	End if 
	
	
Function selectPO()
	If (Form:C1466.sfw.checkIsInModification())
		Case of 
			: (FORM Event:C1606.code=On Getting Focus:K2:7) | (FORM Event:C1606.code=On Clicked:K2:4)
				
				OBJECT GET COORDINATES:C663(*; "pup_po"; $l; $t; $r; $b)
				CONVERT COORDINATES:C1365($l; $b; XY Current form:K27:5; XY Main window:K27:8)
				
				$form:=New object:C1471()
				
				
				$form.lb_items:=Form:C1466.current_item.customer.purchaseOrders
				$form.current_item:=Form:C1466.current_item.customer.purchaseOrders
				$form.oo:=""
				
				$winRef:=Open form window:C675("selectPo"; Pop up form window:K39:11; $l; $b+1)
				DIALOG:C40("selectPo"; $form)
				CLOSE WINDOW:C154($winRef)
				
				If (ok=1)
					Form:C1466.current_item.UUID_PurchaseOrder:=$form.item.UUID
					Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
				End if 
				
		End case 
	End if 
	
	This:C1470.drawPup_po()
	
	//mark:Job
Function drawPup_job()
	var $jobName : Text
	If (Form:C1466.current_item#Null:C1517)
		$jobName:=String:C10(Form:C1466.current_item.job.jobNumber) || "Select job"
		Form:C1466.sfw.drawButtonPup("pup_job"; $jobName; "sfw/image/skin/rainbow/icon/spacer-1x24.png"; (Form:C1466.current_item.job=Null:C1517))
	End if 
	
	
Function selectJob()
	If (Form:C1466.sfw.checkIsInModification())
		Case of 
			: (FORM Event:C1606.code=On Getting Focus:K2:7) | (FORM Event:C1606.code=On Clicked:K2:4)
				
				OBJECT GET COORDINATES:C663(*; "pup_job"; $l; $t; $r; $b)
				CONVERT COORDINATES:C1365($l; $b; XY Current form:K27:5; XY Main window:K27:8)
				$form:=New object:C1471()
				
				If (Form:C1466.current_item.purchaseOrder#Null:C1517)
					$form.lb_items:=Form:C1466.current_item.purchaseOrder.lineItems
				Else 
					$form.lb_items:=Form:C1466.current_item.customer.purchaseOrders.lineItems
				End if 
				$form.lb_items:=ds:C1482.Job.query("UUID in :1"; $form.lb_items.distinct("UUID_Job"))
				$form.current_item:=$form.lb_items
				$form.oo:=""
				
				$winRef:=Open form window:C675("selectJob"; Pop up form window:K39:11; $l; $b+1)
				DIALOG:C40("selectJob"; $form)
				CLOSE WINDOW:C154($winRef)
				
				If (ok=1)
					Form:C1466.current_item.UUID_Job:=$form.item.UUID
					Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
				End if 
				
		End case 
	End if 
	This:C1470.drawPup_job()
	
	
	//Mark:-redraw
Function redrawAndSetVisible()
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($widthSubform; $heightSubform)
	$verticalMargin:=3
	
	Case of 
		: (FORM Get current page:C276(*)=1)
			OBJECT GET COORDINATES:C663(*; "Rec_note"; $g; $t; $r; $b)
			OBJECT SET COORDINATES:C1248(*; "Rec_note"; $g; $t; $r; $heightSubform)
			
			
			OBJECT GET COORDINATES:C663(*; "bar_history"; $g; $t; $r; $b)
			OBJECT GET COORDINATES:C663(*; "Rec_history"; $gh; $th; $rh; $bh)
			
			OBJECT SET COORDINATES:C1248(*; "bar_history"; $g; $t; $widthSubform; $b)
			OBJECT SET COORDINATES:C1248(*; "Rec_history"; $gh; $th; $widthSubform; $heightSubform)
			
		: (FORM Get current page:C276(*)=2)
			OBJECT SET ENABLED:C1123(*; "bActionInteractions"; Form:C1466.sfw.checkIsInModification())
			This:C1470.drawPup_Interaction(["method"; "outcome"; "trigger"; "contact"; "sales"; "type"])
			This:C1470.display_interactionDetails()
			
		: (FORM Get current page:C276(*)=3)
			
			OBJECT GET COORDINATES:C663(*; "Rect"; $g; $t; $r; $b)
			OBJECT SET COORDINATES:C1248(*; "Rect"; $g; $t; $r; $heightSubform)
			
			OBJECT GET COORDINATES:C663(*; "lb_jobs"; $gj; $tj; $rj; $bj)
			OBJECT SET COORDINATES:C1248(*; "lb_jobs"; $gj; $tj; $widthSubform; $heightSubform)
			
			
	End case 
	
	
	
	This:C1470.drawPup_serviceType()
	This:C1470.drawPup_stage()
	This:C1470.drawPup_priority()
	This:C1470.drawPup_customer()
	This:C1470.drawPup_staff()
	
	This:C1470.drawPup_nextStep()
	
	This:C1470.drawPup_quote()
	This:C1470.drawPup_po()
	This:C1470.drawPup_job()
	
	OBJECT SET ENABLED:C1123(*; "entryField_reasonWL"; (Form:C1466.current_item.currentStageID=6) || (Form:C1466.current_item.currentStageID=7))
	
	
	//mark:-BTN 
Function btnOpenCustomer()
	$entity:=Form:C1466.current_item.customer
	Form:C1466.sfw.openInANewWindow($entity; "customerService"; "customer")
	
Function btnOpenStaff()
	$entity:=Form:C1466.current_item.staff
	Form:C1466.sfw.openInANewWindow($entity; "qualityAssistance"; "staff")
	
Function btnCreateCustomer()
	Form:C1466.sfw.openCreateWindow("customerService"; "customer")
	
Function btnDatePickerCreate($object; $attribut; $stmp)
	$name:=OBJECT Get name:C1087
	OBJECT GET COORDINATES:C663(*; $name; $x1; $y1; $x2; $y2)
	CONVERT COORDINATES:C1365($x1; $y1; XY Current form:K27:5; XY Current window:K27:6)
	$test:=DatePicker Display Dialog($x1; $y1)
	If ($test#!00-00-00!)
		If (Bool:C1537($stmp))
			$object[$attribut]:=cs:C1710.sfw_stmp.me.build($test)
		Else 
			$object[$attribut]:=$test
		End if 
	End if 
	
	
Function btnDatePickerClose()
	If (Form:C1466.sfw.checkIsInModification())
		OBJECT GET COORDINATES:C663(*; "btnDatePickerClose"; $x1; $y1; $x2; $y2)
		$test:=DatePicker Display Dialog($x1+500; $y1+100)
		If ($test#!00-00-00!)
			Form:C1466.current_item.dateClose:=$test
		End if 
	End if 
	
	
Function btnActionContacts()
	//mark: better code 
	$refMenu:=Create menu:C408()
	
	APPEND MENU ITEM:C411($refMenu; "Add main contact"; *)
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--addMainContact")
	If (Not:C34(Form:C1466.sfw.checkIsInModification()))
		DISABLE MENU ITEM:C150($refMenu; -1)
	End if 
	
	APPEND MENU ITEM:C411($refMenu; "Add secondary contact"; *)
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--addSeconaryContact")
	If (Not:C34(Form:C1466.sfw.checkIsInModification()))
		DISABLE MENU ITEM:C150($refMenu; -1)
	End if 
	
	APPEND MENU ITEM:C411($refMenu; "Delete contact"; *)
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--deleteContact")
	If (Not:C34(Form:C1466.sfw.checkIsInModification())) || (Form:C1466.contact=Null:C1517)
		DISABLE MENU ITEM:C150($refMenu; -1)
	End if 
	
	$choice:=Dynamic pop up menu:C1006($refMenu)
	RELEASE MENU:C978($refMenu)
	
	
	
	Case of 
		: ($choice="")
			
		: ($choice="--addMainContact")
			$uuids:=New collection:C1472()
			If (Form:C1466.current_item.moreData#Null:C1517) && (Form:C1466.current_item.moreData.mainContact#Null:C1517)
				$uuids.push(Form:C1466.current_item.moreData.mainContact.UUID)
			End if 
			If (Form:C1466.current_item.moreData#Null:C1517) && (Form:C1466.current_item.moreData.secondaryContacts#Null:C1517)
				$uuids:=$uuids.concat(Form:C1466.current_item.moreData.secondaryContacts)
			End if 
			
			$form:=New object:C1471()
			$form.lb_contacts:=ds:C1482.Contact.query("customer.leads.UUID == :1 and not(UUID in :2)"; Form:C1466.current_item.UUID; $uuids)
			$ref:=Open form window:C675("Lead_chooseMainContact"; Sheet form window:K39:12)
			DIALOG:C40("Lead_chooseMainContact"; $form)
			CLOSE WINDOW:C154($ref)
			
			If (ok=1)
				If (Form:C1466.current_item.moreData=Null:C1517)
					Form:C1466.current_item.moreData:=New object:C1471()
				End if 
				
				If (Form:C1466.current_item.moreData.mainContact=Null:C1517)
					Form:C1466.current_item.moreData.mainContact:=New object:C1471()
				End if 
				
				Form:C1466.current_item.moreData.mainContact:={UUID: $form.current_contact.UUID}
				This:C1470.loadContacts()
				cs:C1710.panel_lead.me._activate_save_cancel_button()
			End if 
			
		: ($choice="--addSeconaryContact")
			$uuids:=New collection:C1472()
			If (Form:C1466.current_item.moreData#Null:C1517) && (Form:C1466.current_item.moreData.mainContact#Null:C1517)
				$uuids.push(Form:C1466.current_item.moreData.mainContact.UUID)
			End if 
			If (Form:C1466.current_item.moreData#Null:C1517) && (Form:C1466.current_item.moreData.secondaryContacts#Null:C1517)
				$uuids:=$uuids.concat(Form:C1466.current_item.moreData.secondaryContacts)
			End if 
			
			$form:=New object:C1471()
			$form.lb_contacts:=ds:C1482.Contact.query("customer.leads.UUID == :1 and not(UUID in :2)"; Form:C1466.current_item.UUID; $uuids).toCollection()
			For each ($contact; $form.lb_contacts)
				$contact.selected:=False:C215
			End for each 
			
			$ref:=Open form window:C675("Lead_chooseSecondaryContacts"; Sheet form window:K39:12)
			DIALOG:C40("Lead_chooseSecondaryContacts"; $form)
			CLOSE WINDOW:C154($ref)
			
			If (ok=1)
				If (Form:C1466.current_item.moreData=Null:C1517)
					Form:C1466.current_item.moreData:=New object:C1471()
				End if 
				
				If (Form:C1466.current_item.moreData.secondaryContacts=Null:C1517)
					Form:C1466.current_item.moreData.secondaryContacts:=New collection:C1472()
				End if 
				
				For each ($contact; $form.lb_contacts)
					If ($contact.selected)
						Form:C1466.current_item.moreData.secondaryContacts.push($contact.UUID)
					End if 
				End for each 
				
				This:C1470.loadContacts()
				cs:C1710.panel_lead.me._activate_save_cancel_button()
			End if 
			
			
		: ($choice="--deleteContact")
			
			If (Form:C1466.contact.type="Main")
				Form:C1466.current_item.moreData.mainContact:=Null:C1517
			Else 
				$index:=Form:C1466.current_item.moreData.secondaryContacts.indexOf(Form:C1466.contact.UUID)
				If ($indexOf#-1)
					Form:C1466.current_item.moreData.secondaryContacts.remove($index)
				End if 
			End if 
			This:C1470.loadContacts()
			cs:C1710.panel_lead.me._activate_save_cancel_button()
	End case 
	
	
Function _activate_save_cancel_button()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	
	
	
Function bActionInteractions()
	var $interaction : cs:C1710.InteractionEntity
	var $status : cs:C1710.InteractionTypeEntity
	
	If (Storage:C1525.cache=Null:C1517) || (Storage:C1525.cache.interactionType=Null:C1517)
		ds:C1482.InteractionType.cacheLoad()
	End if 
	
	$items:=Storage:C1525.cache.interactionType.query("code == :1"; "SCHEDULED")
	If ($items.length#0)
		$scheduledUUID:=$items[0].UUID
	Else 
		$scheduledUUID:=""
	End if 
	
	$mainMenu:=Create menu:C408
	
	APPEND MENU ITEM:C411($mainMenu; "Cancel interaction"; *)
	SET MENU ITEM PARAMETER:C1004($mainMenu; -1; "--cancel")
	If (Form:C1466.current_interaction=Null:C1517) || (Form:C1466.current_interaction#Null:C1517 && Form:C1466.current_interaction.UUID_Type#$scheduledUUID)
		DISABLE MENU ITEM:C150($mainMenu; -1)
	End if 
	
	APPEND MENU ITEM:C411($mainMenu; "Complete follow up"; *)
	SET MENU ITEM PARAMETER:C1004($mainMenu; -1; "--complete")
	If (Form:C1466.current_interaction=Null:C1517)
		DISABLE MENU ITEM:C150($mainMenu; -1)
	End if 
	
	APPEND MENU ITEM:C411($mainMenu; "Schedule follow up"; *)
	SET MENU ITEM PARAMETER:C1004($mainMenu; -1; "--schedule")
	If (Form:C1466.current_interaction=Null:C1517)
		DISABLE MENU ITEM:C150($mainMenu; -1)
	End if 
	
	APPEND MENU ITEM:C411($mainMenu; "Log interaction"; *)
	SET MENU ITEM PARAMETER:C1004($mainMenu; -1; "--log")
	
	
	$choice:=Dynamic pop up menu:C1006($mainMenu)
	RELEASE MENU:C978($mainMenu)
	
	
	Case of 
		: ($choice="")
		: ($choice="--log")
			$form:=New object:C1471
			$form.creationDate:=Current date:C33()
			$form.current_item:=Form:C1466.current_item
			$form.number:=ds:C1482.Interaction.sequence
			$form.nextFollowUp:=False:C215
			$form.followUPDate:=Add to date:C393(Current date:C33; 0; 0; 1)
			
			$ref:=Open form window:C675("Lead_AddInteraction"; Sheet form window:K39:12)
			DIALOG:C40("Lead_AddInteraction"; $form)
			CLOSE WINDOW:C154($ref)
			
			If (ok=1)
				$form.stmpCreation:=cs:C1710.sfw_stmp.me.build($form.creationDate)
				$form.stmpFollowUp:=cs:C1710.sfw_stmp.me.build($form.followUPDate)
				OB REMOVE:C1226($form; "creationDate")
				OB REMOVE:C1226($form; "followUPDate")
				OB REMOVE:C1226($form; "current_item")
				
				$interaction:=ds:C1482.Interaction.new()
				$interaction.fromObject($form)
				$interaction.UUID_Lead:=Form:C1466.current_item.UUID
				$status:=ds:C1482.InteractionType.query("code == :1"; "COMPLETED").first()
				If ($status#Null:C1517)
					$interaction.UUID_Type:=$status.UUID
				End if 
				$result:=$interaction.save()
				Form:C1466.lb_interactions:=Form:C1466.lb_interactions.add($interaction).orderBy("number desc")
				
				
				If ($form.nextFollowUp)
					$scheduledInteraction:=ds:C1482.Interaction.new()
					$scheduledInteraction.fromObject($form)
					$scheduledInteraction.number:=ds:C1482.Interaction.sequence
					$scheduledInteraction.UUID_Lead:=Form:C1466.current_item.UUID
					$scheduledInteraction.notes:=""
					$scheduledInteraction.UUID_Lead:=Form:C1466.current_item.UUID
					$status:=ds:C1482.InteractionType.query("code == :1"; "SCHEDULED").first()
					If ($status#Null:C1517)
						$scheduledInteraction.UUID_Type:=$status.UUID
					End if 
					$scheduledInteraction.UUID_Interaction:=$interaction.UUID
					
					$result:=$scheduledInteraction.save()
					Form:C1466.lb_interactions:=Form:C1466.lb_interactions.add($scheduledInteraction).orderBy("number desc")
					
				End if 
				
				cs:C1710.panel_lead.me._activate_save_cancel_button()
			End if 
			
		: ($choice="--cancel")
			$items:=Storage:C1525.cache.interactionType.query("code == :1"; "CANCELED")
			If ($items.length#0)
				$canceledUUID:=$items[0].UUID
			Else 
				$canceledUUID:=""
			End if 
			Form:C1466.current_interaction.UUID_Type:=$canceledUUID
			Form:C1466.current_interaction.save()
			cs:C1710.panel_lead.me._activate_save_cancel_button()
	End case 
	
Function pup_interaction($type; $currentUUID)->$uuid : Text
	If (Form:C1466.sfw.checkIsInModification=Null:C1517) || (Form:C1466.sfw.checkIsInModification#Null:C1517 && Form:C1466.sfw.checkIsInModification())
		Case of 
			: ($type="method")
				$dc:="InteractionMethod"
				$cacheAttribut:="interactionMethod"
				$widgetName:="pup_method"
				
			: ($type="outcome")
				$dc:="InteractionOutcome"
				$cacheAttribut:="interactionOutcome"
				$widgetName:="pup_outcome"
				
			: ($type="trigger")
				$dc:="InteractionTrigger"
				$cacheAttribut:="interactionTrigger"
				$widgetName:="pup_trigger"
				
			: ($type="type")
				$dc:="InteractionType"
				$cacheAttribut:="interactionType"
				$widgetName:="pup_type"
				
		End case 
		
		
		$menu:=Create menu:C408
		If (Storage:C1525.cache=Null:C1517) || (Storage:C1525.cache[$cacheAttribut]=Null:C1517)
			ds:C1482[$dc].cacheLoad()
		End if 
		
		For each ($eItem; Storage:C1525.cache[$cacheAttribut])
			APPEND MENU ITEM:C411($menu; $eItem.name; *)
			SET MENU ITEM PARAMETER:C1004($menu; -1; $eItem.UUID)
			If ($eItem.UUID=$currentUUID)
				SET MENU ITEM MARK:C208($menu; -1; Char:C90(18))
				If (Is Windows:C1573)
					SET MENU ITEM STYLE:C425($menu; -1; Bold:K14:2)
				End if 
			End if 
		End for each 
		$uuid:=Dynamic pop up menu:C1006($menu)
		RELEASE MENU:C978($menu)
		
		Case of 
			: ($uuid#"")
				$item:=Storage:C1525.cache[$cacheAttribut].query("UUID == :1"; $uuid)[0]
				OBJECT SET TITLE:C194(*; $widgetName; $item.name)
		End case 
	End if 