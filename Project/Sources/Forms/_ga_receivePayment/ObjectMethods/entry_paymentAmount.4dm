// Purpose: Refresh applied / unapplied totals when the payment amount changes.
// modified by 4D/PS [2026-june-08]
Case of 
	: (Form event:C1606.code=On Data Change:K2:15)
		_ga_receivePayment_recalc()
End case 
