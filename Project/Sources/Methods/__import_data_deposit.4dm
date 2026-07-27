//%attributes = {"executedOnServer":true}

// Purpose: Import Deposit headers and lines from legacy JSON into typed catalog fields (no moreData.legacy blob).
// Parameters: reads DataJson/deposits_export.json and deposit_items_export.json.
// Returns: nothing (truncates and reloads Deposit + DepositItem).
// modified by 4D/PS [2026-june-26]

var $headers : Collection
var $lines : Collection
var $headerFile : 4D:C1709.File
var $linesFile : 4D:C1709.File
var $eDeposit : cs:C1710.DepositEntity
var $eLine : cs:C1710.DepositItemEntity
var $ePay : cs:C1710.SalesTransactionEntity
var $depositBySlip : Object
var $lineNumBySlip : Object
var $customerCache : Object
var $slipNum : Integer
var $lineNum : Integer
var $info : Object
var $record : Object
var $mapped : Object
var $payTotal : Real
var $otherTotal : Real
var $emptyUUID : Text

$depositBySlip:=New object:C1471
$lineNumBySlip:=New object:C1471
$customerCache:=New object:C1471
$emptyUUID:=16*"00"

TRUNCATE TABLE:C1051([DepositItem:149])
TRUNCATE TABLE:C1051([Deposit:148])

$headerFile:=Folder:C1567(fk data folder:K87:12).file("DataJson/deposits_export.json")
If ($headerFile.exists)
	$headers:=JSON Parse:C1218($headerFile.getText())
	For each ($record; $headers)
		$slipNum:=Num:C11($record.Slipnum)
		$eDeposit:=ds:C1482.Deposit.new()
		$eDeposit.depositNumber:=$slipNum
		$eDeposit.depositDate:=_ga_parseLegacyDepositDate($record.DepositDate)
		$eDeposit.memo:=""
		$eDeposit.bankAccountLabel:=""
		$eDeposit.cashBackMemo:=""
		$eDeposit.cashBackAccountLabel:=""
		If (OB Is defined:C1231($record; "DepositMemo"))
			$eDeposit.memo:=String:C10($record.DepositMemo)
		End if
		// Purpose: Legacy Account is the bank account number (not a CAO GLAC); store as text snapshot only.
		// modified by 4D/PS [2026-june-26]
		If (OB Is defined:C1231($record; "Account"))
			$eDeposit.bankAccountLabel:=String:C10($record.Account)
		End if
		// Purpose: Legacy import has no resolvable CAO/ST FK — empty UUID means "optional link not set".
		// bankAccountLabel holds the legacy bank account number for display.
		// modified by 4D/PS [2026-june-26]
		$eDeposit.UUID_CAO_bank:=$emptyUUID
		If (OB Is defined:C1231($record; "TotalReceipt"))
			$eDeposit.total:=Num:C11($record.TotalReceipt)
			$eDeposit.netToBank:=Num:C11($record.TotalReceipt)
		End if
		$eDeposit.cashBackAmount:=0
		$eDeposit.paymentsTotal:=0
		$eDeposit.otherFundsTotal:=0
		$eDeposit.isSaved:=True:C214
		$eDeposit.UUID_CAO_cashBack:=$emptyUUID
		$eDeposit.UUID_SalesTransaction_DEP:=$emptyUUID
		$info:=$eDeposit.save()
		If ($info.success)
			$depositBySlip[String:C10($slipNum)]:=$eDeposit.UUID
		End if
	End for each
End if

$linesFile:=Folder:C1567(fk data folder:K87:12).file("DataJson/deposit_items_export.json")
If ($linesFile.exists)
	$lines:=JSON Parse:C1218($linesFile.getText())
	For each ($record; $lines)
		$slipNum:=Num:C11($record.Slipnum)
		If (OB Is defined:C1231($depositBySlip; String:C10($slipNum)))
			If (Not:C34(OB Is defined:C1231($lineNumBySlip; String:C10($slipNum))))
				$lineNumBySlip[String:C10($slipNum)]:=0
			End if
			$lineNumBySlip[String:C10($slipNum)]:=Num:C11($lineNumBySlip[String:C10($slipNum)])+1
			$lineNum:=Num:C11($lineNumBySlip[String:C10($slipNum)])
			$mapped:=_ga_importDepositResolveLine($record; $customerCache)
			$eLine:=ds:C1482.DepositItem.new()
			$eLine.UUID_Deposit:=$depositBySlip[String:C10($slipNum)]
			$eLine.lineNumber:=$lineNum
			$eLine.amount:=OB Is defined:C1231($record; "Amt") ? Num:C11($record.Amt) : 0
			$eLine.lineType:=String:C10($mapped.lineType)
			$eLine.refNo:=String:C10($mapped.refNo)
			$eLine.description:=String:C10($mapped.description)
			$eLine.customerName:=String:C10($mapped.customerName)
			$eLine.accountLabel:=String:C10($mapped.accountLabel)
			$eLine.UUID_Customer:=String:C10($mapped.UUID_Customer)
			$eLine.UUID_Payment:=String:C10($mapped.UUID_Payment)
			$eLine.UUID_CAO:=String:C10($mapped.UUID_CAO)
			$eLine.save()
			If (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID(String:C10($mapped.UUID_Payment))))
				$ePay:=ds:C1482.SalesTransaction.get(String:C10($mapped.UUID_Payment))
				If ($ePay#Null:C1517)
					$ePay.markDeposited($emptyUUID)
					$ePay.save()
				End if
			End if
		End if
	End for each
End if

For each ($eDeposit; ds:C1482.Deposit.all())
	$payTotal:=0
	$otherTotal:=0
	For each ($eLine; ds:C1482.DepositItem.query("UUID_Deposit = :1"; $eDeposit.UUID))
		If ($eLine.lineType="payment")
			$payTotal:=$payTotal+$eLine.amount
		Else
			If ($eLine.lineType="otherFund")
				$otherTotal:=$otherTotal+$eLine.amount
			End if
		End if
	End for each
	$eDeposit.paymentsTotal:=$payTotal
	$eDeposit.otherFundsTotal:=$otherTotal
	If ($eDeposit.total=0)
		$eDeposit.total:=$payTotal+$otherTotal
	End if
	If ($eDeposit.netToBank=0)
		$eDeposit.netToBank:=$eDeposit.total-$eDeposit.cashBackAmount
	End if
	$eDeposit.save()
End for each
