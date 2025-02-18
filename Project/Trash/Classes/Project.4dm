Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	var $filter : cs:C1710.sfw_definitionFilter
	
	$entry:=cs:C1710.sfw_definitionEntry.new("project"; "projectManagment"; "Projects"; "Project")
	$entry.setDataclass("Project")
	$entry.setIcon("image/entry/project-50x50.png")
	$entry.setSearchboxField("name")
	$entry.setSearchboxField("customer.name"; "placeholder:customer")
	$entry.setSearchboxField("serviceType.code"; "placeholder:serviceType_code")
	$entry.setSearchboxField("serviceType.name"; "placeholder:serviceType_name")
	$entry.setDisplayOrder(500)
	$entry.setPanel("panel_project")
	$entry.setPanelPage(1; "staff-32x32.png"; "staff")
	$entry.setPanelPage(2; "contract-32x32.png"; "contracts")
	$entry.setPanelPage(3; "description-32x32.png"; "description")
	$entry.setPanelPage(4; "tasks-32x32.png"; "tasks")
	$entry.setPanelPage(5; "keyDate-32x32.png"; "keyDates")
	$entry.setPanelPage(6; "progressReport-32x32.png"; "progressReports")
	$entry.setPanelPage(7; "tasks-32x32.png"; "globalTasksView")
	
	$entry.setLBItemsColumn("serviceType.code"; "Serv."; "width:45"; "columnName:columnService"; "center")
	$entry.setLBItemsColumn("customer.name"; "Customer"; "width:120")
	$entry.setLBItemsColumn("name"; "Name"; "width:235")
	$entry.setLBItemsColumn("currentStatus"; "Status"; "width:45"; "columnName:columnStatus"; "center")
	
	$entry.setLBItemsOrderBy("customer.name, name")
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:project"; "unitN:projects")
	//$entry.setLBAllowedProfiles("administrator")
	
	$entry.setValidationRule("name"; "entryField_name"; "mandatory"; "trimSpace")
	//$entry.setValidationRule("code"; "entryField_name"; "mandatory"; "trimSpace"; "capitalize")
	
	$entry.enableTransaction()
	
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	$entry.setItemListPreconfigAction("copyItemsListToPasteboard")
	$entry.setItemListAction("Check dates"; "Project_check_dates_all")
	$entry.setItemListAction("Check project no"; "Project_check_no_all")
	$entry.setItemListAction("Check project codes"; "Project_check_code_all")
	
	$entry.setLinkedReferenceRecordsDataclasses("phases"; "phases.lots"; "phases.lots.tasks"; "phases.lots.tasks.taskType")
	$entry.setLinkedReferenceRecordsDataclasses("phases.lots.tasks.statusHistories"; "phases.lots.tasks.affectations"; "phases.lots.tasks.affectations.taskTimes")
	
	$filter:=cs:C1710.sfw_definitionFilter.new("filterCompany")
	$filter.setDefaultTitle("All companies")
	$filter.setFilterByLinkedEntity("Company"; "UUID_Company"; ""; "company")
	$filter.setDynamicTitle("name"; "## companies")
	$filter.setOrderForItems("name")
	$filter.setAttributeLabelForItem("name")
	$entry.addFilter($filter)
	
	$filter:=cs:C1710.sfw_definitionFilter.new("filterCustomer")
	$filter.setDefaultTitle("All customers")
	$filter.setFilterByLinkedEntity("Customer"; "UUID_Customer"; ""; "customer")
	$filter.setDynamicTitle("name"; "## customers")
	$entry.addFilter($filter)
	
	$filter:=cs:C1710.sfw_definitionFilter.new("filterService")
	$filter.setDefaultTitle("All types of service")
	$filter.setFilterByLinkedEntity("ServiceType"; "UUID_ServiceType"; ""; "serviceType")
	$filter.setDynamicTitle("name"; "## service types")
	$entry.addFilter($filter)
	
	$filter:=cs:C1710.sfw_definitionFilter.new("filterCustomerCountry")
	$filter.setDefaultTitle("All customer countries")
	$filter.setFilterByLinkedEntity("sfw_Country"; "customer.UUID_Country"; "uuidCustomerCountry"; "customer.country")
	$filter.setDynamicTitle("name"; "## customer countries")
	$entry.addFilter($filter)
	
	$filter:=cs:C1710.sfw_definitionFilter.new("filterCurrentStatus")
	$filter.setDefaultTitle("All status")
	$filter.setFilterByIDInTable("ProjectStatus"; "statusID"; "currentStatusID")
	$filter.setDynamicTitle("name"; "## customer countries")
	$entry.addFilter($filter)
	
	// MARK: 
	$view:=cs:C1710.sfw_definitionView.new("myProjects"; "Projects I am working on")  //; "derivedFrom:main")
	$view.setLBItemsColumn("customer.name"; "Customer"; "width:150")
	$view.setLBItemsColumn("name"; "Name"; "width:250")
	$view.setLBItemsColumn("serviceType.colorPicture"; ""; "type:picture"; "width:5"; "orderByFormula:this.serviceType.name")
	$view.setLBItemsColumn("serviceType.code"; "Service type"; "width:50")
	$view.setLBItemsOrderBy("customer.name, name")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:project"; "unitN:projects")
	$view.setSubset("myProjects")
	$entry.setView($view)
	
	
	$view:=cs:C1710.sfw_definitionView.new("teamMemberWithoutRole"; "Team members without role affected")
	$view.setLBItemsColumn("customer.name"; "Customer"; "width:150")
	$view.setLBItemsColumn("name"; "Name"; "width:250")
	$view.setLBItemsColumn("serviceType.colorPicture"; ""; "type:picture"; "width:5"; "orderByFormula:this.serviceType.name")
	$view.setLBItemsColumn("serviceType.code"; "Service type"; "width:50")
	$view.setLBItemsOrderBy("customer.name, name")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:project"; "unitN:projects")
	$view.setSubset("projectWithTeamMembersWithoutRole")
	$view.setPictoLabel("/RESOURCES/kairos/image/picto/exclamation-diamond.png")
	$entry.setView($view)
	
	
	$entry.setSpecificAddMode("addFromTemplate"; "Creation from template..."; "kairos/image/icon/createFromTemplate-24x24.png"; "createFromTemplate")
	
	$entry.activateFavorite()
	$entry.activateComment()
	$entry.activateEvent("ProjectEvent"; "UUID_Project")
	$entry.setAttributesToTrackInModificationEvent("code"; "name")
	$entry.setAttributeStmpToTrackInModificationEvent("dateStartWork"; "stmpStartWork"; Is date:K8:7)
	
	//$entry.setAttributeStmpToTrackInModificationEvent("timeStartWork"; "stmpStartWork"; Is time)
	$entry.setLinkManyToOneToTrackInModificationEvent("company"; "UUID_Company"; "company.name")
	$entry.setLinkManyToOneToTrackInModificationEvent("customer"; "UUID_Customer"; "customer.name")
	$entry.setLinkManyToOneToTrackInModificationEvent("service type"; "UUID_serviceType"; "serviceType.name")
	$entry.setEventOptions("dontCreateModifyEventIfNoTrackingAttribute")
	
	
	$entry.setItemListProjection("Projection to tasks"; "projectionToTasks"; "task"; "projectManagment")
	
	
