// Purpose: SFW entry for check register (legacy Check_Register).
// created by 4D/PS [2026-june-09]
Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("Check"; ["accounting"]; "Checks"; "Check")
	$entry.setDataclass("Check")
	$entry.setDisplayOrder(-700)
	$entry.setIcon("image/entry/check-white-50x50.png")
	
	$entry.setSearchboxField("checkNumber")
	
	$entry.setPanel("panel_check"; 1)
	$entry.setPanelPage(1; ""; "Main")
	
	$entry.setLBItemsColumn("checkNumber"; "Check #"; "width:80")
	// Purpose: Show typed header columns in the entry list (legacy Check_Register fields).
	// modified by 4D/PS [2026-june-29]
	$entry.setLBItemsColumn("checkDate"; "Date"; "width:80")
	$entry.setLBItemsColumn("payee"; "Pay To"; "width:180")
	$entry.setLBItemsColumn("amount"; "Amount"; "width:80")
	$entry.setLBItemsOrderBy("checkNumber")
	$entry.setMainViewLabel("All checks")
	
	$entry.setItemListAction("Export to Excel"; "_ga_exportCheckSelection")
	$entry.setItemAction("Generate Barcode"; "_ga_openBarCodeForm")
	$entry.setItemListAction("Search by Scanning"; "_ga_searchByBarcodeScanning")
	
	$entry.enableTransaction()
	$entry.activateFavorite()

// Purpose: Next check number for a new Check row (max existing + 1).
// Returns: Integer
// created by 4D/PS [2026-june-29]
Function nextCheckNumber()->$num : Integer
	var $last : cs:C1710.CheckEntity
	
	$num:=1
	$last:=This:C1470.all().orderBy("checkNumber desc").first()
	If ($last#Null:C1517)
		$num:=$last.checkNumber+1
	End if
	
