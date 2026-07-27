// Purpose: Entity helpers for Check (typed Check_Register fields + AP bill lines).
// modified by 4D/PS [2026-june-29]
Class extends Entity

local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=String:C10(This:C1470.checkNumber)

// Purpose: Ensure moreData is a valid object (barcode only — no legacy blob).
// modified by 4D/PS [2026-june-29]
Function _ensureMoreData()
	If (Value type:C1509(This:C1470.moreData)#Is object:K8:27)
		This:C1470.moreData:=New object:C1471
	End if

local Function get checkDate()->$date : Date
	$date:=This:C1470.checkDateStmp=0 ? !00-00-00! : cs:C1710.sfw_stmp.me.getDate(This:C1470.checkDateStmp; True:C214)

local Function set checkDate($date : Date)
	This:C1470.checkDateStmp:=$date=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build($date)

// Purpose: Resolved bank GL label for the check header (Bank import or CAO relation).
// modified by 4D/PS [2026-june-29]
local Function get bankAccountName()->$name : Text
	var $eCao : cs:C1710.CAOEntity
	var $glAcct : Text
	
	$name:=String:C10(This:C1470.bankAccountLabel)
	If ($name#"")
		return $name
	End if
	
	$glAcct:=String:C10(This:C1470.bankGlAccount)
	If ($glAcct#"")
		$eCao:=_ga_jeResolveCaoByAcct($glAcct)
		If ($eCao#Null:C1517)
			$name:=$eCao.displayLabel()
			return $name
		End if
		$name:=$glAcct
		return $name
	End if
	
	If (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID(String:C10(This:C1470.UUID_CAO_bank))))
		$eCao:=ds:C1482.CAO.get(String:C10(This:C1470.UUID_CAO_bank))
		If ($eCao#Null:C1517)
			$name:=$eCao.displayLabel()
		End if
	End if
	
	If ($name="") && (This:C1470.acNumber#"")
		$eCao:=ds:C1482.Bank.resolveCaoForAcNumber(This:C1470.acNumber)
		If ($eCao#Null:C1517)
			$name:=$eCao.displayLabel()
		End if
	End if

local Function get isVoid()->$void : Boolean
	$void:=False:C215
	If (This:C1470.payee="VOID")
		$void:=True:C214
	End if

// Purpose: Default values when creating a check from the entry panel.
// modified by 4D/PS [2026-june-29]
Function _initOnCreation()
	This:C1470._ensureMoreData()
	If (This:C1470.checkNumber=0)
		This:C1470.checkNumber:=ds:C1482.Check.nextCheckNumber()
	End if
	If (This:C1470.checkDate=!00-00-00!)
		This:C1470.checkDate:=Current date:C33(*)
	End if

// Purpose: Initialize barcode data when a new record is created in the entry panel.
// modified by 4D/PS [2026-june-29]
local Function loadAfterCreation()
	This:C1470._initOnCreation()
	This:C1470.moreData.barcodeData:=String:C10(cs:C1710.Util_ScannerManager.me.getBarcodeData(Form:C1466.sfw.entry.dataclass); "0000000000")

// Purpose: Refresh bank GL mapping before save when AC number is set.
// modified by 4D/PS [2026-june-29]
local Function beforeSave()
	_ga_enrichCheckBank(This:C1470)

// Purpose: Post AP check payments for linked bill lines after save (skipped during bulk import).
// modified by 4D/PS [2026-june-29]
local Function afterSave()
	var $eLine : cs:C1710.BuyingOrderLineEntity
	var $lines : cs:C1710.BuyingOrderLineSelection
	var $res : Object
	
	If (_ga_jeSkipGlPosting())
		return 
	End if
	$lines:=ds:C1482.BuyingOrderLine.query("checkNumber = :1"; This:C1470.checkNumber)
	For each ($eLine; $lines)
		$res:=_ga_jePostApPayment($eLine; This:C1470)
		If (Not:C34($res.success))
			// Purpose: Do not block check save — GL misconfiguration is logged server-side for admin follow-up.
			// modified by 4D/PS [2026-june-29]
		End if
	End for each
