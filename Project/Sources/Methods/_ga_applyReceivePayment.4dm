//%attributes = {}

// Purpose: Create a PAY SalesTransaction, apply amounts to invoices, and persist PaymentApplication rows.
// Parameters:
// $customerUUID : Text — customer UUID
// $totalAmount : Real — payment amount received (positive)
// $applications : Collection — objects with UUID_Invoice (Text) and appliedAmount (Real)
// $memo : Text — payment memo
// $transactionDate : Date — payment date
// Returns: Object — { success : Boolean, paymentUUID : Text, totalApplied : Real, error : Text }
// created by 4D/PS [2026-june-08]

#DECLARE($customerUUID : Text; $totalAmount : Real; $applications : Collection; $memo : Text; $transactionDate : Date) -> $result : Object

var $ePayment : cs:C1710.SalesTransactionEntity
var $eInv : cs:C1710.SalesTransactionEntity
var $eApp : cs:C1710.PaymentApplicationEntity
var $eType : cs:C1710.TransactionTypeEntity
var $totalApplied : Real
var $unapplied : Real
var $app : Object
var $res : Object
var $tableError : Text
var $ownTransaction : Boolean

$result:=New object:C1471("success"; False:C215; "paymentUUID"; ""; "totalApplied"; 0; "error"; "")

$tableError:=_ga_payAppTableError()
If ($tableError#"")
	$result.error:=$tableError
	return $result
End if

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
		$eInv:=ds:C1482.SalesTransaction.get($app.UUID_Invoice)
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

$ePayment:=ds:C1482.SalesTransaction.new()
$ePayment.transactionNumber:=ds:C1482.SalesTransaction.nextTransactionNumber()
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
	// Purpose: New payments sit in undeposited funds until included in a bank deposit (QuickBooks-style).
	// modified by 4D/PS [2026-june-08]
	$ePayment.setUndeposited(True:C214)

// Purpose: Use ORDA datastore transactions (SFW entry may already hold one); classic START TRANSACTION fails in that context.
// modified by 4D/PS [2026-june-08]
$ownTransaction:=False
If (Transaction level:C961=0)
	ds:C1482.startTransaction()
	$ownTransaction:=True
End if

$res:=$ePayment.save()
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
		// Purpose: Persist application link via ORDA (same pattern as ds.DepositItem.new in __import_data_deposit).
		// modified by 4D/PS [2026-june-08]
		$eApp:=ds:C1482.PaymentApplication.new()
		$eApp.UUID_Payment:=$ePayment.UUID
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
$result.paymentUUID:=$ePayment.UUID
$result.totalApplied:=$totalApplied
