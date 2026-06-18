//%attributes = {"executedOnServer":true}

// Purpose: Build SalesTransaction rows from already-imported Invoice (PO receivables) and JobInvoice tables.
// Parameters: none.
// Returns: Integer — number of records created.
// created by 4D/PS [2026-june-09]

var $count : Integer
var $seq : Integer
var $eST : cs:C1710.SalesTransactionEntity
var $eInvoice : cs:C1710.InvoiceEntity
var $eJobInvoice : cs:C1710.JobInvoiceEntity
var $typeCode : Text
var $num : Integer
var $amount : Real
var $openBalance : Real
var $parts : Collection
var $eType : cs:C1710.TransactionTypeEntity
var $eStatus : cs:C1710.TransactionStatusEntity
var $info : Object

$count:=0
$seq:=0

TRUNCATE TABLE:C1051([SalesTransaction:80])

// MARK: Invoice (legacy PO receivables)
For each ($eInvoice; ds:C1482.Invoice.all())
	$seq:=$seq+1
	
	$parts:=Split string:C1554($eInvoice.invoice; " "; sk trim spaces:K86:2)
	Case of 
		: ($parts.length=0)
			$typeCode:="INV"
		: ($parts[0]="CM")
			$typeCode:="CM"
		: ($parts[0]="PY")
			$typeCode:="PAY"
		: ($parts[0]="DEP")
			$typeCode:="DEP"
		Else 
			$typeCode:="INV"
	End case 
	
	$num:=Num:C11($parts[$parts.length-1])
	If ($num=0)
		$num:=$seq
	End if 
	
	$amount:=$eInvoice.total
	$openBalance:=$eInvoice.due
	If ($typeCode="CM") && ($amount>0)
		$amount:=-$amount
	End if 
	If ($typeCode="CM") && ($openBalance>0)
		$openBalance:=-$openBalance
	End if 
	If ($typeCode="PAY") && ($amount>0)
		$amount:=-$amount
	End if 
	
	$eST:=ds:C1482.SalesTransaction.new()
	$eST.transactionNumber:=$num
	// Purpose: Resolve customer via PO link, PO name, or legacy Invoice.customerId fallback.
	// modified by 4D/PS [2026-june-08]
	$eST.UUID_Customer:=ds:C1482.SalesTransaction.resolveCustomerUUIDFromInvoice($eInvoice)
	
	$eType:=ds:C1482.TransactionType.query("code = :1"; $typeCode).first()
	If ($eType#Null:C1517)
		$eST.UUID_TransactionType:=$eType.UUID
	End if 
	$eST.stmpTransaction:=$eInvoice.date=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build($eInvoice.date)
	$eST.Amount:=$amount
	$eST.openBalance:=$openBalance
	$eST.memo:=""
	$eST.applyTypeAmountSign($typeCode)
	$eST.refreshStatus()
	// Purpose: Legacy readyToDel maps to CLOSED status (no UUID_Invoice FK on SalesTransaction).
	// modified by 4D/PS [2026-june-09]
	If ($eInvoice.readyToDel)
		$eStatus:=ds:C1482.TransactionStatus.query("code = :1"; "CLOSED").first()
		If ($eStatus#Null:C1517)
			$eST.UUID_TransactionStatus:=$eStatus.UUID
		End if 
	End if 
	
	$info:=$eST.save()
	If ($info.success)
		$count:=$count+1
	End if 
End for each 

// MARK: JobInvoice (customer service billing)
For each ($eJobInvoice; ds:C1482.JobInvoice.all())
	$seq:=$seq+1
	$num:=Num:C11($eJobInvoice.invoiceNumber)
	If ($num=0)
		$num:=$seq+100000
	End if 
	
	$eST:=ds:C1482.SalesTransaction.new()
	$eST.transactionNumber:=$num
	// Purpose: Resolve customer via job, PO, or customer name fallback.
	// modified by 4D/PS [2026-june-08]
	$eST.UUID_Customer:=ds:C1482.SalesTransaction.resolveCustomerUUIDFromJobInvoice($eJobInvoice)
	
	$eType:=ds:C1482.TransactionType.query("code = :1"; "INV").first()
	If ($eType#Null:C1517)
		$eST.UUID_TransactionType:=$eType.UUID
	End if 
	$eST.stmpTransaction:=$eJobInvoice.invoiceStmp
	// Purpose: Use charge components when legacy total field is zero on import.
	// modified by 4D/PS [2026-june-08]
	$amount:=ds:C1482.SalesTransaction.resolveJobInvoiceAmount($eJobInvoice)
	$eST.Amount:=$amount
	$eST.openBalance:=$amount
	$eST.memo:="Job invoice "+$eJobInvoice.invoiceNumber
	$eST.applyTypeAmountSign("INV")
	$eST.refreshStatus()
	
	$info:=$eST.save()
	If ($info.success)
		$count:=$count+1
	End if 
End for each 

$0:=$count
