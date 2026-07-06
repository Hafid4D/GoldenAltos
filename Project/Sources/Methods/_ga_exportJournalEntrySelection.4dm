//%attributes = {}

// Purpose: Export current Journal Entry list selection to Excel using typed catalog fields.
// modified by 4D/PS [2026-june-29]

var $mapping : Collection
var $exportRows : Collection
var $eEntry : cs:C1710.JournalEntryEntity
var $row : Object
var $destinationFolder : 4D:C1709.Folder

If (Form:C1466.sfw.lb_items.length>0)
	$fileName:=Form:C1466.sfw.view.label
	$templateFile:=Folder:C1567(fk resources folder:K87:11).file("excelTemplates/excelExportTemplate.xlsx")
	$mapping:=New collection:C1472(\
		New object:C1471("header"; "Journal #"; "field"; "entryNumber"; "footerOperation"; ""); \
		New object:C1471("header"; "Date"; "field"; "journalDate"; "footerOperation"; ""); \
		New object:C1471("header"; "Trans Type"; "field"; "transactionType"; "footerOperation"; ""); \
		New object:C1471("header"; "Num"; "field"; "transactionNum"; "footerOperation"; ""); \
		New object:C1471("header"; "Debit Acc"; "field"; "listDebitAccount"; "footerOperation"; ""); \
		New object:C1471("header"; "Credit Acc"; "field"; "listCreditAccount"; "footerOperation"; ""); \
		New object:C1471("header"; "Debit"; "field"; "totalDebit"; "footerOperation"; ""); \
		New object:C1471("header"; "Credit"; "field"; "totalCredit"; "footerOperation"; ""))
	$exportRows:=New collection:C1472()
	For each ($eEntry; Form:C1466.sfw.lb_items)
		$row:=New object:C1471(\
			"entryNumber"; $eEntry.entryNumber; \
			"journalDate"; $eEntry.journalDate; \
			"transactionType"; $eEntry.transactionType; \
			"transactionNum"; $eEntry.transactionNum; \
			"listDebitAccount"; $eEntry.listDebitAccount; \
			"listCreditAccount"; $eEntry.listCreditAccount; \
			"totalDebit"; $eEntry.totalDebit; \
			"totalCredit"; $eEntry.totalCredit)
		$exportRows.push($row)
	End for each
	If ($fileName="main") | ($fileName="Main view")
		$title:="All Journal Entries"
		$fileName:="AllJournalEntries"
	Else 
		$title:=$fileName
		$fileName:=Replace string:C233($fileName; " "; "")
	End if 
	$destinationFolder:=Folder:C1567(fk resources folder:K87:11).folder("exportedData").folder("JournalEntry")
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
