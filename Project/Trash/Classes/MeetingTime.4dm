Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("meetingTime"; "time"; "Meeting Times")
	$entry.setDataclass("MeetingTime")
	$entry.setDisplayOrder(200)
	$entry.setIcon("image/entry/meetingTime-50x50.png")
	
	
	//$entry.setSearchboxField("stmpDuration")
	
	
	$entry.setPanel("panel_meetingTime")
	
	//$entry.setPanelPage(1; "-24x24.png")
	
	$entry.setLBItemsColumn("attendee.meeting.name"; "Meeting"; "width:320"; "headerLeft")
	$entry.setLBItemsColumn("dateStart"; "Date"; "type:date"; "width:80"; "headerCenter"; "center")
	$entry.setLBItemsColumn("durationMeeting"; "Dur."; "width:45"; "headerCenter"; "center")
	
	$entry.setValidationRule("comment"; "entryField_comment"; "mandatory"; "trimSpace"; "capitalize")
	
	
	$entry.setLBItemsOrderBy("stmpStart desc")
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:meeting time"; "unitN:meeting times")
	$entry.setAddable(False:C215)
	
	$entry.setPanelAfterProjection("panel_meeting_projection")
	
	$entry.enableTransaction()
	
	// MARK: -Views
	// MARK: My meetingtimes
	$view:=cs:C1710.sfw_definitionView.new("myMeetingTimes"; "My meeting times")
	$view.setLBItemsColumn("attendee.meeting.name"; "Meeting"; "width:300"; "headerLeft")
	$view.setLBItemsColumn("dateStart"; "Date"; "type:date"; "width:80")
	$view.setLBItemsColumn("durationMeeting"; "Duration"; "width:50")
	
	$view.setLBItemsOrderBy("dateStart DESC")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:meeting time"; "unitN:meeting times")
	$view.setSubset("myMeetingTimes")
	$entry.setView($view)
	
	// MARK: My meetingtimes this week
	$view:=cs:C1710.sfw_definitionView.new("myWeekMeetingTimes"; "My week meeting times")
	$view.setLBItemsColumn("attendee.meeting.name"; "Meeting"; "width:300"; "headerLeft")
	$view.setLBItemsColumn("dateStart"; "Date"; "type:date"; "width:80")
	$view.setLBItemsColumn("durationMeeting"; "Duration"; "width:50")
	$view.setLBItemsOrderBy("dateStart DESC")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:meeting time"; "unitN:meeting times")
	$view.setSubset("myWeekMeetingTimes")
	$entry.setView($view)
	
	
	//MARK:- functions to create subsets for views
Function myMeetingTimes()->$myTaskTimes : cs:C1710.MeetingTimeSelection
	
	If (cs:C1710.sfw_userManager.me.staff#Null:C1517)
		$myTaskTimes:=ds:C1482.MeetingTime.query("attendee.UUID_Staff = :1"; cs:C1710.sfw_userManager.me.staff.UUID)
	Else 
		$myTaskTimes:=ds:C1482.MeetingTime.all()
	End if 
	
Function myWeekMeetingTimes()->$taskTimes : cs:C1710.MeetingTimeSelection
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
		$queryParts.push("attendee.UUID_Staff = :uuidStaff")
		$querySettings.parameters.uuidStaff:=cs:C1710.sfw_userManager.me.staff.UUID
	End if 
	$queryString:=$queryParts.join(" AND ")
	$taskTimes:=ds:C1482.MeetingTime.query($queryString; $querySettings)
	
	
	
	