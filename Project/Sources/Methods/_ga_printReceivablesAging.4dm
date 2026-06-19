//%attributes = {}

// Purpose: Print Receivables Aging Report for the current Sales Transaction list.
// modified by 4D/PS [2026-june-08]

var $wp : Object

If (Form:C1466.sfw.lb_items.length>0)
	$wp:=_ga_buildRecvAgingReport(Form:C1466.sfw.lb_items)
	// Purpose: Inline Write Pro print so aging print works without a separate project method.
	// modified by 4D/PS [2026-june-08]
	If ($wp#Null:C1517)
		SET PRINT OPTION:C733(Orientation option:K47:2; 1)
		PRINT SETTINGS:C106(2)
		WP PRINT:C1343($wp)
	End if
Else
	cs:C1710.sfw_dialog.me.alert(ds:C1482.sfw_readXliff("No items in the list"; "No items in the list"))
End if
