Class extends sfw_definitionBuilder

Class constructor
	
	Super:C1705()
	This:C1470._global_parameters()
	This:C1470._visions_definition()
	This:C1470._entries_definition()
	//This._event_definition()
	//This._scheduler_definition()
	//This._notification_definition()
	//This._profiles_definition()
	
Function _global_parameters()
	
	This:C1470.globalParameters:=New object:C1471
	This:C1470.globalParameters.toolbar:=New object:C1471("visionsLogo"; "/RESOURCES/image/logo/Kairos-logo-100x25.png"; "visionsLogoLocal"; "/RESOURCES/image/logo/Kairos-logo-local-100x25.png")
	This:C1470.globalParameters.panel:=New object:C1471("defaultLogo"; "/RESOURCES/image/logo/Kairos-512x452.png"; "defaultLogoLocal"; "/RESOURCES/image/logo/Kairos-local-512x452.png")
	This:C1470.globalParameters.users:=New object:C1471("passwordLength"; 12)
	This:C1470.globalParameters.users.linkedDataclass:="Staff"
	This:C1470.globalParameters.users.linkedObject:="staff"
	This:C1470.globalParameters.users.linkedPathToNameFromUserEntity:="staffs.first().fullName"
	This:C1470.globalParameters.users.linkedPathToEmailFromUserEntity:="staffs.first().email"
	This:C1470.globalParameters.folders:=New object:C1471("projectResources"; "kairos")
	This:C1470.globalParameters.address:=New object:C1471("defaultCountry"; "fr")
	This:C1470.globalParameters.preferedCountriesInPup:=New collection:C1472("ma"; "fr"; "us")
	
	
Function _event_definition()
	
	cs:C1710.sfw_eventManager.me.createIfNotExist("addSkill"; "Add skill to a staff")
	cs:C1710.sfw_eventManager.me.createIfNotExist("closeSkill"; "Close a skill for a staff")
	cs:C1710.sfw_eventManager.me.createIfNotExist("startSkill"; "Start a skill for a staff")
	
	// phase
	cs:C1710.sfw_eventManager.me.createIfNotExist("addPhase"; "Add phase to project")
	cs:C1710.sfw_eventManager.me.createIfNotExist("renamePhase"; "Rename a phase of project")
	cs:C1710.sfw_eventManager.me.createIfNotExist("modifyPhase"; "Modify aphase of project")
	cs:C1710.sfw_eventManager.me.createIfNotExist("deletePhase"; "Delete a phase from project")
	
	// lot
	cs:C1710.sfw_eventManager.me.createIfNotExist("addLot"; "Add lot to phase")
	cs:C1710.sfw_eventManager.me.createIfNotExist("renameLot"; "Rename lot in phase")
	cs:C1710.sfw_eventManager.me.createIfNotExist("modifyLot"; "Modify lot in phase")
	cs:C1710.sfw_eventManager.me.createIfNotExist("deleteLot"; "Delete lot from phase")
	cs:C1710.sfw_eventManager.me.createIfNotExist("moveLotUp"; "Move lot up in phase")
	cs:C1710.sfw_eventManager.me.createIfNotExist("moveLotDown"; "Move lot down in phase")
	
	// task
	cs:C1710.sfw_eventManager.me.createIfNotExist("addTask"; "Add task to lot")
	cs:C1710.sfw_eventManager.me.createIfNotExist("modifyTask"; "Modify task in lot")
	cs:C1710.sfw_eventManager.me.createIfNotExist("deleteTask"; "Delete task from lot")
	
	// taskTime
	cs:C1710.sfw_eventManager.me.createIfNotExist("addTaskTime"; "Add task time")
	cs:C1710.sfw_eventManager.me.createIfNotExist("modifyTaskTime"; "Modify task time")
	cs:C1710.sfw_eventManager.me.createIfNotExist("deleteTaskTime"; "Delete task time")
	
	//KeyDate
	cs:C1710.sfw_eventManager.me.createIfNotExist("addKeyDate"; "Add keyDate")
	cs:C1710.sfw_eventManager.me.createIfNotExist("modifyKeyDate"; "Modify keyDate")
	cs:C1710.sfw_eventManager.me.createIfNotExist("deleteKeyDate"; "Delete keyDate")
	
	//progress report
	cs:C1710.sfw_eventManager.me.createIfNotExist("addProgressReport"; "Add progress report")
	cs:C1710.sfw_eventManager.me.createIfNotExist("modifyProgressReport"; "Modify progress report")
	cs:C1710.sfw_eventManager.me.createIfNotExist("deleteProgressReport"; "Delete progress report")
	
	
	// customerTime
	cs:C1710.sfw_eventManager.me.createIfNotExist("addCustomerTime"; "Add customer time")
	cs:C1710.sfw_eventManager.me.createIfNotExist("modifyCustomerTime"; "Modify customer time")
	cs:C1710.sfw_eventManager.me.createIfNotExist("deleteCustomerTime"; "Delete customer time")
	
	// meetingTime
	cs:C1710.sfw_eventManager.me.createIfNotExist("addMeetingTime"; "Add meeting time")
	cs:C1710.sfw_eventManager.me.createIfNotExist("modifyMeetingTime"; "Modify meeting time")
	cs:C1710.sfw_eventManager.me.createIfNotExist("deleteMeetingTime"; "Delete meeting time")
	
	// adminTime
	cs:C1710.sfw_eventManager.me.createIfNotExist("addAdminTime"; "Add administrative time")
	cs:C1710.sfw_eventManager.me.createIfNotExist("modifyAdminTime"; "Modify administrative time")
	cs:C1710.sfw_eventManager.me.createIfNotExist("deleteAdminTime"; "Delete administrative time")
	
