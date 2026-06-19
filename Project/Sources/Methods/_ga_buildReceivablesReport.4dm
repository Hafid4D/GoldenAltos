//%attributes = {}

// Purpose: Build a Write Pro receivables report from open invoice lines in the current list.
// Parameters:
// $items — SalesTransactionEntity selection or collection (Form.sfw.lb_items)
// Returns: Object — Write Pro area (WP)
// modified by 4D/PS [2026-june-08]

#DECLARE($items) -> $wp : Object

var $eST : cs:C1710.SalesTransactionEntity
var $eCustomer : cs:C1710.CustomerEntity
var $range : Object
var $table : Object
var $row : Object
var $customerName : Text
var $typeCode : Text
var $totalOpen : Real
var $openBalance : Real
var $rowCount : Integer
var $txnDateTxt : Text
var $dueDateTxt : Text

$wp:=WP New:C1317()
$range:=WP Text range:C1341($wp; wk end text:K81:164; wk end text:K81:164)
WP SET TEXT:C1574($range; "Receivables Report — "+String:C10(Current date:C33(*)); wk append:K81:179)
WP SET ATTRIBUTES:C1342($range; wk font bold:K81:68; True:C214; wk font size:K81:66; 14)

$range:=WP Text range:C1341($wp; wk end text:K81:164; wk end text:K81:164)
$table:=WP Insert table:C1473($range; wk append:K81:179)
$row:=WP Table append row:C1474($table; "Customer"; "Num"; "Date"; "Due"; "Amount"; "Open Balance")

$totalOpen:=0
$rowCount:=0
For each ($eST; $items)
	$typeCode:=""
	If ($eST.type#Null:C1517)
		$typeCode:=$eST.type.code
	Else
		$typeCode:=$eST.typeCode()
	End if
	If ($typeCode="INV") && ($eST.openBalance#0)
		$openBalance:=Abs:C99($eST.openBalance)
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
		// Purpose: Inline date formatting so report build works without a separate project method.
		// modified by 4D/PS [2026-june-08]
		$txnDateTxt:=Choose(($eST.transactionDate=Null:C1517) | ($eST.transactionDate=!00-00-00!); ""; String:C10($eST.transactionDate))
		$dueDateTxt:=Choose(($eST.dueDate=Null:C1517) | ($eST.dueDate=!00-00-00!); ""; String:C10($eST.dueDate))
		$row:=WP Table append row:C1474($table; $customerName; String:C10($eST.transactionNumber); $txnDateTxt; $dueDateTxt; String:C10($eST.Amount; "###,###,##0.00"); String:C10($openBalance; "###,###,##0.00"))
	End if
End for each

If ($rowCount=0)
	$row:=WP Table append row:C1474($table; "(No open invoices in the current list)"; ""; ""; ""; ""; "")
End if

$row:=WP Table append row:C1474($table; "TOTAL"; ""; ""; ""; ""; String:C10($totalOpen; "###,###,##0.00"))
WP SET ATTRIBUTES:C1342($row; wk font bold:K81:68; True:C214)
