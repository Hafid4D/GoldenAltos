
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
	
	$entry.setLBItemsColumn("transactionType.name"; "Type"; "width:100")
	$entry.setLBItemsColumn("transactionNumber"; "Num"; "width:60")
	$entry.setLBItemsColumn("transactionDate"; "Date"; "width:80")
	$entry.setLBItemsColumn("customer.name"; "Customer"; "width:200")
	$entry.setLBItemsColumn("Amount"; "Amount"; "width:100")
	$entry.setLBItemsColumn("openBalance"; "Open Balance"; "width:100")
	
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
	
	
// Purpose: Rebuild all SalesTransaction rows from Invoice (PO receivables) and JobInvoice sources.
// Returns: Integer — number of records created (0 when no source data; no design-mockup seeding).
// modified by 4D/PS [2026-june-08]
Function rebuildFromSources()->$count : Integer
	
	var $eST : cs:C1710.SalesTransactionEntity
	var $eType : cs:C1710.TransactionTypeEntity
	var $eInvoice : Object
	var $eJobInvoice : cs:C1710.JobInvoiceEntity
	var $typeCode : Text
	var $num : Integer
	var $seq : Integer
	var $amount : Real
	var $openBalance : Real
	var $res : Object
	
	TRUNCATE TABLE:C1051([SalesTransaction:80])
	$count:=0
	$seq:=0
	
	For each ($eInvoice; ds:C1482.Invoice.all())
		$seq:=$seq+1
		$typeCode:=This:C1470.mapLegacyTypeCode($eInvoice.invoice)
		$num:=This:C1470.parseLegacyTransactionNumber($eInvoice.invoice)
		If ($num=0)
			$num:=$seq
		End if
		
		$amount:=$eInvoice.total
		$openBalance:=$eInvoice.due
		If ($typeCode="CM") && ($amount>0)
			$amount:=-$amount
		End if
		If ($typeCode="CM") && ($openBalance>0)
			$openBalance:=-$openBalance
		End if
		If ($typeCode="PAY") && ($amount>0)
			$amount:=-$amount
		End if
		
		$eST:=ds:C1482.SalesTransaction.new()
		$eST.transactionNumber:=$num
		If ($eInvoice.purchaseOrder#Null:C1517)
			$eST.UUID_Customer:=$eInvoice.purchaseOrder.UUID_Customer
		Else
			$eST.UUID_Customer:=16*"00"
		End if
		This:C1470._assignTypeAndStatus($eST; $typeCode)
		$eST.transactionDate:=$eInvoice.date
		$eST.Amount:=$amount
		$eST.openBalance:=$openBalance
		$eST.memo:=""
		$eST.moreData:=New object:C1471(\
			"source"; "Invoice"; \
			"legacyInvoice"; $eInvoice.invoice; \
			"UUID_Invoice"; $eInvoice.UUID; \
			"amountPaid"; $eInvoice.amountPaid; \
			"slip"; $eInvoice.slip; \
			"readyToDel"; $eInvoice.readyToDel\
			)
		If ($eInvoice.readyToDel)
			$eST.moreData.closed:=True:C214
		End if
		$res:=$eST.save()
		If ($res.success)
			$count:=$count+1
		End if
	End for each
	
	For each ($eJobInvoice; ds:C1482.JobInvoice.all())
		$seq:=$seq+1
		$num:=Num:C11($eJobInvoice.invoiceNumber)
		If ($num=0)
			$num:=$seq+100000
		End if
		
		$eST:=ds:C1482.SalesTransaction.new()
		$eST.transactionNumber:=$num
		If ($eJobInvoice.job#Null:C1517) && ($eJobInvoice.job.purchaseOrder#Null:C1517)
			$eST.UUID_Customer:=$eJobInvoice.job.purchaseOrder.UUID_Customer
		Else
			$eST.UUID_Customer:=16*"00"
		End if
		This:C1470._assignTypeAndStatus($eST; "INV")
		$eST.transactionDate:=$eJobInvoice.invoiceDate
		$eST.Amount:=$eJobInvoice.total
		$eST.openBalance:=$eJobInvoice.total
		$eST.memo:="Job invoice "+$eJobInvoice.invoiceNumber
		$eST.moreData:=New object:C1471(\
			"source"; "JobInvoice"; \
			"UUID_JobInvoice"; $eJobInvoice.UUID; \
			"invoiceNumber"; $eJobInvoice.invoiceNumber\
			)
		$res:=$eST.save()
		If ($res.success)
			$count:=$count+1
		End if
	End for each
	
	
// Purpose: Set required type/status UUIDs before saving an imported AR line.
// Parameters:
// $eST : cs.SalesTransactionEntity — target entity
// $typeCode : Text — TransactionType.code
// modified by 4D/PS [2026-june-08]
Function _assignTypeAndStatus($eST : cs:C1710.SalesTransactionEntity; $typeCode : Text)
	
	$eType:=ds:C1482.TransactionType.query("code = :1"; $typeCode).first()
	If ($eType#Null:C1517)
		$eST.UUID_TransactionType:=$eType.UUID
	End if
	$eST.applyTypeAmountSign($typeCode)
	$eST.refreshStatus()
	If (cs:C1710.sfw_string.me.isAnEmptyUUID($eST.UUID_TransactionStatus))
		$eStatus:=ds:C1482.TransactionStatus.query("code = :1"; "OPEN").first()
		If ($eStatus#Null:C1517)
			$eST.UUID_TransactionStatus:=$eStatus.UUID
		End if
	End if
	
	
// Purpose: Parse legacy receivable invoice label prefix (CM / PY / blank) into a type code.
// Parameters:
// $invoiceLabel : Text — legacy invoice field (e.g. "CM 12345", "PY 99", "12345")
// Returns: Text — type code (INV, CM, PAY, DEP)
// created by 4D/PS [2026-june-08]
Function mapLegacyTypeCode($invoiceLabel : Text)->$typeCode : Text
	
	$parts:=Split string:C1554($invoiceLabel; " "; sk trim spaces:K86:2)
	Case of
		: ($parts.length=0)
			$typeCode:="INV"
		: ($parts[0]="CM")
			$typeCode:="CM"
		: ($parts[0]="PY")
			$typeCode:="PAY"
		: ($parts[0]="DEP")
			$typeCode:="DEP"
		Else
			$typeCode:="INV"
	End case
	
	
// Purpose: Extract numeric transaction number from a legacy invoice label.
// Parameters:
// $invoiceLabel : Text — legacy invoice field
// Returns: Integer — parsed number, or 0 when not found
// created by 4D/PS [2026-june-08]
Function parseLegacyTransactionNumber($invoiceLabel : Text)->$number : Integer
	
	$parts:=Split string:C1554($invoiceLabel; " "; sk trim spaces:K86:2)
	$last:=$parts[$parts.length-1]
	$number:=Num:C11($last)
	
	
