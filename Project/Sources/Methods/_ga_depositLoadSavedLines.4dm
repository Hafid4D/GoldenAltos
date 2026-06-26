//%attributes = {}

// Purpose: Load saved DepositItem rows into panel listbox collections for view mode (typed catalog fields).
// Parameters:
// $eDeposit : cs.DepositEntity — deposit header
// Returns: Object — { paymentLines : Collection, otherFundLines : Collection }
// modified by 4D/PS [2026-june-23]

#DECLARE($eDeposit : cs:C1710.DepositEntity) -> $data : Object

var $eLine : cs:C1710.DepositItemEntity
var $ePay : cs:C1710.SalesTransactionEntity
var $eCustomer : cs:C1710.CustomerEntity
var $eCao : cs:C1710.CAOEntity
var $paymentLines : Collection
var $otherFundLines : Collection
var $line : Object
var $refNo : Text
var $typeName : Text

$paymentLines:=New collection:C1472()
$otherFundLines:=New collection:C1472()

For each ($eLine; ds:C1482.DepositItem.query("UUID_Deposit = :1"; $eDeposit.UUID).orderBy("lineNumber"))
	If ($eLine.lineType="payment")
		$line:=New object:C1471
		$line.include:=1
		$line.UUID_Payment:=$eLine.UUID_Payment
		$line.transactionNumber:=""
		$line.transactionDate:=$eDeposit.depositDate
		$line.typeName:="Payment"
		$line.customerName:=$eLine.customerName
		$line.memo:=$eLine.description
		$line.refNo:=$eLine.refNo
		$line.amount:=$eLine.amount
		If (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($eLine.UUID_Payment)))
			$ePay:=ds:C1482.SalesTransaction.get($eLine.UUID_Payment)
			If ($ePay#Null:C1517)
				$line.UUID_Payment:=$ePay.UUID
				$line.transactionNumber:=String:C10($ePay.transactionNumber)
				$line.transactionDate:=$ePay.transactionDate
				If ($ePay.type#Null:C1517)
					$line.typeName:=$ePay.type.name
				End if
				$line.memo:=$ePay.memo
				$eCustomer:=$ePay.customer
				If ($eCustomer#Null:C1517)
					$line.customerName:=$eCustomer.name
				End if
				$ePay._ensureMoreData()
				// Purpose: Guard refNo read when moreData has no refNo key (imported PAY rows).
				// modified by 4D/PS [2026-june-23]
				If (OB Is defined:C1231($ePay.moreData; "refNo")) && ($ePay.moreData.refNo#Null:C1517)
					$line.refNo:=String:C10($ePay.moreData.refNo)
				End if
				$line.amount:=$ePay.depositAmount()
			End if
		Else
			If ($line.transactionNumber="") && ($line.refNo#"")
				$line.transactionNumber:=$line.refNo
			End if
		End if
		$paymentLines.push($line)
	Else
		If ($eLine.lineType="otherFund")
			$line:=New object:C1471
			$line.lineNumber:=$eLine.lineNumber
			$line.UUID_Customer:=$eLine.UUID_Customer
			$line.customerName:=$eLine.customerName
			$line.UUID_CAO:=$eLine.UUID_CAO
			$line.accountName:=$eLine.accountLabel
			If ($line.accountName="") && (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($eLine.UUID_CAO)))
				$eCao:=ds:C1482.CAO.get($eLine.UUID_CAO)
				If ($eCao#Null:C1517)
					// modified by 4D/PS [2026-june-26]
					$line.accountName:=$eCao.displayLabel()
				End if
			End if
			$line.description:=$eLine.description
			$line.refNo:=$eLine.refNo
			$line.amount:=$eLine.amount
			$otherFundLines.push($line)
		End if
	End if
End for each

$data:=New object:C1471("paymentLines"; $paymentLines; "otherFundLines"; $otherFundLines)
