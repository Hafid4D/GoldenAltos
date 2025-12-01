singleton Class constructor
	//It's a singleton class
	
Function _activate_save_cancel_button()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	
Function formMethod()
	//This function manages the main logic for updating and refreshing the form
	Form:C1466.sfw.panelFormMethod()  //The main body of the form method and basic sfw functionalities 
	If (Form:C1466.sfw.updateOfPanelNeeded())
		
		This:C1470.loadAllTabs()
		Form:C1466.current_item.poBasedCharges:=Form:C1466.lb_poLines.sum("total")-Form:C1466.lb_poLines.sum("saleTax")
		
	End if 
	This:C1470.drawPup_job()
	This:C1470.drawPup_status()
	
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())  //a page is displayed so it's time to load the sources of data to display
		Case of 
			: (FORM Get current page:C276(*)=1)
				
				//This.loadPoLines()
			: (FORM Get current page:C276(*)=2)
				This:C1470.loadLots()
				//This.loadPoLines()
				
				
			: (FORM Get current page:C276(*)=3)
				This:C1470.loadPoLines()
				
			: (FORM Get current page:C276(*)=4)
				
				
		End case 
	End if 
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())  //It's time to resize the object or set visible
		This:C1470.redrawAndSetVisible()
	End if 
	
	
Function redrawAndSetVisible()
	
	//Adjusts the layout and visibility of form elements based on the current page and modification state
	This:C1470.drawPup_job()
	This:C1470.drawPup_status()
	
	Use (Form:C1466.sfw.entry.panel.pages)
		Form:C1466.sfw.entry.panel.pages[1].label:="Lot Qty Amt Based ("+String:C10(Form:C1466.lb_lots.length)+")"
		Form:C1466.sfw.entry.panel.pages[2].label:="PO Items Based ("+String:C10(Form:C1466.lb_poLines.length)+")"
	End use 
	
	OBJECT SET ENTERABLE:C238(*; "entryField_type"; False:C215)
	OBJECT SET ENTERABLE:C238(*; "entryField_job@"; False:C215)
	OBJECT SET VISIBLE:C603(*; "btnDatePickerInvoiceDate"; Form:C1466.sfw.checkIsInModification())
	Form:C1466.sfw.drawHTab()
	
	
	//mark:Job
