//%attributes = {}

// Purpose: Resolve an active CAO row by legacy GL account number (accountNumber field).
// Parameters: $acctNum : Text — chart account number (e.g. 5000-0)
// Returns: cs.CAOEntity or Null when not found
// created by 4D/PS [2026-june-29]

#DECLARE($acctNum : Text) -> $eCao : cs:C1710.CAOEntity

$eCao:=Null:C1517
If ($acctNum#"")
	$eCao:=ds:C1482.CAO.query("accountNumber = :1 AND isInacActive = :2"; $acctNum; False:C215).first()
End if
