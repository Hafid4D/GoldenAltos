//%attributes = {"executedOnServer":true}

// Purpose: Post-import AP batch steps — bank enrichment on checks and bill links on supplier credits.
// Parameters: none — runs after all AP sub-ledger tables are loaded.
// Returns: nothing.
// created by 4D/PS [2026-june-29]

var $eCheck : cs:C1710.CheckEntity
var $eCredit : cs:C1710.SupplierCreditEntity
var $eBillLine : cs:C1710.BuyingOrderLineEntity
var $emptyUUID : Text
var $enrich : Object

$emptyUUID:=16*"00"

For each ($eCheck; ds:C1482.Check.all())
	$enrich:=_ga_enrichCheckBank($eCheck)
	If ($enrich.updated)
		$eCheck.save()
	End if
End for each

For each ($eCredit; ds:C1482.SupplierCredit.all())
	If ($eCredit.billSeqNumber=0)
		continue
	End if
	$eBillLine:=ds:C1482.BuyingOrderLine.query("seqNumber = :1"; $eCredit.billSeqNumber).first()
	If ($eBillLine=Null:C1517)
		$eBillLine:=ds:C1482.BuyingOrderLine.query("boNumber = :1"; $eCredit.billSeqNumber).first()
	End if
	If ($eBillLine#Null:C1517)
		If (cs:C1710.sfw_string.me.isAnEmptyUUID(String:C10($eCredit.UUID_BuyingOrderLine)))
			$eCredit.UUID_BuyingOrderLine:=$eBillLine.UUID
			$eCredit.save()
		End if
	End if
End for each
