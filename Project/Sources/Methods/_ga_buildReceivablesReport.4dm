//%attributes = {}

// Purpose: Build receivables report using selectionPrintTemplate.4wp and column mapping.
// Parameters:
// $items : Object — SalesTransactionEntity selection (Form.sfw.lb_items)
// Returns: Object — Write Pro document, or Null when build fails
// modified by 4D/PS [2026-june-08]

#DECLARE($items : Object) -> $wp : Object

var $eST : cs:C1710.SalesTransactionEntity
var $eCustomer : cs:C1710.CustomerEntity
var $lines : Collection
var $line : Object
var $mapping : Collection
var $headerText : Text
var $options : Object
var $buildResult : Object
var $wp : Object
var $table : Object
var $row : Object
var $typeCode : Text
var $totalOpen : Real
var $rowCount : Integer
var $customerName : Text
var $openBalance : Real
var $txnDateTxt : Text
var $dueDateTxt : Text
var $filterLabel : Text

$lines:=New collection:C1472
$totalOpen:=0
$rowCount:=0

For each ($eST; $items)
	$typeCode:=""
	If ($eST.type#Null:C1517)
		$typeCode:=$eST.type.code
	Else
		$typeCode:=$eST.typeCode()
	End if
	// Purpose: Num() avoids "Argument types are incompatible" when openBalance is Null.
	// modified by 4D/PS [2026-june-08]
	$openBalance:=Abs:C99(Num:C11($eST.openBalance))
	If ($typeCode="INV") && ($openBalance#0)
		$totalOpen:=$totalOpen+$openBalance
		$rowCount:=$rowCount+1
		$customerName:=""
		$eCustomer:=$eST.customer
		If ($eCustomer=Null:C1517) && (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($eST.UUID_Customer)))
			$eCustomer:=ds:C1482.Customer.get($eST.UUID_Customer)
		End if
		If ($eCustomer#Null:C1517)
			$customerName:=$eCustomer.name
		End if
		$txnDateTxt:=Choose:C955($eST.transactionDate=!00-00-00!; ""; String:C10($eST.transactionDate))
		$dueDateTxt:=Choose:C955($eST.dueDate=!00-00-00!; ""; String:C10($eST.dueDate))
		$line:=New object:C1471(\
			"customerName"; $customerName; \
			"transactionNumber"; String:C10($eST.transactionNumber); \
			"txnDateTxt"; $txnDateTxt; \
			"dueDateTxt"; $dueDateTxt; \
			"amountTxt"; String:C10(Num:C11($eST.Amount); "###,###,##0.00"); \
			"openBalTxt"; String:C10($openBalance; "###,###,##0.00")\
			)
		$lines.push($line)
	End if
End for each

If ($rowCount=0)
	// Purpose: Build placeholder row without multiline New object — avoids type issues on empty literals.
	// modified by 4D/PS [2026-june-08]
	$line:=New object:C1471
	$line.customerName:="(No open invoices in the current list)"
	$line.transactionNumber:=""
	$line.txnDateTxt:=""
	$line.dueDateTxt:=""
	$line.amountTxt:=""
	$line.openBalTxt:=""
	$lines.push($line)
End if

// Purpose: Column mapping for open-invoice lines (plain text fields on each collection item).
// modified by 4D/PS [2026-june-08]
$mapping:=New collection:C1472
$mapping.push(New object:C1471("header"; "Customer"; "source"; "This.item.customerName"; "width"; "6.5cm"; "align"; "left"))
$mapping.push(New object:C1471("header"; "Num"; "source"; "This.item.transactionNumber"; "width"; "1.1cm"; "align"; "right"))
$mapping.push(New object:C1471("header"; "Date"; "source"; "This.item.txnDateTxt"; "width"; "2cm"; "align"; "left"))
$mapping.push(New object:C1471("header"; "Due"; "source"; "This.item.dueDateTxt"; "width"; "2cm"; "align"; "left"))
$mapping.push(New object:C1471("header"; "Amount"; "source"; "This.item.amountTxt"; "width"; "2.45cm"; "align"; "right"))
$mapping.push(New object:C1471("header"; "Open Balance"; "source"; "This.item.openBalTxt"; "width"; "2.45cm"; "align"; "right"))

$headerText:="Receivables Report — "+String:C10(Current date:C33(*))+Char:C90(Carriage return:K15:38)
$headerText:=$headerText+"Count : "+String:C10($rowCount)+Char:C90(Carriage return:K15:38)
$filterLabel:=_ga_getListFiltersValues("TransactionType"; "UUID")
$headerText:=$headerText+"Type : "+$filterLabel+Char:C90(Carriage return:K15:38)
$filterLabel:=_ga_getListFiltersValues("TransactionStatus"; "UUID")
$headerText:=$headerText+"Status : "+$filterLabel+Char:C90(Carriage return:K15:38)
$filterLabel:=_ga_getListFiltersValues("Customer"; "UUID")
$headerText:=$headerText+"Customer : "+$filterLabel
$options:=New object:C1471("allowEmpty"; True:C214)
$buildResult:=_ga_buildListFromMapping("selectionPrintTemplate.4wp"; $mapping; $lines; $headerText; $options)

If ($buildResult#Null:C1517) && ($buildResult.wp#Null:C1517)
	$wp:=$buildResult.wp
	$table:=$buildResult.table
	$row:=WP Table append row:C1474($table; "TOTAL"; ""; ""; ""; ""; String:C10($totalOpen; "###,###,##0.00"))
	WP SET ATTRIBUTES:C1342($row; wk font bold:K81:68; True:C214)
End if
