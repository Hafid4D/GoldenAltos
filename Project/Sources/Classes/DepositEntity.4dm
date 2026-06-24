// Purpose: Entity helpers for Deposit (header fields in moreData, list display, creation defaults).
// created by 4D/PS [2026-june-22]
Class extends Entity

local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=String:C10(This:C1470.depositNumber)

// Purpose: Ensure moreData object exists before reading or writing deposit header fields.
// modified by 4D/PS [2026-june-22]
Function _ensureMoreData()
	If (This:C1470.moreData=Null:C1517)
		This:C1470.moreData:=New object:C1471
	End if

local Function get depositDate()->$date : Date
	This:C1470._ensureMoreData()
	$date:=This:C1470.moreData.depositDate
	If ($date=Null:C1517)
		$date:=!00-00-00!
	End if

local Function set depositDate($date : Date)
	This:C1470._ensureMoreData()
	This:C1470.moreData.depositDate:=$date

local Function get memo()->$memo : Text
	This:C1470._ensureMoreData()
	$memo:=This:C1470.moreData.memo
	If ($memo=Null:C1517)
		$memo:=""
	End if

local Function set memo($memo : Text)
	This:C1470._ensureMoreData()
	This:C1470.moreData.memo:=$memo

local Function get UUID_CAO_bank()->$uuid : Text
	This:C1470._ensureMoreData()
	$uuid:=This:C1470.moreData.UUID_CAO_bank
	If ($uuid=Null:C1517)
		$uuid:=""
	End if

local Function set UUID_CAO_bank($uuid : Text)
	This:C1470._ensureMoreData()
	This:C1470.moreData.UUID_CAO_bank:=$uuid

local Function get bankAccountName()->$name : Text
	This:C1470._ensureMoreData()
	$name:=This:C1470.moreData.bankAccountName
	If ($name=Null:C1517)
		$name:=""
	End if

local Function set bankAccountName($name : Text)
	This:C1470._ensureMoreData()
	This:C1470.moreData.bankAccountName:=$name

local Function get UUID_Customer_filter()->$uuid : Text
	This:C1470._ensureMoreData()
	$uuid:=This:C1470.moreData.UUID_Customer_filter
	If ($uuid=Null:C1517)
		$uuid:=""
	End if

local Function set UUID_Customer_filter($uuid : Text)
	This:C1470._ensureMoreData()
	This:C1470.moreData.UUID_Customer_filter:=$uuid

local Function get cashBackAmount()->$amount : Real
	This:C1470._ensureMoreData()
	$amount:=Num:C11(This:C1470.moreData.cashBackAmount)
	If ($amount=Null:C1517)
		$amount:=0
	End if

local Function set cashBackAmount($amount : Real)
	This:C1470._ensureMoreData()
	This:C1470.moreData.cashBackAmount:=$amount

local Function get cashBackMemo()->$memo : Text
	This:C1470._ensureMoreData()
	$memo:=This:C1470.moreData.cashBackMemo
	If ($memo=Null:C1517)
		$memo:=""
	End if

local Function set cashBackMemo($memo : Text)
	This:C1470._ensureMoreData()
	This:C1470.moreData.cashBackMemo:=$memo

local Function get UUID_CAO_cashBack()->$uuid : Text
	This:C1470._ensureMoreData()
	$uuid:=This:C1470.moreData.UUID_CAO_cashBack
	If ($uuid=Null:C1517)
		$uuid:=""
	End if

local Function set UUID_CAO_cashBack($uuid : Text)
	This:C1470._ensureMoreData()
	This:C1470.moreData.UUID_CAO_cashBack:=$uuid

local Function get cashBackAccountName()->$name : Text
	This:C1470._ensureMoreData()
	$name:=This:C1470.moreData.cashBackAccountName
	If ($name=Null:C1517)
		$name:=""
	End if

local Function set cashBackAccountName($name : Text)
	This:C1470._ensureMoreData()
	This:C1470.moreData.cashBackAccountName:=$name

// Purpose: List column — bank account label for the deposit header.
// Returns: Text
// created by 4D/PS [2026-june-22]
Function accountLabel()->$label : Text
	$label:=This:C1470.bankAccountName

// Purpose: List column — gross deposit total (payments + other funds, before cash back).
// Returns: Real
// created by 4D/PS [2026-june-22]
Function totalAmount()->$total : Real
	This:C1470._ensureMoreData()
	$total:=Num:C11(This:C1470.moreData.total)
	If ($total=Null:C1517)
		$total:=0
	End if

