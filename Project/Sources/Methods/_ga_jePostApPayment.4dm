//%attributes = {}

// Purpose: Post GL journal for an AP check payment on one bill line (Cr bank / Dr A/P, legacy check_recon_new3).
// Parameters:
// $eLine : cs.BuyingOrderLineEntity — paid bill line linked by checkNumber
// $eCheck : cs.CheckEntity — check header with bank account fields
// Returns: Object — { success : Boolean, error : Text }
// modified by 4D/PS [2026-june-29]

#DECLARE($eLine : cs:C1710.BuyingOrderLineEntity; $eCheck : cs:C1710.CheckEntity) -> $result : Object

var $eAP : cs:C1710.CAOEntity
var $eBank : cs:C1710.CAOEntity
var $eDiscount : cs:C1710.CAOEntity
var $amount : Real
var $discount : Real
var $payDate : Date
var $payee : Text
var $post : Object
var $opts : Object
var $sourceID : Text
var $billNum : Text
var $bankLabel : Text

$result:=New object:C1471("success"; False:C215; "error"; "")

If ($eLine=Null:C1517) || ($eCheck=Null:C1517)
	$result.error:="Bill line and check are required for AP payment posting."
	return $result
End if

If ($eCheck.payee="VOID")
	$result.success:=True:C214
	return $result
End if

$amount:=Round:C94(Num:C11($eLine.lineTotal)+Num:C11($eLine.freight)-Num:C11($eLine.discount); 2)
$discount:=Round:C94(Num:C11($eLine.discount); 2)

If ($amount<=0)
	$result.success:=True:C214
	return $result
End if

$eAP:=ds:C1482.CAO.getDefaultAP()
If ($eAP=Null:C1517)
	$result.error:="Default A/P account is not configured."
	return $result
End if

$eBank:=_ga_jeResolveBankCao($eCheck)
If ($eBank=Null:C1517)
	$bankLabel:=String:C10($eCheck.acNumber)
	$result.error:="Bank GL account could not be resolved for check #"+String:C10($eCheck.checkNumber)+". Set bankGlAccount or UUID_CAO_bank on the check (AC_Num="+$bankLabel+")."
	return $result
End if

$payDate:=$eLine.paidDate
If ($eCheck.checkDate#!00-00-00!)
	$payDate:=$eCheck.checkDate
End if
If ($payDate=!00-00-00!)
	$payDate:=Current date:C33(*)
End if

$payee:=String:C10($eCheck.payee)

$billNum:=String:C10($eLine.boNumber)
If ($eLine.seqNumber#0)
	$billNum:=String:C10($eLine.seqNumber)
End if

$sourceID:=String:C10($eCheck.checkNumber)+"_"+$eLine.UUID

$opts:=New object:C1471(\
	"transactionType"; "Payment"; \
	"sourceTableNumber"; 151; \
	"sourceRecordID"; $sourceID; \
	"creditCaoUUID"; $eBank.UUID; \
	"debitCaoUUID"; $eAP.UUID; \
	"amount"; $amount; \
	"journalDate"; $payDate; \
	"memo"; "Bill: "+$billNum+" Chk: "+String:C10($eCheck.checkNumber); \
	"entityName"; $payee; \
	"description"; "Bill payment #"+String:C10($eCheck.checkNumber); \
	"transactionNum"; String:C10($eCheck.checkNumber); \
	"groupID"; $sourceID)

$post:=ds:C1482.JournalEntry.postAutoLine($opts)
If (Not:C34($post.success))
	$result.error:=$post.error
	return $result
End if

// Purpose: Post vendor discount taken on payment (Cr discount income / Dr A/P) when discount is non-zero.
// modified by 4D/PS [2026-june-29]
If ($discount>0)
	$eDiscount:=ds:C1482.CAO.getDefaultDiscountIncome()
	If ($eDiscount=Null:C1517)
		$result.error:="Default discount income account is not configured."
		return $result
	End if
	$opts:=New object:C1471(\
		"transactionType"; "Discount"; \
		"sourceTableNumber"; 64; \
		"sourceRecordID"; $eLine.UUID+"_disc"; \
		"creditCaoUUID"; $eDiscount.UUID; \
		"debitCaoUUID"; $eAP.UUID; \
		"amount"; Round:C94($discount; 2); \
		"journalDate"; $payDate; \
		"memo"; $payee+" Discount"; \
		"entityName"; $payee; \
		"description"; "Bill discount #"+$billNum; \
		"transactionNum"; $billNum; \
		"groupID"; $sourceID)
	$post:=ds:C1482.JournalEntry.postAutoLine($opts)
	If (Not:C34($post.success))
		$result.error:=$post.error
		return $result
	End if
End if

$result.success:=True:C214
