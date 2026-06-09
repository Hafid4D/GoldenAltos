//%attributes = {"executedOnServer":true}

// Purpose: Seed TransactionType/Status reference data and build SalesTransaction from imported Invoice rows.
// Parameters: none (reads existing Invoice table populated by __import_purchaseOrders).
// Returns: nothing.
// created by 4D/PS [2026-june-08]

var $types : Collection
var $statuses : Collection
var $i : Integer
var $eType : cs:C1710.TransactionTypeEntity
var $eStatus : cs:C1710.TransactionStatusEntity
var $eST : cs:C1710.SalesTransactionEntity
var $eInvoice : Object
var $typeCode : Text
var $num : Integer
var $seq : Integer
var $amount : Real
var $openBalance : Real

$types:=New collection:C1472(\
	New object:C1471("name"; "Invoice"; "code"; "INV"; "levelID"; 1); \
	New object:C1471("name"; "Credit Note"; "code"; "CM"; "levelID"; 2); \
	New object:C1471("name"; "Payment"; "code"; "PAY"; "levelID"; 3); \
	New object:C1471("name"; "Deposit"; "code"; "DEP"; "levelID"; 4)\
)

$statuses:=New collection:C1472(\
	New object:C1471("name"; "Open"; "code"; "OPEN"; "levelID"; 1); \
	New object:C1471("name"; "Partially Paid"; "code"; "PARTIAL"; "levelID"; 2); \
	New object:C1471("name"; "Paid"; "code"; "PAID"; "levelID"; 3); \
	New object:C1471("name"; "Applied"; "code"; "APPLIED"; "levelID"; 4); \
	New object:C1471("name"; "Closed"; "code"; "CLOSED"; "levelID"; 5)\
)

TRUNCATE TABLE:C1051([TransactionType:87])
For ($i; 0; $types.length-1)
	$eType:=ds:C1482.TransactionType.new()
	$eType.name:=$types[$i].name
	$eType.code:=$types[$i].code
	$eType.levelID:=$types[$i].levelID
	$eType.color:=""
	$eType.save()
End for

TRUNCATE TABLE:C1051([TransactionStatus:88])
For ($i; 0; $statuses.length-1)
	$eStatus:=ds:C1482.TransactionStatus.new()
	$eStatus.name:=$statuses[$i].name
	$eStatus.code:=$statuses[$i].code
	$eStatus.levelID:=$statuses[$i].levelID
	$eStatus.color:=""
	$eStatus.save()
End for

ds:C1482.TransactionType.cacheClear()
ds:C1482.TransactionStatus.cacheClear()

TRUNCATE TABLE:C1051([SalesTransaction:80])
$seq:=0

For each ($eInvoice; ds:C1482.Invoice.all())
	$seq:=$seq+1
	$typeCode:=cs:C1710.SalesTransaction.mapLegacyTypeCode($eInvoice.invoice)
	$num:=cs:C1710.SalesTransaction.parseLegacyTransactionNumber($eInvoice.invoice)
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
	If ($eInvoice.purchaseOrder#Null:C1517)
		$eST.UUID_Customer:=$eInvoice.purchaseOrder.UUID_Customer
	Else
		$eST.UUID_Customer:=16*"00"
	End if
	$eType:=ds:C1482.TransactionType.query("code = :1"; $typeCode).first()
	If ($eType#Null:C1517)
		$eST.UUID_TransactionType:=$eType.UUID
	End if
	$eST.transactionDate:=$eInvoice.date
	$eST.Amount:=$amount
	$eST.openBalance:=$openBalance
	$eST.memo:=""
	$eST.moreData:=New object:C1471(\
		"legacyInvoice"; $eInvoice.invoice; \
		"UUID_Invoice"; $eInvoice.UUID; \
		"amountPaid"; $eInvoice.amountPaid; \
		"slip"; $eInvoice.slip; \
		"readyToDel"; $eInvoice.readyToDel\
		)
	If ($eInvoice.readyToDel)
		$eST.moreData.closed:=True:C214
	End if
	$eST.refreshStatus()
	$eST.save()
End for each
