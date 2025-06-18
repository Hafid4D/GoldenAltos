Class extends Entity

local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=This:C1470.leadCode
	
	
Function get amountText()->$amount : Text
	
	$amount:="$"+String:C10(This:C1470.amount; "###,###,###,#00.00")
	
	
Function get dateCreation()->$createDate : Date
	$createDate:=cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpCreation; True:C214)
	
Function set dateCreation($createDate : Date)
	This:C1470.stmpCreation:=cs:C1710.sfw_stmp.me.build($createDate)
	
Function get dateClose()->$closeDate : Date
	$closeDate:=cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpClose; True:C214)
	
Function set dateClose($closeDate : Date)
	This:C1470.stmpClose:=cs:C1710.sfw_stmp.me.build($closeDate)
	
Function get customerName()->$name : Text
	$name:=This:C1470.customer.name
	
	
Function get stage()->$stage : Text
	var $eLeadStage : cs:C1710.LeadStageEntity
	$eLeadStage:=ds:C1482.LeadStage.query("stageID = :1"; Num:C11(This:C1470.currentStageID)).first()
	$stage:=$eLeadStage.name || "-"
	
	//Mark:-call back functions
local Function beforeSaveCreation()
	This:C1470.leadCode:=This:C1470.calculateCode()
	
	
	
Function calculateCode()->$leadCode : Text
	$leadCode:="L"
	$test:=ds:C1482.sfw_Counter.getNextValue("leadCode")
	
	$leadCode+=String:C10($test; "00000")
	
	
local Function afterCreation()
	// This callback is called after saving the new item
	