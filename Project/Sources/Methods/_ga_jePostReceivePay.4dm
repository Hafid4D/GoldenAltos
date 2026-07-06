//%attributes = {}

// Purpose: Post GL journal for a customer receive-payment (Dr Undeposited Funds / Cr A/R).
// Parameters: $ePayment : cs.SalesTransactionEntity — PAY row just saved
// Returns: Object — { success : Boolean, error : Text }
// created by 4D/PS [2026-june-26]

#DECLARE($ePayment : cs:C1710.SalesTransactionEntity) -> $result : Object

var $eAR : cs:C1710.CAOEntity
var $eUndep : cs:C1710.CAOEntity
var $amount : Real
var $post : Object
var $opts : Object
var $customerName : Text

$result:=New object:C1471("success"; False:C215; "error"; "")

If ($ePayment=Null:C1517)
	$result.error:="Payment not found for GL posting."
	return $result
End if

$amount:=Abs:C99(Num:C11($ePayment.Amount))
If ($amount<=0)
	$result.error:="Payment amount must be greater than zero."
	return $result
End if

$eAR:=ds:C1482.CAO.getDefaultAR()
$eUndep:=ds:C1482.CAO.getUndepositedFunds()
If ($eAR=Null:C1517) || ($eUndep=Null:C1517)
	$result.error:="Default A/R or undeposited funds account is not configured."
	return $result
End if

$customerName:=""
If ($ePayment.customer#Null:C1517)
	$customerName:=String:C10($ePayment.customer.name)
End if

$opts:=New object:C1471(\
	"transactionType"; "Payment"; \
	"sourceTableNumber"; 80; \
	"sourceRecordID"; $ePayment.UUID; \
	"creditCaoUUID"; $eAR.UUID; \
	"debitCaoUUID"; $eUndep.UUID; \
	"amount"; $amount; \
	"journalDate"; $ePayment.transactionDate; \
	"memo"; String:C10($ePayment.memo); \
	"entityName"; $customerName; \
	"description"; "Receive payment #"+String:C10($ePayment.transactionNumber); \
	"transactionNum"; String:C10($ePayment.transactionNumber))

$post:=ds:C1482.JournalEntry.postAutoLine($opts)
If (Not:C34($post.success))
	$result.error:=$post.error
	return $result
End if

$ePayment._ensureMoreData()
$ePayment.moreData.UUID_JournalEntry:=String:C10($post.entryUUID)
$result.success:=True:C214
