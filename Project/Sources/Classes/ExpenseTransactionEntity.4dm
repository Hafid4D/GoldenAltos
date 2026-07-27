// Purpose: Entity helpers for ExpenseTransaction (typed legacy Internal BUY_ITEMS fields).
// modified by 4D/PS [2026-june-29]
Class extends Entity

local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=String:C10(This:C1470.expenseNumber)

// Purpose: Ensure moreData is a valid object (barcode only — no legacy blob).
// modified by 4D/PS [2026-june-29]
Function _ensureMoreData()
	If (Value type:C1509(This:C1470.moreData)#Is object:K8:27)
		This:C1470.moreData:=New object:C1471
	End if

local Function get orderDate()->$date : Date
	$date:=This:C1470.orderStmp=0 ? !00-00-00! : cs:C1710.sfw_stmp.me.getDate(This:C1470.orderStmp; True:C214)

local Function set orderDate($date : Date)
	This:C1470.orderStmp:=$date=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build($date)

local Function get paidDate()->$date : Date
	$date:=This:C1470.paidStmp=0 ? !00-00-00! : cs:C1710.sfw_stmp.me.getDate(This:C1470.paidStmp; True:C214)

local Function set paidDate($date : Date)
	This:C1470.paidStmp:=$date=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build($date)

// Purpose: Net expense amount for list and panel display (line + freight - discount).
// Returns: Real — rounded net amount
// modified by 4D/PS [2026-june-29]
local Function get netAmount()->$amount : Real
	$amount:=Round:C94(Num:C11(This:C1470.lineTotal)+Num:C11(This:C1470.freight)-Num:C11(This:C1470.discount); 2)

// Purpose: Initialize barcode data when a new record is created in the entry panel.
// modified by 4D/PS [2026-june-29]
local Function loadAfterCreation()
	This:C1470._ensureMoreData()
	This:C1470.moreData.barcodeData:=String:C10(cs:C1710.Util_ScannerManager.me.getBarcodeData(Form:C1466.sfw.entry.dataclass); "0000000000")

// Purpose: Post expense to GL after save (skipped during bulk import).
// modified by 4D/PS [2026-june-29]
local Function afterSave()
	var $res : Object
	
	If (_ga_jeSkipGlPosting())
		return 
	End if
	$res:=_ga_jePostExpense(This:C1470)
	If (Not:C34($res.success))
		// Purpose: Do not block save — GL misconfiguration is logged server-side for admin follow-up.
		// modified by 4D/PS [2026-june-29]
	End if
