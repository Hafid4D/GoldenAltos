Class extends Entity


Function get fullName()->$fullName : Text
	
	$fullName:=[This:C1470.firstName; This:C1470.lastName].join(" ")
	
	
	
local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	
	$nameInWindowTitle:=String:C10(This:C1470.fullName)
	
local Function get nameInWizard()->$nameInWizard : Text
	
	$nameInWizard:="🙍🏻‍♂️ "+String:C10(This:C1470.fullName)
	
Function get userIcon()->$icon : Picture
	var $eUser : cs:C1710.sfw_User
	var $iconFile : 4D:C1709.File
	
	$eUser:=ds:C1482.sfw_User.get(This:C1470.UUID_User)
	If ($eUser#Null:C1517)
		
		Case of 
			: ($eUser.isInactive) && (This:C1470.civility#"Mr")
				$iconName:="inactiveMale"
			: ($eUser.isInactive)
				$iconName:="inactiveFemale"
			: ($eUser.asDesigner) && (This:C1470.civility#"Mr")
				$iconName:="devFemale"
			: ($eUser.asDesigner)
				$iconName:="devMale"
			: (This:C1470.civility#"Mr")
				$iconName:="basicFemale"
			Else 
				$iconName:="basicMale"
		End case 
		$icon:=cs:C1710.sfw_userManager.me.icon[$iconName]
	End if 
	
	
local Function get active()->$active : Boolean
	$active:=Not:C34(Bool:C1537(This:C1470.inactive))
	
	
local Function set active($active : Boolean)
	This:C1470.inactive:=Not:C34($active)
	
	
local Function get metaViewAllEmployees()->$meta : Object
	
	$meta:=New object:C1471
	If (This:C1470.inactive)
		$meta.stroke:="lightgrey"
	End if 
	
Function skillsSummary()->$skillsSummary : Text
	
	$skillsSummary:=This:C1470.skills.role.distinct("name").join(", ")
	
	
	
	//mark:-Form management
	
	
local Function rebuildAddress()
	
	Form:C1466.subFormAddress:=New object:C1471
	Form:C1466.subFormAddress.situation:=Form:C1466.situation
	Case of 
		: (Form:C1466.addressPersonnal=1)
			$mainAddress:=Form:C1466.current_item.contactDetails.addresses.query("type = :1"; "main").first()
			Form:C1466.subFormAddress.address:=$mainAddress
		: (Form:C1466.addressCompany=1)
			$mainAddress:=Form:C1466.current_item.department.company.contactDetails.addresses.query("type = :1"; "main").first()
			Form:C1466.subFormAddress.address:=$mainAddress
			Form:C1466.subFormAddress.readOnly:=True:C214
	End case 
	Form:C1466.subFormAddress:=Form:C1466.subFormAddress
	
	
local Function _initAddress()
	// This callback is called when the item is selected in the itemList
	If (This:C1470.contactDetails=Null:C1517)
		This:C1470.contactDetails:=New object:C1471
	End if 
	If (This:C1470.contactDetails.addresses=Null:C1517)
		This:C1470.contactDetails.addresses:=New collection:C1472
	End if 
	$mainAddress:=This:C1470.contactDetails.addresses.query("type = :1"; "main").first()
	If ($mainAddress=Null:C1517)
		$mainAddress:=New object:C1471
		$mainAddress.type:="main"
		$mainAddress.detail:=New object:C1471
		$mainAddress.detail.country:="FR"
		This:C1470.contactDetails.addresses.push($mainAddress)
	End if 
	
	
	
Function getHolidays($date : Date)->$holidays : Collection
	
	$esHolidays:=This:C1470.holidays || ds:C1482.Holiday.newSelection()
	$esBankHolidays:=This:C1470.department.company.bankHolidays || ds:C1482.BankHoliday.newSelection()
	$esCloseDays:=This:C1470.department.company.closeDays || ds:C1482.CloseDay.newSelection()
	If (Count parameters:C259>0)
		$month:=Month of:C24($date)
		$year:=Year of:C25($date)
		$first:=Add to date:C393(!00-00-00!; $year; $month; 1)
		$last:=Add to date:C393($first; 0; 1; 0)-1
		$esHolidays:=$esHolidays.query("dateOff >= :1 and dateOff <= :2"; $first; $last)
		$esBankHolidays:=$esBankHolidays.query("dateOff >= :1 and dateOff <= :2"; $first; $last)
		$esCloseDays:=$esCloseDays.query("dateOff >= :1 and dateOff <= :2"; $first; $last)
	End if 
	$holidays:=New collection:C1472()
	For each ($day; $esHolidays)
		$holidays.push({dateOff: $day.dateOff; type: "Holiday"; name: $day.holidayType.name; stmp: cs:C1710.sfw_stmp.me.build($day.dateOff; ?00:00:00?)})
	End for each 
	For each ($day; $esBankHolidays)
		$holidays.push({dateOff: $day.dateOff; type: "BankHoliday"; name: $day.name; stmp: cs:C1710.sfw_stmp.me.build($day.dateOff; ?00:00:00?)})
	End for each 
	For each ($day; $esCloseDays)
		$holidays.push({dateOff: $day.dateOff; type: "CloseDay"; name: $day.label; stmp: cs:C1710.sfw_stmp.me.build($day.dateOff; ?00:00:00?)})
	End for each 
	
	//mark:-Callbacks
	
	
	
	
local Function loadAfterCreation()
	// This callback is called after creating the new item but before displaying the panel.
	This:C1470._initAddress()
	
local Function afterCreation()
	This:C1470._initAddress()
	
	
local Function itemLoad()
	// This callback is called when the item is selected in the itemList
	This:C1470._initAddress()
	This:C1470._initCommunication()
	
local Function get email()->$email : Text
	If (This:C1470.contactDetails#Null:C1517) && (This:C1470.contactDetails.communications#Null:C1517)
		$communication:=This:C1470.contactDetails.communications.query("type = :1"; "mail").first()
		If ($communication#Null:C1517)
			$email:=$communication.contact
		End if 
	End if 
	
local Function isDeletable()->$isDeletable : Boolean
	// This callback must return false to inactivate the deletion mode for the current item.
	$isDeletable:=True:C214
	
	//mark:-Sub functions
local Function _initCommunication()
	If (This:C1470.contactDetails.communications=Null:C1517)
		This:C1470.contactDetails.communications:=New collection:C1472
	End if 
	
	
	
	
Function getTimeSheetsYear($year : Integer)->$timesheets : Collection
	var $eTaskTime : cs:C1710.TaskTimeEntity
	var $eCustomerTime : cs:C1710.CustomerTimeEntity
	var $eMeetingTime : cs:C1710.MeetingTimeEntity
	var $eAdministrativeTime : cs:C1710.AdministrativeTimeEntity
	
	$dateFrom:=Add to date:C393(!00-00-00!; $year; 1; 1)
	$dateTo:=Add to date:C393($dateFrom; 1; 0; -1)
	
	$timesheets:=New collection:C1472
	
	For each ($eTaskTime; ds:C1482.TaskTime.query("affectation.UUID_Staff = :1 and dateStart >= :2 and dateStart<= :3"; This:C1470.UUID; $dateFrom; $dateTo))
		$timesheet:=New object:C1471
		$timesheet.type:="Task time"
		$timesheet.duration:=$eTaskTime.stmpDuration
		$timesheet.date:=$eTaskTime.dateStart
		$timesheet.UUID:=$eTaskTime.UUID
		$timesheets.push($timesheet)
	End for each 
	
	For each ($eCustomerTime; ds:C1482.CustomerTime.query("UUID_Staff = :1 and dateStart >= :2 and dateStart<= :3"; This:C1470.UUID; $dateFrom; $dateTo))
		$timesheet:=New object:C1471
		$timesheet.type:="Customer time"
		$timesheet.duration:=$eCustomerTime.stmpDuration
		$timesheet.date:=$eCustomerTime.dateStart
		$timesheet.UUID:=$eCustomerTime.UUID
		$timesheets.push($timesheet)
	End for each 
	
	For each ($eMeetingTime; ds:C1482.MeetingTime.query("attendee.UUID_Staff = :1 and dateStart >= :2 and dateStart<= :3"; This:C1470.UUID; $dateFrom; $dateTo))
		$timesheet:=New object:C1471
		$timesheet.type:="Meeting time"
		$timesheet.duration:=$eMeetingTime.stmpDuration
		$timesheet.date:=$eMeetingTime.dateStart
		$timesheet.UUID:=$eMeetingTime.UUID
		$timesheets.push($timesheet)
	End for each 
	
	For each ($eAdministrativeTime; ds:C1482.AdministrativeTime.query("UUID_Staff = :1 and dateStart >= :2 and dateStart<= :3"; This:C1470.UUID; $dateFrom; $dateTo))
		$timesheet:=New object:C1471
		$timesheet.type:="Administrative time"
		$timesheet.duration:=$eAdministrativeTime.stmpDuration
		$timesheet.date:=$eAdministrativeTime.dateStart
		$timesheet.UUID:=$eAdministrativeTime.UUID
		$timesheets.push($timesheet)
	End for each 
	
	
Function getSlotsYear($year : Integer)->$slots : Collection
	var $ePlanificationSlot : cs:C1710.PlanificationSlotEntity
	$dateFrom:=Add to date:C393(!00-00-00!; $year; 1; 1)
	$dateTo:=Add to date:C393($dateFrom; 1; 0; -1)
	
	$slots:=New collection:C1472
	
	For each ($ePlanificationSlot; ds:C1482.PlanificationSlot.query("UUID_Staff = :1 and dateStart >= :2 and dateStart<= :3"; This:C1470.UUID; $dateFrom; $dateTo))
		$slot:=New object:C1471
		$slot.type:="Planification slot"
		$slot.duration:=$ePlanificationSlot.stmpDuration
		$slot.date:=$ePlanificationSlot.dateStart
		$slot.UUID:=$ePlanificationSlot.UUID
		$slots.push($slot)
	End for each 