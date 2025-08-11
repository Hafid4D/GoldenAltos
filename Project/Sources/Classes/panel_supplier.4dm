singleton Class constructor
	//It's a singleton class
	
Function _activate_save_cancel_button()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	
Function formMethod()
	//This function manages the main logic for updating and refreshing the form
	Form:C1466.sfw.panelFormMethod()  //The main body of the form method and basic sfw functionalities 
	If (Form:C1466.sfw.updateOfPanelNeeded())  //The current item is changed or reloaded, so it's necessary ti refresh 
		Form:C1466.mainAddress:=1
		Form:C1466.remitAddress:=0
		This:C1470.LoadSecondaryContact()
		This:C1470.LoadPrimaryContact()
		This:C1470.LoadAllTabs()
	End if 
	
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())  //a page is displayed so it's time to load the sources of data to display
		Case of 
			: (FORM Get current page:C276(*)=1)
				This:C1470.LoadSecondaryContact()
				This:C1470.LoadPrimaryContact()
				
				
			: (FORM Get current page:C276(*)=2)
				This:C1470.loadDocuments()
				OBJECT SET ENTERABLE:C238(*; "lb_documents"; False:C215)
				
				
		End case 
	End if 
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())  //It's time to resize the object or set visible
		This:C1470.redrawAndSetVisible()
	End if 
	
	
Function redrawAndSetVisible()
	//Adjusts the layout and visibility of form elements based on the current page and modification state
	This:C1470.contactDetails()
	This:C1470.drawPup_enteredBy()
	This:C1470.drawPup_division()
	
	OBJECT SET VISIBLE:C603(*; "PopupDa@"; Form:C1466.sfw.checkIsInModification())
	
	Use (Form:C1466.sfw.entry.panel.pages)
		Form:C1466.sfw.entry.panel.pages[1].label:="Documents ("+String:C10(Form:C1466.lb_documents.length)+")"
	End use 
	
	Form:C1466.sfw.drawHTab()
	
	
Function contactDetails()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.subFormAddress:=New object:C1471()
		Form:C1466.subFormAddress.address:=Form:C1466.current_item.rebuildAddress()
		Form:C1466.subFormAddress.situation:=Form:C1466.situation
	End if 
	
	
Function LoadPrimaryContact()
	
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.lb_primaryContact:=New collection:C1472()
		If (ds:C1482.Contact.query("UUID_Company = :1"; Form:C1466.current_item.UUID).query("title=:1"; "Primary").first()#Null:C1517)
			
			Form:C1466.lb_primaryContact:=Form:C1466.current_item.rebuidComunications("Primary")
			
		End if 
	End if 
	
	
Function LoadSecondaryContact()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.lb_secondaryContact:=New collection:C1472()
		
		If (ds:C1482.Contact.query("UUID_Company = :1"; Form:C1466.current_item.UUID).query("title=:1"; "Secondary").first()#Null:C1517)
			
			Form:C1466.lb_secondaryContact:=Form:C1466.current_item.rebuidComunications("Secondary")
			
		End if 
	End if 
	
	
Function bActionPrimaryContact()
	$refMenu:=Create menu:C408
	APPEND MENU ITEM:C411($refMenu; "Open in new window"; *)
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "openInWindow")
	If (ds:C1482.Contact.query("UUID_Company = :1"; Form:C1466.current_item.UUID).query("title=:1"; "Primary").first()=Null:C1517)
		DISABLE MENU ITEM:C150($refMenu; -1)
	End if 
	
	$choice:=Dynamic pop up menu:C1006($refMenu)
	RELEASE MENU:C978($refMenu)
	Case of 
		: ($choice="openInWindow")
			Form:C1466.sfw.openInANewWindow(ds:C1482.Contact.query("UUID_Company = :1"; Form:C1466.current_item.UUID).query("title=:1"; "Primary").first(); "customerService"; "contact")
	End case 
	This:C1470.LoadPrimaryContact()
	
	
Function bActionSecondaryContact()
	$refMenu:=Create menu:C408
	APPEND MENU ITEM:C411($refMenu; "Open in new window"; *)
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "openInWindow")
	If (ds:C1482.Contact.query("UUID_Company = :1"; Form:C1466.current_item.UUID).query("title=:1"; "Secondary").first()=Null:C1517)
		DISABLE MENU ITEM:C150($refMenu; -1)
	End if 
	
	$choice:=Dynamic pop up menu:C1006($refMenu)
	RELEASE MENU:C978($refMenu)
	Case of 
		: ($choice="openInWindow")
			Form:C1466.sfw.openInANewWindow(ds:C1482.Contact.query("UUID_Company = :1"; Form:C1466.current_item.UUID).query("title=:1"; "Secondary").first(); "customerService"; "contact")
	End case 
	This:C1470.LoadSecondaryContact()
	
	
