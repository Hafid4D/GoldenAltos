// Purpose: Link entity between a PAY SalesTransaction and the INV lines it closes (QuickBooks-style applications).
// ORDA dataclass is auto-mapped from table PaymentApplication (id 156); no separate DataClass file (same as DepositItem).
// ORDA relations: payment / appliedInvoice on PaymentApplication; paymentApplications / invoiceApplications on SalesTransaction.
// created by 4D/PS [2026-june-17]
Class extends Entity

local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=String:C10(This:C1470.appliedAmount; "###,###,##0.00")
