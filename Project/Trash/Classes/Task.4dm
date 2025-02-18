Class extends DataClass




local Function closeBoxMainForm()
	// With this callback you close the BoxMain form
	
local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	var $filter : cs:C1710.sfw_definitionFilter
	
	$entry:=cs:C1710.sfw_definitionEntry.new("task"; "projectManagment"; "Tasks")
	$entry.setDataclass("Task")
	$entry.setDisplayOrder(100)
	$entry.setIcon("image/entry/task-50x50.png")
	
	$entry.setSearchboxField("name")
	$entry.setSearchboxField("lot.phase.project.name"; "placeholder:projectName")
	$entry.setSearchboxField("lot.phase.project.customer.name"; "placeholder:customerName")
	
	$entry.setPanel("panel_task"; 1)
	$entry.setPanelPage(1; "taskStatus-32x32.png"; "Info")
	$entry.setPanelPage(2; "workTime-32x32.png"; "Times")
	$entry.setPanelPage(3; "staff-32x32.png"; "Times")
	
	
	$entry.setItemListProjection("Projection to task times"; "projectionToTaskTimes"; "taskTime"; "projectManagment")
	
	
	// MARK: - Views
	
	// MARK: My tasks
	$view:=cs:C1710.sfw_definitionView.new("myTasks"; "Assigned to me")
	$view.setLBItemsColumn("lot.phase.project.name"; "Project")
	$view.setLBItemsColumn("name"; "Task name"; "width:250")
	$view.setLBItemsColumn("colorPicture"; ""; "width:5"; "type:picture")
	$view.setLBItemsColumn("status"; "Status"; "width:50")
	$view.setLBItemsOrderBy("lot.phase.project.name, lot.phase.order, lot.order, order")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:task"; "unitN:tasks")
	$view.setSubset("myTasks")
	$entry.setView($view)
	
	// MARK: Open tasks
	$view:=cs:C1710.sfw_definitionView.new("openTasks"; "Open")
	$view.setLBItemsColumn("lot.phase.project.name"; "Project")
	$view.setLBItemsColumn("name"; "Task name"; "width:250")
	$view.setLBItemsColumn("colorPicture"; ""; "width:5"; "type:picture")
	$view.setLBItemsColumn("status"; "Status"; "width:50")
	$view.setLBItemsOrderBy("lot.phase.project.name, lot.phase.order, lot.order, order")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:task"; "unitN:tasks")
	$view.setSubset("openTasks")
	$entry.setView($view)
	
	// MARK: Closed tasks
	$view:=cs:C1710.sfw_definitionView.new("closedTasks"; "Closed")
	$view.setLBItemsColumn("lot.phase.project.name"; "Project")
	$view.setLBItemsColumn("name"; "Task name"; "width:250")
	$view.setLBItemsColumn("colorPicture"; ""; "width:5"; "type:picture")
	$view.setLBItemsColumn("status"; "Status"; "width:50")
	$view.setLBItemsOrderBy("lot.phase.project.name, lot.phase.order, lot.order, order")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:task"; "unitN:tasks")
	$view.setSubset("closedTasks")
	$entry.setView($view)
	
	//MARK: Main view = all tasks
	$entry.setLBItemsColumn("lot.phase.project.name"; "Project")
	$entry.setLBItemsColumn("name"; "Task name"; "width:250")
	$entry.setLBItemsColumn("colorPicture"; ""; "width:5"; "type:picture")
	$entry.setLBItemsColumn("status"; "Status"; "width:50")
	$entry.setLBItemsOrderBy("lot.phase.project.name, lot.phase.order, lot.order, order")
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:task"; "unitN:tasks")
	$entry.setValidationRule("name"; "entryField_name"; "mandatory"; "trimSpace"; "capitalize")
	$entry.setSubset("allProjectTask")
	$entry.setMainViewLabel("All tasks")
	
	
	
	
	// MARK: -Filters
	$filter:=cs:C1710.sfw_definitionFilter.new("filterCompany")
	$filter.setDefaultTitle("All companies")
	$filter.setFilterByLinkedEntity("Company"; "lot.phase.project.UUID_Company"; "companyName"; "lot.phase.project.company")
	$filter.setDynamicTitle("name"; "## companies")
	$filter.setOrderForItems("name")
	$entry.addFilter($filter)
	
	$filter:=cs:C1710.sfw_definitionFilter.new("filterCustomers")
	$filter.setDefaultTitle("All customers")
	$filter.setFilterByLinkedEntity("Customer"; "lot.phase.project.UUID_Customer"; "customerName"; "lot.phase.project.customer")
	$filter.setDynamicTitle("name"; "## customers")
	$filter.setOrderForItems("name")
	$entry.addFilter($filter)
	
	$filter:=cs:C1710.sfw_definitionFilter.new("filterStatus")
	$filter.setDefaultTitle("All status")
	$filter.setFilterByIDInTable("TaskStatus"; "statusID"; "currentStatusID")
	$filter.setDynamicTitle("numAndName"; "## status")
	$filter.setAttributeLabelForItem("numAndName")
	$filter.setOrderForItems("statusID")
	$entry.addFilter($filter)
	
	
	$entry.enableTransaction()
	$entry.setAddable(False:C215)
	$entry.activateFavorite()
	$entry.activateComment()
	$entry.activateEvent("TaskEvent"; "UUID_Task")
	
	//MARK:- functions to create subsets for views
Function myTasks()->$myTasks : cs:C1710.TaskSelection
	If (cs:C1710.sfw_userManager.me.staff#Null:C1517)
		$myTasks:=ds:C1482.Task.query("affectations.UUID_Staff = :1 and project # null"; cs:C1710.sfw_userManager.me.staff.UUID)
	Else 
		$myTasks:=ds:C1482.Task.query("project # null")
	End if 
	
Function openTasks()->$myTasks : cs:C1710.TaskSelection
	var $closedStatusID : Collection
	$closedStatusID:=[0; 3; 5; 8]
	$myTasks:=ds:C1482.Task.query("NOT(currentStatusID IN :1 and project # null)"; $closedStatusID)
	
Function closedTasks()->$myTasks : cs:C1710.TaskSelection
	var $closedStatusID : Collection
	$closedStatusID:=[0; 3; 5; 8]
	$myTasks:=ds:C1482.Task.query("currentStatusID IN :1 and project # null"; $closedStatusID)
	
Function allProjectTask()->$myTasks : cs:C1710.TaskSelection
	$myTasks:=ds:C1482.Task.query("project # null")
	