Class extends Entity

//local Function beforeSaveCreation()
//This._initCorrectiveActionReport()

local Function loadAfterCreation()
	// This callback is called after creating the new item but before displaying the panel.
	This:C1470.qcarNumber:=ds:C1482.Qcar.all().max("qcarNumber")+1
	
local Function _initCorrectiveActionReport()
	This:C1470.correctiveActionReport:=New object:C1471(\
		"teamLearders"; ""; \
		"supervisor"; ""; \
		"teamMembers"; ""; \
		"d2"; ""; \
		"d3"; ""; \
		"d3TargetDate"; !00-00-00!; \
		"d3ActualDate"; !00-00-00!; \
		"d4"; ""; \
		"d5"; ""; \
		"d6"; ""; \
		"d6TargetDate"; !00-00-00!; \
		"d6ActualDate"; !00-00-00!; \
		"d7"; ""; \
		"d7TargetDate"; !00-00-00!; \
		"d7ActualDate"; !00-00-00!; \
		"controlPlan"; False:C215; \
		"training"; False:C215; \
		"flowchart"; False:C215; \
		"procWork"; False:C215; \
		"addToInternalAudit"; False:C215; \
		"others"; False:C215; \
		"othersText"; ""\
		)
	
	
local Function get closedDate()->$date : Date
	$date:=This:C1470.closedStmp=0 ? !00-00-00! : cs:C1710.sfw_stmp.me.getDate(This:C1470.closedStmp; True:C214)
	
local Function set closedDate($date : Date)
	This:C1470.closedStmp:=$date=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build($date)
	
local Function get verifiedDate()->$date : Date
	$date:=This:C1470.verifiedStmp=0 ? !00-00-00! : cs:C1710.sfw_stmp.me.getDate(This:C1470.verifiedStmp; True:C214)
	
local Function set verifiedDate($date : Date)
	This:C1470.verifiedStmp:=$date=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build($date)
	
local Function get issuedDate()->$date : Date
	$date:=This:C1470.issuedStmp=0 ? !00-00-00! : cs:C1710.sfw_stmp.me.getDate(This:C1470.issuedStmp; True:C214)
	
local Function set issuedDate($date : Date)
	This:C1470.issuedStmp:=$date=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build($date)
	
local Function get submitDate()->$date : Date
	$date:=This:C1470.submitStmp=0 ? !00-00-00! : cs:C1710.sfw_stmp.me.getDate(This:C1470.submitStmp; True:C214)
	
local Function set submitDate($date : Date)
	This:C1470.submitStmp:=$date=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build($date)
	
local Function get targetCloseDate()->$date : Date
	$date:=This:C1470.targetCloseStmp=0 ? !00-00-00! : cs:C1710.sfw_stmp.me.getDate(This:C1470.targetCloseStmp; True:C214)
	
local Function set targetCloseDate($date : Date)
	This:C1470.targetCloseStmp:=$date=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build($date)
	
	
	