Function drawPup_enteredBy()
	If (Form:C1466.current_item#Null:C1517)
		$operator:=ds:C1482.Staff.query("code= :1"; Form:C1466.current_item.enteredBy).first() || New object:C1471()
		$operatorCode:=$operator.code
		If ($operatorCode=Null:C1517)
			$operatorCode:=""
		End if 
		$color:=""
		$pathIcon:=""
		Form:C1466.sfw.drawButtonPup("pup_enteredBy"; $operatorCode; $pathIcon; ($operator=Null:C1517))
		
	End if 
	
Function pup_enteredBy()
	//Create pop up menu
	
	If (Form:C1466.sfw.checkIsInModification())
		
		OBJECT GET COORDINATES:C663(*; "pup_enteredBy"; $l; $t; $r; $b)
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
			Form:C1466.current_item.enteredBy:=$form.item.code
			cs:C1710.panel_supplier.me._activate_save_cancel_button()
		End if 
	End if 
	
	This:C1470.drawPup_enteredBy()
	
	
Function drawPup_division()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.current_item.drowPup("Division"; "divisionID"; "divisionID"; "pup_division")
	End if 
	
	
Function pup_division()
	//Create pop up menu
	Form:C1466.current_item.pup("divisions"; "Division"; "divisionID"; "divisionID")
	This:C1470.drawPup_division()
	
	
Function btnOpenSupplier()
	
	$es:=ds:C1482.Supplier.query("UUID = :1"; Form:C1466.current_item.UUID_Supplier)
	
	If ($es.length>0)
		Form:C1466.sfw.openInANewWindow($es[0]; "qualityAssurance"; "AVL")
	End if 
	
	
	
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
				Form:C1466.selectedDocument:=$form.details
				//Form.current_item.attachedDocuments.documents.push($form.details)
				cs:C1710.panel_supplier.me._activate_save_cancel_button()
			End if 
			
			
		: ($choice="--modify")
			
			$form:=New object:C1471("details"; Form:C1466.current_item.attachedDocuments.documents[Form:C1466.selectedDocumentPos-1])
			
			$form.operation:="modify"
			
			$winRef:=Open form window:C675("_ga_document"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4)
			DIALOG:C40("_ga_document"; $form)
			If (OK=1)
				Form:C1466.selectedDocument:=$form.details
				//Form.current_item.attachedDocuments.documents.push($form.details)
				cs:C1710.panel_supplier.me._activate_save_cancel_button()
			End if 
			
		: ($choice="--delete")
			
			$ok:=cs:C1710.sfw_dialog.me.confirm("Do you really want to delete this document? "; "Delete"; "CANCEL")
			If ($ok)
				
				Form:C1466.lb_documents.remove(Form:C1466.selectedDocumentPos-1)
				//Form.current_item.attachedDocuments.documents.remove(Form.selectedDocumentPos-1)
				cs:C1710.panel_supplier.me._activate_save_cancel_button()
				
			End if 
			
			//This.loadDocuments()
			
	End case 
	
	
	
Function loadDocuments()
	
	If (Form:C1466.current_item#Null:C1517)
		
		Form:C1466.lb_documents:=Form:C1466.current_item.attachedDocuments.documents.map(Formula:C1597(_ga_getDateTime))
		
	End if 
	
	
Function LoadAllTabs()
	
	This:C1470.loadDocuments()