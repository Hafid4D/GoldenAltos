// Purpose: Entity helpers for SalesTransaction AR lines (dates, status, creation defaults).
// created by 4D/PS [2026-june-08]
Class extends Entity

local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=String:C10(This:C1470.transactionNumber)

local Function get transactionDate()->$date : Date
	$date:=This:C1470.stmpTransaction=0 ? !00-00-00! : cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpTransaction; True:C214)

local Function set transactionDate($date : Date)
	This:C1470.stmpTransaction:=$date=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build($date)

local Function get dueDate()->$date : Date
	If (This:C1470.moreData=Null:C1517)
		$date:=!00-00-00!
	Else
		$date:=This:C1470.moreData.dueDate
		If ($date=Null:C1517)
			$date:=!00-00-00!
		End if
	End if

local Function set dueDate($date : Date)
	If (This:C1470.moreData=Null:C1517)
		This:C1470.moreData:=New object:C1471
	End if
	This:C1470.moreData.dueDate:=$date

local Function beforeSave()
	var $typeCode : Text
	$typeCode:=This:C1470.typeCode()
	If ($typeCode#"")
		This:C1470.applyTypeAmountSign($typeCode)
	End if
	This:C1470.refreshStatus()

local Function afterCreation()

local Function loadAfterCreation()
	// Purpose: Assign a unique barcode in moreData for scanner lookup on new records.
	// modified by 4D/PS [2026-june-23]
	This:C1470.moreData.barcodeData:=String:C10(cs:C1710.Util_ScannerManager.me.getBarcodeData(Form:C1466.sfw.entry.dataclass); "0000000000")
	This:C1470._initOnCreation()

// Purpose: Assign defaults when a new AR line is created in the panel.
// modified by 4D/PS [2026-june-08]
local Function _initOnCreation()
	If (Form:C1466.situation.mode="add")
		If (This:C1470.transactionNumber=0)
			$max:=ds:C1482.SalesTransaction.all().extract("transactionNumber").max()
			This:C1470.transactionNumber:=($max=Null:C1517) ? 1 : $max+1
		End if
		If (This:C1470.transactionDate=!00-00-00!)
			This:C1470.transactionDate:=Current date:C33(*)
		End if
		If (cs:C1710.sfw_string.me.isAnEmptyUUID(This:C1470.UUID_TransactionType))
			$eType:=ds:C1482.TransactionType.query("code = :1"; "INV").first()
			If ($eType#Null:C1517)
				This:C1470.UUID_TransactionType:=$eType.UUID
			End if
		End if
		If (cs:C1710.sfw_string.me.isAnEmptyUUID(This:C1470.UUID_TransactionStatus))
			This:C1470.refreshStatus()
		End if
		If (This:C1470.openBalance=0) & (This:C1470.Amount#0)
			This:C1470.openBalance:=This:C1470.Amount
		End if
	End if

// Purpose: Recompute status from amount, open balance, and transaction type (QuickBooks-style AR state).
// modified by 4D/PS [2026-june-17]
Function refreshStatus()
	var $statusCode : Text
	var $eStatus : cs:C1710.TransactionStatusEntity
	var $absAmount : Real
	var $absBalance : Real
	var $typeCode : Text
	
	$typeCode:=This:C1470.typeCode()
	$absAmount:=Abs:C99(This:C1470.Amount)
	$absBalance:=Abs:C99(This:C1470.openBalance)
	
	Case of
		: ($typeCode="PAY")
			If ($absBalance=0)
				$statusCode:="APPLIED"
			Else
				$statusCode:="OPEN"
			End if
		: ($typeCode="CM")
			If ($absBalance=0)
				$statusCode:="APPLIED"
			Else
				$statusCode:="OPEN"
			End if
		: ($absAmount=0)
			$statusCode:="OPEN"
		: ($absBalance=0)
			$statusCode:="PAID"
		: ($absBalance<$absAmount)
			$statusCode:="PARTIAL"
		Else
			$statusCode:="OPEN"
	End case
	
	$eStatus:=ds:C1482.TransactionStatus.query("code = :1"; $statusCode).first()
	If ($eStatus#Null:C1517)
		This:C1470.UUID_TransactionStatus:=$eStatus.UUID
	End if

// Purpose: Return TransactionType.code from the ORDA "type" relation or UUID fallback.
// Returns: Text — INV, CM, PAY, DEP, or empty when unknown
// created by 4D/PS [2026-june-17]
Function typeCode()->$typeCode : Text
	var $eType : cs:C1710.TransactionTypeEntity
	
	$typeCode:=""
	If (This:C1470.type#Null:C1517)
		$typeCode:=This:C1470.type.code
	Else
		If (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID(This:C1470.UUID_TransactionType)))
			$eType:=ds:C1482.TransactionType.get(This:C1470.UUID_TransactionType)
			If ($eType#Null:C1517)
				$typeCode:=$eType.code
			End if
		End if
	End if

// Purpose: Apply signed amount rules when the transaction type changes (credit notes are negative).
// Parameters:
// $typeCode : Text — TransactionType.code (INV, CM, PAY, DEP)
// modified by 4D/PS [2026-june-08]
Function applyTypeAmountSign($typeCode : Text)
	Case of
		: ($typeCode="CM")
			If (This:C1470.Amount>0)
				This:C1470.Amount:=-This:C1470.Amount
			End if
			If (This:C1470.openBalance>0)
				This:C1470.openBalance:=-This:C1470.openBalance
			End if
		: ($typeCode="PAY")
			If (This:C1470.Amount>0)
				This:C1470.Amount:=-This:C1470.Amount
			End if
	End case

// Purpose: Return True when this line can receive a customer payment (open invoice).
// Returns: Boolean
// created by 4D/PS [2026-june-08]
Function canReceivePayment()->$can : Boolean
	var $typeCode : Text
	
	$typeCode:=This:C1470.typeCode()
	$can:=($typeCode="INV") & (This:C1470.openBalance#0)

// Purpose: Return True when this credit memo line has unapplied credit (open CM balance).
// Returns: Boolean
// created by 4D/PS [2026-june-08]
Function canApplyCreditMemo()->$can : Boolean
	var $typeCode : Text
	
	$typeCode:=This:C1470.typeCode()
	$can:=($typeCode="CM") & (This:C1470.openBalance#0)

// Purpose: Ensure the moreData blob exists before reading or writing AR extension fields.
// modified by 4D/PS [2026-june-08]
Function _ensureMoreData()
	// Purpose: Legacy rows may store a non-object in moreData — normalize before property access.
	// modified by 4D/PS [2026-june-23]
	If (Value type:C1509(This:C1470.moreData)#Is object:K8:27)
		This:C1470.moreData:=New object:C1471
	End if

// Purpose: Return True when a PAY line is still in undeposited funds (not yet bank-deposited).
// Returns: Boolean
// created by 4D/PS [2026-june-08]
Function isUndeposited()->$isUndeposited : Boolean
	
	$isUndeposited:=False:C215
	If (This:C1470.typeCode()#"PAY")
		return $isUndeposited
	End if
	This:C1470._ensureMoreData()
	If (Bool:C1537(This:C1470.moreData.deposited))
		return $isUndeposited
	End if
	If (This:C1470.moreData.undeposited=Null:C1517) || (Bool:C1537(This:C1470.moreData.undeposited))
		$isUndeposited:=True:C214
	End if

// Purpose: Flag a new PAY line as undeposited (Receive Payment default).
// Parameters: $flag : Boolean — True when payment should appear in Make Deposit
// modified by 4D/PS [2026-june-08]
Function setUndeposited($flag : Boolean)
	This:C1470._ensureMoreData()
	This:C1470.moreData.undeposited:=$flag

// Purpose: Mark a PAY line as deposited and link it to the DEP SalesTransaction row.
// Parameters: $depositUUID : Text — DEP line UUID
// modified by 4D/PS [2026-june-08]
Function markDeposited($depositUUID : Text)
	This:C1470._ensureMoreData()
	This:C1470.moreData.deposited:=True:C214
	This:C1470.moreData.undeposited:=False:C215
	This:C1470.moreData.UUID_DepositST:=$depositUUID

// Purpose: Return the cash amount to include when depositing this PAY line.
// Returns: Real — positive payment amount
// created by 4D/PS [2026-june-08]
Function depositAmount()->$amount : Real
	$amount:=0
	If (This:C1470.typeCode()="PAY")
		$amount:=Abs:C99(This:C1470.Amount)
	End if

// Purpose: Return True when this PAY line can be included in a bank deposit.
// Returns: Boolean
// created by 4D/PS [2026-june-08]
Function canIncludeInDeposit()->$can : Boolean
	$can:=(This:C1470.typeCode()="PAY") & (This:C1470.isUndeposited()) & (This:C1470.depositAmount()>0)

// Purpose: Refresh Amount/openBalance when import left zero on a Job Invoice ST row (instance method — safe from SFW item actions).
// Returns: SalesTransactionEntity — reloaded entity when updated, otherwise This
// created by 4D/PS [2026-june-08]
Function syncJobInvoiceSTAmount()->$eSTOut : cs:C1710.SalesTransactionEntity
	
	var $eJobInvoice : cs:C1710.JobInvoiceEntity
	var $eJob : cs:C1710.JobEntity
	var $invNum : Text
	var $amount : Real
	var $res : Object
	var $prefix : Text
	
	$eSTOut:=This:C1470
	$prefix:="Job invoice "
	If (($eSTOut.openBalance#0) || ($eSTOut.Amount#0))
		return $eSTOut
	End if
	If ($eSTOut.memo=Null:C1517) || (Position:C15($prefix; $eSTOut.memo)#1)
		return $eSTOut
	End if
	
	$invNum:=Substring:C12($eSTOut.memo; Length:C16($prefix)+1)
	$eJobInvoice:=ds:C1482.JobInvoice.query("invoiceNumber = :1"; $invNum).first()
	If ($eJobInvoice=Null:C1517)
		return $eSTOut
	End if
	
	$amount:=$eJobInvoice.total
	If ($amount=0)
		$amount:=$eJobInvoice.poBasedCharges+$eJobInvoice.travBasedCharges+$eJobInvoice.totalSalesTax+$eJobInvoice.orderItemsCharges
	End if
	If ($amount=0) && ($eJobInvoice.job#Null:C1517)
		$eJob:=$eJobInvoice.job
		If ($eJob.totalCharge#0)
			$amount:=$eJob.totalCharge
		End if
	End if
	If ($amount=0)
		return $eSTOut
	End if
	
	$eSTOut.Amount:=$amount
	$eSTOut.openBalance:=$amount
	$eSTOut.applyTypeAmountSign("INV")
	$eSTOut.refreshStatus()
	$res:=$eSTOut.save()
	If ($res.success)
		$eSTOut:=ds:C1482.SalesTransaction.get($eSTOut.UUID)
	End if
