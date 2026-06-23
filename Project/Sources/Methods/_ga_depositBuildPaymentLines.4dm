//%attributes = {}

// Purpose: Build undeposited PAY rows for the deposit panel Select Payment listbox.
// Parameters:
// $customerUUID : Text — optional customer filter (empty = all undeposited payments)
// Returns: Collection — listbox rows with include, UUID_Payment, transactionNumber, …
// created by 4D/PS [2026-june-22]

#DECLARE($customerUUID : Text) -> $lines : Collection

var $ePay : cs:C1710.SalesTransactionEntity
var $eCustomer : cs:C1710.CustomerEntity
var $customerName : Text
var $line : Object
var $refNo : Text
var $typeName : Text

$lines:=New collection:C1472()

For each ($ePay; ds:C1482.SalesTransaction.getUndepositedPayments())
	If (cs:C1710.sfw_string.me.isAnEmptyUUID($customerUUID)) || ($ePay.UUID_Customer=$customerUUID)
		$customerName:=""
		$eCustomer:=$ePay.customer
		If ($eCustomer=Null:C1517) && (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($ePay.UUID_Customer)))
			$eCustomer:=ds:C1482.Customer.get($ePay.UUID_Customer)
		End if
		If ($eCustomer#Null:C1517)
			$customerName:=$eCustomer.name
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
		$lines.push($line)
	End if
End for each
