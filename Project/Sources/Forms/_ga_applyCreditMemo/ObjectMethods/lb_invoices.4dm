// Purpose: Refresh applied / remaining credit totals when an invoice apply amount changes.
// created by 4D/PS [2026-june-08]
Case of 
	: (Form event:C1606.code=On Data Change:K2:15)
		_ga_applyCreditMemoRecalc()
End case 
