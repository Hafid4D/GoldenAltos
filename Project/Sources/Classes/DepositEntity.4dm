// Purpose: Entity helpers for Deposit (typed header fields + barcode in moreData).
// modified by 4D/PS [2026-june-29]
Class extends Entity

local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=String:C10(This:C1470.depositNumber)

// Purpose: Ensure moreData is a valid object (barcode scanner payload only).
// modified by 4D/PS [2026-june-26]
Function _ensureMoreData()
	If (Value type:C1509(This:C1470.moreData)#Is object:K8:27)
		This:C1470.moreData:=New object:C1471
	End if

local Function get depositDate()->$date : Date
	$date:=This:C1470.stmpDepositDate=0 ? !00-00-00! : cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpDepositDate; True:C214)

local Function set depositDate($date : Date)
	This:C1470.stmpDepositDate:=$date=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build($date)

// Purpose: Panel alias — bank account label shown on the entry list and header popup.
// modified by 4D/PS [2026-june-26]
local Function get bankAccountName()->$name : Text
	var $eCao : cs:C1710.CAOEntity
	var $bankUUID : Text
	$name:=String:C10(This:C1470.bankAccountLabel)
	// Purpose: Coerce catalog UUID to Text before isAnEmptyUUID (Undefined/UUID types are not Text).
	// modified by 4D/PS [2026-june-29]
	If (Undefined:C82(This:C1470.UUID_CAO_bank)) || (This:C1470.UUID_CAO_bank=Null:C1517)
		$bankUUID:=16*"00"
	Else
		$bankUUID:=String:C10(This:C1470.UUID_CAO_bank)
	End if
	If ($name="") && (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($bankUUID)))
		$eCao:=This:C1470.bankAccount
		If ($eCao=Null:C1517)
			$eCao:=ds:C1482.CAO.get($bankUUID)
		End if
		If ($eCao#Null:C1517)
			$name:=$eCao.displayLabel()
		End if
	End if

local Function set bankAccountName($name : Text)
	This:C1470.bankAccountLabel:=$name

// Purpose: Panel alias — cash back account label on the deposit form.
// modified by 4D/PS [2026-june-26]
local Function get cashBackAccountName()->$name : Text
	var $eCao : cs:C1710.CAOEntity
	var $cashBackUUID : Text
	$name:=String:C10(This:C1470.cashBackAccountLabel)
	// Purpose: Coerce catalog UUID to Text before isAnEmptyUUID (Undefined/UUID types are not Text).
	// modified by 4D/PS [2026-june-29]
	If (Undefined:C82(This:C1470.UUID_CAO_cashBack)) || (This:C1470.UUID_CAO_cashBack=Null:C1517)
		$cashBackUUID:=16*"00"
	Else
		$cashBackUUID:=String:C10(This:C1470.UUID_CAO_cashBack)
	End if
	If ($name="") && (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID($cashBackUUID)))
		$eCao:=This:C1470.cashBackAccount
		If ($eCao=Null:C1517)
			$eCao:=ds:C1482.CAO.get($cashBackUUID)
		End if
		If ($eCao#Null:C1517)
			$name:=$eCao.displayLabel()
		End if
	End if

local Function set cashBackAccountName($name : Text)
	This:C1470.cashBackAccountLabel:=$name

// Purpose: Removed unused accountLabel() wrapper — list column uses bankAccountName getter on typed bankAccountLabel.
// modified by 4D/PS [2026-june-29]

// Purpose: Return True when this deposit is still being created (not yet persisted with lines).
// Returns: Boolean
// modified by 4D/PS [2026-june-29]
Function isDraft()->$draft : Boolean
	$draft:=Not:C34(Bool:C1537(This:C1470.isSaved))

local Function itemReload()
	cs:C1710.panel_deposit.me.loadPanelData()

local Function loadAfterCreation()
	If (Form:C1466.situation.mode="add")
		This:C1470._initOnCreation()
	End if
	This:C1470._ensureMoreData()
	This:C1470.moreData.barcodeData:=String:C10(cs:C1710.Util_ScannerManager.me.getBarcodeData(Form:C1466.sfw.entry.dataclass); "0000000000")

// Purpose: Assign deposit number and default header values for a new deposit in the panel.
// modified by 4D/PS [2026-june-26]
Function _initOnCreation()
	var $eCao : cs:C1710.CAOEntity
	var $emptyUUID : Text
	
	$emptyUUID:=16*"00"
	
	If (This:C1470.depositNumber=0)
		This:C1470.depositNumber:=ds:C1482.Deposit.nextDepositNumber()
	End if
	This:C1470.isSaved:=False:C215
	If (This:C1470.depositDate=!00-00-00!)
		This:C1470.depositDate:=Current date:C33(*)
	End if
	If (This:C1470.memo=Null:C1517) || (This:C1470.memo="")
		This:C1470.memo:="Bank deposit"
	End if
	// Purpose: Default optional cash-back header fields so getters and validation never see Undefined UUIDs.
	// modified by 4D/PS [2026-june-29]
	If (This:C1470.cashBackAmount=Null:C1517)
		This:C1470.cashBackAmount:=0
	End if
	If (This:C1470.cashBackMemo=Null:C1517)
		This:C1470.cashBackMemo:=""
	End if
	If (This:C1470.cashBackAccountLabel=Null:C1517)
		This:C1470.cashBackAccountLabel:=""
	End if
	If (Undefined:C82(This:C1470.UUID_CAO_cashBack)) || (This:C1470.UUID_CAO_cashBack=Null:C1517) || (cs:C1710.sfw_string.me.isAnEmptyUUID(String:C10(This:C1470.UUID_CAO_cashBack)))
		This:C1470.UUID_CAO_cashBack:=$emptyUUID
	End if
	If (Undefined:C82(This:C1470.UUID_CAO_bank)) || (This:C1470.UUID_CAO_bank=Null:C1517) || (cs:C1710.sfw_string.me.isAnEmptyUUID(String:C10(This:C1470.UUID_CAO_bank)))
		// Purpose: Default new deposits to the first active Bank-type CAO (mockup — not any GL account).
		// modified by 4D/PS [2026-june-29]
		$eCao:=ds:C1482.CAO.getActiveBankAccounts().orderBy("accountNumber").first()
		If ($eCao#Null:C1517)
			This:C1470.UUID_CAO_bank:=$eCao.UUID
			This:C1470.bankAccountLabel:=$eCao.displayLabel()
		End if
	End if

local Function beforeSave()
	// Purpose: Deposits are persisted only on creation via Deposit_create — no post-save edits in v1.
	// modified by 4D/PS [2026-june-22]
