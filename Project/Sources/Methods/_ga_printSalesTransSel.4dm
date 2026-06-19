//%attributes = {}

// Purpose: Print the current Sales Transaction list using the standard selection Write Pro template.
// modified by 4D/PS [2026-june-08]

var $context : Object
var $template : Object
var $paragraphs : Collection
var $paragraph : Object
var $range : Object
var $table : Object
var $row : Object
var $rowRange : Object
var $eST : cs:C1710.SalesTransactionEntity
var $eCustomer : cs:C1710.CustomerEntity
var $customerName : Text
var $typeName : Text
var $txnDateTxt : Text
var $rowTxt : Text
var $file : 4D:C1709.File
var $items : Collection
var $itemCount : Integer
var $customerNames : Object
var $typeNames : Object
var $uuids : Collection
var $uuid : Text
var $typeRow : Object
var $progressId : Integer
var $step : Integer
var $largePrintThreshold : Integer

$largePrintThreshold:=500
$items:=Form:C1466.sfw.lb_items
$itemCount:=$items.length

If ($itemCount>0)
	// Purpose: Warn on large selections and suggest Excel export; Write Pro is slow beyond a few hundred rows.
	// modified by 4D/PS [2026-june-08]
	If ($itemCount>$largePrintThreshold)
		If (Not:C34(cs:C1710.sfw_dialog.me.confirm("Printing "+String:C10($itemCount)+" lines may take several minutes. For large lists, Export to Excel is faster. Continue printing?"; "Print"; "Cancel")))
			return 
		End if
	End if
	
	// Purpose: Preload customer and type labels once to avoid per-row ORDA lookups on large selections.
	// modified by 4D/PS [2026-june-08]
	$customerNames:=New object:C1471
	$uuids:=$items.extract("UUID_Customer").distinct()
	For each ($uuid; $uuids)
		If (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($uuid)))
			$customerNames[$uuid]:=""
		End if
	End for each
	If (OB Keys:C1719($customerNames).length>0)
		For each ($eCustomer; ds:C1482.Customer.query("UUID IN :1"; OB Keys:C1719($customerNames)))
			$customerNames[$eCustomer.UUID]:=$eCustomer.name
		End for each
	End if
	
	$typeNames:=New object:C1471
	ds:C1482.TransactionType.cacheLoad()
	If (Storage:C1525.cache#Null:C1517) && (Storage:C1525.cache.transactionType#Null:C1517)
		For each ($typeRow; Storage:C1525.cache.transactionType)
			$typeNames[$typeRow.UUID]:=$typeRow.name
		End for each
	End if
	
	$context:=New object:C1471("subject"; Form:C1466.sfw.view.label)
	$file:=Folder:C1567(fk resources folder:K87:11).file("4DWriteProPrintTemplates/selectionPrintTemplate.4wp")
	$template:=WP Import document:C1318($file.platformPath)
	
	$paragraphs:=WP Get elements:C1550($template; wk type paragraph:K81:191)
	For each ($paragraph; $paragraphs)
		If (WP Get text:C1575($paragraph)="Tabl@")
			$range:=WP Paragraph range:C1346($paragraph)
		End if
	End for each
	
	$table:=WP Insert table:C1473($range; wk replace:K81:177; wk include in range:K81:180)
	$row:=WP Table append row:C1474($table; "Num"; "Type"; "Date"; "Customer"; "Amount"; "Open Balance")
	
	$progressId:=Progress New
	Progress SET TITLE($progressId; "Printing Sales Transactions")
	Progress SET MESSAGE($progressId; "Building table (0/"+String:C10($itemCount)+")")
	
	// Purpose: Insert all data rows in one call, then fill cells — faster than append row per line.
	// modified by 4D/PS [2026-june-08]
	WP Table insert rows:C1691($table; 2; $itemCount)
	
	$step:=0
	For each ($eST; $items)
		$step:=$step+1
		If ($step=$itemCount) | (($step\250)*250=$step)
			Progress SET PROGRESS($progressId; $step/$itemCount)
			Progress SET MESSAGE($progressId; "Building table ("+String:C10($step)+"/"+String:C10($itemCount)+")")
		End if
		
		$customerName:=""
		If ($eST.customer#Null:C1517)
			$customerName:=$eST.customer.name
		Else
			If (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($eST.UUID_Customer)))
				$customerName:=$customerNames[$eST.UUID_Customer]
				If ($customerName=Null:C1517)
					$customerName:=""
				End if
			End if
		End if
		
		$typeName:=""
		If ($eST.type#Null:C1517)
			$typeName:=$eST.type.name
		Else
			If (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($eST.UUID_TransactionType)))
				$typeName:=$typeNames[$eST.UUID_TransactionType]
				If ($typeName=Null:C1517)
					$typeName:=""
				End if
			End if
		End if
		
		$txnDateTxt:=Choose(($eST.transactionDate=Null:C1517) | ($eST.transactionDate=!00-00-00!); ""; String:C10($eST.transactionDate))
		$rowTxt:=String:C10($eST.transactionNumber)+Char:C90(Tab:C9:37)+$typeName+Char:C90(Tab:C9:37)+$txnDateTxt+Char:C90(Tab:C9:37)+$customerName+Char:C90(Tab:C9:37)+String:C10($eST.Amount; "###,###,##0.00")+Char:C90(Tab:C9:37)+String:C10($eST.openBalance; "###,###,##0.00")
		$rowRange:=WP Table get rows:C1475($table; $step+1; 1)
		WP SET TEXT:C1574($rowRange; $rowTxt)
	End for each
	
	Progress QUIT($progressId)
	
	WP SET DATA CONTEXT:C1786($template; $context)
	PRINT SETTINGS:C106(2)
	WP PRINT:C1343($template)
Else
	cs:C1710.sfw_dialog.me.alert(ds:C1482.sfw_readXliff("No items in the list to print"; "No items in the list to print"))
End if
