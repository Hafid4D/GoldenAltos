//%attributes = {}

// Purpose: Post GL journal for a vendor bill BuyingOrderLine (Cr A/P / Dr expense, legacy QBXL_ExportBills).
// Parameters: $eLine : cs.BuyingOrderLineEntity — imported or saved AP bill line
// Returns: Object — { success : Boolean, error : Text }
// modified by 4D/PS [2026-june-29]

#DECLARE($eLine : cs:C1710.BuyingOrderLineEntity) -> $result : Object

var $eAP : cs:C1710.CAOEntity
var $eExpense : cs:C1710.CAOEntity
var $amount : Real
var $glAcct : Text
var $billDate : Date
var $billNum : Text
var $vendorName : Text
var $post : Object
var $opts : Object

$result:=New object:C1471("success"; False:C215; "error"; "")

If ($eLine=Null:C1517)
	$result.error:="Bill line not found for GL posting."
	return $result
End if

$amount:=Round:C94(Num:C11($eLine.lineTotal)+Num:C11($eLine.freight)-Num:C11($eLine.discount); 2)

If ($amount<=0)
	$result.error:="Bill amount must be greater than zero."
	return $result
End if

$eAP:=ds:C1482.CAO.getDefaultAP()
If ($eAP=Null:C1517)
	$result.error:="Default A/P account is not configured."
	return $result
End if

$glAcct:=String:C10($eLine.glAccount)
$eExpense:=_ga_jeResolveCaoByAcct($glAcct)
If ($eExpense=Null:C1517)
	$eExpense:=ds:C1482.CAO.getDefaultPurchases()
End if
If ($eExpense=Null:C1517)
	$result.error:="Expense account is missing for bill line and DefaultPurchases is not configured."
	return $result
End if

$billDate:=$eLine.billRecognitionDate
If ($billDate=!00-00-00!)
	$billDate:=$eLine.orderDate
End if
If ($billDate=!00-00-00!)
	$billDate:=$eLine.dateIn
End if
If ($billDate=!00-00-00!)
	$billDate:=Current date:C33(*)
End if

$billNum:=String:C10($eLine.boNumber)
If ($eLine.seqNumber#0)
	$billNum:=String:C10($eLine.seqNumber)
End if

$vendorName:=String:C10($eLine.vendorName)
If ($vendorName="") && ($eLine.buyingOrder#Null:C1517) && ($eLine.buyingOrder.supplier#Null:C1517)
	$vendorName:=String:C10($eLine.buyingOrder.supplier.name)
End if

$opts:=New object:C1471(\
	"transactionType"; "Bill"; \
	"sourceTableNumber"; 64; \
	"sourceRecordID"; $eLine.UUID; \
	"creditCaoUUID"; $eAP.UUID; \
	"debitCaoUUID"; $eExpense.UUID; \
	"amount"; $amount; \
	"journalDate"; $billDate; \
	"memo"; String:C10($eLine.description); \
	"entityName"; $vendorName; \
	"description"; "Bill #"+$billNum; \
	"transactionNum"; $billNum; \
	"groupID"; $eLine.UUID+"_bill")

$post:=ds:C1482.JournalEntry.postAutoLine($opts)
If (Not:C34($post.success))
	$result.error:=$post.error
	return $result
End if

$result.success:=True:C214
