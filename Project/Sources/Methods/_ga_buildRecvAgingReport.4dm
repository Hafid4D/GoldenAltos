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
var $customerCol : Object
var $numCol : Object
var $bucketCol : Object
var $headerRow : Object
var $colIndex : Integer
var $headerLabels : Collection
var $cell : Object

$wp:=WP New:C1317()
_ga_wpSetPortraitReportPage($wp)
$range:=WP Text range:C1341($wp; wk end text:K81:164; wk end text:K81:164)
WP SET TEXT:C1574($range; "Receivables Aging Report — "+String:C10(Current date:C33(*)); wk append:K81:179)
WP SET ATTRIBUTES:C1342($range; wk font bold:K81:68; True:C214; wk font size:K81:66; 14)

$range:=WP Text range:C1341($wp; wk end text:K81:164; wk end text:K81:164)
$table:=WP Insert table:C1473($range; wk append:K81:179)
$row:=WP Table append row:C1474($table; ""; ""; ""; ""; ""; ""; "")
// Purpose: Set header labels with WP SET TEXT — values like "1-30" are parsed as formulas (1-30=-29) when passed to append row.
// modified by 4D/PS [2026-june-08]
$headerLabels:=New collection:C1472("Customer"; "Num"; "Current"; "1-30"; "31-60"; "61-90"; "90+")
For ($colIndex; 1; 7)
	$cell:=WP Table get cells:C1477($table; $colIndex; 1; 1; 1)
	WP SET TEXT:C1574($cell; $headerLabels[$colIndex-1]; wk replace:K81:177)
End for 

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

// Purpose: Seven-column aging layout ~16.5 cm total (fits A4 portrait with 1 cm page margins).
// modified by 4D/PS [2026-june-08]
$customerCol:=WP Table get columns:C1476($table; 1)
$numCol:=WP Table get columns:C1476($table; 2)
WP SET ATTRIBUTES:C1342($customerCol; wk width:K81:45; "5.5cm"; wk text align:K81:49; wk left:K81:95)
WP SET ATTRIBUTES:C1342($numCol; wk width:K81:45; "1.1cm"; wk text align:K81:49; wk right:K81:96)
For ($colIndex; 3; 7)
	$bucketCol:=WP Table get columns:C1476($table; $colIndex)
	WP SET ATTRIBUTES:C1342($bucketCol; wk width:K81:45; "2.05cm"; wk text align:K81:49; wk right:K81:96)
End for

WP SET ATTRIBUTES:C1342($table; wk font size:K81:66; 9)
$headerRow:=WP Table get rows:C1475($table; 1)
WP SET ATTRIBUTES:C1342($headerRow; wk font bold:K81:68; True:C214)
