//%attributes = {}

// Purpose: Resolve bank CAO for AP check posting from typed check fields or imported Bank table.
// Parameters: $eCheck : cs.CheckEntity — check header with acNumber / bankGlAccount / UUID_CAO_bank
// Returns: cs.CAOEntity or Null when bank GL cannot be resolved
// modified by 4D/PS [2026-june-29]

#DECLARE($eCheck : cs:C1710.CheckEntity) -> $eCao : cs:C1710.CAOEntity

var $acNum : Text
var $glAcct : Text

$eCao:=Null:C1517
If ($eCheck=Null:C1517)
	return $eCao
End if

$glAcct:=String:C10($eCheck.bankGlAccount)
If ($glAcct#"")
	$eCao:=_ga_jeResolveCaoByAcct($glAcct)
	If ($eCao#Null:C1517)
		return $eCao
	End if
End if

If (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID(String:C10($eCheck.UUID_CAO_bank))))
	$eCao:=ds:C1482.CAO.get(String:C10($eCheck.UUID_CAO_bank))
	If ($eCao#Null:C1517)
		return $eCao
	End if
End if

$acNum:=String:C10($eCheck.acNumber)
If ($acNum#"")
	$eCao:=ds:C1482.Bank.resolveCaoForAcNumber($acNum)
	If ($eCao#Null:C1517)
		return $eCao
	End if
	$eCao:=_ga_jeResolveCaoByAcct($acNum)
End if