Function _scheduler_definition()
	var $periodicity : cs:C1710.sfw_definitionScheduler
	
	$periodicity:=cs:C1710.sfw_definitionScheduler.new("hourly")
	$periodicity.setMinuteToStart(5)
	$periodicity.setHourMinMax(9; 18)
	cs:C1710.sfw_schedulerManager.me.createIfNotExist("test"; "test scheduler"; $periodicity; "testForScheduler"; "HelloIsTime"; False:C215)
	
	$periodicity:=cs:C1710.sfw_definitionScheduler.new("daily")
	$periodicity.setHourToStart(11)
	$periodicity.setMinuteToStart(0)
	$periodicity.setDayNumbers(Monday:K10:13; Tuesday:K10:14; Wednesday:K10:15; Thursday:K10:16; Friday:K10:17)
	cs:C1710.sfw_schedulerManager.me.createIfNotExist("test2"; "test scheduler2"; $periodicity; "testForScheduler"; "HelloIsTimeandDay"; False:C215)
	
	$periodicity:=cs:C1710.sfw_definitionScheduler.new("weekly")
	$periodicity.setHourToStart(11)
	$periodicity.setMinuteToStart(10)
	$periodicity.setDayNumber(Tuesday:K10:14)
	cs:C1710.sfw_schedulerManager.me.createIfNotExist("test3"; "test scheduler3"; $periodicity; "testForScheduler"; "HelloisWeek"; False:C215)
	
	$periodicity:=cs:C1710.sfw_definitionScheduler.new("hourly")
	$periodicity.setMinutesToStart([0; 15; 30; 45])
	cs:C1710.sfw_schedulerManager.me.createIfNotExist("microsoftAPIGraph_refreshToken"; "Refresh Token of Microsoft API Graph"; $periodicity; "microsoftGraphAPI"; "getToken"; True:C214)
	
	
Function _notification_definition()
	var $definition : cs:C1710.sfw_definitionNotificationType
	
	$definition:=cs:C1710.sfw_definitionNotificationType.new()
	$definition.setDescription("A new task time is added for the project ##projectName## by ##staffName##.")
	$definition.setActive()
	cs:C1710.sfw_notificationManager.me.createTypeIfNotExist("NewTaskTime"; "New tasktime"; $definition)
	
	$definition:=cs:C1710.sfw_definitionNotificationType.new()
	$definition.setDescription("A new meeting time is added by ##staffName##.")
	$definition.setActive()
	cs:C1710.sfw_notificationManager.me.createTypeIfNotExist("NewMeetingTime"; "New meeting time"; $definition)
	
	$definition:=cs:C1710.sfw_definitionNotificationType.new()
	$definition.setDescription("A new customer time is added for customer ##customerName## by ##staffName##.")
	$definition.setActive()
	cs:C1710.sfw_notificationManager.me.createTypeIfNotExist("NewCustomerTime"; "New customer time"; $definition)
	
	$definition:=cs:C1710.sfw_definitionNotificationType.new()
	$definition.setDescription("A new administrative time is added by ##staffName##.")
	$definition.setActive()
	cs:C1710.sfw_notificationManager.me.createTypeIfNotExist("NewMeetingTime"; "New meeting time"; $definition)
	
	
	//Mark:-Visions defintion
Function _visions_definition()
	var $vision : cs:C1710.sfw_definitionVision
	
	$vision:=cs:C1710.sfw_definitionVision.new("customerService"; "Customer service")
	$vision.setToolbarBackgroundColor("#52ABD8")
	$vision.setFocusRingColor("navy")
	$vision.setIcon("image/vision/staff-management-50x50.png")
	This:C1470._push_vision($vision)
	
	
	//Mark:-Entries defintion
Function _entries_definition()
	
	
	
Function _profiles_definition()
	
	$ePM:=ds:C1482.sfw_UserProfile.getAndCreateIfNotExist("pm"; "project manager"; "autoCreation")
	$eAM:=ds:C1482.sfw_UserProfile.getAndCreateIfNotExist("am"; "account manager"; "autoCreation")
	$eTAM:=ds:C1482.sfw_UserProfile.getAndCreateIfNotExist("tam"; "technical account manager"; "autoCreation")
	$eTest:=ds:C1482.sfw_UserProfile.getAndCreateIfNotExist("tst"; "tester"; "autoCreation")
	