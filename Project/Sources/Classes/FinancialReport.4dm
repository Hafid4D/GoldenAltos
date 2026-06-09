// Purpose: SFW entry for accounting report definitions (legacy RM_Reports).
// created by 4D/PS [2026-june-09]
Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("FinancialReport"; ["accounting"]; "Reports"; "FinancialReport")
	$entry.setDataclass("FinancialReport")
	$entry.setDisplayOrder(-1100)
	$entry.setIcon("image/entry/financialReport-white-50x50.png")
	
	$entry.setSearchboxField("reportName")
	
	$entry.setPanel("panel_financialReport"; 1)
	$entry.setPanelPage(1; ""; "Main")
	
	$entry.setLBItemsColumn("reportName"; "Report"; "width:200")
	$entry.setLBItemsOrderBy("reportName")
	$entry.setMainViewLabel("All reports")
	
	$entry.setItemListAction("Export to Excel"; "_ga_exportFinancialReportSelection")
	$entry.setItemAction("Generate Barcode"; "_ga_openBarCodeForm")
	$entry.setItemListAction("Search by Scanning"; "_ga_searchByBarcodeScanning")
	
	$entry.enableTransaction()
	$entry.activateFavorite()
