//%attributes = {}

// Purpose: Post GL journal for a vendor supplier credit (Dr A/P / Cr expense, legacy VendorDebitMemo).
// Parameters: $eCredit : cs.SupplierCreditEntity — imported or saved vendor credit row
// Returns: Object — { success : Boolean, error : Text }
// modified by 4D/PS [2026-june-29]

#DECLARE($eCredit : cs:C1710.SupplierCreditEntity) -> $result : Object

var $eAP : cs:C1710.CAOEntity
var $eCreditAcc : cs:C1710.CAOEntity
var $eBillLine : cs:C1710.BuyingOrderLineEntity
var $amount : Real
var $billNum : Text
var $glAcct : Text
var $creditDate : Date
var $vendorName : Text
var $post : Object
var $opts : Object
var $creditNum : Text

$result:=New object:C1471("success"; False:C215; "error"; "")

If ($eCredit=Null:C1517)
	$result.error:="Supplier credit not found for GL posting."
	return $result
End if

$amount:=Round:C94(Abs:C99(Num:C11($eCredit.amount)); 2)

If ($amount<=0)
	$result.error:="Supplier credit amount must be greater than zero."
	return $result
End if

$eAP:=ds:C1482.CAO.getDefaultAP()
If ($eAP=Null:C1517)
	$result.error:="Default A/P account is not configured."
	return $result
End if

// Purpose: Resolve credit-side account from linked bill GL or DefaultBillCredits (legacy GetCreditAccForVendorDebitMemo).
// modified by 4D/PS [2026-june-29]
$eCreditAcc:=Null:C1517
$eBillLine:=Null:C1517
$billNum:=""
If (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID(String:C10($eCredit.UUID_BuyingOrderLine))))
	$eBillLine:=ds:C1482.BuyingOrderLine.get(String:C10($eCredit.UUID_BuyingOrderLine))
End if
If ($eBillLine=Null:C1517) && ($eCredit.billSeqNumber#0)
	$eBillLine:=ds:C1482.BuyingOrderLine.query("seqNumber = :1"; $eCredit.billSeqNumber).first()
	If ($eBillLine=Null:C1517)
		$eBillLine:=ds:C1482.BuyingOrderLine.query("boNumber = :1"; $eCredit.billSeqNumber).first()
	End if
End if
If ($eBillLine#Null:C1517)
	$billNum:=String:C10($eBillLine.seqNumber)
	If ($billNum="0")
		$billNum:=String:C10($eBillLine.boNumber)
	End if
	$glAcct:=String:C10($eBillLine.glAccount)
	If ($glAcct#"")
		$eCreditAcc:=_ga_jeResolveCaoByAcct($glAcct)
	End if
Else 
	If ($eCredit.billSeqNumber#0)
		$billNum:=String:C10($eCredit.billSeqNumber)
	End if
End if
If ($eCreditAcc=Null:C1517)
	$eCreditAcc:=ds:C1482.CAO.getDefaultBillCredits()
End if
If ($eCreditAcc=Null:C1517)
	$eCreditAcc:=ds:C1482.CAO.getDefaultPurchases()
End if
If ($eCreditAcc=Null:C1517)
	$result.error:="Credit account is missing and DefaultBillCredits / DefaultPurchases are not configured."
	return $result
End if

$creditDate:=$eCredit.creditDate
If ($creditDate=!00-00-00!)
	$creditDate:=Current date:C33(*)
End if

$vendorName:=String:C10($eCredit.vendorName)
$creditNum:=String:C10($eCredit.creditNumber)

$opts:=New object:C1471(\
	"transactionType"; "VendorDebitMemo"; \
	"sourceTableNumber"; 153; \
	"sourceRecordID"; $eCredit.UUID; \
	"creditCaoUUID"; $eCreditAcc.UUID; \
	"debitCaoUUID"; $eAP.UUID; \
	"amount"; $amount; \
	"journalDate"; $creditDate; \
	"memo"; "Vendor debit memo #"+$creditNum; \
	"entityName"; $vendorName; \
	"description"; "Vendor credit #"+$creditNum+If($billNum#""; " Bill #"+$billNum; ""); \
	"transactionNum"; $creditNum; \
	"groupID"; $eCredit.UUID+"_vcm")

$post:=ds:C1482.JournalEntry.postAutoLine($opts)
If (Not:C34($post.success))
	$result.error:=$post.error
	return $result
End if

$result.success:=True:C214
