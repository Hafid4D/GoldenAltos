// Purpose: Refresh deposit total when payment selection changes.
// created by 4D/PS [2026-june-22]
Case of 
	: (Form event:C1606.code=On Data Change:K2:15)
		_ga_makeDepositRecalc()
End case 
