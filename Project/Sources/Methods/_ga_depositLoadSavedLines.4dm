//%attributes = {}

// Purpose: Load saved DepositItem rows into panel listbox collections for view mode.
// Parameters:
// $eDeposit : cs.DepositEntity — deposit header
// Returns: Object — { paymentLines : Collection, otherFundLines : Collection }
// modified by 4D/PS [2026-june-23]

#DECLARE($eDeposit : cs:C1710.DepositEntity) -> $data : Object

var $eLine : cs:C1710.DepositItemEntity
var $paymentLines : Collection
var $otherFundLines : Collection
var $line : Object
var $md : Object
var $legacy : Object
var $invoiceNum : Integer

$paymentLines:=New collection:C1472()
$otherFundLines:=New collection:C1472()

For each ($eLine; ds:C1482.DepositItem.query("UUID_Deposit = :1"; $eDeposit.UUID).orderBy("lineNumber"))
	$md:=$eLine.moreData
	If ($md=Null:C1517)
		continue
	End if
	
	If ($md.lineType="payment")
		// Purpose: Build payment line property-by-property with safe Text coercion on moreData fields.
		// modified by 4D/PS [2026-june-23]
		$line:=New object:C1471
		$line.include:=1
		$line.UUID_Payment:=$md.UUID_Payment
		$line.transactionNumber:=_ga_depositPrintAsText($md.transactionNumber)
		$line.transactionDate:=$md.transactionDate
		$line.typeName:=_ga_depositPrintAsText($md.typeName)
		$line.customerName:=_ga_depositPrintAsText($md.customerName)
		$line.memo:=_ga_depositPrintAsText($md.memo)
		$line.refNo:=_ga_depositPrintAsText($md.refNo)
		$line.amount:=Num:C11($md.amount)
		$paymentLines.push($line)
	Else
		If ($md.lineType="otherFund")
			$line:=New object:C1471
			$line.lineNumber:=$eLine.lineNumber
			$line.UUID_Customer:=$md.UUID_Customer
			$line.customerName:=_ga_depositPrintAsText($md.customerName)
			$line.UUID_CAO:=$md.UUID_CAO
			$line.accountName:=_ga_depositPrintAsText($md.accountName)
			$line.description:=_ga_depositPrintAsText($md.description)
			$line.refNo:=_ga_depositPrintAsText($md.refNo)
			$line.amount:=Num:C11($md.amount)
			$otherFundLines.push($line)
		Else
			// Purpose: Legacy import rows — property-by-property + safe Text coercion on JSON fields.
			// modified by 4D/PS [2026-june-23]
			If ($md.legacy#Null:C1517)
				$legacy:=$md.legacy
				$invoiceNum:=Num:C11($legacy.Invoice)
				If ($invoiceNum=-1)
					$line:=New object:C1471
					$line.lineNumber:=$eLine.lineNumber
					$line.UUID_Customer:=""
					$line.customerName:=_ga_depositPrintAsText($legacy.Customer)
					$line.UUID_CAO:=""
					$line.accountName:=_ga_depositPrintAsText($legacy.Account)
					$line.description:=_ga_depositPrintAsText($legacy.Division)
					$line.refNo:=""
					$line.amount:=Num:C11($legacy.Amt)
					$otherFundLines.push($line)
				Else
					$line:=New object:C1471
					$line.include:=1
					$line.UUID_Payment:=""
					$line.transactionNumber:=_ga_depositPrintAsText($legacy.Invoice)
					$line.transactionDate:=$eDeposit._legacyDateValue($legacy.Deposit_Date)
					$line.typeName:="Payment"
					$line.customerName:=_ga_depositPrintAsText($legacy.Customer)
					$line.memo:=""
					$line.refNo:=_ga_depositPrintAsText($legacy.Invoice)
					$line.amount:=Num:C11($legacy.Amt)
					$paymentLines.push($line)
				End if
			End if
		End if
	End if
End for each

$data:=New object:C1471("paymentLines"; $paymentLines; "otherFundLines"; $otherFundLines)
