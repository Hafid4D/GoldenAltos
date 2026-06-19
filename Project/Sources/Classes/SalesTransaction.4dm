
// Purpose: SFW entry for the Accounts Receivable sub-ledger (GA3-T398 / legacy Receivables).
// created by 4D/PS [2026-june-08]
Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	// Purpose: Entry label aligned with Zoho GA3-T398 naming (Sales Transactions).
	// modified by 4D/PS [2026-june-08]
	$entry:=cs:C1710.sfw_definitionEntry.new("SalesTransaction"; ["accounting"]; "Sales Transactions"; "SalesTransaction")
	$entry.setDataclass("SalesTransaction")
	$entry.setDisplayOrder(-400)
	$entry.setIcon("image/entry/sales-Transaction-50x50.png")
	
	$entry.setSearchboxField("transactionNumber"; "placeholder:transactionNumber")
	$entry.setSearchboxField("customer.name"; "placeholder:customer")
	
	$entry.setPanel("panel_salesTransaction"; 1)
	$entry.setPanelPage(1; ""; "Main")
	$entry.setPanelPage(2; ""; "Applications")
	
	$entry.setLBItemsColumn("transactionNumber"; "Num"; "width:60")
	// Purpose: ORDA relation name is "type" (catalog name_Nto1), not transactionType.
	// modified by 4D/PS [2026-june-17]
	$entry.setLBItemsColumn("type.name"; "Type"; "width:80")
	$entry.setLBItemsColumn("transactionDate"; "Date"; "width:80")
	$entry.setLBItemsColumn("Amount"; "Amount"; "width:60")
	$entry.setLBItemsColumn("customer.name"; "Customer"; "width:100")
	
	$entry.setLBItemsOrderBy("transactionNumber")
	$entry.setMainViewLabel("All sales transactions")
	
	// Purpose: Method names kept within the 4D 31-character limit.
	// modified by 4D/PS [2026-june-08]
	$entry.setItemListAction("Export to Excel"; "_ga_exportSalesTransactionSelec")
	$entry.setItemListAction("Print selection"; "_ga_printSalesTransSel")
	$entry.setItemListAction("-"; "-")
	$entry.setItemListAction("View Receivables Report"; "_ga_viewReceivablesReport")
	$entry.setItemListAction("Print Receivables Report"; "_ga_printReceivablesReport")
	$entry.setItemListAction("View Receivables Aging Report"; "_ga_viewReceivablesAging")
	$entry.setItemListAction("Print Receivables Aging Report"; "_ga_printReceivablesAging")
	$entry.setItemListAction("-"; "-")
	$entry.setItemListAction("Make Deposit"; "_ga_makeDeposit")
	
	$entry.setItemAction("Receive Payement"; "_ga_receivePayement")
	$entry.setItemAction("Apply Credit Memo"; "_ga_applyCreditMemo")
	$entry.setItemAction("Generate Barcode"; "_ga_openBarCodeForm")
	$entry.setItemListAction("Search by Scanning"; "_ga_searchByBarcodeScanning")
	
	$entry.setValidationRule("Amount"; "entryField_amount")
	$entry.setValidationRule("memo"; "entryField_memo")
	$entry.setValidationRule("transactionDate"; "entryField_transactionDate")
	$entry.setValidationRule("dueDate"; "entryField_dueDate")
	$entry.setValidationRule("openBalance"; "entryField_openBalance")
	
	$entry.setSubset("main")
	
	$entry.enableTransaction()
	$entry.activateFavorite()
	
	
Function main()->$transactions : cs:C1710.SalesTransactionSelection
	$transactions:=ds:C1482.SalesTransaction.all()
	
	
	// Purpose: Return the next available transactionNumber for a new AR line.
	// Returns: Integer
	// created by 4D/PS [2026-june-17]
Function nextTransactionNumber()->$num : Integer
	var $max : Integer
	
	$max:=This:C1470.all().extract("transactionNumber").max()
	$num:=($max=Null:C1517) ? 1 : $max+1
	
	
	// Purpose: Create a PAY line, apply amounts to open invoices, and persist PaymentApplication links.
	// Parameters:
	// $customerUUID : Text — customer UUID
	// $totalAmount : Real — total payment received (positive)
	// $applications : Collection — objects with UUID_Invoice (Text) and appliedAmount (Real)
	// $memo : Text — payment memo
	// $transactionDate : Date — payment date
	// Returns: Object — { success : Boolean, paymentUUID : Text, totalApplied : Real, error : Text }
	// created by 4D/PS [2026-june-17]