Function myProjects()->$myProjects : cs:C1710.ProjectSelection
	
	If (cs:C1710.sfw_userManager.me.staff#Null:C1517)
		$myProjects:=ds:C1482.Project.query("phases.lots.tasks.affectations.UUID_Staff = :1 OR teamMembers.UUID_Staff = :1"; cs:C1710.sfw_userManager.me.staff.UUID)
	Else 
		$myProjects:=ds:C1482.Project.all()
	End if 
	
	
Function projectWithTeamMembersWithoutRole()->$subsetProject : cs:C1710.ProjectSelection
	
	$subsetProject:=ds:C1482.Project.query("teamMembers.role = null")
	
local Function createFromTemplate()->$ok : Boolean
	
	$form:=New object:C1471
	$form.lb_templates:=ds:C1482.TemplateProject.all().orderBy("name")
	$form.templateProject:=Null:C1517
	If (Is Windows:C1573)
		$refWindow:=Open form window:C675("selector_templateProject"; Modal form dialog box:K39:7)
	Else 
		$refWindow:=Open form window:C675("selector_templateProject"; Sheet form window:K39:12)
	End if 
	DIALOG:C40("selector_templateProject"; $form)
	CLOSE WINDOW:C154($refWindow)
	If (ok=1)
		Form:C1466.sfw.cancelAndRestartTransaction()
		LISTBOX SELECT ROW:C912(*; "lb_items"; 0; lk remove from selection:K53:3)
		
		Form:C1466.current_item:=ds:C1482.Project.new()
		Form:C1466.current_item.UUID:=Generate UUID:C1066
		Form:C1466.current_item.code:=$form.templateProject.code
		Form:C1466.current_item.name:=$form.templateProject.name
		Form:C1466.current_item.UUID_ServiceType:=$form.templateProject.UUID_ServiceType
		
		ds:C1482.duplicatePhasesLotsTasksForProjectOrTemplate($form.templateProject.UUID; Form:C1466.current_item.UUID; "UUID_TemplateProject"; "UUID_Project")
		$ok:=True:C214
	End if 