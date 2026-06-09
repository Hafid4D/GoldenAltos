//%attributes = {"executedOnServer":true}

// Purpose: Import Deposit headers and lines from legacy JSON (Deposits / Deposit_Items).
// Parameters: reads DataJson/deposits_export.json and deposit_items_export.json.
// Returns: nothing (truncates and reloads Deposit + DepositItem).
// created by 4D/PS [2026-june-09]

var $headers : Collection
var $lines : Collection
var $headerFile : 4D:C1709.File
var $linesFile : 4D:C1709.File
var $eDeposit : cs:C1710.DepositEntity
var $eLine : cs:C1710.DepositItemEntity
var $depositBySlip : Object
var $slipNum : Integer
var $lineNum : Integer
var $info : Object

$depositBySlip:=New object:C1471

TRUNCATE TABLE:C1051([DepositItem:149])
TRUNCATE TABLE:C1051([Deposit:148])

$headerFile:=Folder:C1567(fk data folder:K87:12).file("DataJson/deposits_export.json")
If ($headerFile.exists)
	$headers:=JSON Parse:C1218($headerFile.getText())
	For each ($record; $headers)
		$slipNum:=Num:C11($record.Slipnum)
		$eDeposit:=ds:C1482.Deposit.new()
		$eDeposit.depositNumber:=$slipNum
		$eDeposit.moreData:=New object:C1471("legacy"; $record)
		$info:=$eDeposit.save()
		If ($info.success)
			$depositBySlip[String:C10($slipNum)]:=$eDeposit.UUID
		End if
	End for each
End if

$linesFile:=Folder:C1567(fk data folder:K87:12).file("DataJson/deposit_items_export.json")
If ($linesFile.exists)
	$lines:=JSON Parse:C1218($linesFile.getText())
	$lineNum:=0
	For each ($record; $lines)
		$slipNum:=Num:C11($record.Slipnum)
		If (OB Is defined:C1231($depositBySlip; String:C10($slipNum)))
			$lineNum:=$lineNum+1
			$eLine:=ds:C1482.DepositItem.new()
			$eLine.UUID_Deposit:=$depositBySlip[String:C10($slipNum)]
			$eLine.lineNumber:=$lineNum
			$eLine.moreData:=New object:C1471("legacy"; $record)
			$eLine.save()
		End if
	End for each
End if
