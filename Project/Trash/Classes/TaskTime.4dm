Class extends DataClass



local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("taskTime"; "time"; "Task times")
	$entry.setDataclass("TaskTime")
	$entry.setDisplayOrder(0)
	$entry.setIcon("image/entry/workTime-50x50.png")
	
	$entry.setSearchboxField("stmpDuration")
	$entry.setSearchboxField("affectation.task.name"; "placeholder:taskName")
	
	
	$entry.setPanel("panel_taskTime"; 2)
	//$entry.setPanelPage(1; "-24x24.png"; "")
	
	
	$filter:=cs:C1710.sfw_definitionFilter.new("filterProject")
	$filter.setDefaultTitle("All projects")
	$filter.setFilterByLinkedEntity("Project"; "affectation.task.lot.phase.UUID_Project"; "uuidProject"; "affectation.task.lot.phase.project")
	$filter.setDynamicTitle("name"; "## projects")
	$filter.setOrderForItems("name")
	$entry.addFilter($filter)
	
	
	$filter:=cs:C1710.sfw_definitionFilter.new("filterStaff")
	$filter.setDefaultTitle("All staffs")
	$filter.setFilterByLinkedEntity("Staff"; "affectation.UUID_Staff"; "uuidStaff"; "affectation.staff")
	$filter.setDynamicTitle("fullName"; "## staffs")
	$filter.setOrderForItems("firstName, lastName")
	$filter.setAttributeLabelForItem("fullName")
	$entry.addFilter($filter)
	
	$entry.setLBItemsColumn("affectation.task.name"; "Task"; "width:320"; "headerLeft")
	$entry.setLBItemsColumn("dateStart"; "Date"; "type:date"; "width:80"; "headerCenter"; "center")
	$entry.setLBItemsColumn("durationWork"; "Dur."; "width:45"; "headerCenter"; "center")
	
	$entry.setValidationRule("comment"; "entryField_comment"; "mandatory"; "trimSpace"; "capitalize")
	
	
	$entry.setLBItemsOrderBy("stmpStart desc")
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:task time"; "unitN:task times")
	$entry.setAddable(False:C215)
	
	$entry.setPanelAfterProjection("panel_tasks_projection")
	
	$entry.enableTransaction()
	//$entry.enableEvent()
	
	// MARK: -Views
	// MARK: My tasktimes
	$view:=cs:C1710.sfw_definitionView.new("myTaskTimes"; "My task times")
	$view.setLBItemsColumn("affectation.task.name"; "Task"; "width:300")
	$view.setLBItemsColumn("dateStart"; "Date"; "type:date"; "width:80")
	$view.setLBItemsColumn("durationWork"; "Duration"; "width:50")
	
	$view.setLBItemsOrderBy("dateStart DESC")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:task time"; "unitN:task times")
	$view.setSubset("myTaskTimes")
	$entry.setView($view)
	
	// MARK: My tasktimes this week
	$view:=cs:C1710.sfw_definitionView.new("myWeekTaskTimes"; "My week task times")
	$view.setLBItemsColumn("affectation.task.name"; "Task"; "width:300")
	$view.setLBItemsColumn("dateStart"; "Date"; "type:date"; "width:80")
	$view.setLBItemsColumn("durationWork"; "Duration"; "width:50")
	$view.setLBItemsOrderBy("dateStart DESC")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:task time"; "unitN:task times")
	$view.setSubset("myWeekTaskTimes")
	$entry.setView($view)
	
	// MARK: TaskTimes this week on projects I manage
	$view:=cs:C1710.sfw_definitionView.new("taskTimesOnProjectsIManage"; "This week times on projects I manage")
	$view.setLBItemsColumn("affectation.task.name"; "Task"; "width:200")
	$view.setLBItemsColumn("affectation.staff.fullName"; "Staff"; "width:100")
	$view.setLBItemsColumn("dateStart"; "Date"; "type:date"; "width:80")
	$view.setLBItemsColumn("durationWork"; "Duration"; "width:50")
	$view.setLBItemsOrderBy("dateStart DESC")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:task time"; "unitN:task times")
	$view.setSubset("taskTimesOnProjectsIManage")
	$entry.setView($view)
	
	//MARK:- functions to create subsets for views
Function myTaskTimes()->$myTaskTimes : cs:C1710.TaskTimeSelection
	
	If (cs:C1710.sfw_userManager.me.staff#Null:C1517)
		$myTaskTimes:=ds:C1482.TaskTime.query("UUID_Staff = :1"; cs:C1710.sfw_userManager.me.staff.UUID)
	Else 
		$myTaskTimes:=ds:C1482.TaskTime.all()
	End if 
	
Function myWeekTaskTimes()->$taskTimes : cs:C1710.TaskTimeSelection
	$queryParts:=New collection:C1472
	
	$querySettings:=New object:C1471
	$querySettings.parameters:=New object:C1471
	
	$dateMonday:=cs:C1710.sfw_stmp.me.getMonday()
	$dateSunday:=$dateMonday+6
	
	$queryParts.push("dateStart >= :monday")
	$querySettings.parameters.monday:=$dateMonday
	
	$queryParts.push("dateStart <= :sunday")
	$querySettings.parameters.sunday:=$dateSunday
	
	If (cs:C1710.sfw_userManager.me.staff#Null:C1517)
		$queryParts.push("UUID_Staff = :uuidStaff")
		$querySettings.parameters.uuidStaff:=cs:C1710.sfw_userManager.me.staff.UUID
	End if 
	$queryString:=$queryParts.join(" AND ")
	$taskTimes:=ds:C1482.TaskTime.query($queryString; $querySettings)
	
	
	
Function taskTimesOnProjectsIManage()->$taskTimes : cs:C1710.TaskTimeSelection
	$queryParts:=New collection:C1472
	
	$querySettings:=New object:C1471
	$querySettings.parameters:=New object:C1471
	
	$dateMonday:=cs:C1710.sfw_stmp.me.getMonday()
	$dateSunday:=$dateMonday+6
	
	$queryParts.push("dateStart >= :monday")
	$querySettings.parameters.monday:=$dateMonday
	
	$queryParts.push("dateStart <= :sunday")
	$querySettings.parameters.sunday:=$dateSunday
	
	If (cs:C1710.sfw_userManager.me.staff#Null:C1517)
		$subQueryString:="(project.teamMembers.role.code == :codeRole AND project.teamMembers.UUID_Staff = :uuidStaff)"
		$queryParts.push($subQueryString)
		
		$querySettings.parameters.codeRole:="PMG"
		$querySettings.parameters.uuidStaff:=cs:C1710.sfw_userManager.me.staff.UUID
	End if 
	
	$queryString:=$queryParts.join(" AND ")
	$taskTimes:=ds:C1482.TaskTime.query($queryString; $querySettings)
	