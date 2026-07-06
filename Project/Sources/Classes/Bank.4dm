// Purpose: Legacy bank account registry (AC_number → GL account) for AP check posting and import.
// No SFW entry — client mockups (Nov 2025): bank accounts are CAO rows of type Bank, not a separate menu entry.
// modified by 4D/PS [2026-june-29]
Class extends DataClass

// Purpose: Find a bank row by legacy account number (Check_Register.AC_Num).
// Parameters: $acNumber : Text — legacy Bank.AC_number value
// Returns: cs.BankEntity or Null
// created by 4D/PS [2026-june-29]
Function getByAcNumber($acNumber : Text)->$eBank : cs:C1710.BankEntity
	$eBank:=Null:C1517
	If ($acNumber#"")
		$eBank:=This:C1470.query("acNumber = :1"; $acNumber).first()
	End if

// Purpose: Resolve the CAO bank account for a legacy AC_number (via Bank.glAccount or UUID_CAO).
// Parameters: $acNumber : Text — legacy Bank.AC_number value
// Returns: cs.CAOEntity or Null
// created by 4D/PS [2026-june-29]
Function resolveCaoForAcNumber($acNumber : Text)->$eCao : cs:C1710.CAOEntity
	var $eBank : cs:C1710.BankEntity
	
	$eCao:=Null:C1517
	$eBank:=This:C1470.getByAcNumber($acNumber)
	If ($eBank=Null:C1517)
		return $eCao
	End if
	$eCao:=$eBank.resolveGlCao()
