//%attributes = {}

// Purpose: Print Receivables Aging Report (skeleton — A/R aging buckets TBD).
// created by 4D/PS [2026-june-08]

If (Form:C1466.sfw.lb_items.length>0)
	cs:C1710.sfw_dialog.me.alert("Receivables aging report print is not yet wired to a report template.")
Else
	cs:C1710.sfw_dialog.me.alert(ds:C1482.sfw_readXliff("No items in the list"; "No items in the list"))
End if
