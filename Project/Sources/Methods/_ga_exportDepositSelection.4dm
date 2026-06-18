//%attributes = {}

// Purpose: Export current Deposit list selection to Excel (skeleton mapping).
// created by 4D/PS [2026-june-09]

var $mapping : Collection:=New collection:C1472()

If (Form:C1466.sfw.lb_items.length>0)
	$fileName:=Form:C1466.sfw.view.label
	$templateFile:=Folder:C1567(fk resources folder:K87:11).file("excelTemplates/excelExportTemplate.xlsx")
	$mapping:=New collection:C1472(New object:C1471("header"; "Deposit #"; "field"; "depositNumber"; "footerOperation"; ""))
	If ($fileName="main") | ($fileName="Main view")
		$title:="All Deposits"
		$fileName:="AllDeposits"
	Else 
		$title:=$fileName
		$fileName:=Replace string:C233($fileName; " "; "")
	End if 
	$destinationFolderPath:=Get 4D folder:C485(Current resources folder:K5:16)+"exportedData"+Folder separator:K24:12+"Deposit"
	$destinationFileName:=Split string:C1554(String:C10($fileName+"_"+Replace string:C233(String:C10(Date:C102(Timestamp:C1445)); "/"; "_")); " "; sk ignore empty strings:K86:1+sk trim spaces:K86:2).join("")
	$offscreen:=cs:C1710.ExcelDataExporter.new($templateFile.platformPath; $mapping; Form:C1466.sfw.lb_items; $destinationFileName; $destinationFolderPath; $title; $fileName; True:C214)
	VP Run offscreen area($offscreen)
Else 
	cs:C1710.sfw_dialog.me.alert(ds:C1482.sfw_readXliff("No items in the list to Export"; "No items in the list to Export"))
End if 
