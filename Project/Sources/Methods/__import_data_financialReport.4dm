//%attributes = {"executedOnServer":true}

// Purpose: Import report definitions from legacy RM_Reports export JSON.
// Parameters: reads DataJson/rm_reports_export.json from the data folder.
// Returns: nothing (truncates and reloads FinancialReport).
// created by 4D/PS [2026-june-09]

var $records : Collection
var $file : 4D:C1709.File
var $eReport : cs:C1710.FinancialReportEntity

TRUNCATE TABLE:C1051([FinancialReport:155])

$file:=Folder:C1567(fk data folder:K87:12).file("DataJson/rm_reports_export.json")
If ($file.exists)
	$records:=JSON Parse:C1218($file.getText())
	For each ($record; $records)
		$eReport:=ds:C1482.FinancialReport.new()
		$eReport.reportName:=Split string:C1554(String:C10($record.RM_ReportName); "\r"; sk trim spaces:K86:2).join("\r")
		$eReport.moreData:=New object:C1471("legacy"; $record)
		$eReport.save()
	End for each
End if
