//%attributes = {}

// Purpose: Load undeposited PAY lines and default bank account into the Make Deposit dialog.
// created by 4D/PS [2026-june-22]

var $ePay : cs:C1710.SalesTransactionEntity
var $eCao : cs:C1710.CAOEntity
var $eCustomer : cs:C1710.CustomerEntity
var $line : Object
var $customerName : Text

Form:C1466.paymentLines:=New collection:C1472()

For each ($ePay; ds:C1482.SalesTransaction.getUndepositedPayments())
	$customerName:=""
	$eCustomer:=$ePay.customer
	If ($eCustomer=Null:C1517) && (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($ePay.UUID_Customer)))
		$eCustomer:=ds:C1482.Customer.get($ePay.UUID_Customer)
	End if
	If ($eCustomer#Null:C1517)
		$customerName:=$eCustomer.name
	End if
	$line:=New object:C1471(\
		"UUID_Payment"; $ePay.UUID; \
		"transactionNumber"; String:C10($ePay.transactionNumber); \
		"transactionDate"; $ePay.transactionDate; \
		"customerName"; $customerName; \
		"amount"; $ePay.depositAmount(); \
		"include"; 1)
	Form:C1466.paymentLines.push($line)
End for each

If (Form:C1466.paymentLines.length=0)
	cs:C1710.sfw_dialog.me.alert("No undeposited payments are available for deposit.")
	CANCEL:C270
Else
	$eCao:=ds:C1482.CAO.activeCAOs().first()
	If ($eCao#Null:C1517)
		Form:C1466.bankAccountUUID:=$eCao.UUID
		// modified by 4D/PS [2026-june-26]
		Form:C1466.bankAccountName:=$eCao.displayLabel()
	End if
	If (Form:C1466.depositDate=Null:C1517) || (Form:C1466.depositDate=!00-00-00!)
		Form:C1466.depositDate:=Current date:C33(*)
	End if
	_ga_makeDepositRecalc()
End if
