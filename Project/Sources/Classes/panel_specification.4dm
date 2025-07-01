singleton Class constructor
	//It's a singleton class
	
Function _activate_save_cancel_button()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	
Function formMethod()
	//This function manages the main logic for updating and refreshing the form
	Form:C1466.sfw.panelFormMethod()  //The main body of the form method and basic sfw functionalities 
	If (Form:C1466.sfw.updateOfPanelNeeded())  //The current item is changed or reloaded, so it's necessary ti refresh 
		
		This:C1470.LoadAllTabs()
	End if 
	
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())  //a page is displayed so it's time to load the sources of data to display
		Case of 
			: (FORM Get current page:C276(*)=1)
				
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
	This:C1470.drawPup_category()
	This:C1470.drawPup_departement()
	
	OBJECT SET VISIBLE:C603(*; "PopupDa@"; Form:C1466.sfw.checkIsInModification())
	OBJECT SET VISIBLE:C603(*; "bSpecView"; Not:C34(Form:C1466.sfw.checkIsInModification()))
	OBJECT SET VISIBLE:C603(*; "bSpecEdit"; Form:C1466.sfw.checkIsInModification())
	
	Use (Form:C1466.sfw.entry.panel.pages)
		
		Form:C1466.sfw.entry.panel.pages[1].label:="Documents ("+String:C10(Form:C1466.lb_documents.length)+")"
		
	End use 
	Form:C1466.sfw.drawHTab()
	
Function drawPup_XXX()
	//This function updates the dropdown by displaying the name
	Form:C1466.sfw.drawButtonPup("pup_xxx"; $xxxName; "xxxx.png"; (Form:C1466.current_item.xxxx=Null:C1517))
	
	
Function pup_XXX()
	//Create pop up menu
	
	
Function LoadAllTabs()
	
	This:C1470.loadDocuments()
	
	
Function loadDocuments()
	
	If (Form:C1466.current_item#Null:C1517)
		
		Form:C1466.lb_documents:=Form:C1466.current_item.documents.documentsCollection.map(Formula:C1597(_ga_getDateTime))
		
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
				Form:C1466.current_item.documents.documentsCollection.push($form.details)
				cs:C1710.panel_specification.me._activate_save_cancel_button()
			End if 
			
			
		: ($choice="--modify")
			
			$form:=New object:C1471("details"; Form:C1466.current_item.documents.documentsCollection[Form:C1466.selectedDocumentPos-1])
			
			$form.operation:="modify"
			
			$winRef:=Open form window:C675("_ga_document"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4)
			DIALOG:C40("_ga_document"; $form)
			
		: ($choice="--delete")
			
			$ok:=cs:C1710.sfw_dialog.me.confirm("Do you really want to delete this document? "; "Delete"; "CANCEL")
			If ($ok)
				
				Form:C1466.current_item.documents.documentsCollection.remove(Form:C1466.selectedDocumentPos-1)
				
				
			End if 
			
			This:C1470.loadDocuments()
			
	End case 
	
	
Function drawPup_category()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.current_item.drowPup("SpecCategory"; "categoryID"; "categoryID"; "pup_category")
	End if 
	
	
Function pup_category()
	//Create pop up menu
	Form:C1466.current_item.pup("specCategories"; "SpecCategory"; "categoryID"; "categoryID")
	This:C1470.drawPup_category()
	
	
Function drawPup_departement()
	If (Form:C1466.current_item#Null:C1517)
		Form:C1466.current_item.drowPup("SpecControllingDept"; "departmentID"; "controllingDeptID"; "pup_departement")
	End if 
	
	
Function pup_departement()
	Form:C1466.current_item.publishedDocumentBlob  //Create pop up menu
	Form:C1466.current_item.pup("specDepartements"; "SpecControllingDept"; "departmentID"; "controllingDeptID")
	This:C1470.drawPup_departement()
	
	
Function bSpecEdit()
	
	$details:=New object:C1471("blob"; Form:C1466.current_item.publishedDocumentBlob; "docPath"; ""; "docName"; Form:C1466.current_item.spec)
	
	$form:=New object:C1471("details"; $details)
	$form.operation:="modify"
	
	$winRef:=Open form window:C675("_ga_uploadDocument"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4)
	DIALOG:C40("_ga_uploadDocument"; $form)
	
	If (OK=1)
		Form:C1466.current_item.publishedDocumentBlob:=$form.details.blob
		cs:C1710.panel_specification.me._activate_save_cancel_button()
	End if 
	
	
	