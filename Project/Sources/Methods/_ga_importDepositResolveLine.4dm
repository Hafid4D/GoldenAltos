// Purpose: Map one legacy Deposit_Items JSON row onto typed DepositItem FK fields and lineType.
// Legacy Invoice semantics: -1 = other fund; >0 = invoice payment; <-1 = legacy negative payment id.
// Parameters:
// $record : Object — one row from deposit_items_export.json
// $customerCache : Object — optional name→UUID map (mutated when a match is found)
// Returns: Object — { lineType, refNo, description, customerName, accountLabel, UUID_Customer, UUID_Payment, UUID_CAO }
// created by 4D/PS [2026-june-26]

#DECLARE($record : Object; $customerCache : Object) -> $mapped : Object

var $invoiceNum : Integer
var $customerName : Text
var $accountLabel : Text
var $description : Text
var $refNo : Text
var $lineType : Text
var $uuidCustomer : Text
var $uuidPayment : Text
var $uuidCao : Text
var $emptyUUID : Text
var $lookupNum : Integer
var $eCustomer : cs:C1710.CustomerEntity
var $ePay : cs:C1710.SalesTransactionEntity
var $eTypePay : cs:C1710.TransactionTypeEntity

$emptyUUID:=16*"00"
$uuidCustomer:=$emptyUUID
$uuidPayment:=$emptyUUID
$uuidCao:=$emptyUUID
$customerName:=""
$accountLabel:=""
$description:=""
$refNo:=""
$lineType:=""

If (OB Is defined:C1231($record; "Customer"))
	$customerName:=String:C10($record.Customer)
	If ($customerName="?")
		$customerName:=""
	End if
End if

If (OB Is defined:C1231($record; "Account"))
	$accountLabel:=String:C10($record.Account)
End if

$invoiceNum:=OB Is defined:C1231($record; "Invoice") ? Num:C11($record.Invoice) : 0

If ($invoiceNum=-1)
	$lineType:="otherFund"
	If (OB Is defined:C1231($record; "Memo")) && (String:C10($record.Memo)#"")
		$description:=String:C10($record.Memo)
	Else
		If (OB Is defined:C1231($record; "Division"))
			$description:=String:C10($record.Division)
		End if
	End if
Else
	$lineType:="payment"
	$refNo:=String:C10($record.Invoice)
	If (OB Is defined:C1231($record; "Memo")) && (String:C10($record.Memo)#"")
		$description:=String:C10($record.Memo)
	End if
	$lookupNum:=($invoiceNum>0) ? $invoiceNum : Abs:C99($invoiceNum)
	If ($lookupNum>0)
		$eTypePay:=ds:C1482.TransactionType.query("code = :1"; "PAY").first()
		If ($eTypePay#Null:C1517)
			$ePay:=ds:C1482.SalesTransaction.query("UUID_TransactionType = :1 AND transactionNumber = :2"; $eTypePay.UUID; $lookupNum).first()
			If ($ePay#Null:C1517)
				$uuidPayment:=$ePay.UUID
				If ($customerName="")
					$eCustomer:=$ePay.customer
					If ($eCustomer#Null:C1517)
						$customerName:=$eCustomer.name
					End if
				End if
			End if
		End if
	End if
End if

If ($customerName#"")
	If (OB Is defined:C1231($customerCache; $customerName))
		$uuidCustomer:=$customerCache[$customerName]
	Else
		$eCustomer:=ds:C1482.Customer.query("name = :1"; Split string:C1554($customerName; "\r"; sk trim spaces:K86:2).join("\r")).first()
		If ($eCustomer#Null:C1517)
			$uuidCustomer:=$eCustomer.UUID
			$customerCache[$customerName]:=$uuidCustomer
		Else
			$customerCache[$customerName]:=$emptyUUID
		End if
	End if
End if

$mapped:=New object:C1471(\
	"lineType"; $lineType; \
	"refNo"; $refNo; \
	"description"; $description; \
	"customerName"; $customerName; \
	"accountLabel"; $accountLabel; \
	"UUID_Customer"; $uuidCustomer; \
	"UUID_Payment"; $uuidPayment; \
	"UUID_CAO"; $uuidCao)
