//%attributes = {}

// Purpose: View Receivables Aging Report for the current Sales Transaction list.
// modified by 4D/PS [2026-june-08]

var $wp : Object

If (Form:C1466.sfw.lb_items.length>0)
	$wp:=_ga_buildRecvAgingReport(Form:C1466.sfw.lb_items)
	_ga_showArReportPreview($wp; "Receivables Aging Report")
Else
	cs:C1710.sfw_dialog.me.alert(ds:C1482.sfw_readXliff("No items in the list"; "No items in the list"))
End if
