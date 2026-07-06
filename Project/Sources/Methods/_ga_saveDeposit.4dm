//%attributes = {}

// Purpose: Persist a bank deposit (Deposit + DepositItem rows, DEP SalesTransaction, mark PAY lines deposited).
// Parameters:
// $depositUUID : Text — pre-assigned Deposit UUID from the SFW panel
// $depositNumber : Integer — deposit slip number
// $caoUUID : Text — bank CAO account UUID
// $depositDate : Date — deposit date
// $memo : Text — deposit memo
// $paymentLines : Collection — UI rows with include, UUID_Payment, amount, …
// $otherFundLines : Collection — UI rows with UUID_CAO, amount, description, …
// $cashBackAmount : Real — cash retained from the deposit
// $cashBackCaoUUID : Text — petty cash / cash back CAO account UUID
// $cashBackMemo : Text — cash back description
// Returns: Object — { success : Boolean, depositUUID : Text, totalDeposited : Real, error : Text }
// modified by 4D/PS [2026-june-29]

#DECLARE(\
$depositUUID : Text; \
$depositNumber : Integer; \
$caoUUID : Text; \
$depositDate : Date; \
$memo : Text; \
$paymentLines : Collection; \
$otherFundLines : Collection; \
$cashBackAmount : Real; \
$cashBackCaoUUID : Text; \
$cashBackMemo : Text) -> $result : Object

var $eDeposit : cs:C1710.DepositEntity
var $eLine : cs:C1710.DepositItemEntity
var $eDepST : cs:C1710.SalesTransactionEntity
var $ePay : cs:C1710.SalesTransactionEntity
var $eType : cs:C1710.TransactionTypeEntity
var $eCao : cs:C1710.CAOEntity
var $eCaoCashBack : cs:C1710.CAOEntity
var $line : Object
var $payUUID : Text
var $paymentUUIDs : Collection
var $paymentsTotal : Real
var $otherFundsTotal : Real
var $grossTotal : Real
var $netToBank : Real
var $lineNum : Integer
var $res : Object
var $ownTransaction : Boolean

$result:=New object:C1471("success"; False:C215; "depositUUID"; ""; "totalDeposited"; 0; "error"; "")

If (cs:C1710.sfw_string.me.isAnEmptyUUID($caoUUID))
	$result.error:="Select a bank account for the deposit."
	return $result
End if

$eCao:=ds:C1482.CAO.get($caoUUID)
If ($eCao=Null:C1517)
	$result.error:="Bank account not found."
	return $result
End if

If ($depositDate=Null:C1517) || ($depositDate=!00-00-00!)
	$depositDate:=Current date:C33(*)
End if