Function applyReceivePayment($customerUUID : Text; $totalAmount : Real; $applications : Collection; $memo : Text; $transactionDate : Date)->$result : Object
	
	// Purpose: Delegate persistence to the project method (same pattern as import/build methods).
	// modified by 4D/PS [2026-june-08]
	$result:=_ga_applyReceivePayment($customerUUID; $totalAmount; $applications; $memo; $transactionDate)
	
	
	// Purpose: Apply an existing CM line to open invoices and persist PaymentApplication rows.
	// Parameters:
	// $creditMemoUUID : Text — SalesTransaction UUID of the credit memo line
	// $applications : Collection — objects with UUID_Invoice (Text) and appliedAmount (Real)
	// $memo : Text — optional application memo (stored on CM when provided)
	// Returns: Object — { success : Boolean, creditMemoUUID : Text, totalApplied : Real, error : Text }
	// created by 4D/PS [2026-june-08]
Function applyCreditMemo($creditMemoUUID : Text; $applications : Collection; $memo : Text)->$result : Object
	
	$result:=_ga_applyCreditMemoApply($creditMemoUUID; $applications; $memo)
	
	
	// Purpose: Create a DEP line from undeposited PAY lines and mark them deposited.
	// Parameters:
	// $paymentUUIDs : Collection — SalesTransaction UUIDs (PAY lines)
	// $caoUUID : Text — bank CAO account UUID
	// $memo : Text — deposit memo
	// $depositDate : Date — deposit date
	// Returns: Object — { success : Boolean, depositUUID : Text, totalDeposited : Real, error : Text }
	// created by 4D/PS [2026-june-08]
Function makeDeposit($paymentUUIDs : Collection; $caoUUID : Text; $memo : Text; $depositDate : Date)->$result : Object
	
	$result:=_ga_makeDepositApply($paymentUUIDs; $caoUUID; $memo; $depositDate)
	
	
	// Purpose: Return PAY lines still in undeposited funds.
	// Returns: SalesTransactionSelection
	// created by 4D/PS [2026-june-08]
Function getUndepositedPayments()->$payments : cs:C1710.SalesTransactionSelection
	
	var $eType : cs:C1710.TransactionTypeEntity
	var $ePay : cs:C1710.SalesTransactionEntity
	
	$eType:=ds:C1482.TransactionType.query("code = :1"; "PAY").first()
	$payments:=This:C1470.newSelection()
	If ($eType=Null:C1517)
		return $payments
	End if 
	
	For each ($ePay; This:C1470.query("UUID_TransactionType = :1"; $eType.UUID).orderBy("transactionNumber"))
		If ($ePay.isUndeposited())
			$payments:=$payments.or($ePay)
		End if 
	End for each 
	
	
	// Purpose: Return open CM lines for a customer (unapplied credit), ordered by transaction number.
	// Parameters:
	// $customerUUID : Text — customer UUID
	// Returns: SalesTransactionSelection — open credit memo lines
	// created by 4D/PS [2026-june-08]
Function getOpenCreditsForCustomer($customerUUID : Text)->$credits : cs:C1710.SalesTransactionSelection
	
	var $eType : cs:C1710.TransactionTypeEntity
	
	$eType:=ds:C1482.TransactionType.query("code = :1"; "CM").first()
	If ($eType=Null:C1517)
		$credits:=This:C1470.newSelection()
	Else 
		$credits:=This:C1470.query("UUID_Customer = :1 AND UUID_TransactionType = :2 AND openBalance # 0"; $customerUUID; $eType.UUID).orderBy("transactionNumber")
	End if 
	
	
	// Purpose: Return open INV lines for a customer (openBalance not zero), ordered by transaction number.
	// Parameters:
	// $customerUUID : Text — customer UUID
	// Returns: SalesTransactionSelection — open invoice lines
	// created by 4D/PS [2026-june-08]
Function getOpenInvoicesForCustomer($customerUUID : Text)->$invoices : cs:C1710.SalesTransactionSelection
	
	var $eType : cs:C1710.TransactionTypeEntity
	
	$eType:=ds:C1482.TransactionType.query("code = :1"; "INV").first()
	If ($eType=Null:C1517)
		$invoices:=This:C1470.newSelection()
	Else 
		$invoices:=This:C1470.query("UUID_Customer = :1 AND UUID_TransactionType = :2 AND openBalance # 0"; $customerUUID; $eType.UUID).orderBy("transactionNumber")
	End if 
	
	
	// Purpose: Resolve Customer UUID when building SalesTransaction from a legacy Invoice row.
	// Parameters:
	// $eInvoice : InvoiceEntity — PO receivables source line
	// Returns: Text — Customer.UUID or empty UUID when not found
	// created by 4D/PS [2026-june-08]