// Purpose: Map legacy import JSON (moreData.legacy) into header display fields for browse mode.
// modified by 4D/PS [2026-june-23]
Function hydrateDisplayFromLegacy()
	var $legacy : Object
	var $eCao : cs:C1710.CAOEntity
	var $firstLine : cs:C1710.DepositItemEntity
	var $lineMd : Object
	
	This:C1470._ensureMoreData()
	If (This:C1470.moreData.legacy=Null:C1517)
		return 
	End if
	$legacy:=This:C1470.moreData.legacy
	If (This:C1470.depositDate=!00-00-00!)
		This:C1470.depositDate:=This:C1470._legacyDateValue($legacy.DepositDate)
	End if
	If (This:C1470.bankAccountName="")
		If ($legacy.Account#Null:C1517)
			This:C1470.bankAccountName:=String:C10($legacy.Account)
		End if
	End if
	If (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID(This:C1470.UUID_CAO_bank))) && (This:C1470.bankAccountName="")
		$eCao:=ds:C1482.CAO.get(This:C1470.UUID_CAO_bank)
		If ($eCao#Null:C1517)
			This:C1470.bankAccountName:=$eCao.accountNumber+" — "+$eCao.name
		End if
	End if
	If (Num:C11(This:C1470.moreData.total)=0) && ($legacy.TotalReceipt#Null:C1517)
		This:C1470.moreData.total:=Num:C11($legacy.TotalReceipt)
	End if
	If (This:C1470.depositDate=!00-00-00!)
		$firstLine:=ds:C1482.DepositItem.query("UUID_Deposit = :1"; This:C1470.UUID).orderBy("lineNumber").first()
		If ($firstLine#Null:C1517) && ($firstLine.moreData#Null:C1517)
			$lineMd:=$firstLine.moreData
			If ($lineMd.legacy#Null:C1517)
				This:C1470.depositDate:=This:C1470._legacyDateValue($lineMd.legacy.Deposit_Date)
			End if
		End if
	End if
	If (This:C1470.moreData.saved=Null:C1517)
		This:C1470.moreData.saved:=True:C214
	End if

// Purpose: Convert a legacy JSON date value to a 4D Date.
// Parameters: $value : Variant — legacy field (Date, Text ISO, numeric, or Null)
// Returns: Date — !00-00-00! when conversion fails
// modified by 4D/PS [2026-june-23]
Function _legacyDateValue($value : Variant)->$date : Date
	$date:=!00-00-00!
	If ($value=Null:C1517) || (Undefined:C82($value))
		return $date
	End if
	Case of
		: (Value type:C1509($value)=Is date:K8:7)
			$date:=$value
		: (Value type:C1509($value)=Is text:K8:3)
			If ($value#"")
				$date:=Date:C102($value)
			End if
		: ((Value type:C1509($value)=Is real:K8:5) | (Value type:C1509($value)=Is longint:K8:6))
			If (Num:C11($value)#0)
				$date:=!00-00-00!+Num:C11($value)
			End if
	End case

// Purpose: Return True when this deposit is still being created (not yet persisted with lines).
// Returns: Boolean
// created by 4D/PS [2026-june-22]
Function isDraft()->$draft : Boolean
	This:C1470._ensureMoreData()
	$draft:=Not:C34(Bool:C1537(This:C1470.moreData.saved))

local Function itemReload()
	// Purpose: Reload listbox data when the user selects another deposit in the list.
	// modified by 4D/PS [2026-june-22]
	cs:C1710.panel_deposit.me.loadPanelData()

local Function loadAfterCreation()
	If (Form:C1466.situation.mode="add")
		This:C1470._initOnCreation()
	End if
	// Purpose: Assign a unique barcode in moreData for scanner lookup on new records.
	// modified by 4D/PS [2026-june-23]
	This:C1470.moreData.barcodeData:=String:C10(cs:C1710.Util_ScannerManager.me.getBarcodeData(Form:C1466.sfw.entry.dataclass); "0000000000")

// Purpose: Assign deposit number and default header values for a new deposit in the panel.
// modified by 4D/PS [2026-june-22]
Function _initOnCreation()
	var $eCao : cs:C1710.CAOEntity
	
	If (This:C1470.depositNumber=0)
		This:C1470.depositNumber:=ds:C1482.Deposit.nextDepositNumber()
	End if
	This:C1470._ensureMoreData()
	This:C1470.moreData.saved:=False:C215
	If (This:C1470.depositDate=!00-00-00!)
		This:C1470.depositDate:=Current date:C33(*)
	End if
	If (This:C1470.memo="")
		This:C1470.memo:="Bank deposit"
	End if
	If (cs:C1710.sfw_string.me.isAnEmptyUUID(This:C1470.UUID_CAO_bank))
		$eCao:=ds:C1482.CAO.activeCAOs().orderBy("accountNumber").first()
		If ($eCao#Null:C1517)
			This:C1470.UUID_CAO_bank:=$eCao.UUID
			This:C1470.bankAccountName:=$eCao.accountNumber+" — "+$eCao.name
		End if
	End if

local Function beforeSave()
	// Purpose: Deposits are persisted only on creation via Deposit_create — no post-save edits in v1.
	// modified by 4D/PS [2026-june-22]
