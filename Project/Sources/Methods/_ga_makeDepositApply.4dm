//%attributes = {}

// Purpose: Create a DEP SalesTransaction from undeposited PAY lines and mark them deposited.
// Parameters:
// $paymentUUIDs : Collection — PAY SalesTransaction UUIDs to include
// $caoUUID : Text — bank CAO account UUID
// $memo : Text — deposit memo
// $depositDate : Date — deposit date
// Returns: Object — { success : Boolean, depositUUID : Text, totalDeposited : Real, error : Text }
// created by 4D/PS [2026-june-08]

#DECLARE($paymentUUIDs : Collection; $caoUUID : Text; $memo : Text; $depositDate : Date) -> $result : Object

var $eDep : cs:C1710.SalesTransactionEntity
var $ePay : cs:C1710.SalesTransactionEntity
var $eType : cs:C1710.TransactionTypeEntity
var $eCao : cs:C1710.CAOEntity
var $payUUID : Text
var $totalDeposited : Real
var $res : Object
var $ownTransaction : Boolean

$result:=New object:C1471("success"; False:C215; "depositUUID"; ""; "totalDeposited"; 0; "error"; "")

If ($paymentUUIDs.length=0)
	$result.error:="Select at least one payment to deposit."
	return $result
End if

If (cs:C1710.sfw_string.me.isAnEmptyUUID($caoUUID))
	$result.error:="Select a bank account for the deposit."
	return $result
End if

$eCao:=ds:C1482.CAO.get($caoUUID)
If ($eCao=Null:C1517)
	$result.error:="Bank account not found."
	return $result
End if

$totalDeposited:=0
For each ($payUUID; $paymentUUIDs)
	If (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($payUUID)))
		$ePay:=ds:C1482.SalesTransaction.get($payUUID)
		If ($ePay=Null:C1517)
			$result.error:="Payment not found for deposit."
			return $result
		End if
		If (Not:C34($ePay.canIncludeInDeposit()))
			$result.error:="Payment #"+String:C10($ePay.transactionNumber)+" is not available for deposit."
			return $result
		End if
		$totalDeposited:=$totalDeposited+$ePay.depositAmount()
	End if
End for each

If ($totalDeposited<=0)
	$result.error:="Deposit total must be greater than zero."
	return $result
End if

$ownTransaction:=False
If (Transaction level:C961=0)
	ds:C1482.startTransaction()
	$ownTransaction:=True
End if

$eDep:=ds:C1482.SalesTransaction.new()
$eDep.transactionNumber:=ds:C1482.SalesTransaction.nextTransactionNumber()
$eDep.UUID_Customer:=16*"00"
$eType:=ds:C1482.TransactionType.query("code = :1"; "DEP").first()
If ($eType#Null:C1517)
	$eDep.UUID_TransactionType:=$eType.UUID
End if
$eDep.transactionDate:=$depositDate
$eDep.Amount:=$totalDeposited
$eDep.openBalance:=0
$eDep.memo:=$memo
$eDep._ensureMoreData()
$eDep.moreData.UUID_CAO:=$caoUUID
$eDep.moreData.bankAccountName:=$eCao.name
$eDep.moreData.paymentUUIDs:=New collection:C1472()
For each ($payUUID; $paymentUUIDs)
	If (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($payUUID)))
		$eDep.moreData.paymentUUIDs.push($payUUID)
	End if
End for each
$eDep.refreshStatus()

$res:=$eDep.save()
If (Not:C34($res.success))
	If ($ownTransaction)
		ds:C1482.cancelTransaction()
	End if
	$result.error:=$res.statusText
	return $result
End if

For each ($payUUID; $paymentUUIDs)
	If (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($payUUID)))
		$ePay:=ds:C1482.SalesTransaction.get($payUUID)
		$ePay.markDeposited($eDep.UUID)
		$res:=$ePay.save()
		If (Not:C34($res.success))
			If ($ownTransaction)
				ds:C1482.cancelTransaction()
			End if
			$result.error:=$res.statusText
			return $result
		End if
	End if
End for each

If ($ownTransaction)
	ds:C1482.validateTransaction()
End if

$result.success:=True:C214
$result.depositUUID:=$eDep.UUID
$result.totalDeposited:=$totalDeposited
