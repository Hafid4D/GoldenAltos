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
		$line:=New object:C1471(\
			"include"; 1; \
			"UUID_Payment"; $md.UUID_Payment; \
			"transactionNumber"; String:C10($md.transactionNumber); \
			"transactionDate"; $md.transactionDate; \
			"typeName"; $md.typeName; \
			"customerName"; $md.customerName; \
			"memo"; $md.memo; \
			"refNo"; $md.refNo; \
			"amount"; Num:C11($md.amount))
		$paymentLines.push($line)
	Else
		If ($md.lineType="otherFund")
			$line:=New object:C1471(\
				"lineNumber"; $eLine.lineNumber; \
				"UUID_Customer"; $md.UUID_Customer; \
				"customerName"; $md.customerName; \
				"UUID_CAO"; $md.UUID_CAO; \
				"accountName"; $md.accountName; \
				"description"; $md.description; \
				"refNo"; $md.refNo; \
				"amount"; Num:C11($md.amount))
			$otherFundLines.push($line)
		Else
			// Purpose: Support legacy import rows stored as moreData.legacy (Deposits / Deposit_Items v18).
			// modified by 4D/PS [2026-june-23]
			If ($md.legacy#Null:C1517)
				$legacy:=$md.legacy
				$invoiceNum:=Num:C11($legacy.Invoice)
				If ($invoiceNum=-1)
					$line:=New object:C1471(\
						"lineNumber"; $eLine.lineNumber; \
						"UUID_Customer"; ""; \
						"customerName"; String:C10($legacy.Customer); \
						"UUID_CAO"; ""; \
						"accountName"; String:C10($legacy.Account); \
						"description"; String:C10($legacy.Division); \
						"refNo"; ""; \
						"amount"; Num:C11($legacy.Amt))
					$otherFundLines.push($line)
				Else
					$line:=New object:C1471(\
						"include"; 1; \
						"UUID_Payment"; ""; \
						"transactionNumber"; String:C10($legacy.Invoice); \
						"transactionDate"; $eDeposit._legacyDateValue($legacy.Deposit_Date); \
						"typeName"; "Payment"; \
						"customerName"; String:C10($legacy.Customer); \
						"memo"; ""; \
						"refNo"; String:C10($legacy.Invoice); \
						"amount"; Num:C11($legacy.Amt))
					$paymentLines.push($line)
				End if
			End if
		End if
	End if
End for each

$data:=New object:C1471("paymentLines"; $paymentLines; "otherFundLines"; $otherFundLines)
