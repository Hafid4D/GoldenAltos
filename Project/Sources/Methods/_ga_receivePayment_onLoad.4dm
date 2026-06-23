//%attributes = {}

// Purpose: Load open invoices into the Receive Payment dialog and pre-fill the seed invoice line.
// Parameters: uses Form (customerUUID, seedInvoice, invoiceLines, paymentAmount, transactionDate).
// Returns: nothing.
// created by 4D/PS [2026-june-08]

var $seed : cs:C1710.SalesTransactionEntity
var $eInv : cs:C1710.SalesTransactionEntity
var $eSeed : cs:C1710.SalesTransactionEntity
var $eCustomer : cs:C1710.CustomerEntity
var $line : Object
var $absBalance : Real
var $txnKey : Text

If (Form:C1466.customerUUID=Null:C1517)
	return 
End if 

// Purpose: Refresh customer label from ORDA (seed invoice relation may not be hydrated in the dialog).
// modified by 4D/PS [2026-june-08]
$seed:=Form:C1466.seedInvoice
If ($seed#Null:C1517) && (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($seed.UUID)))
	$eSeed:=ds:C1482.SalesTransaction.get($seed.UUID)
	If ($eSeed#Null:C1517)
		If ($eSeed.customer#Null:C1517)
			Form:C1466.customerName:=$eSeed.customer.name
		Else
			If (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($eSeed.UUID_Customer)))
				Form:C1466.customerUUID:=$eSeed.UUID_Customer
			End if
		End if
	End if
End if

If ((Form:C1466.customerName=Null:C1517) || (Form:C1466.customerName="")) && (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID(Form:C1466.customerUUID)))
	$eCustomer:=ds:C1482.Customer.get(Form:C1466.customerUUID)
	If ($eCustomer#Null:C1517)
		Form:C1466.customerName:=$eCustomer.name
	End if
End if

Form:C1466.invoiceLines:=New collection:C1472()
// Purpose: Backup map so listbox edits cannot lose invoice UUIDs needed on confirm.
// modified by 4D/PS [2026-june-08]
Form:C1466.invoiceUUIDByNumber:=New object:C1471()

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
	$txnKey:=String:C10($eInv.transactionNumber)
	Form:C1466.invoiceUUIDByNumber[$txnKey]:=$eInv.UUID
	Form:C1466.invoiceLines.push($line)
	// Purpose: Fallback customer label from the first open invoice when UUID lookup returned empty.
	// modified by 4D/PS [2026-june-08]
	If ((Form:C1466.customerName=Null:C1517) || (Form:C1466.customerName=""))
		If ($eInv.customer#Null:C1517)
			Form:C1466.customerName:=$eInv.customer.name
		Else
			If (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($eInv.UUID_Customer)))
				$eCustomer:=ds:C1482.Customer.get($eInv.UUID_Customer)
				If ($eCustomer#Null:C1517)
					Form:C1466.customerName:=$eCustomer.name
				End if
			End if
		End if
	End if
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
