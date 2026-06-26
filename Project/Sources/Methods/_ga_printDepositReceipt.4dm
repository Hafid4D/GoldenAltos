//%attributes = {}

// Purpose: Print a deposit receipt for the current Deposit panel item (header + payment/other-fund lines).
// Uses selectionPrintTemplate.4wp via _ga_buildListFromMapping (same pattern as receivables report).
// modified by 4D/PS [2026-june-23]

var $eDeposit : cs:C1710.DepositEntity
var $lineData : Object
var $printLines : Collection
var $line : Object
var $printRow : Object
var $mapping : Collection
var $headerText : Text
var $paymentsTotal : Real
var $otherFundsTotal : Real
var $grandTotal : Real
var $cashBack : Real
var $netToBank : Real
var $dateTxt : Text
var $memo : Text
var $reference : Text
var $typeLabel : Text
var $accountLabel : Text
var $lineDateTxt : Text
var $refPart : Text
var $memoPart : Text
var $customerName : Text
var $accountName : Text
var $amountTxt : Text
var $options : Object
var $built : Object
var $colDef : Object

If (Form:C1466.current_item=Null:C1517)
	cs:C1710.sfw_dialog.me.alert("Select a deposit to print.")
Else
	$eDeposit:=Form:C1466.current_item
	
	$lineData:=_ga_depositLoadSavedLines($eDeposit)
	$printLines:=New collection:C1472()
	
	For each ($line; $lineData.paymentLines)
		$typeLabel:="Payment"
		If (OB Is defined:C1231($line; "typeName"))
			$typeLabel:=_ga_depositPrintAsText($line.typeName)
			If ($typeLabel="")
				$typeLabel:="Payment"
			End if
		End if
		$reference:=""
		$refPart:=_ga_depositPrintAsText($line.refNo)
		If ($refPart#"")
			$reference:=$refPart
		End if
		$memoPart:=_ga_depositPrintAsText($line.memo)
		If ($memoPart#"")
			If ($reference#"")
				$reference:=$reference+" — "+$memoPart
			Else
				$reference:=$memoPart
			End if
		End if
		$lineDateTxt:=_ga_depositPrintAsText($line.transactionDate)
		$customerName:=_ga_depositPrintAsText($line.customerName)
		$amountTxt:=_ga_depositFormatMoney($line.amount)
		// Purpose: Build row property-by-property — multiline New object with "" literals can raise #54.
		// modified by 4D/PS [2026-june-23]
		$printRow:=New object:C1471
		$printRow.typeLabel:=$typeLabel
		$printRow.lineDateTxt:=$lineDateTxt
		$printRow.customerName:=$customerName
		$printRow.reference:=$reference
		$printRow.accountName:=""
		$printRow.amountTxt:=$amountTxt
		$printLines.push($printRow)
	End for each
	
	For each ($line; $lineData.otherFundLines)
		$reference:=""
		$refPart:=_ga_depositPrintAsText($line.description)
		If ($refPart#"")
			$reference:=$refPart
		End if
		$memoPart:=_ga_depositPrintAsText($line.refNo)
		If ($memoPart#"")
			If ($reference#"")
				$reference:=$reference+" — "+$memoPart
			Else
				$reference:=$memoPart
			End if
		End if
		$customerName:=_ga_depositPrintAsText($line.customerName)
		$accountName:=_ga_depositPrintAsText($line.accountName)
		$amountTxt:=_ga_depositFormatMoney($line.amount)
		$printRow:=New object:C1471
		$printRow.typeLabel:="Other fund"
		$printRow.lineDateTxt:=""
		$printRow.customerName:=$customerName
		$printRow.reference:=$reference
		$printRow.accountName:=$accountName
		$printRow.amountTxt:=$amountTxt
		$printLines.push($printRow)
	End for each
	
	If ($printLines.length=0)
		cs:C1710.sfw_dialog.me.alert("This deposit has no lines to print.")
	Else
		$paymentsTotal:=Num:C11($eDeposit.paymentsTotal)
		$otherFundsTotal:=Num:C11($eDeposit.otherFundsTotal)
		If ($paymentsTotal=0)
			For each ($line; $lineData.paymentLines)
				$paymentsTotal:=$paymentsTotal+Num:C11($line.amount)
			End for each
		End if
		If ($otherFundsTotal=0)
			For each ($line; $lineData.otherFundLines)
				$otherFundsTotal:=$otherFundsTotal+Num:C11($line.amount)
			End for each
		End if
		
		$grandTotal:=Num:C11($eDeposit.total)
		If ($grandTotal=0)
			$grandTotal:=$paymentsTotal+$otherFundsTotal
		End if
		
		$cashBack:=Num:C11($eDeposit.cashBackAmount)
		$netToBank:=Num:C11($eDeposit.netToBank)
		If ($netToBank=0)
			$netToBank:=$grandTotal-$cashBack
		End if
		
		$dateTxt:=""
		If ($eDeposit.depositDate#!00-00-00!)
			$dateTxt:=String:C10($eDeposit.depositDate)
		End if
		
		$memo:=$eDeposit.memo
		$accountLabel:=$eDeposit.bankAccountLabel
		If ($accountLabel="")
			$accountLabel:=$eDeposit.bankAccountName
		End if
		
		$headerText:="Deposit Receipt"+Char:C90(Carriage return:K15:38)
		$headerText:=$headerText+"Deposit #: "+String:C10($eDeposit.depositNumber)+Char:C90(Carriage return:K15:38)
		If ($dateTxt#"")
			$headerText:=$headerText+"Date: "+$dateTxt+Char:C90(Carriage return:K15:38)
		End if
		$headerText:=$headerText+"Account: "+$accountLabel+Char:C90(Carriage return:K15:38)
		If ($memo#"")
			$headerText:=$headerText+"Memo: "+$memo+Char:C90(Carriage return:K15:38)
		End if
		$headerText:=$headerText+Char:C90(Carriage return:K15:38)
		// Purpose: Num() before String(format) — same pattern as _ga_buildReceivablesReport.
		// modified by 4D/PS [2026-june-23]
		$headerText:=$headerText+"Payments: $"+String:C10(Num:C11($paymentsTotal); "###,###,##0.00")+Char:C90(Carriage return:K15:38)
		$headerText:=$headerText+"Other funds: $"+String:C10(Num:C11($otherFundsTotal); "###,###,##0.00")+Char:C90(Carriage return:K15:38)
		$headerText:=$headerText+"Total: $"+String:C10(Num:C11($grandTotal); "###,###,##0.00")
		If ($cashBack>0)
			$headerText:=$headerText+Char:C90(Carriage return:K15:38)
			$headerText:=$headerText+"Cash back: $"+String:C10(Num:C11($cashBack); "###,###,##0.00")+Char:C90(Carriage return:K15:38)
			$headerText:=$headerText+"Net to bank: $"+String:C10(Num:C11($netToBank); "###,###,##0.00")
		End if
		
		// Purpose: Build mapping with .push() — avoids multiline New object type issues.
		// modified by 4D/PS [2026-june-23]
		$mapping:=New collection:C1472()
		$colDef:=New object:C1471("header"; "Type"; "source"; "This.item.typeLabel"; "width"; "2cm"; "align"; "left")
		$mapping.push($colDef)
		$colDef:=New object:C1471("header"; "Date"; "source"; "This.item.lineDateTxt"; "width"; "2.2cm"; "align"; "left")
		$mapping.push($colDef)
		$colDef:=New object:C1471("header"; "Customer"; "source"; "This.item.customerName"; "width"; "4.5cm"; "align"; "left")
		$mapping.push($colDef)
		$colDef:=New object:C1471("header"; "Ref / Memo"; "source"; "This.item.reference"; "width"; "3.5cm"; "align"; "left")
		$mapping.push($colDef)
		$colDef:=New object:C1471("header"; "Account"; "source"; "This.item.accountName"; "width"; "3.5cm"; "align"; "left")
		$mapping.push($colDef)
		$colDef:=New object:C1471("header"; "Amount"; "source"; "This.item.amountTxt"; "width"; "2.25cm"; "align"; "right")
		$mapping.push($colDef)
		
		// Purpose: Call _ga_buildListFromMapping directly (Collection items) — same as receivables report.
		// modified by 4D/PS [2026-june-23]
		$options:=New object:C1471("allowEmpty"; False:C215)
		$built:=_ga_buildListFromMapping("selectionPrintTemplate.4wp"; $mapping; $printLines; $headerText; $options)
		If ($built#Null:C1517) && ($built.wp#Null:C1517)
			SET PRINT OPTION:C733(Orientation option:K47:2; 1)
			PRINT SETTINGS:C106(2)
			WP PRINT:C1343($built.wp)
		End if
	End if
End if
