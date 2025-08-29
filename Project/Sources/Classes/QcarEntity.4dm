Class extends Entity

local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=String:C10(This:C1470.qcarNumber)
	
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
	
local Function getRMA()->$rma_e : cs:C1710.RMAEntity
	If (This:C1470.rmas.length>0)
		$rma_e:=This:C1470.rmas[0]
	End if 
	