Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("administrativeTime"; "time"; "Admi. Times")
	$entry.setDataclass("AdministrativeTime")
	
	$entry.setIcon("image/entry/administrativeTime-50x50.png")
	
	
	//$entry.setSearchboxField("stmpDuration")
	
	
	$entry.setPanel("panel_administrativeTime")
	
	//$entry.setPanelPage(1; "-24x24.png")
	
	$entry.setLBItemsColumn("administrativeTimeType.name"; "Administrative Task"; "width:320"; "headerLeft")
	$entry.setLBItemsColumn("dateStart"; "Date"; "type:date"; "width:80"; "headerCenter"; "center")
	$entry.setLBItemsColumn("durationAdministrative"; "Dur."; "width:45"; "headerCenter"; "center")
	
	$entry.setValidationRule("comment"; "entryField_comment"; "mandatory"; "trimSpace"; "capitalize")
	
	
	$entry.setLBItemsOrderBy("stmpStart desc")
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:administrative time"; "unitN:administrative times")
	$entry.setAddable(False:C215)
	$entry.setPanelAfterProjection("panel_administartive_projection")
	
	$entry.enableTransaction()
	
	// MARK: -Views
	// MARK: My administrativetimes
	$view:=cs:C1710.sfw_definitionView.new("myAdministrativeTimes"; "My administrative times")
	$view.setLBItemsColumn("attendee.meeting.name"; "Task"; "width:300"; "headerLeft")
	$view.setLBItemsColumn("dateStart"; "Date"; "type:date"; "width:80")
	$view.setLBItemsColumn("durationAdministrative"; "Duration"; "width:50")
	
	$view.setLBItemsOrderBy("dateStart DESC")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:administrative time"; "unitN:administrative times")
	$view.setSubset("myAdministrativeTimes")
	$entry.setView($view)
	
	// MARK: My administrativetimes this week
	$view:=cs:C1710.sfw_definitionView.new("myWeekAdministrativeTimes"; "My week administrative times")
	$view.setLBItemsColumn("attendee.meeting.name"; "Task"; "width:300"; "headerLeft")
	$view.setLBItemsColumn("dateStart"; "Date"; "type:date"; "width:80")
	$view.setLBItemsColumn("durationAdministrative"; "Duration"; "width:50")
	$view.setLBItemsOrderBy("dateStart DESC")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:administrative time"; "unitN:administrative times")
	$view.setSubset("myWeekAdministrativeTimes")
	$entry.setView($view)
	
	
	//MARK:- functions to create subsets for views
Function myAdministrativeTimes()->$myTaskTimes : cs:C1710.AdministrativeTimeSelection
	
	If (cs:C1710.sfw_userManager.me.staff#Null:C1517)
		$myTaskTimes:=ds:C1482.AdministrativeTime.query("UUID_Staff = :1"; cs:C1710.sfw_userManager.me.staff.UUID)
	Else 
		$myTaskTimes:=ds:C1482.AdministrativeTime.all()
	End if 
	
Function myWeekAdministrativeTimes()->$taskTimes : cs:C1710.AdministrativeTimeSelection
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
	$taskTimes:=ds:C1482.AdministrativeTime.query($queryString; $querySettings)