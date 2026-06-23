//%attributes = {}

// Purpose: Load open invoices into the Apply Credit Memo dialog.
// Parameters: uses Form (customerUUID, seedCreditMemo, invoiceLines, creditAvailable).
// Returns: nothing.
// created by 4D/PS [2026-june-08]

var $seed : cs:C1710.SalesTransactionEntity
var $eCm : cs:C1710.SalesTransactionEntity
var $eInv : cs:C1710.SalesTransactionEntity
var $eCustomer : cs:C1710.CustomerEntity
var $line : Object
var $absBalance : Real
var $txnKey : Text
var $firstFilled : Boolean

If (Form:C1466.customerUUID=Null:C1517)
	return 
End if 

// Purpose: Refresh header labels from ORDA (list selection may not hydrate customer relation).
// modified by 4D/PS [2026-june-08]
If (Form:C1466.creditMemoUUID#Null:C1517) && (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID(Form:C1466.creditMemoUUID)))
	$eCm:=ds:C1482.SalesTransaction.get(Form:C1466.creditMemoUUID)
	If ($eCm#Null:C1517)
		Form:C1466.creditMemoNumber:=String:C10($eCm.transactionNumber)
		If ($eCm.customer#Null:C1517)
			Form:C1466.customerName:=$eCm.customer.name
		Else
			If (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($eCm.UUID_Customer)))
				Form:C1466.customerUUID:=$eCm.UUID_Customer
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

$seed:=Form:C1466.seedCreditMemo
Form:C1466.invoiceLines:=New collection:C1472()
Form:C1466.invoiceUUIDByNumber:=New object:C1471()
$firstFilled:=False

For each ($eInv; ds:C1482.SalesTransaction.getOpenInvoicesForCustomer(Form:C1466.customerUUID))
	$absBalance:=Abs:C99($eInv.openBalance)
	$line:=New object:C1471(\
		"UUID_Invoice"; $eInv.UUID; \
		"transactionNumber"; $eInv.transactionNumber; \
		"transactionDate"; $eInv.transactionDate; \
		"openBalance"; $absBalance; \
		"applyAmount"; 0)
	// Purpose: Pre-fill the first open invoice up to available credit (QuickBooks-style default).
	// modified by 4D/PS [2026-june-08]
	If (Not:C34($firstFilled)) && ($seed#Null:C1517) && (Form:C1466.creditAvailable#Null:C1517) && (Form:C1466.creditAvailable>0)
		$line.applyAmount:=Choose:C955($absBalance<Form:C1466.creditAvailable; $absBalance; Form:C1466.creditAvailable)
		$firstFilled:=True
	End if
	$txnKey:=String:C10($eInv.transactionNumber)
	Form:C1466.invoiceUUIDByNumber[$txnKey]:=$eInv.UUID
	Form:C1466.invoiceLines.push($line)
	// Purpose: Fallback customer label from the first open invoice when CM has no hydrated customer.
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

If (Form:C1466.creditAvailable=Null:C1517) || (Form:C1466.creditAvailable=0)
	If ($seed#Null:C1517)
		Form:C1466.creditAvailable:=Abs:C99($seed.openBalance)
	End if 
End if

_ga_applyCreditMemoRecalc()
