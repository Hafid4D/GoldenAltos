// Purpose: Build bill line rows for the check panel (BuyingOrderLine linked by checkNumber).
// Parameters: $checkNumber : Integer — Check.checkNumber
// Returns: Collection — listbox rows { billNumber, vendorName, billDate, glAccount, amount, description }
// modified by 4D/PS [2026-june-29]

#DECLARE($checkNumber : Integer) -> $lines : Collection

var $eLine : cs:C1710.BuyingOrderLineEntity
var $line : Object
var $amount : Real
var $billNum : Text
var $vendorName : Text
var $billDate : Date

$lines:=New collection:C1472()

If ($checkNumber=0)
	return $lines
End if

For each ($eLine; ds:C1482.BuyingOrderLine.query("checkNumber = :1"; $checkNumber))
	$amount:=Round:C94(Num:C11($eLine.lineTotal)+Num:C11($eLine.freight)-Num:C11($eLine.discount); 2)
	
	$billNum:=String:C10($eLine.boNumber)
	If ($eLine.seqNumber#0)
		$billNum:=String:C10($eLine.seqNumber)
	End if
	
	$vendorName:=String:C10($eLine.vendorName)
	If ($vendorName="") && ($eLine.buyingOrder#Null:C1517) && ($eLine.buyingOrder.supplier#Null:C1517)
		$vendorName:=String:C10($eLine.buyingOrder.supplier.name)
	End if
	
	$billDate:=$eLine.orderDate
	If ($billDate=!00-00-00!)
		$billDate:=$eLine.dateIn
	End if
	
	$line:=New object:C1471(\
		"billNumber"; $billNum; \
		"vendorName"; $vendorName; \
		"billDate"; $billDate; \
		"glAccount"; String:C10($eLine.glAccount); \
		"amount"; $amount; \
		"description"; String:C10($eLine.description))
	$lines.push($line)
End for each
