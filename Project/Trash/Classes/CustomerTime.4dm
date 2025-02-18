Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("customerTime"; "time"; "Cust. Times")
	$entry.setDataclass("CustomerTime")
	
	$entry.setIcon("image/entry/customerTime-50x50.png")
	
	
	//$entry.setSearchboxField("stmpDuration")
	
	
	$entry.setPanel("panel_customerTime")
	
	//$entry.setPanelPage(1; "-24x24.png")
	
	$entry.setLBItemsColumn("customerTimeType.name"; "Customer time"; "width:320"; "headerLeft")
	$entry.setLBItemsColumn("dateStart"; "Date"; "type:date"; "width:80"; "headerCenter"; "center")
	$entry.setLBItemsColumn("durationCustomer"; "Dur."; "width:45"; "headerCenter"; "center")
	
	$entry.setValidationRule("comment"; "entryField_comment"; "mandatory"; "trimSpace"; "capitalize")
	
	
	$entry.setLBItemsOrderBy("stmpStart desc")
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:customer time"; "unitN:customer times")
	$entry.setAddable(False:C215)
	$entry.setPanelAfterProjection("panel_customer_projection")
	
	$entry.enableTransaction()
	
	// MARK: -Views
	// MARK: My customertimes
	$view:=cs:C1710.sfw_definitionView.new("myCustomerTimes"; "My customer times")
	$view.setLBItemsColumn("customerTimeType.name"; "Customer time"; "width:300"; "headerLeft")
	$view.setLBItemsColumn("dateStart"; "Date"; "type:date"; "width:80")
	$view.setLBItemsColumn("durationCustomer"; "Duration"; "width:50")
	
	$view.setLBItemsOrderBy("dateStart DESC")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:customer time"; "unitN:customer times")
	$view.setSubset("myCustomerTimes")
	$entry.setView($view)
	
	// MARK: My customertimes this week
	$view:=cs:C1710.sfw_definitionView.new("myWeekAdministrativeTimes"; "My week customer times")
	$view.setLBItemsColumn("customerTimeType.name"; "Customer time"; "width:300"; "headerLeft")
	$view.setLBItemsColumn("dateStart"; "Date"; "type:date"; "width:80")
	$view.setLBItemsColumn("durationCustomer"; "Duration"; "width:50")
	$view.setLBItemsOrderBy("dateStart DESC")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:customer time"; "unitN:customer times")
	$view.setSubset("myWeekCustomerTimes")
	$entry.setView($view)
	
	
	//MARK:- functions to create subsets for views
Function myCustomerTimes()->$myTaskTimes : cs:C1710.CustomerTimeSelection
	
	If (cs:C1710.sfw_userManager.me.staff#Null:C1517)
		$myTaskTimes:=ds:C1482.CustomerTime.query("UUID_Staff = :1"; cs:C1710.sfw_userManager.me.staff.UUID)
	Else 
		$myTaskTimes:=ds:C1482.CustomerTime.all()
	End if 
	
Function myWeekCustomerTimes()->$taskTimes : cs:C1710.CustomerTimeSelection
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
	$taskTimes:=ds:C1482.CustomerTime.query($queryString; $querySettings)