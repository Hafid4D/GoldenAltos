//%attributes = {}

// Purpose: Apply an existing CM SalesTransaction to open invoices and persist PaymentApplication rows.
// Parameters:
// $creditMemoUUID : Text — credit memo SalesTransaction UUID
// $applications : Collection — objects with UUID_Invoice (Text) and appliedAmount (Real)
// $memo : Text — optional memo appended to the credit memo line
// Returns: Object — { success : Boolean, creditMemoUUID : Text, totalApplied : Real, error : Text }
// created by 4D/PS [2026-june-08]

#DECLARE($creditMemoUUID : Text; $applications : Collection; $memo : Text) -> $result : Object

var $eCm : cs:C1710.SalesTransactionEntity
var $eInv : cs:C1710.SalesTransactionEntity
var $eApp : cs:C1710.PaymentApplicationEntity
var $totalApplied : Real
var $creditAvailable : Real
var $app : Object
var $res : Object
var $tableError : Text
var $ownTransaction : Boolean

$result:=New object:C1471("success"; False:C215; "creditMemoUUID"; ""; "totalApplied"; 0; "error"; "")

$tableError:=_ga_payAppTableError()
If ($tableError#"")
	$result.error:=$tableError
	return $result
End if

If ($applications.length=0)
	$result.error:="Select at least one invoice to apply the credit memo."
	return $result
End if

$eCm:=ds:C1482.SalesTransaction.get($creditMemoUUID)
If ($eCm=Null:C1517)
	$result.error:="Credit memo not found."
	return $result
End if

If (Not:C34($eCm.canApplyCreditMemo()))
	$result.error:="Credit memo #"+String:C10($eCm.transactionNumber)+" has no unapplied credit."
	return $result
End if

$creditAvailable:=Abs:C99($eCm.openBalance)

$totalApplied:=0
For each ($app; $applications)
	If ($app.appliedAmount#Null:C1517) && ($app.appliedAmount>0)
		$eInv:=ds:C1482.SalesTransaction.get($app.UUID_Invoice)
		If ($eInv=Null:C1517)
			$result.error:="Invoice not found for credit application."
			return $result
		End if
		If ($eInv.UUID_Customer#$eCm.UUID_Customer)
			$result.error:="All invoices must belong to the same customer as the credit memo."
			return $result
		End if
		If (Not:C34($eInv.canReceivePayment()))
			$result.error:="Invoice #"+String:C10($eInv.transactionNumber)+" cannot receive a credit application."
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

If ($totalApplied>$creditAvailable)
	$result.error:="Applied amount cannot exceed the available credit."
	return $result
End if

// Purpose: Use ORDA datastore transactions (SFW entry may already hold one).
// modified by 4D/PS [2026-june-08]
$ownTransaction:=False
If (Transaction level:C961=0)
	ds:C1482.startTransaction()
	$ownTransaction:=True
End if

$eCm.openBalance:=$eCm.openBalance+$totalApplied
If ($memo#"")
	If ($eCm.memo=Null:C1517) || ($eCm.memo="")
		$eCm.memo:=$memo
	Else
		$eCm.memo:=$eCm.memo+" — "+$memo
	End if
End if
$eCm.refreshStatus()
$res:=$eCm.save()
If (Not:C34($res.success))
	If ($ownTransaction)
		ds:C1482.cancelTransaction()
	End if
	$result.error:=$res.statusText
	return $result
End if

For each ($app; $applications)
	If ($app.appliedAmount#Null:C1517) && ($app.appliedAmount>0)
		$eInv:=ds:C1482.SalesTransaction.get($app.UUID_Invoice)
		$eInv.openBalance:=$eInv.openBalance-$app.appliedAmount
		$eInv.refreshStatus()
		$res:=$eInv.save()
		If (Not:C34($res.success))
			If ($ownTransaction)
				ds:C1482.cancelTransaction()
			End if
			$result.error:=$res.statusText
			return $result
		End if
		$eApp:=ds:C1482.PaymentApplication.new()
		$eApp.UUID_Payment:=$eCm.UUID
		$eApp.UUID_Invoice:=$eInv.UUID
		$eApp.appliedAmount:=$app.appliedAmount
		$res:=$eApp.save()
		If (Not:C34($res.success))
			If ($ownTransaction)
				ds:C1482.cancelTransaction()
			End if
			$result.error:=$res.statusText
			return $result
		End if
	End if
End for each

If ($ownTransaction)
	ds:C1482.validateTransaction()
End if

$result.success:=True:C214
$result.creditMemoUUID:=$eCm.UUID
$result.totalApplied:=$totalApplied
