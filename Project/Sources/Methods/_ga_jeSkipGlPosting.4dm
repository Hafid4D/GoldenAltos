//%attributes = {}

// Purpose: Return True when automatic GL posting must be skipped (e.g. ST import rebuild).
// Returns: Boolean
// created by 4D/PS [2026-june-29]

$skip:=False:C215
If (Storage:C1525.cache#Null:C1517) && (Storage:C1525.cache.skipJePosting#Null:C1517) && (Bool:C1537(Storage:C1525.cache.skipJePosting))
	$skip:=True:C214
End if
