//%attributes = {}

// Purpose: Export current Bill Payment list selection to Excel using typed catalog fields.
// modified by 4D/PS [2026-june-29]

var $mapping : Collection
var $exportRows : Collection
var $ePayment : cs:C1710.BillPaymentEntity
var $row : Object
var $destinationFolder : 4D:C1709.Folder

If (Form:C1466.sfw.lb_items.length>0)
	$fileName:=Form:C1466.sfw.view.label
	$templateFile:=Folder:C1567(fk resources folder:K87:11).file("excelTemplates/excelExportTemplate.xlsx")
	$mapping:=New collection:C1472(\
		New object:C1471("header"; "Payment #"; "field"; "paymentNumber"; "footerOperation"; ""); \
		New object:C1471("header"; "Date"; "field"; "paymentDate"; "footerOperation"; ""); \
		New object:C1471("header"; "Check #"; "field"; "checkNumber"; "footerOperation"; ""); \
		New object:C1471("header"; "Amount"; "field"; "amount"; "footerOperation"; ""); \
		New object:C1471("header"; "Invoice #"; "field"; "invoiceNumber"; "footerOperation"; ""); \
		New object:C1471("header"; "Bill Line #"; "field"; "buyItemSeqNumber"; "footerOperation"; ""))
	$exportRows:=New collection:C1472()
	For each ($ePayment; Form:C1466.sfw.lb_items)
		$row:=New object:C1471(\
			"paymentNumber"; $ePayment.paymentNumber; \
			"paymentDate"; $ePayment.paymentDate; \
			"checkNumber"; $ePayment.checkNumber; \
			"amount"; $ePayment.amount; \
			"invoiceNumber"; $ePayment.invoiceNumber; \
			"buyItemSeqNumber"; $ePayment.buyItemSeqNumber)
		$exportRows.push($row)
	End for each
	If ($fileName="main") | ($fileName="Main view")
		$title:="All Bill Payments"
		$fileName:="AllBillPayments"
	Else 
		$title:=$fileName
		$fileName:=Replace string:C233($fileName; " "; "")
	End if 
	$destinationFolder:=Folder:C1567(fk resources folder:K87:11).folder("exportedData").folder("BillPayment")
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
