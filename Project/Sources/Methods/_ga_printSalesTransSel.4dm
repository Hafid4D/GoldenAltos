//%attributes = {}

// Purpose: Print the current Sales Transaction list (wizard, code mapping, or legacy append-row path).
// Wizard template: Resources/4DWriteProPrintTemplates/salesTransactionPrint.4wp (from 4DWP_Wizard/Templates/salesTransactionSelection.json).
// modified by 4D/PS [2026-june-08]

var $printPath : Integer
var $mapping : Collection
var $headerText : Text
var $context : Object
var $template : Object
var $paragraphs : Collection
var $paragraph : Object
var $range : Object
var $table : Object
var $row : Object
var $eST : cs:C1710.SalesTransactionEntity
var $eCustomer : cs:C1710.CustomerEntity
var $customerName : Text
var $typeName : Text
var $txnDateTxt : Text
var $amountTxt : Text
var $openBalTxt : Text
var $file : 4D:C1709.File
var $items : cs:C1710.SalesTransactionSelection
var $itemCount : Integer
var $customerNames : Object
var $typeNames : Object
var $uuids : Collection
var $uuid : Text
var $typeRow : Object
var $progressId : Integer
var $step : Integer
var $largePrintThreshold : Integer
var $numCol : Object
var $typeCol : Object
var $dateCol : Object
var $customerCol : Object
var $amountCol : Object
var $openBalCol : Object

$largePrintThreshold:=500
$items:=Form:C1466.sfw.lb_items
$itemCount:=$items.length
// Purpose: Switch print engine for UAT — 1=Write Pro wizard, 2=code mapping (_ga_printListFromMapping), 3=legacy append-row.
// modified by 4D/PS [2026-june-08]
$printPath:=2

