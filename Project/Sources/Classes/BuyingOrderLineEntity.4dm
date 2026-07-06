Class extends Entity


// Purpose: Window title uses legacy bill seq number when available.
// modified by 4D/PS [2026-june-29]
local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=This:C1470.billNumber

// Purpose: Display bill number (legacy Seq_Number preferred over PO number).
// Returns: Text
// modified by 4D/PS [2026-june-29]
local Function get billNumber()->$billNum : Text
	If (This:C1470.seqNumber#0)
		$billNum:=String:C10(This:C1470.seqNumber)
	Else 
		$billNum:=String:C10(This:C1470.boNumber)
	End if

// Purpose: Net bill amount for list, panel and GL (line + freight - discount).
// Returns: Real — rounded net amount
// modified by 4D/PS [2026-june-29]
local Function get netBillAmount()->$amount : Real
	$amount:=Round:C94(Num:C11(This:C1470.lineTotal)+Num:C11(This:C1470.freight)-Num:C11(This:C1470.discount); 2)

local Function get orderDate()->$date : Date
	$date:=This:C1470.orderStmp=0 ? !00-00-00! : cs:C1710.sfw_stmp.me.getDate(This:C1470.orderStmp; True:C214)
	
local Function set orderDate($date : Date)
	This:C1470.orderStmp:=$date=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build($date)
	
local Function get dateIn()->$date : Date
	$date:=This:C1470.inStmp=0 ? !00-00-00! : cs:C1710.sfw_stmp.me.getDate(This:C1470.inStmp; True:C214)
	
local Function set dateIn($date : Date)
	This:C1470.inStmp:=$date=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build($date)
	
local Function get requiredDate()->$date : Date
	$date:=This:C1470.requiredStmp=0 ? !00-00-00! : cs:C1710.sfw_stmp.me.getDate(This:C1470.requiredStmp; True:C214)
	
local Function set requiredDate($date : Date)
	This:C1470.requiredStmp:=$date=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build($date)
	
local Function get paidDate()->$date : Date
	$date:=This:C1470.paidStmp=0 ? !00-00-00! : cs:C1710.sfw_stmp.me.getDate(This:C1470.paidStmp; True:C214)
	
local Function set paidDate($date : Date)
	This:C1470.paidStmp:=$date=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build($date)

// Purpose: Bill recognition date for GL posting (legacy BillRecognitionDate).
// modified by 4D/PS [2026-june-29]
local Function get billRecognitionDate()->$date : Date
	$date:=This:C1470.billRecognitionStmp=0 ? !00-00-00! : cs:C1710.sfw_stmp.me.getDate(This:C1470.billRecognitionStmp; True:C214)

local Function set billRecognitionDate($date : Date)
	This:C1470.billRecognitionStmp:=$date=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build($date)
	
local Function get expectedDeliveryDate()->$date : Date
	$date:=This:C1470.expectedDeliveryStmp=0 ? !00-00-00! : cs:C1710.sfw_stmp.me.getDate(This:C1470.expectedDeliveryStmp; True:C214)
	
local Function set expectedDeliveryDate($date : Date)
	This:C1470.expectedDeliveryStmp:=$date=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build($date)
	
local Function get actualDeliveryDate()->$date : Date
	$date:=This:C1470.actualDeliveryStmp=0 ? !00-00-00! : cs:C1710.sfw_stmp.me.getDate(This:C1470.actualDeliveryStmp; True:C214)
	
local Function set actualDeliveryDate($date : Date)
	This:C1470.actualDeliveryStmp:=$date=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build($date)
	
	
Function get qtyDeliveredMajDelay()->$quantity : Real
	$param:=cs:C1710.goldenAltos_definition_globalParameters.new()
	If (This:C1470.actualDeliveryDate#Null:C1517) && (This:C1470.expectedDeliveryDate#!00-00-00!)
		$quantity:=(This:C1470.actualDeliveryDate>(This:C1470.expectedDeliveryDate+$param.constants.deleveryMinimunDelay)) ? This:C1470.qtyReceived : 0
	End if 
	
Function get qtyDeliveredMinDelay()->$quantity : Real
	If (This:C1470.actualDeliveryDate#Null:C1517) && (This:C1470.expectedDeliveryDate#!00-00-00!)
		$quantity:=(This:C1470.actualDeliveryDate<(This:C1470.expectedDeliveryDate+10)) && (This:C1470.actualDeliveryDate>This:C1470.expectedDeliveryDate) ? This:C1470.qtyReceived : 0
	End if 

// Purpose: Post vendor bill to GL after save (skipped during AP import rebuild).
// modified by 4D/PS [2026-june-29]
local Function afterSave()
	var $res : Object
	
	If (_ga_jeSkipGlPosting())
		return 
	End if
	$res:=_ga_jePostBill(This:C1470)
	If (Not:C34($res.success))
		// Purpose: Do not block AP save — GL misconfiguration is logged server-side for admin follow-up.
		// modified by 4D/PS [2026-june-29]
	End if
	
	
	
	