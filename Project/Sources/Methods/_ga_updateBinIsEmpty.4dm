//%attributes = {}
// Recalculates isEmpty on every Bin based on whether any linked Inventory has qtyInStock > 0.
// Run manually from the debugger or from a project method.

var $bins : cs:C1710.BinSelection
var $bin : cs:C1710.BinEntity
var $hasStock : Boolean
var $newIsEmpty : Boolean
var $updated; $total : Integer
var $res : Object

$updated:=0
$bins:=ds:C1482.Bin.all()
$total:=$bins.length

For each ($bin; $bins)
	
	$hasStock:=($bin.inventories.query("qtyInStock > :1"; 0).length>0)
	$newIsEmpty:=Not:C34($hasStock)
	
	If ($newIsEmpty#$bin.isEmpty)
		$bin.isEmpty:=$newIsEmpty
		$res:=$bin.save()
		If ($res.success)
			$updated:=$updated+1
		Else 
			TRACE:C157  // pause on save error for inspection
		End if 
	End if 
	
End for each 

If (Storage:C1525.cache=Null:C1517)
	Use (Storage:C1525)
		Storage:C1525.cache:=New shared object:C1526
	End use 
End if 

// Invalidate and reload the bin cache
Use (Storage:C1525.cache)
	Storage:C1525.cache.bins:=Null:C1517
End use 
ds:C1482.Bin.cacheLoad()

ALERT:C41("✅ Done — "+String:C10($updated)+" bin(s) updated out of "+String:C10($total)+" total.")
