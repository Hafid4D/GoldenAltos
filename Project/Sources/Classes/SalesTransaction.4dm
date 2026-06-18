
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
	
	$entry.setItemAction("Receive Payement"; "_ga_receivePayement")
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
	// Returns: Object — { success : Boolean, payment : SalesTransactionEntity|null, totalApplied : Real, error : Text }
	// created by 4D/PS [2026-june-17]
Function applyReceivePayment($customerUUID : Text; $totalAmount : Real; $applications : Collection; $memo : Text; $transactionDate : Date)->$result : Object
	
	var $ePayment : cs:C1710.SalesTransactionEntity
	var $eInv : cs:C1710.SalesTransactionEntity
	var $eApp : cs:C1710.PaymentApplicationEntity
	var $eType : cs:C1710.TransactionTypeEntity
	var $totalApplied : Real
	var $unapplied : Real
	var $app : Object
	var $res : Object
	
	$result:=New object:C1471("success"; False:C215; "payment"; Null:C1517; "totalApplied"; 0; "error"; "")
	
	If ($totalAmount<=0)
		$result.error:="Payment amount must be greater than zero."
		return $result
	End if 
	
	If ($applications.length=0)
		$result.error:="Select at least one invoice to apply the payment."
		return $result
	End if 
	
	$totalApplied:=0
	For each ($app; $applications)
		If ($app.appliedAmount#Null:C1517) && ($app.appliedAmount>0)
			$eInv:=This:C1470.get($app.UUID_Invoice)
			If ($eInv=Null:C1517)
				$result.error:="Invoice not found for payment application."
				return $result
			End if 
			If ($eInv.UUID_Customer#$customerUUID)
				$result.error:="All invoices must belong to the same customer."
				return $result
			End if 
			If (Not:C34($eInv.canReceivePayment()))
				$result.error:="Invoice #"+String:C10($eInv.transactionNumber)+" cannot receive a payment."
				return $result
			End if 
			If ($app.appliedAmount>Abs:C99($eInv.openBalance))
				$result.error:="Applied amount exceeds open balance on invoice #"+String:C10($eInv.transactionNumber)+"."
				return $result
			End if 
			$totalApplied:=$totalApplied+$app.appliedAmount
		End if 
	End for each 
	
	If ($totalApplied<=0)
		$result.error:="Applied amount must be greater than zero."
		return $result
	End if 
	
	If ($totalApplied>$totalAmount)
		$result.error:="Applied amount cannot exceed the payment amount."
		return $result
	End if 
	
	$ePayment:=This:C1470.new()
	$ePayment.transactionNumber:=This:C1470.nextTransactionNumber()
	$ePayment.UUID_Customer:=$customerUUID
	$eType:=ds:C1482.TransactionType.query("code = :1"; "PAY").first()
	If ($eType#Null:C1517)
		$ePayment.UUID_TransactionType:=$eType.UUID
	End if 
	$ePayment.transactionDate:=$transactionDate
	$ePayment.Amount:=-$totalAmount
	$unapplied:=$totalAmount-$totalApplied
	$ePayment.openBalance:=($unapplied>0) ? -$unapplied : 0
	$ePayment.memo:=$memo
	$ePayment.applyTypeAmountSign("PAY")
	$ePayment.refreshStatus()
	
	// Purpose: Removed invalid pre-check (C254 theme is Last table number, which takes no argument).
	// modified by 4D/PS [2026-june-08]
	START TRANSACTION:C239
	
	$res:=$ePayment.save()
	If (Not:C34($res.success))
		CANCEL TRANSACTION:C241
		$result.error:=$res.statusText
		return $result
	End if 
	
	For each ($app; $applications)
		If ($app.appliedAmount#Null:C1517) && ($app.appliedAmount>0)
			$eInv:=This:C1470.get($app.UUID_Invoice)
			$eInv.openBalance:=$eInv.openBalance-$app.appliedAmount
			$eInv.refreshStatus()
			$res:=$eInv.save()
			If (Not:C34($res.success))
				CANCEL TRANSACTION:C241
				$result.error:=$res.statusText
				return $result
			End if 
			// Purpose: Catch missing PaymentApplication table in the .4dd file and return a clear message.
			// modified by 4D/PS [2026-june-08]
			Try
				$eApp:=ds:C1482.PaymentApplication.new()
				$eApp.UUID_Payment:=$ePayment.UUID
				$eApp.UUID_Invoice:=$eInv.UUID
				$eApp.appliedAmount:=$app.appliedAmount
				$res:=$eApp.save()
			Catch
				CANCEL TRANSACTION:C241
				$result.error:="PaymentApplication table is missing in the database file. In 4D Designer: Structure > Update database structure, then retry."
				return $result
			End try
			If (Not:C34($res.success))
				CANCEL TRANSACTION:C241
				$result.error:=$res.statusText
				return $result
			End if 
		End if 
	End for each 
	
	VALIDATE TRANSACTION:C240
	$result.success:=True:C214
	$result.payment:=$ePayment
	$result.totalApplied:=$totalApplied
	
	
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
	
	var $eJobInvoice : cs:C1710.JobInvoiceEntity
	var $invNum : Text
	var $amount : Real
	var $res : Object
	var $prefix : Text
	
	$eSTOut:=$eST
	$prefix:="Job invoice "
	If ($eST=Null:C1517)
		return $eSTOut
	End if 
	If (($eST.openBalance#0) || ($eST.Amount#0))
		return $eSTOut
	End if 
	If ($eST.memo=Null:C1517) || (Position:C15($prefix; $eST.memo)#1)
		return $eSTOut
	End if 
	
	$invNum:=Substring:C12($eST.memo; Length:C16($prefix)+1)
	$eJobInvoice:=ds:C1482.JobInvoice.query("invoiceNumber = :1"; $invNum).first()
	If ($eJobInvoice=Null:C1517)
		return $eSTOut
	End if 
	
	$amount:=This:C1470.resolveJobInvoiceAmount($eJobInvoice)
	If ($amount=0)
		return $eSTOut
	End if 
	
	$eST.Amount:=$amount
	$eST.openBalance:=$amount
	$eST.applyTypeAmountSign("INV")
	$eST.refreshStatus()
	$res:=$eST.save()
	If ($res.success)
		$eSTOut:=This:C1470.get($eST.UUID)
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
	
	