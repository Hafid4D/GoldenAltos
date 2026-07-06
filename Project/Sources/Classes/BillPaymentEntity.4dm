// Purpose: Entity helpers for BillPayment (typed legacy PartialPays fields).
// modified by 4D/PS [2026-june-29]
Class extends Entity

local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=String:C10(This:C1470.paymentNumber)

// Purpose: Ensure moreData is a valid object (barcode only — no legacy blob).
// modified by 4D/PS [2026-june-29]
Function _ensureMoreData()
	If (Value type:C1509(This:C1470.moreData)#Is object:K8:27)
		This:C1470.moreData:=New object:C1471
	End if

local Function get paymentDate()->$date : Date
	$date:=This:C1470.paymentDateStmp=0 ? !00-00-00! : cs:C1710.sfw_stmp.me.getDate(This:C1470.paymentDateStmp; True:C214)

local Function set paymentDate($date : Date)
	This:C1470.paymentDateStmp:=$date=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build($date)

local Function get invoiceDate()->$date : Date
	$date:=This:C1470.invoiceDateStmp=0 ? !00-00-00! : cs:C1710.sfw_stmp.me.getDate(This:C1470.invoiceDateStmp; True:C214)

local Function set invoiceDate($date : Date)
	This:C1470.invoiceDateStmp:=$date=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build($date)

// Purpose: Initialize barcode data when a new record is created in the entry panel.
// modified by 4D/PS [2026-june-29]
local Function loadAfterCreation()
	This:C1470._ensureMoreData()
	This:C1470.moreData.barcodeData:=String:C10(cs:C1710.Util_ScannerManager.me.getBarcodeData(Form:C1466.sfw.entry.dataclass); "0000000000")