$startTime:=Current time:C178()
If ($itemCount>0)
	If ($itemCount>$largePrintThreshold)
		If (Not:C34(cs:C1710.sfw_dialog.me.confirm("Printing "+String:C10($itemCount)+" lines may take several minutes. For large lists, Export to Excel is faster. Continue printing?"; "Print"; "Cancel")))
			return 
		End if 
	End if 
	
	Case of 
		: ($printPath=1)
			// Purpose: Wizard template + WP SET DATA CONTEXT (same pattern as _ga_printCAOSelection / _ga_printSpecList).
			// modified by 4D/PS [2026-june-19]
			$file:=Folder:C1567(fk resources folder:K87:11).file("4DWriteProPrintTemplates/salesTransactionPrint.4wp")
			If (Not:C34($file.exists))
				cs:C1710.sfw_dialog.me.alert("Print template not found: salesTransactionPrint.4wp. Create it with the Write Pro Wizard using Resources/4DWP_Wizard/Templates/salesTransactionSelection.json.")
				return 
			End if 
			
			$context:=New object:C1471
			$context.subject:=Form:C1466.sfw.view.label
			$context.length:=$itemCount
			
			$template:=WP Import document:C1318($file.platformPath)
			
			SET PRINT OPTION:C733(Orientation option:K47:2; 1)
			WP SET DATA CONTEXT:C1786($template; $context)
			WP COMPUTE FORMULAS:C1707($template)
			PRINT SETTINGS:C106(2)
			WP PRINT:C1343($template)
			
		: ($printPath=2)
			// Purpose: Generic shell template — caller formats header text; table via column mapping + This.data.items.
			// modified by 4D/PS [2026-june-08]
			$mapping:=New collection:C1472(\
				New object:C1471("header"; "Num"; "source"; "String(This.item.transactionNumber)"; "width"; "1.2cm"; "align"; "right"); \
				New object:C1471("header"; "Type"; "source"; "This.item.type.name"; "width"; "2cm"; "align"; "left"); \
				New object:C1471("header"; "Date"; "source"; "Choose((This.item.transactionDate=Null) | (This.item.transactionDate=!00-00-00!); \"\"; String(This.item.transactionDate))"; "width"; "2.2cm"; "align"; "left"); \
				New object:C1471("header"; "Customer"; "source"; "This.item.customer.name"; "width"; "7.8cm"; "align"; "left"); \
				New object:C1471("header"; "Amount"; "source"; "String(This.item.Amount; \"###,###,##0.00\")"; "width"; "2.25cm"; "align"; "right"); \
				New object:C1471("header"; "Open Balance"; "source"; "String(This.item.openBalance; \"###,###,##0.00\")"; "width"; "2.25cm"; "align"; "right")\
				)
			$headerText:=Form:C1466.sfw.view.label+Char:C90(Carriage return:K15:38)
			$headerText:=$headerText+"Count : "+String:C10($itemCount)+Char:C90(Carriage return:K15:38)
			$headerText:=$headerText+"Type : "+_ga_getListFiltersValues("TransactionType"; "UUID")+Char:C90(Carriage return:K15:38)
			$headerText:=$headerText+"Status : "+_ga_getListFiltersValues("TransactionStatus"; "UUID")+Char:C90(Carriage return:K15:38)
			$headerText:=$headerText+"Customer : "+_ga_getListFiltersValues("Customer"; "UUID")
			_ga_printListFromMapping("selectionPrintTemplate.4wp"; $mapping; $items; $headerText)
			
		Else 
			
			// Purpose: Legacy path — build table row-by-row in code (kept for fallback / comparison).
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
				
				$txnDateTxt:=Choose:C955(($eST.transactionDate=Null:C1517) | ($eST.transactionDate=!00-00-00!); ""; String:C10($eST.transactionDate))
				$amountTxt:=String:C10($eST.Amount; "###,###,##0.00")
				$openBalTxt:=String:C10($eST.openBalance; "###,###,##0.00")
				$row:=WP Table append row:C1474($table; String:C10($eST.transactionNumber); $typeName; $txnDateTxt; $customerName; $amountTxt; $openBalTxt)
			End for each 
			
			$numCol:=WP Table get columns:C1476($table; 1)
			$typeCol:=WP Table get columns:C1476($table; 2)
			$dateCol:=WP Table get columns:C1476($table; 3)
			$customerCol:=WP Table get columns:C1476($table; 4)
			$amountCol:=WP Table get columns:C1476($table; 5)
			$openBalCol:=WP Table get columns:C1476($table; 6)
			
			WP SET ATTRIBUTES:C1342($numCol; wk width:K81:45; "1.2cm"; wk text align:K81:49; wk right:K81:96)
			WP SET ATTRIBUTES:C1342($typeCol; wk width:K81:45; "2cm"; wk text align:K81:49; wk left:K81:95)
			WP SET ATTRIBUTES:C1342($dateCol; wk width:K81:45; "2.2cm"; wk text align:K81:49; wk left:K81:95)
			WP SET ATTRIBUTES:C1342($customerCol; wk width:K81:45; "7.8cm"; wk text align:K81:49; wk left:K81:95)
			WP SET ATTRIBUTES:C1342($amountCol; wk width:K81:45; "2.25cm"; wk text align:K81:49; wk right:K81:96)
			WP SET ATTRIBUTES:C1342($openBalCol; wk width:K81:45; "2.25cm"; wk text align:K81:49; wk right:K81:96)
			
			WP SET ATTRIBUTES:C1342($table; wk font size:K81:66; 9)
			$row:=WP Table get rows:C1475($table; 1)
			WP SET ATTRIBUTES:C1342($row; wk font bold:K81:68; True:C214)
			
			Progress QUIT($progressId)
			
			WP SET DATA CONTEXT:C1786($template; $context)
			PRINT SETTINGS:C106(2)
			WP PRINT:C1343($template)
			
	End case 
	
Else 
	cs:C1710.sfw_dialog.me.alert(ds:C1482.sfw_readXliff("No items in the list to print"; "No items in the list to print"))
End if 
$endTime:=Current time:C178()

$duration:=$endTime-$startTime
