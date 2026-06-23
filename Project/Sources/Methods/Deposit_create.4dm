//%attributes = {}

// Purpose: SFW create callback — persist deposit from panel Form state via _ga_saveDeposit.
// Parameters:
// $newEntity : Pointer — receives the saved DepositEntity
// $itemCopy : Object — copy of Form.current_item at save time
// Returns: nothing (alerts on failure)
// created by 4D/PS [2026-june-22]

#DECLARE($newEntity : Pointer; $itemCopy : Object)

var $result : Object
var $paymentLines : Collection
var $otherFundLines : Collection
var $depositUUID : Text
var $depositNumber : Integer
var $memo : Text
var $check : Object

$check:=_ga_depositValidateForm()
If (Not:C34($check.valid))
	If ($check.error#"")
		cs:C1710.sfw_dialog.me.alert($check.error)
	End if
	return 
End if
If (Form:C1466.depositPaymentLines=Null:C1517)
	$paymentLines:=New collection:C1472()
Else
	$paymentLines:=Form:C1466.depositPaymentLines
End if

If (Form:C1466.depositOtherFundLines=Null:C1517)
	$otherFundLines:=New collection:C1472()
Else
	$otherFundLines:=Form:C1466.depositOtherFundLines
End if

$depositUUID:=Form:C1466.current_item.UUID
$depositNumber:=Form:C1466.current_item.depositNumber
$memo:=Form:C1466.current_item.memo
If ($memo=Null:C1517)
	$memo:=""
End if

$result:=_ga_saveDeposit(\
	$depositUUID; \
	$depositNumber; \
	Form:C1466.current_item.UUID_CAO_bank; \
	Form:C1466.current_item.depositDate; \
	$memo; \
	$paymentLines; \
	$otherFundLines; \
	Form:C1466.current_item.cashBackAmount; \
	Form:C1466.current_item.UUID_CAO_cashBack; \
	Form:C1466.current_item.cashBackMemo)

If ($result.success)
	If ($newEntity#Null:C1517)
		$newEntity->:=ds:C1482.Deposit.get($result.depositUUID)
	End if
Else
	If ($result.error="")
		$result.error:="Could not save deposit."
	End if
	cs:C1710.sfw_dialog.me.alert($result.error)
End if
