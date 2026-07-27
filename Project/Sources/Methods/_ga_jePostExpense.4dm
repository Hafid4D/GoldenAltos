//%attributes = {}

// Purpose: Post GL journal for a vendor expense (Dr expense / Cr bank, legacy Internal BUY_ITEMS paid by check).
// Parameters: $eExpense : cs.ExpenseTransactionEntity — imported or saved expense row
// Returns: Object — { success : Boolean, error : Text }
// modified by 4D/PS [2026-june-29]

#DECLARE($eExpense : cs:C1710.ExpenseTransactionEntity) -> $result : Object

var $eExpenseAcc : cs:C1710.CAOEntity
var $eBank : cs:C1710.CAOEntity
var $eCheck : cs:C1710.CheckEntity
var $amount : Real
var $glAcct : Text
var $checkNum : Integer
var $expenseDate : Date
var $vendorName : Text
var $post : Object
var $opts : Object
var $expenseNum : Text
var $acNum : Text

$result:=New object:C1471("success"; False:C215; "error"; "")

If ($eExpense=Null:C1517)
	$result.error:="Expense transaction not found for GL posting."
	return $result
End if

$amount:=Round:C94(Num:C11($eExpense.lineTotal)+Num:C11($eExpense.freight)-Num:C11($eExpense.discount); 2)
$checkNum:=Num:C11($eExpense.checkNumber)
$glAcct:=String:C10($eExpense.glAccount)

If ($amount<=0)
	$result.error:="Expense amount must be greater than zero."
	return $result
End if

If ($checkNum=0)
	$result.error:="Expense is not linked to a check (checkNumber missing)."
	return $result
End if

$eExpenseAcc:=_ga_jeResolveCaoByAcct($glAcct)
If ($eExpenseAcc=Null:C1517)
	$eExpenseAcc:=ds:C1482.CAO.getDefaultPurchases()
End if
If ($eExpenseAcc=Null:C1517)
	$result.error:="Expense account is missing and DefaultPurchases is not configured."
	return $result
End if

$eCheck:=ds:C1482.Check.query("checkNumber = :1"; $checkNum).first()
If ($eCheck=Null:C1517)
	$result.error:="Check #"+String:C10($checkNum)+" was not found for expense posting."
	return $result
End if

If ($eCheck.payee="VOID")
	$result.success:=True:C214
	return $result
End if

_ga_enrichCheckBank($eCheck)
$eBank:=_ga_jeResolveBankCao($eCheck)
If ($eBank=Null:C1517)
	$acNum:=String:C10($eCheck.acNumber)
	$result.error:="Bank GL account could not be resolved for expense check #"+String:C10($checkNum)+" (AC_Num="+$acNum+")."
	return $result
End if

$expenseDate:=$eExpense.paidDate
If ($expenseDate=!00-00-00!)
	$expenseDate:=$eExpense.orderDate
End if
If ($expenseDate=!00-00-00!)
	$expenseDate:=Current date:C33(*)
End if

$vendorName:=String:C10($eExpense.vendorName)
$expenseNum:=String:C10($eExpense.expenseNumber)

$opts:=New object:C1471(\
	"transactionType"; "Expense"; \
	"sourceTableNumber"; 154; \
	"sourceRecordID"; $eExpense.UUID; \
	"creditCaoUUID"; $eBank.UUID; \
	"debitCaoUUID"; $eExpenseAcc.UUID; \
	"amount"; $amount; \
	"journalDate"; $expenseDate; \
	"memo"; String:C10($eExpense.description); \
	"entityName"; $vendorName; \
	"description"; "Expense #"+$expenseNum+" Chk #"+String:C10($checkNum); \
	"transactionNum"; $expenseNum; \
	"groupID"; $eExpense.UUID+"_exp")

$post:=ds:C1482.JournalEntry.postAutoLine($opts)
If (Not:C34($post.success))
	$result.error:=$post.error
	return $result
End if

$result.success:=True:C214
