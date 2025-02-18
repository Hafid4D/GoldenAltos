Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("templateProject"; ["administration"; "projectManagment"]; "Template projects")
	$entry.setDataclass("TemplateProject")
	$entry.setDisplayOrder(-6000)
	$entry.setIcon("image/entry/template-50x50.png")
	$entry.setSearchboxField("code")
	$entry.setSearchboxField("name")
	$entry.setPanel("panel_templateProject"; 1)
	$entry.setPanelPage(1; "tasks-32x32.png"; "tasks")
	$entry.setPanelPage(2; "keydate-32x32.png"; "tasks")
	
	$entry.setLBItemsColumn("code"; "Code"; "width:100")
	$entry.setLBItemsColumn("name"; "Name"; "width:200")
	$entry.setLBItemsColumn("serviceType.colorPicture"; ""; "type:picture"; "width:5"; "orderByFormula:this.serviceType.name")
	$entry.setLBItemsColumn("serviceType.code"; "Service"; "width:50")
	$entry.setLBItemsOrderBy("code")
	
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:template project"; "unitN:template projects")
	
	$entry.setValidationRule("code"; "entryField_code"; "mandatory"; "trimSpace"; "uppercase")
	$entry.setValidationRule("name"; "entryField_name"; "mandatory"; "trimSpace"; "capitalize")
	$entry.setValidationRule("UUID_ServiceType"; ""; "UUIDNotNull")
	
	$entry.setAddable()
	$entry.setSpecificAddMode("addFromProject"; "Creation from existing project..."; "kairos/image/icon/createFromTemplate-24x24.png"; "createFromProject")
	// prévoir un autre calcul juste après pour aller effacter dans les tasks et les lots, les affectations
	
	$entry.enableTransaction()
	
	$entry.setLinkedReferenceRecordsDataclasses("phases"; "phases.lots"; "phases.lots.tasks"; "phases.lots.tasks.taskType")
	
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	$entry.setItemListPreconfigAction("copyItemsListToPasteboard")
	
	$entry.activateComment()
	$entry.activateEvent("TemplateProjectEvent"; "UUID_TemplateProject")
	$entry.setAttributesToTrackInModificationEvent("code"; "name")
	$entry.setEventOptions("dontCreateModifyEventIfNoTrackingAttribute")
	
local Function closeBoxMainForm()
	
	
	
local Function createFromProject()->$ok : Boolean
	
	$form:=New object:C1471
	$form.lb_projects:=ds:C1482.Project.all().orderBy("customer.name, name")
	$form.project:=Null:C1517
	If (Is Windows:C1573)
		$refWindow:=Open form window:C675("selector_project"; Modal form dialog box:K39:7)
	Else 
		$refWindow:=Open form window:C675("selector_project"; Sheet form window:K39:12)
	End if 
	DIALOG:C40("selector_project"; $form)
	CLOSE WINDOW:C154($refWindow)
	If (ok=1)
		Form:C1466.sfw.cancelAndRestartTransaction()
		LISTBOX SELECT ROW:C912(*; "lb_items"; 0; lk remove from selection:K53:3)
		
		Form:C1466.current_item:=ds:C1482.TemplateProject.new()
		Form:C1466.current_item.UUID:=Generate UUID:C1066
		Form:C1466.current_item.code:=$form.project.code
		Form:C1466.current_item.name:=$form.project.name
		Form:C1466.current_item.UUID_ServiceType:=$form.project.UUID_ServiceType
		
		ds:C1482.duplicatePhasesLotsTasksForProjectOrTemplate($form.project.UUID; Form:C1466.current_item.UUID; "UUID_Project"; "UUID_TemplateProject")
		$ok:=True:C214
	End if 