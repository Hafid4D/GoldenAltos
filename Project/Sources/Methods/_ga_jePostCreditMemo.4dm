//%attributes = {}

// Purpose: Post GL journal for a credit memo SalesTransaction (Cr credit-memos / Dr A/R, optional tax line).
// Parameters: $eST : cs.SalesTransactionEntity — CM row just saved
// Returns: Object — { success : Boolean, error : Text }
// created by 4D/PS [2026-june-29]

#DECLARE($eST : cs:C1710.SalesTransactionEntity) -> $result : Object

var $eAR : cs:C1710.CAOEntity
var $eCmAcc : cs:C1710.CAOEntity
var $eTax : cs:C1710.CAOEntity
var $amount : Real
var $taxAmount : Real
var $netAmount : Real
var $post : Object
var $opts : Object
var $customerName : Text
var $groupID : Text

$result:=New object:C1471("success"; False:C215; "error"; "")

If ($eST=Null:C1517)
	$result.error:="Credit memo not found for GL posting."
	return $result
End if

If ($eST.typeCode()#"CM")
	$result.error:="Sales transaction is not a credit memo."
	return $result
End if

$amount:=Abs:C99(Num:C11($eST.Amount))
If ($amount<=0)
	$result.error:="Credit memo amount must be greater than zero."
	return $result
End if

$eAR:=ds:C1482.CAO.getDefaultAR()
$eCmAcc:=ds:C1482.CAO.getDefaultCreditMemos()
If ($eAR=Null:C1517) || ($eCmAcc=Null:C1517)
	$result.error:="Default A/R or credit memos account is not configured."
	return $result
End if

$taxAmount:=0
$eST._ensureMoreData()
If ($eST.moreData.salesTaxAmount#Null:C1517)
	$taxAmount:=Num:C11($eST.moreData.salesTaxAmount)
End if
If ($taxAmount<0)
	$taxAmount:=0
End if
If ($taxAmount>$amount)
	$taxAmount:=0
End if
$netAmount:=$amount-$taxAmount

$customerName:=""
If ($eST.customer#Null:C1517)
	$customerName:=String:C10($eST.customer.name)
End if

$groupID:=$eST.UUID+"_cm"

$opts:=New object:C1471(\
	"transactionType"; "Credit Note"; \
	"sourceTableNumber"; 80; \
	"sourceRecordID"; $eST.UUID; \
	"creditCaoUUID"; $eCmAcc.UUID; \
	"debitCaoUUID"; $eAR.UUID; \
	"amount"; $netAmount; \
	"journalDate"; $eST.transactionDate; \
	"memo"; String:C10($eST.memo); \
	"entityName"; $customerName; \
	"description"; "Credit memo #"+String:C10($eST.transactionNumber); \
	"transactionNum"; String:C10($eST.transactionNumber); \
	"groupID"; $groupID)

$post:=ds:C1482.JournalEntry.postAutoLine($opts)
If (Not:C34($post.success))
	$result.error:=$post.error
	return $result
End if

If ($taxAmount>0)
	$eTax:=ds:C1482.CAO.getDefaultSalesTax()
	If ($eTax=Null:C1517)
		$result.error:="Sales tax payable account is not configured."
		return $result
	End if
	// Purpose: Reverse sales tax on credit memo (legacy SalesTaxDebit — Cr A/R / Dr tax payable).
	// modified by 4D/PS [2026-june-29]
	$opts:=New object:C1471(\
		"transactionType"; "SalesTax"; \
		"sourceTableNumber"; 80; \
		"sourceRecordID"; $eST.UUID+"_tax"; \
		"creditCaoUUID"; $eAR.UUID; \
		"debitCaoUUID"; $eTax.UUID; \
		"amount"; $taxAmount; \
		"journalDate"; $eST.transactionDate; \
		"memo"; String:C10($eST.memo); \
		"entityName"; $customerName; \
		"description"; "Sales tax credit memo #"+String:C10($eST.transactionNumber); \
		"transactionNum"; String:C10($eST.transactionNumber); \
		"groupID"; $groupID)
	$post:=ds:C1482.JournalEntry.postAutoLine($opts)
	If (Not:C34($post.success))
		$result.error:=$post.error
		return $result
	End if
End if

$result.success:=True:C214
