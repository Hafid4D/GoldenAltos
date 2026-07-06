//%attributes = {}

// Purpose: Export current Supplier Credit list selection to Excel using typed catalog fields.
// Note: Method name kept <= 31 chars (4D limit); was _ga_exportSupplierCreditSelection.
// modified by 4D/PS [2026-june-29]

var $mapping : Collection
var $exportRows : Collection
var $eCredit : cs:C1710.SupplierCreditEntity
var $row : Object
var $destinationFolder : 4D:C1709.Folder

If (Form:C1466.sfw.lb_items.length>0)
	$fileName:=Form:C1466.sfw.view.label
	$templateFile:=Folder:C1567(fk resources folder:K87:11).file("excelTemplates/excelExportTemplate.xlsx")
	$mapping:=New collection:C1472(\
		New object:C1471("header"; "Credit #"; "field"; "creditNumber"; "footerOperation"; ""); \
		New object:C1471("header"; "Date"; "field"; "creditDate"; "footerOperation"; ""); \
		New object:C1471("header"; "Vendor"; "field"; "vendorName"; "footerOperation"; ""); \
		New object:C1471("header"; "Bill #"; "field"; "billSeqNumber"; "footerOperation"; ""); \
		New object:C1471("header"; "Amount"; "field"; "amount"; "footerOperation"; ""); \
		New object:C1471("header"; "Linked Bill"; "field"; "linkedBillLabel"; "footerOperation"; ""))
	$exportRows:=New collection:C1472()
	For each ($eCredit; Form:C1466.sfw.lb_items)
		$row:=New object:C1471(\
			"creditNumber"; $eCredit.creditNumber; \
			"creditDate"; $eCredit.creditDate; \
			"vendorName"; $eCredit.vendorName; \
			"billSeqNumber"; $eCredit.billSeqNumber; \
			"amount"; $eCredit.amount; \
			"linkedBillLabel"; $eCredit.linkedBillLabel)
		$exportRows.push($row)
	End for each
	If ($fileName="main") | ($fileName="Main view")
		$title:="All Supplier Credits"
		$fileName:="AllSupplierCredits"
	Else 
		$title:=$fileName
		$fileName:=Replace string:C233($fileName; " "; "")
	End if 
	$destinationFolder:=Folder:C1567(fk resources folder:K87:11).folder("exportedData").folder("SupplierCredit")
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
