//%attributes = {}

// Purpose: Build a Write Pro A/R aging report (standard buckets) from open invoice lines.
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
var $daysPast : Integer
var $openBalance : Real
var $bCurrent : Real
var $b1_30 : Real
var $b31_60 : Real
var $b61_90 : Real
var $b90plus : Real
var $totCurrent : Real
var $tot1_30 : Real
var $tot31_60 : Real
var $tot61_90 : Real
var $tot90plus : Real
var $rowCount : Integer
var $referenceDate : Date

$wp:=WP New:C1317()
$range:=WP Text range:C1341($wp; wk end text:K81:164; wk end text:K81:164)
WP SET TEXT:C1574($range; "Receivables Aging Report — "+String:C10(Current date:C33(*)); wk append:K81:179)
WP SET ATTRIBUTES:C1342($range; wk font bold:K81:68; True:C214; wk font size:K81:66; 14)

$range:=WP Text range:C1341($wp; wk end text:K81:164; wk end text:K81:164)
$table:=WP Insert table:C1473($range; wk append:K81:179)
$row:=WP Table append row:C1474($table; "Customer"; "Num"; "Current"; "1-30"; "31-60"; "61-90"; "90+")

$totCurrent:=0
$tot1_30:=0
$tot31_60:=0
$tot61_90:=0
$tot90plus:=0
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
		// Purpose: Inline days-past-due so aging build works without a separate project method.
		// modified by 4D/PS [2026-june-08]
		$daysPast:=0
		$referenceDate:=$eST.dueDate
		If ($referenceDate=Null:C1517) | ($referenceDate=!00-00-00!)
			$referenceDate:=$eST.transactionDate
		End if
		If ($referenceDate#Null:C1517) && ($referenceDate#!00-00-00!)
			$daysPast:=Num:C11(Current date:C33(*)-$referenceDate)
		End if
		$bCurrent:=0
		$b1_30:=0
		$b31_60:=0
		$b61_90:=0
		$b90plus:=0
		Case of 
			: ($daysPast<=0)
				$bCurrent:=$openBalance
			: ($daysPast<=30)
				$b1_30:=$openBalance
			: ($daysPast<=60)
				$b31_60:=$openBalance
			: ($daysPast<=90)
				$b61_90:=$openBalance
			Else 
				$b90plus:=$openBalance
		End case
		$totCurrent:=$totCurrent+$bCurrent
		$tot1_30:=$tot1_30+$b1_30
		$tot31_60:=$tot31_60+$b31_60
		$tot61_90:=$tot61_90+$b61_90
		$tot90plus:=$tot90plus+$b90plus
		$rowCount:=$rowCount+1
		$customerName:=""
		$eCustomer:=$eST.customer
		If ($eCustomer=Null:C1517) && (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($eST.UUID_Customer)))
			$eCustomer:=ds:C1482.Customer.get($eST.UUID_Customer)
		End if
		If ($eCustomer#Null:C1517)
			$customerName:=$eCustomer.name
		End if
		$row:=WP Table append row:C1474($table; $customerName; String:C10($eST.transactionNumber); String:C10($bCurrent; "###,###,##0.00"); String:C10($b1_30; "###,###,##0.00"); String:C10($b31_60; "###,###,##0.00"); String:C10($b61_90; "###,###,##0.00"); String:C10($b90plus; "###,###,##0.00"))
	End if
End for each

If ($rowCount=0)
	$row:=WP Table append row:C1474($table; "(No open invoices in the current list)"; ""; ""; ""; ""; ""; "")
End if

$row:=WP Table append row:C1474($table; "TOTAL"; ""; String:C10($totCurrent; "###,###,##0.00"); String:C10($tot1_30; "###,###,##0.00"); String:C10($tot31_60; "###,###,##0.00"); String:C10($tot61_90; "###,###,##0.00"); String:C10($tot90plus; "###,###,##0.00"))
WP SET ATTRIBUTES:C1342($row; wk font bold:K81:68; True:C214)
