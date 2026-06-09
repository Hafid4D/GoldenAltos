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
	$typeCode:=""
	If (This:C1470.transactionType#Null:C1517)
		$typeCode:=This:C1470.transactionType.code
	Else
		If (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID(This:C1470.UUID_TransactionType)))
			$eType:=ds:C1482.TransactionType.get(This:C1470.UUID_TransactionType)
			If ($eType#Null:C1517)
				$typeCode:=$eType.code
			End if
		End if
	End if
	If ($typeCode#"")
		This:C1470.applyTypeAmountSign($typeCode)
	End if
	This:C1470.refreshStatus()

local Function afterCreation()

local Function loadAfterCreation()
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

// Purpose: Recompute status from amount and open balance (QuickBooks-style AR state).
// modified by 4D/PS [2026-june-08]
Function refreshStatus()
	var $statusCode : Text
	var $eStatus : cs:C1710.TransactionStatusEntity
	var $absAmount : Real
	var $absBalance : Real
	
	$absAmount:=Abs:C99(This:C1470.Amount)
	$absBalance:=Abs:C99(This:C1470.openBalance)
	
	Case of
		: (This:C1470.moreData#Null:C1517) && ((This:C1470.moreData.closed=True:C214) | (This:C1470.moreData.readyToDel=True:C214))
			$statusCode:="CLOSED"
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
	$typeCode:=""
	If (This:C1470.transactionType#Null:C1517)
		$typeCode:=This:C1470.transactionType.code
	End if
	$can:=($typeCode="INV") & (This:C1470.openBalance#0)
