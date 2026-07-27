// Purpose: Entity helpers for Bank rows (GL resolution for AP checks and import enrichment).
// No SFW entry — bank accounts are managed via CAO per client mockups; this table is import/support only.
// modified by 4D/PS [2026-june-29]
Class extends Entity

// Purpose: Display label for the linked GL account (CAO name or GLAC fallback).
// Returns: Text
// modified by 4D/PS [2026-june-29]
local Function get glAccountLabel()->$label : Text
	var $eCao : cs:C1710.CAOEntity
	
	$label:=String:C10(This:C1470.glAccount)
	$eCao:=This:C1470.resolveGlCao()
	If ($eCao#Null:C1517)
		$label:=$eCao.displayLabel()
	End if

// Purpose: Resolve the linked CAO row for this bank (UUID_CAO first, then glAccount lookup).
// Returns: cs.CAOEntity or Null
// created by 4D/PS [2026-june-29]
Function resolveGlCao()->$eCao : cs:C1710.CAOEntity
	var $glAcct : Text
	
	$eCao:=Null:C1517
	If (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID(String:C10(This:C1470.UUID_CAO))))
		$eCao:=ds:C1482.CAO.get(String:C10(This:C1470.UUID_CAO))
		If ($eCao#Null:C1517)
			return $eCao
		End if
	End if
	$glAcct:=String:C10(This:C1470.glAccount)
	If ($glAcct#"")
		$eCao:=_ga_jeResolveCaoByAcct($glAcct)
	End if