Function resolveCustomerUUIDFromInvoice($eInvoice : cs:C1710.InvoiceEntity)->$customerUUID : Text
	
	var $eCustomer : cs:C1710.CustomerEntity
	var $ePO : cs:C1710.PurchaseOrderEntity
	
	$customerUUID:=16*"00"
	If ($eInvoice=Null:C1517)
		return $customerUUID
	End if 
	
	If ($eInvoice.purchaseOrder#Null:C1517)
		$ePO:=$eInvoice.purchaseOrder
		If (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($ePO.UUID_Customer)))
			$customerUUID:=$ePO.UUID_Customer
		Else 
			If ($ePO.customer_name#"")
				$eCustomer:=ds:C1482.Customer.query("name = :1"; $ePO.customer_name).first()
				If ($eCustomer#Null:C1517)
					$customerUUID:=$eCustomer.UUID
				End if 
			End if 
		End if 
	End if 
	
	If (cs:C1710.sfw_string.me.isAnEmptyUUID($customerUUID)) && ($eInvoice.customerId#"")
		$eCustomer:=ds:C1482.Customer.query("code = :1"; $eInvoice.customerId).first()
		If ($eCustomer=Null:C1517)
			$eCustomer:=ds:C1482.Customer.query("accountNumber = :1"; $eInvoice.customerId).first()
		End if 
		If ($eCustomer#Null:C1517)
			$customerUUID:=$eCustomer.UUID
		End if 
	End if 
	
	
	// Purpose: Resolve billable amount for a JobInvoice (total field or charge components fallback).
	// Parameters:
	// $eJobInvoice : JobInvoiceEntity — job billing source line
	// Returns: Real — invoice amount (positive)
	// created by 4D/PS [2026-june-08]
Function resolveJobInvoiceAmount($eJobInvoice : cs:C1710.JobInvoiceEntity)->$amount : Real
	
	var $eJob : cs:C1710.JobEntity
	
	$amount:=0
	If ($eJobInvoice=Null:C1517)
		return $amount
	End if 
	
	$amount:=$eJobInvoice.total
	If ($amount#0)
		return $amount
	End if 
	
	$amount:=$eJobInvoice.poBasedCharges+$eJobInvoice.travBasedCharges+$eJobInvoice.totalSalesTax+$eJobInvoice.orderItemsCharges
	If ($amount#0)
		return $amount
	End if 
	
	If ($eJobInvoice.job#Null:C1517)
		$eJob:=$eJobInvoice.job
		If ($eJob.totalCharge#0)
			$amount:=$eJob.totalCharge
		End if 
	End if 
	
	
	// Purpose: Refresh Amount/openBalance on a job-invoice ST row when import left zero balances.
	// Parameters:
	// $eST : SalesTransactionEntity — AR line linked by memo "Job invoice <number>"
	// Returns: SalesTransactionEntity — same entity, reloaded when updated
	// created by 4D/PS [2026-june-08]
Function syncJobInvoiceSTAmount($eST : cs:C1710.SalesTransactionEntity)->$eSTOut : cs:C1710.SalesTransactionEntity
	
	// Purpose: Delegate to entity instance method (DataClass+entity param fails to stream from client SFW actions).
	// modified by 4D/PS [2026-june-08]
	If ($eST=Null:C1517)
		$eSTOut:=$eST
	Else 
		$eSTOut:=$eST.syncJobInvoiceSTAmount()
	End if 
	
	
	// Purpose: Resolve Customer UUID when building SalesTransaction from a JobInvoice row.
	// Parameters:
	// $eJobInvoice : JobInvoiceEntity — job billing source line
	// Returns: Text — Customer.UUID or empty UUID when not found
	// created by 4D/PS [2026-june-08]
Function resolveCustomerUUIDFromJobInvoice($eJobInvoice : cs:C1710.JobInvoiceEntity)->$customerUUID : Text
	
	var $eCustomer : cs:C1710.CustomerEntity
	var $eJob : cs:C1710.JobEntity
	
	$customerUUID:=16*"00"
	If ($eJobInvoice=Null:C1517)
		return $customerUUID
	End if 
	
	If ($eJobInvoice.job#Null:C1517)
		$eJob:=$eJobInvoice.job
		If (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($eJob.UUID_Customer)))
			$customerUUID:=$eJob.UUID_Customer
		Else 
			If ($eJob.purchaseOrder#Null:C1517) && (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($eJob.purchaseOrder.UUID_Customer)))
				$customerUUID:=$eJob.purchaseOrder.UUID_Customer
			Else 
				If ($eJob.customerName#"")
					$eCustomer:=ds:C1482.Customer.query("name = :1"; $eJob.customerName).first()
					If ($eCustomer#Null:C1517)
						$customerUUID:=$eCustomer.UUID
					End if 
				End if 
			End if 
		End if 
	End if 
	
	