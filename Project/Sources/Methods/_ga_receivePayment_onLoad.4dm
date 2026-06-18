//%attributes = {}

// Purpose: Load open invoices into the Receive Payment dialog and pre-fill the seed invoice line.
// Parameters: uses Form (customerUUID, seedInvoice, invoiceLines, paymentAmount, transactionDate).
// Returns: nothing.
// created by 4D/PS [2026-june-08]

var $seed : cs:C1710.SalesTransactionEntity
var $eInv : cs:C1710.SalesTransactionEntity
var $eCustomer : cs:C1710.CustomerEntity
var $line : Object
var $absBalance : Real

If (Form:C1466.customerUUID=Null:C1517)
	return 
End if 

// Purpose: Fill customerName when the opener passed UUID only (relation not hydrated).
// modified by 4D/PS [2026-june-08]
If ((Form:C1466.customerName=Null:C1517) || (Form:C1466.customerName="")) && (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID(Form:C1466.customerUUID)))
	$eCustomer:=ds:C1482.Customer.get(Form:C1466.customerUUID)
	If ($eCustomer#Null:C1517)
		Form:C1466.customerName:=$eCustomer.name
	End if
End if

$seed:=Form:C1466.seedInvoice
Form:C1466.invoiceLines:=New collection:C1472()

For each ($eInv; ds:C1482.SalesTransaction.getOpenInvoicesForCustomer(Form:C1466.customerUUID))
	$absBalance:=Abs:C99($eInv.openBalance)
	$line:=New object:C1471(\
		"UUID_Invoice"; $eInv.UUID; \
		"transactionNumber"; $eInv.transactionNumber; \
		"transactionDate"; $eInv.transactionDate; \
		"openBalance"; $absBalance; \
		"applyAmount"; 0)
	If ($seed#Null:C1517) && ($eInv.UUID=$seed.UUID)
		$line.applyAmount:=$absBalance
	End if 
	Form:C1466.invoiceLines.push($line)
End for each 

If (Form:C1466.transactionDate=Null:C1517) || (Form:C1466.transactionDate=!00-00-00!)
	Form:C1466.transactionDate:=Current date:C33(*)
End if

If (Form:C1466.paymentAmount=Null:C1517) || (Form:C1466.paymentAmount=0)
	If ($seed#Null:C1517)
		Form:C1466.paymentAmount:=Abs:C99($seed.openBalance)
	End if 
End if

_ga_receivePayment_recalc()
