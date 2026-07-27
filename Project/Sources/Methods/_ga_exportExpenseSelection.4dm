//%attributes = {}

// Purpose: Export current Expense Transaction list selection to Excel using typed catalog fields.
// Note: Method name kept <= 31 chars (4D limit); was _ga_exportExpenseTransactionSelection.
// modified by 4D/PS [2026-june-29]

var $mapping : Collection
var $exportRows : Collection
var $eExpense : cs:C1710.ExpenseTransactionEntity
var $row : Object
var $destinationFolder : 4D:C1709.Folder

If (Form:C1466.sfw.lb_items.length>0)
	$fileName:=Form:C1466.sfw.view.label
	$templateFile:=Folder:C1567(fk resources folder:K87:11).file("excelTemplates/excelExportTemplate.xlsx")
	$mapping:=New collection:C1472(\
		New object:C1471("header"; "Expense #"; "field"; "expenseNumber"; "footerOperation"; ""); \
		New object:C1471("header"; "Vendor"; "field"; "vendorName"; "footerOperation"; ""); \
		New object:C1471("header"; "Check #"; "field"; "checkNumber"; "footerOperation"; ""); \
		New object:C1471("header"; "GL"; "field"; "glAccount"; "footerOperation"; ""); \
		New object:C1471("header"; "Amount"; "field"; "netAmount"; "footerOperation"; ""); \
		New object:C1471("header"; "Description"; "field"; "description"; "footerOperation"; ""))
	$exportRows:=New collection:C1472()
	For each ($eExpense; Form:C1466.sfw.lb_items)
		$row:=New object:C1471(\
			"expenseNumber"; $eExpense.expenseNumber; \
			"vendorName"; $eExpense.vendorName; \
			"checkNumber"; $eExpense.checkNumber; \
			"glAccount"; $eExpense.glAccount; \
			"netAmount"; $eExpense.netAmount; \
			"description"; $eExpense.description)
		$exportRows.push($row)
	End for each
	If ($fileName="main") | ($fileName="Main view")
		$title:="All Expense Transactions"
		$fileName:="AllExpenseTransactions"
	Else 
		$title:=$fileName
		$fileName:=Replace string:C233($fileName; " "; "")
	End if 
	$destinationFolder:=Folder:C1567(fk resources folder:K87:11).folder("exportedData").folder("ExpenseTransaction")
	If (Not:C34($destinationFolder.exists))
		$destinationFolder.create()
	End if
	$destinationFolderPath:=$destinationFolder.platformPath
	$destinationFileName:=Split string:C1554(String:C10($fileName+"_"+Replace string:C233(String:C10(Date:C102(Timestamp:C1445)); "/"; "_")); " "; sk ignore empty strings:K86:1+sk trim spaces:K86:2).join("")
	$offscreen:=cs:C1710.ExcelDataExporter.new($templateFile.platformPath; $mapping; $exportRows; $destinationFileName; $destinationFolderPath; $title; $fileName; False:C215)
	VP Run offscreen area($offscreen)
Else 
	cs:C1710.sfw_dialog.me.alert(ds:C1482.sfw_readXliff("No items in the list to Export"; "No items in the list to Export"))
End if
