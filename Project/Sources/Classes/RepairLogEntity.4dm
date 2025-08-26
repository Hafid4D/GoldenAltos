Class extends Entity


local Function get fixedDate()->$fixedDate : Date
	$fixedDate:=cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpFixed; True:C214)
	
local Function set fixedDate($fixedDate : Date)
	This:C1470.stmpFixed:=cs:C1710.sfw_stmp.me.build($fixedDate)
	
local Function get reportDate()->$reportDate : Date
	$reportDate:=cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpReport; True:C214)
	
local Function set reportDate($reportDate : Date)
	This:C1470.stmpReport:=cs:C1710.sfw_stmp.me.build($reportDate)
	
local Function get dateUp()->$dateUp : Date
	$dateUp:=cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpUp; True:C214)
	
local Function set dateUp($dateUp : Date)
	This:C1470.stmpUp:=cs:C1710.sfw_stmp.me.build($dateUp)
	
local Function get upAt()->$upAt : Time
	$upAt:=cs:C1710.sfw_stmp.me.getTime(This:C1470.upAtStmp)
	
local Function set upAt($upAt : Time)
	This:C1470.upAtStmp:=cs:C1710.sfw_stmp.me.build(!00-00-00!; $upAt)
	
local Function get downAt()->$downAt : Time
	$downAt:=cs:C1710.sfw_stmp.me.getTime(This:C1470.downAtStmp)
	
local Function set downAt($downAt : Time)
	This:C1470.downAtStmp:=cs:C1710.sfw_stmp.me.build(!00-00-00!; $downAt)
	
local Function get approvalDate()->$approvalDate : Date
	$approvalDate:=cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpApproval; True:C214)
	
local Function set approvalDate($approvalDate : Date)
	This:C1470.stmpApproval:=cs:C1710.sfw_stmp.me.build($approvalDate)