//%attributes = {"executedOnServer":true}

// Purpose: Production migration — seed TransactionType/Status and build initial SalesTransaction from legacy sources.
// Called once from __import_data after purchase order import; ongoing AR lines are created by user workflows.
// Parameters: none.
// Returns: nothing.
// modified by 4D/PS [2026-june-08]

var $types : Collection
var $statuses : Collection
var $i : Integer
var $eType : cs:C1710.TransactionTypeEntity
var $eStatus : cs:C1710.TransactionStatusEntity
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

// Purpose: Clear AR lines before reseeding reference tables (FK-safe order).
// modified by 4D/PS [2026-june-08]
TRUNCATE TABLE:C1051([SalesTransaction:80])

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

ds:C1482.SalesTransaction.rebuildFromSources()
