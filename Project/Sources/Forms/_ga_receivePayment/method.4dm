// Purpose: Receive Payment dialog — load open invoices for the customer and pre-fill the seed invoice.
// modified by 4D/PS [2026-june-08]
Case of 
	: (Form event:C1606.code=On Load:K2:1)
		_ga_receivePayment_onLoad()
End case 
