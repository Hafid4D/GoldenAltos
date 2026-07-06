//%attributes = {}

// Purpose: Post GL journal for an invoice SalesTransaction (Cr income / Dr A/R, optional sales tax line).
// Parameters: $eST : cs.SalesTransactionEntity — INV row just saved
// Returns: Object — { success : Boolean, error : Text }
// created by 4D/PS [2026-june-29]

#DECLARE($eST : cs:C1710.SalesTransactionEntity) -> $result : Object

var $eAR : cs:C1710.CAOEntity
var $eSales : cs:C1710.CAOEntity
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
	$result.error:="Invoice not found for GL posting."
	return $result
End if

If ($eST.typeCode()#"INV")
	$result.error:="Sales transaction is not an invoice."
	return $result
End if

$amount:=Abs:C99(Num:C11($eST.Amount))
If ($amount<=0)
	$result.error:="Invoice amount must be greater than zero."
	return $result
End if

$eAR:=ds:C1482.CAO.getDefaultAR()
$eSales:=ds:C1482.CAO.getDefaultSales()
If ($eAR=Null:C1517) || ($eSales=Null:C1517)
	$result.error:="Default A/R or sales income account is not configured."
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

$groupID:=$eST.UUID+"_inv"

$opts:=New object:C1471(\
	"transactionType"; "Invoice"; \
	"sourceTableNumber"; 80; \
	"sourceRecordID"; $eST.UUID; \
	"creditCaoUUID"; $eSales.UUID; \
	"debitCaoUUID"; $eAR.UUID; \
	"amount"; $netAmount; \
	"journalDate"; $eST.transactionDate; \
	"memo"; String:C10($eST.memo); \
	"entityName"; $customerName; \
	"description"; "Invoice #"+String:C10($eST.transactionNumber); \
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
	$opts:=New object:C1471(\
		"transactionType"; "SalesTax"; \
		"sourceTableNumber"; 80; \
		"sourceRecordID"; $eST.UUID+"_tax"; \
		"creditCaoUUID"; $eTax.UUID; \
		"debitCaoUUID"; $eAR.UUID; \
		"amount"; $taxAmount; \
		"journalDate"; $eST.transactionDate; \
		"memo"; String:C10($eST.memo); \
		"entityName"; $customerName; \
		"description"; "Sales tax invoice #"+String:C10($eST.transactionNumber); \
		"transactionNum"; String:C10($eST.transactionNumber); \
		"groupID"; $groupID)
	$post:=ds:C1482.JournalEntry.postAutoLine($opts)
	If (Not:C34($post.success))
		$result.error:=$post.error
		return $result
	End if
End if

$result.success:=True:C214
