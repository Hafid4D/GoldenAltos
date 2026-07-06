// Purpose: Entity helpers for SupplierCredit (typed legacy CM_items vendor credit fields).
// modified by 4D/PS [2026-june-29]
Class extends Entity

local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=String:C10(This:C1470.creditNumber)

// Purpose: Ensure moreData is a valid object (barcode only — no legacy blob).
// modified by 4D/PS [2026-june-29]
Function _ensureMoreData()
	If (Value type:C1509(This:C1470.moreData)#Is object:K8:27)
		This:C1470.moreData:=New object:C1471
	End if

local Function get creditDate()->$date : Date
	$date:=This:C1470.creditDateStmp=0 ? !00-00-00! : cs:C1710.sfw_stmp.me.getDate(This:C1470.creditDateStmp; True:C214)

local Function set creditDate($date : Date)
	This:C1470.creditDateStmp:=$date=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build($date)

// Purpose: Display label for the linked bill line (seq number + description).
// Returns: Text — empty when no bill link is resolved
// modified by 4D/PS [2026-june-29]
local Function get linkedBillLabel()->$label : Text
	var $eLine : cs:C1710.BuyingOrderLineEntity
	
	$label:=""
	If (This:C1470.buyingOrderLine#Null:C1517)
		$eLine:=This:C1470.buyingOrderLine
		If ($eLine.seqNumber#0)
			$label:="Bill #"+String:C10($eLine.seqNumber)
		Else 
			$label:="Bill #"+String:C10($eLine.boNumber)
		End if
		If ($eLine.description#"")
			$label:=$label+" — "+String:C10($eLine.description)
		End if
	Else 
		If (This:C1470.billSeqNumber#0)
			$label:="Bill #"+String:C10(This:C1470.billSeqNumber)
		End if
	End if

// Purpose: Initialize barcode data when a new record is created in the entry panel.
// modified by 4D/PS [2026-june-29]
local Function loadAfterCreation()
	This:C1470._ensureMoreData()
	This:C1470.moreData.barcodeData:=String:C10(cs:C1710.Util_ScannerManager.me.getBarcodeData(Form:C1466.sfw.entry.dataclass); "0000000000")

// Purpose: Post vendor supplier credit to GL after save (skipped during bulk import).
// modified by 4D/PS [2026-june-29]
local Function afterSave()
	var $res : Object
	
	If (_ga_jeSkipGlPosting())
		return 
	End if
	$res:=_ga_jePostSupplierCredit(This:C1470)
	If (Not:C34($res.success))
		// Purpose: Do not block save — GL misconfiguration is logged server-side for admin follow-up.
		// modified by 4D/PS [2026-june-29]
	End if
