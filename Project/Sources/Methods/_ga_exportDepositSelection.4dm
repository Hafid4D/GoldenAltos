//%attributes = {}

// Purpose: Export current Deposit list selection to Excel.
// modified by 4D/PS [2026-june-22]

var $mapping : Collection
var $exportRows : Collection
var $eDeposit : cs:C1710.DepositEntity
var $row : Object
var $destinationFolder : 4D:C1709.Folder

If (Form:C1466.sfw.lb_items.length>0)
	$fileName:=Form:C1466.sfw.view.label
	$templateFile:=Folder:C1567(fk resources folder:K87:11).file("excelTemplates/excelExportTemplate.xlsx")
	$mapping:=New collection:C1472(\
		New object:C1471("header"; "Deposit #"; "field"; "depositNumber"; "footerOperation"; ""); \
		New object:C1471("header"; "Date"; "field"; "depositDate"; "footerOperation"; ""); \
		New object:C1471("header"; "Account"; "field"; "accountLabel"; "footerOperation"; ""); \
		New object:C1471("header"; "Total"; "field"; "totalAmount"; "footerOperation"; ""))
	// Purpose: Flatten entity rows — ExcelDataExporter reads storage fields via ["field"]; entity helpers (accountLabel, totalAmount) need explicit values.
	// modified by 4D/PS [2026-june-23]
	$exportRows:=New collection:C1472()
	For each ($eDeposit; Form:C1466.sfw.lb_items)
		$eDeposit.hydrateDisplayFromLegacy()
		$row:=New object:C1471(\
			"depositNumber"; $eDeposit.depositNumber; \
			"depositDate"; $eDeposit.depositDate; \
			"accountLabel"; $eDeposit.accountLabel(); \
			"totalAmount"; $eDeposit.totalAmount())
		$exportRows.push($row)
	End for each
	If ($fileName="main") | ($fileName="Main view")
		$title:="All Deposits"
		$fileName:="AllDeposits"
	Else 
		$title:=$fileName
		$fileName:=Replace string:C233($fileName; " "; "")
	End if 
	// Purpose: Build export folder via 4D.Folder API (Get 4D folder text is not a valid POSIX path for Folder()).
	// modified by 4D/PS [2026-june-23]
	$destinationFolder:=Folder:C1567(fk resources folder:K87:11).folder("exportedData").folder("Deposit")
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
