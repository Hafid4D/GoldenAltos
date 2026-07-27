//%attributes = {}

// Purpose: Enrich a check with bank GL mapping from imported Bank rows (legacy AC_Num).
// Parameters: $eCheck : cs.CheckEntity — check to update in place
// Returns: Object — { success : Boolean, updated : Boolean, error : Text }
// modified by 4D/PS [2026-june-29]

#DECLARE($eCheck : cs:C1710.CheckEntity) -> $result : Object

var $acNum : Text
var $eBank : cs:C1710.BankEntity
var $eCao : cs:C1710.CAOEntity
var $updated : Boolean
var $emptyUUID : Text

$result:=New object:C1471("success"; False:C215; "updated"; False:C215; "error"; "")
$emptyUUID:=16*"00"

If ($eCheck=Null:C1517)
	$result.error:="Check not found for bank enrichment."
	return $result
End if

$acNum:=String:C10($eCheck.acNumber)
If ($acNum="")
	$result.success:=True:C214
	return $result
End if

$eBank:=ds:C1482.Bank.getByAcNumber($acNum)
If ($eBank=Null:C1517)
	$result.success:=True:C214
	return $result
End if

$updated:=False:C215
If (String:C10($eCheck.bankGlAccount)#String:C10($eBank.glAccount))
	$eCheck.bankGlAccount:=$eBank.glAccount
	$updated:=True:C214
End if

If ($eCheck.bankAccountLabel="")
	$eCheck.bankAccountLabel:=String:C10($eBank.bankName)
	If ($eCheck.bankAccountLabel#"")
		$updated:=True:C214
	End if
End if

$eCao:=$eBank.resolveGlCao()
If ($eCao#Null:C1517)
	If (String:C10($eCheck.UUID_CAO_bank)#String:C10($eCao.UUID))
		$eCheck.UUID_CAO_bank:=$eCao.UUID
		$updated:=True:C214
	End if
Else 
	If (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID(String:C10($eCheck.UUID_CAO_bank))))
		$eCheck.UUID_CAO_bank:=$emptyUUID
		$updated:=True:C214
	End if
End if

$result.success:=True:C214
$result.updated:=$updated
