//%attributes = {}

// Purpose: Create a DEP SalesTransaction from undeposited PAY lines and mark them deposited (dialog + legacy callers).
// Parameters:
// $paymentUUIDs : Collection — PAY SalesTransaction UUIDs to include
// $caoUUID : Text — bank CAO account UUID
// $memo : Text — deposit memo
// $depositDate : Date — deposit date
// Returns: Object — { success : Boolean, depositUUID : Text, totalDeposited : Real, error : Text }
// modified by 4D/PS [2026-june-22]

#DECLARE($paymentUUIDs : Collection; $caoUUID : Text; $memo : Text; $depositDate : Date) -> $result : Object

var $ePay : cs:C1710.SalesTransactionEntity
var $payUUID : Text
var $paymentLines : Collection
var $line : Object
var $depositUUID : Text
var $depositNumber : Integer
var $refNo : Text
var $typeName : Text
var $customerName : Text

$result:=New object:C1471("success"; False:C215; "depositUUID"; ""; "totalDeposited"; 0; "error"; "")

If ($paymentUUIDs.length=0)
	$result.error:="Select at least one payment to deposit."
	return $result
End if

$paymentLines:=New collection:C1472()
For each ($payUUID; $paymentUUIDs)
	If (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($payUUID)))
		$ePay:=ds:C1482.SalesTransaction.get($payUUID)
		If ($ePay=Null:C1517)
			$result.error:="Payment not found for deposit."
			return $result
		End if
		$refNo:=""
		$ePay._ensureMoreData()
		If ($ePay.moreData.refNo#Null:C1517)
			$refNo:=String:C10($ePay.moreData.refNo)
		End if
		$typeName:="Payment"
		If ($ePay.type#Null:C1517)
			$typeName:=$ePay.type.name
		End if
		$customerName:=""
		If ($ePay.customer#Null:C1517)
			$customerName:=$ePay.customer.name
		End if
		$line:=New object:C1471(\
			"include"; 1; \
			"UUID_Payment"; $ePay.UUID; \
			"transactionNumber"; String:C10($ePay.transactionNumber); \
			"transactionDate"; $ePay.transactionDate; \
			"typeName"; $typeName; \
			"customerName"; $customerName; \
			"memo"; $ePay.memo; \
			"refNo"; $refNo; \
			"amount"; $ePay.depositAmount())
		$paymentLines.push($line)
	End if
End for each

$depositUUID:=Generate UUID:C1066
$depositNumber:=ds:C1482.Deposit.nextDepositNumber()

$result:=_ga_saveDeposit(\
	$depositUUID; \
	$depositNumber; \
	$caoUUID; \
	$depositDate; \
	$memo; \
	$paymentLines; \
	New collection:C1472(); \
	0; \
	""; \
	"")
