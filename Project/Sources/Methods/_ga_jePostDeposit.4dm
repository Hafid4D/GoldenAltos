//%attributes = {}

// Purpose: Post GL journals for a bank deposit (Dr Bank / Cr undeposited or income per line; cash back).
// Parameters:
// $eDeposit : cs.DepositEntity — saved deposit header
// $bankCaoUUID : Text — bank CAO UUID
// Returns: Object — { success : Boolean, error : Text }
// created by 4D/PS [2026-june-26]

#DECLARE($eDeposit : cs:C1710.DepositEntity; $bankCaoUUID : Text) -> $result : Object

var $eBank : cs:C1710.CAOEntity
var $eUndep : cs:C1710.CAOEntity
var $eCredit : cs:C1710.CAOEntity
var $eLine : cs:C1710.DepositItemEntity
var $amount : Real
var $post : Object
var $opts : Object
var $desc : Text

$result:=New object:C1471("success"; False:C215; "error"; "")

If ($eDeposit=Null:C1517)
	$result.error:="Deposit not found for GL posting."
	return $result
End if

If (cs:C1710.sfw_string.me.isAnEmptyUUID($bankCaoUUID))
	$result.error:="Bank account is required for deposit posting."
	return $result
End if

$eBank:=ds:C1482.CAO.get($bankCaoUUID)
$eUndep:=ds:C1482.CAO.getUndepositedFunds()
If ($eBank=Null:C1517)
	$result.error:="Bank account not found for deposit posting."
	return $result
End if
If ($eUndep=Null:C1517)
	$result.error:="Undeposited funds account is not configured."
	return $result
End if

For each ($eLine; ds:C1482.DepositItem.query("UUID_Deposit = :1"; $eDeposit.UUID).orderBy("lineNumber"))
	$amount:=Num:C11($eLine.amount)
	If ($amount<=0)
		continue
	End if
	Case of
		: ($eLine.lineType="payment")
			$eCredit:=$eUndep
			$desc:="Deposit payment "+String:C10($eLine.refNo)
		: ($eLine.lineType="otherFund")
			If (cs:C1710.sfw_string.me.isAnEmptyUUID(String:C10($eLine.UUID_CAO)))
				$result.error:="Other-funds line is missing an income account."
				return $result
			End if
			$eCredit:=ds:C1482.CAO.get(String:C10($eLine.UUID_CAO))
			If ($eCredit=Null:C1517)
				$result.error:="Income account not found for deposit line."
				return $result
			End if
			$desc:=String:C10($eLine.description)
		Else
			continue
	End case
	$opts:=New object:C1471(\
		"transactionType"; "Deposit"; \
		"sourceTableNumber"; 149; \
		"sourceRecordID"; $eLine.UUID; \
		"creditCaoUUID"; $eCredit.UUID; \
		"debitCaoUUID"; $eBank.UUID; \
		"amount"; $amount; \
		"journalDate"; $eDeposit.depositDate; \
		"memo"; String:C10($eDeposit.memo); \
		"entityName"; String:C10($eLine.customerName); \
		"description"; $desc; \
		"transactionNum"; String:C10($eDeposit.depositNumber))
	$post:=ds:C1482.JournalEntry.postAutoLine($opts)
	If (Not:C34($post.success))
		$result.error:=$post.error
		return $result
	End if
End for each

If (Num:C11($eDeposit.cashBackAmount)>0)
	If (cs:C1710.sfw_string.me.isAnEmptyUUID(String:C10($eDeposit.UUID_CAO_cashBack)))
		$result.error:="Cash back account is required when cash back amount is entered."
		return $result
	End if
	$eCredit:=ds:C1482.CAO.get(String:C10($eDeposit.UUID_CAO_cashBack))
	If ($eCredit=Null:C1517)
		$result.error:="Cash back account not found."
		return $result
	End if
	$opts:=New object:C1471(\
		"transactionType"; "Deposit"; \
		"sourceTableNumber"; 148; \
		"sourceRecordID"; $eDeposit.UUID+"_cashback"; \
		"creditCaoUUID"; $eBank.UUID; \
		"debitCaoUUID"; $eCredit.UUID; \
		"amount"; Num:C11($eDeposit.cashBackAmount); \
		"journalDate"; $eDeposit.depositDate; \
		"memo"; String:C10($eDeposit.cashBackMemo); \
		"entityName"; ""; \
		"description"; "Cash back"; \
		"transactionNum"; String:C10($eDeposit.depositNumber))
	$post:=ds:C1482.JournalEntry.postAutoLine($opts)
	If (Not:C34($post.success))
		$result.error:=$post.error
		return $result
	End if
End if

$result.success:=True:C214