$paymentUUIDs:=New collection:C1472()
$paymentsTotal:=0
For each ($line; $paymentLines)
	If ($line.include#Null:C1517) && ($line.include#0)
		$payUUID:=$line.UUID_Payment
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
			$paymentUUIDs.push($payUUID)
			If ($line.amount#Null:C1517)
				$paymentsTotal:=$paymentsTotal+$line.amount
			Else
				$paymentsTotal:=$paymentsTotal+$ePay.depositAmount()
			End if
		End if
	End if
End for each

$otherFundsTotal:=0
For each ($line; $otherFundLines)
	If ($line.amount#Null:C1517) && ($line.amount>0)
		If (cs:C1710.sfw_string.me.isAnEmptyUUID($line.UUID_CAO))
			$result.error:="Each other-funds line requires an account."
			return $result
		End if
		$otherFundsTotal:=$otherFundsTotal+$line.amount
	End if
End for each

$grossTotal:=$paymentsTotal+$otherFundsTotal
If ($grossTotal<=0)
	$result.error:="Deposit total must be greater than zero."
	return $result
End if

If ($cashBackAmount<0)
	$result.error:="Cash back amount cannot be negative."
	return $result
End if

If ($cashBackAmount>$grossTotal)
	$result.error:="Cash back amount cannot exceed the deposit total."
	return $result
End if

If ($cashBackAmount>0)
	If (cs:C1710.sfw_string.me.isAnEmptyUUID($cashBackCaoUUID))
		$result.error:="Select an account for cash back."
		return $result
	End if
	$eCaoCashBack:=ds:C1482.CAO.get($cashBackCaoUUID)
	If ($eCaoCashBack=Null:C1517)
		$result.error:="Cash back account not found."
		return $result
	End if
End if

$netToBank:=$grossTotal-$cashBackAmount

$ownTransaction:=False
If (Transaction level:C961=0)
	ds:C1482.startTransaction()
	$ownTransaction:=True
Else
	// Purpose: Nested transaction so a failed deposit save rolls back without committing partial lines to the SFW transaction.
	// modified by 4D/PS [2026-june-22]
	ds:C1482.startTransaction()
	$ownTransaction:=True
End if

$eDeposit:=ds:C1482.Deposit.get($depositUUID)
If ($eDeposit=Null:C1517)
	$eDeposit:=ds:C1482.Deposit.new()
	$eDeposit.UUID:=$depositUUID
End if
// Purpose: Persist deposit header on typed catalog fields instead of moreData blob.
// modified by 4D/PS [2026-june-26]
$eDeposit.depositNumber:=$depositNumber
$eDeposit.depositDate:=$depositDate
$eDeposit.memo:=$memo
$eDeposit.UUID_CAO_bank:=$caoUUID
$eDeposit.bankAccountLabel:=$eCao.displayLabel()
$eDeposit.cashBackAmount:=$cashBackAmount
$eDeposit.cashBackMemo:=$cashBackMemo
$eDeposit.UUID_CAO_cashBack:=$cashBackCaoUUID
If ($cashBackAmount>0) && ($eCaoCashBack#Null:C1517)
	$eDeposit.cashBackAccountLabel:=$eCaoCashBack.displayLabel()
Else
	$eDeposit.cashBackAccountLabel:=""
End if
$eDeposit.paymentsTotal:=$paymentsTotal
$eDeposit.otherFundsTotal:=$otherFundsTotal
$eDeposit.total:=$grossTotal
$eDeposit.netToBank:=$netToBank
$eDeposit.isSaved:=True:C214

$res:=$eDeposit.save()
If (Not:C34($res.success))
	If ($ownTransaction)
		ds:C1482.cancelTransaction()
	End if
	$result.error:=$res.statusText
	return $result
End if

// Purpose: Replace any prior lines when re-saving the same UUID (should not happen in v1).
// modified by 4D/PS [2026-june-22]
For each ($eLine; ds:C1482.DepositItem.query("UUID_Deposit = :1"; $eDeposit.UUID))
	$eLine.drop()
End for each

$lineNum:=0
For each ($line; $paymentLines)
	If ($line.include#Null:C1517) && ($line.include#0)
		$payUUID:=$line.UUID_Payment
		If (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($payUUID)))
			$lineNum:=$lineNum+1
			$eLine:=ds:C1482.DepositItem.new()
			$eLine.UUID_Deposit:=$eDeposit.UUID
			$eLine.lineNumber:=$lineNum
			$eLine.lineType:="payment"
			$eLine.UUID_Payment:=$payUUID
			$eLine.amount:=Num:C11($line.amount)
			$eLine.customerName:=""
			$eLine.refNo:=""
			$eLine.description:=""
			$eLine.accountLabel:=""
			If ($line.customerName#Null:C1517)
				$eLine.customerName:=String:C10($line.customerName)
			End if
			If ($line.refNo#Null:C1517)
				$eLine.refNo:=String:C10($line.refNo)
			End if
			If ($line.memo#Null:C1517)
				$eLine.description:=String:C10($line.memo)
			End if
			$res:=$eLine.save()
			If (Not:C34($res.success))
				If ($ownTransaction)
					ds:C1482.cancelTransaction()
				End if
				$result.error:=$res.statusText
				return $result
			End if
		End if
	End if
End for each

For each ($line; $otherFundLines)
	If ($line.amount#Null:C1517) && ($line.amount>0)
		$lineNum:=$lineNum+1
		$eLine:=ds:C1482.DepositItem.new()
		$eLine.UUID_Deposit:=$eDeposit.UUID
		$eLine.lineNumber:=$lineNum
		$eLine.lineType:="otherFund"
		$eLine.UUID_Customer:=$line.UUID_Customer
		$eLine.UUID_CAO:=$line.UUID_CAO
		$eLine.amount:=Num:C11($line.amount)
		$eLine.customerName:=""
		$eLine.accountLabel:=""
		$eLine.description:=""
		$eLine.refNo:=""
		$eLine.UUID_Payment:=16*"00"
		If ($line.customerName#Null:C1517)
			$eLine.customerName:=String:C10($line.customerName)
		End if
		If ($line.accountName#Null:C1517)
			$eLine.accountLabel:=String:C10($line.accountName)
		End if
		If ($line.description#Null:C1517)
			$eLine.description:=String:C10($line.description)
		End if
		If ($line.refNo#Null:C1517)
			$eLine.refNo:=String:C10($line.refNo)
		End if
		$res:=$eLine.save()
		If (Not:C34($res.success))
			If ($ownTransaction)
				ds:C1482.cancelTransaction()
			End if
			$result.error:=$res.statusText
			return $result
		End if
	End if
End for each

$eDepST:=ds:C1482.SalesTransaction.new()
$eDepST.transactionNumber:=ds:C1482.SalesTransaction.nextTransactionNumber()
$eDepST.UUID_Customer:=16*"00"
$eType:=ds:C1482.TransactionType.query("code = :1"; "DEP").first()
If ($eType#Null:C1517)
	$eDepST.UUID_TransactionType:=$eType.UUID
End if
$eDepST.transactionDate:=$depositDate
$eDepST.Amount:=$netToBank
$eDepST.openBalance:=0
$eDepST.memo:=$memo
$eDepST._ensureMoreData()
$eDepST.moreData.UUID_CAO:=$caoUUID
$eDepST.moreData.bankAccountName:=$eCao.name
$eDepST.moreData.UUID_Deposit:=$eDeposit.UUID
$eDepST.moreData.paymentUUIDs:=New collection:C1472()
$eDepST.moreData.grossTotal:=$grossTotal
$eDepST.moreData.cashBackAmount:=$cashBackAmount
For each ($payUUID; $paymentUUIDs)
	$eDepST.moreData.paymentUUIDs.push($payUUID)
End for each
$eDepST.refreshStatus()

$res:=$eDepST.save()
If (Not:C34($res.success))
	If ($ownTransaction)
		ds:C1482.cancelTransaction()
	End if
	$result.error:=$res.statusText
	return $result
End if

$eDeposit.UUID_SalesTransaction_DEP:=$eDepST.UUID
$res:=$eDeposit.save()
If (Not:C34($res.success))
	If ($ownTransaction)
		ds:C1482.cancelTransaction()
	End if
	$result.error:=$res.statusText
	return $result
End if

For each ($payUUID; $paymentUUIDs)
	$ePay:=ds:C1482.SalesTransaction.get($payUUID)
	$ePay.markDeposited($eDepST.UUID)
	$ePay._ensureMoreData()
	$ePay.moreData.UUID_Deposit:=$eDeposit.UUID
	$res:=$ePay.save()
	If (Not:C34($res.success))
		If ($ownTransaction)
			ds:C1482.cancelTransaction()
		End if
		$result.error:=$res.statusText
		return $result
	End if
End for each

// Purpose: Post deposit lines to GL (Dr bank / Cr undeposited or income) before commit.
// modified by 4D/PS [2026-june-26]
If (Not:C34(_ga_jePostDeposit($eDeposit; $caoUUID).success))
	If ($ownTransaction)
		ds:C1482.cancelTransaction()
	End if
	$result.error:="The deposit was saved but could not be posted to the general ledger. Please contact your administrator."
	return $result
End if

If ($ownTransaction)
	ds:C1482.validateTransaction()
End if

$result.success:=True:C214
$result.depositUUID:=$eDeposit.UUID
$result.totalDeposited:=$netToBank