Function drawPup_job()
	var $jobName : Text
	If (Form:C1466.current_item#Null:C1517)
		$jobName:=String:C10(Form:C1466.current_item.job.jobNumber) || "Select job"
		Form:C1466.sfw.drawButtonPup("pup_job"; $jobName; "sfw/image/skin/rainbow/icon/spacer-1x24.png"; (Form:C1466.current_item.job=Null:C1517))
	End if 
	
Function selectJob()
	
	If (Form:C1466.sfw.checkIsInModification())
		
		$selector:=cs:C1710.sfw_definitionSelector.new("selectorJob"; "jobs")
		$selector.setTitle("Choose a Job")
		$selector.setCurrentItem(Form:C1466.current_item.job)
		$selector.setOptions("noCutLink")
		$selector.openSelector()
		
		Case of 
			: ($selector.isSelected())
				$itemSeleted:=$selector.getCurrentItem()
				
				Case of 
					: ($itemSeleted=Null:C1517)
					: (cs:C1710.sfw_string.me.isAnEmptyUUID($itemSeleted.UUID)=False:C215)
						Form:C1466.current_item.UUID_Job:=$itemSeleted.UUID
						If (cs:C1710.sfw_string.me.isAnEmptyUUID(Form:C1466.current_item.UUID_Job)=True:C214)
							Form:C1466.current_item.UUID_Job:=16*"00"
						End if 
				End case 
				This:C1470.drawPup_job()
				
			: ($selector.needCreation())
				$selector.createANewEntity("cs.panel_jobInvoice.me.callbackAfterCreatioJob($1)")
				This:C1470._clearInfoAfterChangingJob()
				
		End case 
	End if 
	
Function callbackAfterCreatioJob($key : Text)
	Form:C1466.current_item.UUID_Job:=$key
	If (cs:C1710.sfw_string.me.isAnEmptyUUID(Form:C1466.current_item.UUID_Job)=True:C214)
		Form:C1466.current_item.UUID_Job:=16*"00"
	End if 
	EXECUTE METHOD IN SUBFORM:C1085("detail_panel"; Formula:C1597(cs:C1710.panel_lead.me.drawPup_job()); *)
	
Function _clearInfoAfterChangingJob()
	Form:C1466.current_item.UUID_Job:=Null:C1517
	
Function btnOpenJob()
	$entity:=Form:C1466.current_item.job
	If ($entity#Null:C1517)
		Form:C1466.sfw.openInANewWindow($entity; "customerService"; "jobs")
	End if 
	
Function btnOpenPurchaseOrder()
	$es:=ds:C1482.PurchaseOrder.query("poNumber =:1"; Form:C1466.current_item.job.poNumber)
	If ($es.length>0)
		Form:C1466.sfw.openInANewWindow($es[0]; "customerService"; "purchaseOrders")
	End if 
	
Function btnOpenCustomer()
	$es:=ds:C1482.Customer.query("name =:1"; Form:C1466.current_item.job.customer)
	If ($es.length>0)
		Form:C1466.sfw.openInANewWindow($es[0]; "customerService"; "customer")
	End if 
	
Function btnDatePicker($object; $attribut)
	
	If (Form:C1466.sfw.checkIsInModification())
		
		$form:=New object:C1471
		$form.date:=$object[$attribut]
		
		OBJECT GET COORDINATES:C663(Self:C308->; $left; $top; $rigth; $bottom)
		CONVERT COORDINATES:C1365($left; $bottom; XY Current form:K27:5; XY Main window:K27:8)
		Open window:C153($left; $bottom; $left+285; $bottom+210; Movable dialog box:K34:7; "calendar")
		DIALOG:C40("_ga_calendar"; $form)
		
		If (OK=1)
			
			$object[$attribut]:=$form.calendar.display.date
			This:C1470._activate_save_cancel_button()
			
		End if 
	End if 
	
	
Function drawPup_status()
	If (Form:C1466.current_item#Null:C1517)
		$job:=Form:C1466.current_item
		
		$invoiceStatus:=Form:C1466.current_item.status
		
		$color:=""
		$pathIcon:=($color#"") ? "sfw/colors/"+$color+"-circle.png" : "sfw/image/skin/rainbow/icon/spacer-1x24.png"
		Form:C1466.sfw.drawButtonPup("pup_status"; $invoiceStatus; $pathIcon; ($job=Null:C1517))
	End if 
	
	
Function pup_status()
	//Create pop up menu
	If (Form:C1466.sfw.checkIsInModification())
		$menu:=Create menu:C408
		$invoiceStatus:=New collection:C1472(New object:C1471("name"; "paid"))  //; New object("name"; "closed"))  
		For each ($eType; $invoiceStatus)
			APPEND MENU ITEM:C411($menu; $eType.name; *)
			SET MENU ITEM PARAMETER:C1004($menu; -1; $eType.name)
			If ($eType.name=Form:C1466.current_item.staus)
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
				Form:C1466.current_item.status:=$choose
				This:C1470._activate_save_cancel_button()
		End case 
		
	End if 
	This:C1470.drawPup_status()
	
	
Function bActionLot()
	
	$refMenu:=Create menu:C408
	APPEND MENU ITEM:C411($refMenu; "Open in new window"; *)
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "openInWindow")
	
	If (Form:C1466.selectedLot=Null:C1517) | (Undefined:C82(Form:C1466.selectedLot))
		
		DISABLE MENU ITEM:C150($refMenu; -1)
		
	End if 
	
	$choice:=Dynamic pop up menu:C1006($refMenu)
	RELEASE MENU:C978($refMenu)
	
	Case of 
			
		: ($choice="openInWindow")
			
			Form:C1466.sfw.openInANewWindow(Form:C1466.current_item.job.lots.query("UUID=:1"; Form:C1466.selectedLot.UUID).first(); "customerService"; "lots")
			
	End case 
	
	
Function loadLots()
	
	If (Form:C1466.current_item#Null:C1517)
		
		Form:C1466.lb_lots:=ds:C1482.Lot.query("UUID_Job =:1"; Form:C1466.current_item.job.UUID)
		
	End if 
	
Function loadPoLines()
	
	If (Form:C1466.current_item#Null:C1517)
		
		Form:C1466.lb_poLines:=ds:C1482.PurchaseOrderLine.query("UUID_Job =:1"; Form:C1466.current_item.job.UUID)  //Form.current_item.job.purchaseOrderLines
		
	End if 
	
Function loadAllTabs()
	This:C1470.loadLots()
	This:C1470.loadPoLines()
	
	
Function bActionAttachPoLine()
	//Manages actions: add, or remove, using dynamic menus and modification checks
	If (Form:C1466.sfw.checkIsInModification())
		$refMenu:=Create menu:C408
		APPEND MENU ITEM:C411($refMenu; "Attach a PO Line")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--create")
		APPEND MENU ITEM:C411($refMenu; "-")
		APPEND MENU ITEM:C411($refMenu; "(Delete")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--delete")
		
		$choose:=Dynamic pop up menu:C1006($refMenu)
		
		Case of 
			: ($choose="--create")
				$form:=New object:C1471("job"; Form:C1466.current_item.job)
				
				$winRef:=Open form window:C675("createPoLine_jobInvoice"; Controller form window:K39:17; Horizontally centered:K39:1; Vertically centered:K39:4)
				DIALOG:C40("createPoLine_jobInvoice"; $form)
				CLOSE WINDOW:C154($winRef)
				
				If (OK=1)
					This:C1470.loadPoLines()
				End if 
				
			: ($choose="--delete")
				
		End case 
	Else 
		$refMenu:=Create menu:C408
		APPEND MENU ITEM:C411($refMenu; "(Attach a PO Line")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--create")
		APPEND MENU ITEM:C411($refMenu; "-")
		APPEND MENU ITEM:C411($refMenu; "(Delete")
		SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--delete")
		
		$choose:=Dynamic pop up menu:C1006($refMenu)
		
	End if 
	