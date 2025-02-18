Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("trainingTime"; "time"; "Training Times")
	$entry.setDataclass("TrainingTime")
	$entry.setDisplayOrder(-200)
	$entry.setIcon("image/entry/trainingTime-50x50.png")
	
	
	//$entry.setSearchboxField("stmpDuration")
	
	
	$entry.setPanel("panel_trainingTime")
	
	//$entry.setPanelPage(1; "-24x24.png")
	
	$entry.setLBItemsColumn("trainee.trainingSession.training.name"; "Training Task"; "width:320"; "headerLeft")
	$entry.setLBItemsColumn("dateStart"; "Date"; "type:date"; "width:80"; "headerCenter"; "center")
	$entry.setLBItemsColumn("durationTraining"; "Dur."; "width:45"; "headerCenter"; "center")
	
	$entry.setValidationRule("comment"; "entryField_comment"; "mandatory"; "trimSpace"; "capitalize")
	
	
	$entry.setLBItemsOrderBy("stmpStart desc")
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:training time"; "unitN:training times")
	$entry.setAddable(False:C215)
	$entry.setPanelAfterProjection("panel_training_projection")
	
	$entry.enableTransaction()
	
	// MARK: -Views
	// MARK: My trainingtimes
	$view:=cs:C1710.sfw_definitionView.new("myTrainingTimes"; "My training times")
	$view.setLBItemsColumn("trainee.trainingSession.training.name"; "Training Task"; "width:300"; "headerLeft")
	$view.setLBItemsColumn("dateStart"; "Date"; "type:date"; "width:80")
	$view.setLBItemsColumn("durationTraining"; "Duration"; "width:50")
	
	$view.setLBItemsOrderBy("dateStart DESC")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:training time"; "unitN:training times")
	$view.setSubset("mytrainingTimes")
	$entry.setView($view)
	
	// MARK: My trainingtimes this week
	$view:=cs:C1710.sfw_definitionView.new(" myWeekTrainingTimes"; "My week administrative times")
	$view.setLBItemsColumn("trainee.trainingSession.training.name"; "Training Task"; "width:300"; "headerLeft")
	$view.setLBItemsColumn("dateStart"; "Date"; "type:date"; "width:80")
	$view.setLBItemsColumn("durationTraining"; "Duration"; "width:50")
	$view.setLBItemsOrderBy("dateStart DESC")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:training time"; "unitN:training times")
	$view.setSubset("myWeekTrainingTimes")
	$entry.setView($view)
	
	
	//MARK:- functions to create subsets for views
Function myTrainingTimes()->$myTrainingTimes : cs:C1710.TrainingTimeSelection
	
	If (cs:C1710.sfw_userManager.me.staff#Null:C1517)
		$myTaskTimes:=ds:C1482.TrainingTime.query("trainee.UUID_Staff = :1"; cs:C1710.sfw_userManager.me.staff.UUID)
	Else 
		$myTaskTimes:=ds:C1482.TrainingTime.all()
	End if 
	
Function myWeekTrainingTimes()->$taskTimes : cs:C1710.TrainingTimeSelection
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
		$queryParts.push("trainee.UUID_Staff = :uuidStaff")
		$querySettings.parameters.uuidStaff:=cs:C1710.sfw_userManager.me.staff.UUID
	End if 
	$queryString:=$queryParts.join(" AND ")
	$taskTimes:=ds:C1482.TrainingTime.query($queryString; $querySettings)